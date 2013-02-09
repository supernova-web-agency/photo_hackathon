require 'rubygems'
require 'sinatra'
require 'data_mapper'

# A Sqlite3 connection to a persistent database
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/main.db")

class User
    include DataMapper::Resource
    
    property :id,        Serial
    property :name,      String, :required => true
    property :join_date,  Date
    has n, :pictures, 'Picture',
        :parent_key => [ :id ], :child_key => [ :user_id ]
    has n, :comments, 'Comment',
        :parent_key => [ :id ], :child_key => [ :user_id ]
    has 1, :email, 'Email', 
        :parent_key => [ :id ], :child_key => [ :user_id ]
    has 1, :password, 'Password', 
        :parent_key => [ :id ], :child_key => [ :user_id ]
end

class Email
    include DataMapper::Resource

    property :id,    Serial
    property :address,    String, :required => true
    property :modification_date, DateTime

    belongs_to :user, 'User',
        :parent_key => [ :id ], :child_key => [ :user_id ], :required => true
end

class Password
    include DataMapper::Resource

    property :id,    Serial
    property :passcode,    String, :required => true
    property :modification_date, DateTime
    
    belongs_to :user, 'User',
        :parent_key => [ :id ], :child_key => [ :user_id ], :required => true
end

class Picture
    include DataMapper::Resource
    
    property :id,    Serial
    property :title, String, :required => true
    property :thumb_uri, String, :required => true
    property :uri, String, :required => true
    property :creation_date, Date
    property :modification_date, DateTime

    has n, :comments, 'Comment',
        :parent_key => [ :id ], :child_key => [ :picture_id ], :required => true
    
    belongs_to :user, 'User',
        :parent_key => [ :id ], :child_key => [ :user_id ], :required => true
end

class Comment
    include DataMapper::Resource

    property :id,    Serial
    property :body,  Text, :required => true
    property :creation_date, DateTime
    
    belongs_to :user, 'User',
        :parent_key => [ :id ], :child_key => [ :user_id ], :required => true

    belongs_to :picture, 'Picture',
        :parent_key => [ :id ], :child_key => [ :picture_id ], :required => true
end


DataMapper.finalize
DataMapper.auto_upgrade!

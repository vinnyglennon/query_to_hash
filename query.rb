#!/usr/bin/ruby
require 'open-uri'

# Public: Given a HTTP query string, convert it into a hash
#
# http_query  - The String to be converted.
#
# Examples
#
#   query_to_hash("foo=bar&abc=1%202%203")
#   # => {"foo"=>"bar", "abc"=>"1 2 3"}
#
# Issues
#   1) foo[]=bar&foo[]=zap gets quashed into {"foo[]"=>"zap"}
#   2) Function is a duplicate of Rack::Utils.parse_nested_query(http_query) if on Rails 2.3+
#
# Returns the query in a hash format.
def query_to_hash(http_query)
	hash_details = Hash.new
  	return hash_details unless http_query and http_query.is_a?(String)
	http_query.split('&').each do |tuple|
		keyvalue = tuple.split('=')
		hash_details[keyvalue[0]] = URI.decode(keyvalue[1])
	end
	hash_details
 end

require 'rspec'
describe "Query to Hash" do
  it "should process vanilla inputs" do
  	plain_input = "foo=bar&abc=1%202%203"
    expected = { "foo" => "bar", "abc" => "1 2 3" }
    query_to_hash(plain_input).should == expected
  end

  it "should not process ints" do
  	number = 344354354
    expected = {}
    query_to_hash(number).should == expected
  end

  it "should return an empty hash for blank string" do
  	blank_string = ""
    expected = {}
    query_to_hash(blank_string).should == expected
  end
end
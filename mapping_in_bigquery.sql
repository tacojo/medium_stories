WITH mapping_table AS (
  SELECT 
    r'Frence|France' AS country, '33' AS country_prefix 
  UNION ALL
  SELECT 
    r'uk|Uk|UK', '44'
)
, your_data AS (
  SELECT 
    row_number() over () as x --we need this to make sure we get all rows, including duplicates
    , string_to_check
  FROM UNNEST(["France speak French", "Uk speak English", "Germany speak Deutch", "France speak French"]) AS string_to_check
)
SELECT
  x
  , string_to_check
  , MAX(IF(REGEXP_CONTAINS(string_to_check, country), country_prefix, NULL)) AS country_prefix
FROM your_data
CROSS JOIN mapping_table
GROUP BY x, string_to_check

#!/bin/bash

# This file assumes that you have valid AWS access credentials for Ego4D
# as specified here: https://ego4d-data.org/docs/start-here/
# 
# Once you have those AWS access credentials, you just have to update or
# newly create the credentials file (e.g., vim ~/.aws/credentials)

# --- Configuration ---
ANNOTATION_FILE="HME-QA_annotations_v0.json"
OUTPUT_DIR="videos"

if [ ! -f "$ANNOTATION_FILE" ]; then
    echo "ERROR: Annotation file not found at '$ANNOTATION_FILE'"
    exit 1
fi
if ! command -v ego4d &> /dev/null; then
    echo "ERROR: 'ego4d' command not found. Please run: pip install ego4d"
    exit 1
fi
if ! command -v jq &> /dev/null; then
    echo "ERROR: 'jq' command not found. Please install it."
    exit 1
fi

echo "Prerequisites are met. Starting video download process."
mkdir -p "$OUTPUT_DIR"
echo "Videos will be saved in the '$OUTPUT_DIR/' directory."

uids=$(jq -r '.[].video_uid' "$ANNOTATION_FILE") # video UIDs are extracted from the annotations JSON

if [ -z "$uids" ]; then
    echo "No video UIDs found in '$ANNOTATION_FILE'. Nothing to download."
    exit 0
fi

echo "Found the following UIDs to download:"
echo "$uids"
echo "------------------------------------"
echo "Starting download with the ego4d CLI..."

ego4d -o "$OUTPUT_DIR" --dataset full_scale --video_uids $uids

echo "Downloads complete!"
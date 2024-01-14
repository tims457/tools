#!/bin/bash

print_help() {
    echo "Usage: ./whisperyt.sh <video_url> <output_name>"
    echo "This will download a Youtube video at <video_url> convert to .wav and transcribe the txt with whispercpp saving the file as <output_name>.txt"
    echo "Requirements: youtube-dl, ffmpeg. Adjust the path to whisper.cpp repo and desired model as necessary below"
}

if [[ $# != 2 ]]; then
    print_help
    exit 1
fi

if [[ "$1" == "help" ]]; then
    print_help
    exit 0
fi

echo "Downloading from Youtube"
yt-dlp -f m4a -o audio_temp.m4a $1
echo "Converting to wav"
ffmpeg -i audio_temp.m4a -ar 16000 -ac 1 -c:a pcm_s16le audio_temp.wav
echo "Transcribing with Whispernet"
# adjust paths as necessary
~/github/whisper.cpp/main -f audio_temp.wav -m ~/github/whisper.cpp/models/ggml-base.en.bin -otxt -pp -nt -t 3 #> "$2.txt"
mv audio_temp.wav.txt "$2.txt"
echo "Done"



echo "Cleaning up"
rm audio_temp.*

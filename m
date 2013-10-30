Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3J3P7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:59:11 -0400
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:58058 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088Ab3J3P7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:59:09 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 1/4] ALSA: hda - hdmi: Add ATI/AMD multi-channel audio  support
HTTP-Posting-Client: 109.204.228.164
HTTP-Posting-URI: mail.onse.fi:443/index.php
HTTP-Posting-User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0
X-PHP-Originating-Script: 0:rcmail.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 30 Oct 2013 17:59:01 +0200
From: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        =?UTF-8?Q?Peter_Fr=C3=BChberger?= <fritsch@xbmc.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CACna6ryr37WRvKbMFmLEGt_A2zUD46rZOtJMVom+B_xK9WNLuw@mail.gmail.com>
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
 <1380659456-3746-2-git-send-email-anssi.hannula@iki.fi>
 <CACna6ryr37WRvKbMFmLEGt_A2zUD46rZOtJMVom+B_xK9WNLuw@mail.gmail.com>
Message-ID: <07e8973b4665cc23c3f4a77e9c7e2b7c@mail.onse.fi>
User-Agent: Roundcube Webmail/0.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki kirjoitti 2013-10-30 17:35:
> 2013/10/1 Anssi Hannula <anssi.hannula@iki.fi>:
> ATI/AMD codecs do not support all the standard HDA HDMI/DP functions,
> instead various vendor-specific verbs are provided.
> 
> I've just tried my HD6970M (BARTS, DCE5) in my Samsung NP700G7A-S01PL.
> 
> cat /proc/asound/card1/eld#0.0
> monitor_present 1
> eld_valid 1
> monitor_name
> connection_type HDMI
> eld_version [0x2] CEA-861D or below
> edid_version [0x0] no CEA EDID Timing Extension block present
> manufacture_id 0x0
> product_id 0x0
> port_id 0x0
> support_hdcp 0
> support_ai 0
> audio_sync_delay 0
> speakers [0x5f] FL/FR LFE FC RL/RR RC RLC/RRC
> sad_count 6
> sad0_coding_type [0x1] LPCM
> sad0_channels 8
> sad0_rates [0x1ee0] 32000 44100 48000 88200 96000 176400 192000
> sad0_bits [0xe0000] 16 20 24
> sad1_coding_type [0x2] AC-3
> sad1_channels 6
> sad1_rates [0xe0] 32000 44100 48000
> sad1_max_bitrate 640000
> sad2_coding_type [0x7] DTS
> sad2_channels 6
> sad2_rates [0x6c0] 44100 48000 88200 96000
> sad2_max_bitrate 1536000
> sad3_coding_type [0xa] E-AC-3/DD+ (Dolby Digital Plus)
> sad3_channels 8
> sad3_rates [0xc0] 44100 48000
> sad4_coding_type [0xb] DTS-HD
> sad4_channels 8
> sad4_rates [0x1ec0] 44100 48000 88200 96000 176400 192000
> sad5_coding_type [0xc] MLP (Dolby TrueHD)
> sad5_channels 8
> sad5_rates [0x1ec0] 44100 48000 88200 96000 176400 192000
> 
> Command:
> speaker-test -D hdmi:CARD=Generic,DEV=0 -c8 -r192000 -F S16_LE
> works, I just have 5.1 (not 7.1), so Side left goes to the Read left
> and Side right goes to the Rear right. But they were working!

Good :)

BTW, there is a newer version (which was actually applied) of this 
patchset in alsa-devel@, seems you were missing from CC on that one.

> Next I've used howto from
> http://phoronix.com/forums/showthread.php?27348-TrueHD-DTS-HD-E-AC3-Over-HDMI-On-Linux
> to test DTS MA and TrueHD.
> 
> In the file from howto I've used:
> card Generic
> and then tested:
> 
> zajec@linux-samsung700g7a:~> aplay -D hdmihdtest0 -c8 -fs16_le
> -r192000 thd.spdif
> Playing raw data 'thd.spdif' : Signed 16 bit Little Endian, Rate
> 192000 Hz, Channels 8
> zajec@linux-samsung700g7a:~> aplay -D hdmihdtest0 -c8 -fs16_le
> -r192000 dts.spdif
> Playing raw data 'dts.spdif' : Signed 16 bit Little Endian, Rate
> 192000 Hz, Channels 8

For the record, the "howto" is mostly a workaround for missing 
DEV=[1..3] on (now) very old systems, instead of messing around with 
asoundrc you can just use "-D hdmi:CARD=Generic,DEV=0,AES0=6" instead of 
-DhdmihdtestX. (in AES0 the 0x2 is non-PCM flag, 0x4 is non-copyright 
flag IIRC - ALSA default is 0x4).

> Hooray! I got
> DOLBY HD
> and
> DTS-HD MA
> on my Denon 1912 display!
> 
> Now the main question... do you have any experience on using DTS-HD MA
> (or TrueHD) with mplayer? :|

Nope (well, any that I still remember). Support is there, though, so I 
guess it should work.

-- 
Anssi Hannula


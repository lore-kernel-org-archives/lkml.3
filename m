Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3JaQWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:22:50 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:56398 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3JaQWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:22:48 -0400
MIME-Version: 1.0
In-Reply-To: <07e8973b4665cc23c3f4a77e9c7e2b7c@mail.onse.fi>
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
	<1380659456-3746-2-git-send-email-anssi.hannula@iki.fi>
	<CACna6ryr37WRvKbMFmLEGt_A2zUD46rZOtJMVom+B_xK9WNLuw@mail.gmail.com>
	<07e8973b4665cc23c3f4a77e9c7e2b7c@mail.onse.fi>
Date: Thu, 31 Oct 2013 17:22:48 +0100
Message-ID: <CACna6ryFtmZHAhmCPEsoxZc5h4mLuM4ajnKGsp=q0jag2f_SYw@mail.gmail.com>
Subject: Re: [PATCH 1/4] ALSA: hda - hdmi: Add ATI/AMD multi-channel audio support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        =?UTF-8?Q?Peter_Fr=C3=BChberger?= <fritsch@xbmc.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/30 Anssi Hannula <anssi.hannula@iki.fi>:
> BTW, there is a newer version (which was actually applied) of this patchset
> in alsa-devel@, seems you were missing from CC on that one.

I didn't try that updated version yet, but I'm afraid I discovered
some problem. I've switched from my Denon 1912 to the older Onkyo
TX-SR605 and there is problem with multichannel playback. I've tried:
> speaker-test -D hdmi:CARD=Generic,DEV=0 -c6 -r192000 -F S16_LE

speaker-test 1.0.25

Playback device is hdmi:CARD=Generic,DEV=0
Stream parameters are 192000Hz, S16_LE, 6 channels
Using 16 octaves of pink noise
Rate set to 192000Hz (requested 192000Hz)
Buffer size range from 64 to 87360
Period size range from 32 to 43680
Using max buffer size 87360
Periods = 4
was set period_size = 17472
was set buffer_size = 87360
0 - Front Left
4 - Center
1 - Front Right
3 - Rear Right
2 - Rear Left
5 - LFE
Time per period = 17.027360

But I can hear sound for rear right and rear left only :(

Is there anything more I can provide to help resolve this? Do you have
any idea how we can resolve this?

zajec@linux-samsung700g7a:/proc/asound/card1> cat eld#0.0
monitor_present         1
eld_valid               1
monitor_name
connection_type         HDMI
eld_version             [0x2] CEA-861D or below
edid_version            [0x0] no CEA EDID Timing Extension block present
manufacture_id          0x0
product_id              0x0
port_id                 0x0
support_hdcp            0
support_ai              0
audio_sync_delay        0
speakers                [0x4f] FL/FR LFE FC RL/RR RLC/RRC
sad_count               6
sad0_coding_type        [0x1] LPCM
sad0_channels           2
sad0_rates              [0x1ee0] 32000 44100 48000 88200 96000 176400 192000
sad0_bits               [0xe0000] 16 20 24
sad1_coding_type        [0x2] AC-3
sad1_channels           8
sad1_rates              [0xe0] 32000 44100 48000
sad1_max_bitrate        640000
sad2_coding_type        [0x7] DTS
sad2_channels           8
sad2_rates              [0xc0] 44100 48000
sad2_max_bitrate        1536000
sad3_coding_type        [0xa] E-AC-3/DD+ (Dolby Digital Plus)
sad3_channels           8
sad3_rates              [0xc0] 44100 48000
sad4_coding_type        [0xb] DTS-HD
sad4_channels           8
sad4_rates              [0x1ec0] 44100 48000 88200 96000 176400 192000
sad5_coding_type        [0xc] MLP (Dolby TrueHD)
sad5_channels           8
sad5_rates              [0x6c0] 44100 48000 88200 96000
zajec@linux-samsung700g7a:/proc/asound/card1> ls
codec#0  eld#0.0  id  pcm3p
zajec@linux-samsung700g7a:/proc/asound/card1> cat codec#0
Codec: ATI R6xx HDMI
Address: 0
AFG Function Id: 0x1 (unsol 0)
Vendor Id: 0x1002aa01
Subsystem Id: 0x00aa0100
Revision Id: 0x100200
No Modem Function Group found
Default PCM:
    rates [0x70]: 32000 44100 48000
    bits [0x2]: 16
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
State of AFG node 0x01:
  Power states:  D0 D3
  Power: setting=D0, actual=D0
GPIO: io=0, o=0, i=0, unsolicited=0, wake=0
Node 0x02 [Audio Output] wcaps 0x201: Stereo Digital
  Converter: stream=0, channel=0
  Digital: Enabled GenLevel
  Digital category: 0x2
  IEC Coding Type: 0x0
Node 0x03 [Pin Complex] wcaps 0x400381: Stereo Digital
  Control: name="HDMI/DP,pcm=3 Jack", index=0, device=0
  Control: name="IEC958 Playback Con Mask", index=0, device=0
  Control: name="IEC958 Playback Pro Mask", index=0, device=0
  Control: name="IEC958 Playback Default", index=0, device=0
  Control: name="IEC958 Playback Switch", index=0, device=0
  Control: name="ELD", index=0, device=3
  Pincap 0x00000094: OUT Detect HDMI
  Pin Default 0x18560010: [Jack] Digital Out at Int HDMI
    Conn = Digital, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=01, enabled=1
  Connection: 1
     0x02
zajec@linux-samsung700g7a:/proc/asound/card1> cat eld#0.0
monitor_present         1
eld_valid               1
monitor_name
connection_type         HDMI
eld_version             [0x2] CEA-861D or below
edid_version            [0x0] no CEA EDID Timing Extension block present
manufacture_id          0x0
product_id              0x0
port_id                 0x0
support_hdcp            0
support_ai              0
audio_sync_delay        0
speakers                [0x4f] FL/FR LFE FC RL/RR RLC/RRC
sad_count               6
sad0_coding_type        [0x1] LPCM
sad0_channels           2
sad0_rates              [0x1ee0] 32000 44100 48000 88200 96000 176400 192000
sad0_bits               [0xe0000] 16 20 24
sad1_coding_type        [0x2] AC-3
sad1_channels           8
sad1_rates              [0xe0] 32000 44100 48000
sad1_max_bitrate        640000
sad2_coding_type        [0x7] DTS
sad2_channels           8
sad2_rates              [0xc0] 44100 48000
sad2_max_bitrate        1536000
sad3_coding_type        [0xa] E-AC-3/DD+ (Dolby Digital Plus)
sad3_channels           8
sad3_rates              [0xc0] 44100 48000
sad4_coding_type        [0xb] DTS-HD
sad4_channels           8
sad4_rates              [0x1ec0] 44100 48000 88200 96000 176400 192000
sad5_coding_type        [0xc] MLP (Dolby TrueHD)
sad5_channels           8
sad5_rates              [0x6c0] 44100 48000 88200 96000


>> Now the main question... do you have any experience on using DTS-HD MA
>> (or TrueHD) with mplayer? :|
>
>
> Nope (well, any that I still remember). Support is there, though, so I guess
> it should work.

After some testing I found out that xbmc works very nice :)

-- 
Rafał

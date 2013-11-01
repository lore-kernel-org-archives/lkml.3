Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3KANWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:22:14 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52258 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3KANWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <52739B79.3030006@iki.fi>
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
	<1380659456-3746-2-git-send-email-anssi.hannula@iki.fi>
	<CACna6ryr37WRvKbMFmLEGt_A2zUD46rZOtJMVom+B_xK9WNLuw@mail.gmail.com>
	<07e8973b4665cc23c3f4a77e9c7e2b7c@mail.onse.fi>
	<CACna6ryFtmZHAhmCPEsoxZc5h4mLuM4ajnKGsp=q0jag2f_SYw@mail.gmail.com>
	<5272BCE1.7010700@iki.fi>
	<CACna6rzejyTOF2Fvvw1m2SAob7uU5-hJ+yRVk6HS5pDTz7+JWg@mail.gmail.com>
	<5272E920.6030606@iki.fi>
	<CACna6rxuSUA9_1HXnY8yPhQ8BDeEnMvoX6i0WvTtst7UTvcgHA@mail.gmail.com>
	<5272EEAC.6020405@iki.fi>
	<CACna6rymYy6hfpH6reknpa0QPHy31EwngOx4-d7JW4roANNQbQ@mail.gmail.com>
	<52739B79.3030006@iki.fi>
Date: Fri, 1 Nov 2013 13:22:12 +0000
Message-ID: <CACna6rw-xwQk0Ff38cY+HSEM-s7uAWgsPWk10j029jpyE6i3gQ@mail.gmail.com>
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

2013/11/1 Anssi Hannula <anssi.hannula@iki.fi>:
> Strange. One other thing to check (in addition to trying fglrx) would be
> to try 192kHz 8ch audio with a different (non-ATI/AMD) card altogether,
> to see if this is a receiver issue.

What about this:
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GF108
[GeForce GT 540M] [10de:0df4] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation GF108 High Definition
Audio Controller [10de:0bea] (rev a1)
? Chip & family:
[    2.738343] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0c1a00a1
[    2.738347] nouveau  [  DEVICE][0000:01:00.0] Chipset: GF108 (NVC1)
[    2.738348] nouveau  [  DEVICE][0000:01:00.0] Family : NVC0

> cat /proc/asound/card1/eld#1.0
monitor_present         1
eld_valid               1
monitor_name            TX-SR605
connection_type         HDMI
eld_version             [0x2] CEA-861D or below
edid_version            [0x3] CEA-861-B, C or D
manufacture_id          0xcb3d
product_id              0x761
port_id                 0x0
support_hdcp            0
support_ai              1
audio_sync_delay        0
speakers                [0x4f] FL/FR LFE FC RL/RR RLC/RRC
sad_count               7
sad0_coding_type        [0x1] LPCM
sad0_channels           2
sad0_rates              [0x1ee0] 32000 44100 48000 88200 96000 176400 192000
sad0_bits               [0xe0000] 16 20 24
sad1_coding_type        [0x1] LPCM
sad1_channels           8
sad1_rates              [0x1ee0] 32000 44100 48000 88200 96000 176400 192000
sad1_bits               [0xe0000] 16 20 24
sad2_coding_type        [0x2] AC-3
sad2_channels           8
sad2_rates              [0xe0] 32000 44100 48000
sad2_max_bitrate        640000
sad3_coding_type        [0x7] DTS
sad3_channels           8
sad3_rates              [0xc0] 44100 48000
sad3_max_bitrate        1536000
sad4_coding_type        [0xa] E-AC-3/DD+ (Dolby Digital Plus)
sad4_channels           8
sad4_rates              [0xc0] 44100 48000
sad5_coding_type        [0xb] DTS-HD
sad5_channels           8
sad5_rates              [0x1ec0] 44100 48000 88200 96000 176400 192000
sad6_coding_type        [0xc] MLP (Dolby TrueHD)
sad6_channels           8
sad6_rates              [0x6c0] 44100 48000 88200 96000

> aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: PCH [HDA Intel PCH], device 0: ALC275 Analog [ALC275 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: PCH [HDA Intel PCH], device 1: ALC275 Digital [ALC275 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: NVidia [HDA NVidia], device 3: HDMI 0 [HDMI 0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: NVidia [HDA NVidia], device 7: HDMI 0 [HDMI 0]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 1: NVidia [HDA NVidia], device 8: HDMI 0 [HDMI 0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: NVidia [HDA NVidia], device 9: HDMI 0 [HDMI 0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

Unfortunately speaker-test fails :|

linux@linux:~> speaker-test -D hdmi:CARD=NVidia,DEV=0 -c6 -r 48000 -F S16_LE

speaker-test 1.0.26

Playback device is hdmi:CARD=NVidia,DEV=0
Stream parameters are 48000Hz, S16_LE, 6 channels
Using 16 octaves of pink noise
Rate set to 48000Hz (requested 48000Hz)
Buffer size range from 64 to 87360
Period size range from 32 to 43680
Using max buffer size 87360
Periods = 4
was set period_size = 17472
was set buffer_size = 87360
*** Error in `speaker-test': corrupted double-linked list:
0x0000000000cc48a0 ***
^C
linux@linux:~> speaker-test -D hdmi:CARD=NVidia,DEV=1 -c6 -r 48000 -F S16_LE

speaker-test 1.0.26

Playback device is hdmi:CARD=NVidia,DEV=1
Stream parameters are 48000Hz, S16_LE, 6 channels
Using 16 octaves of pink noise
Rate set to 48000Hz (requested 48000Hz)
Buffer size range from 64 to 87360
Period size range from 32 to 43680
Using max buffer size 87360
Periods = 4
was set period_size = 17472
was set buffer_size = 87360
*** Error in `speaker-test': corrupted double-linked list:
0x0000000001e428a0 ***
^C

-- 
Rafał

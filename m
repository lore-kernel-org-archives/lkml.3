Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3KANni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:43:38 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:45058 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3KANnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:43:37 -0400
MIME-Version: 1.0
In-Reply-To: <CACna6rw-xwQk0Ff38cY+HSEM-s7uAWgsPWk10j029jpyE6i3gQ@mail.gmail.com>
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
	<CACna6rw-xwQk0Ff38cY+HSEM-s7uAWgsPWk10j029jpyE6i3gQ@mail.gmail.com>
Date: Fri, 1 Nov 2013 13:43:36 +0000
Message-ID: <CACna6rxiu0QACTpvEk4QN5jauQWgRB=_M-97L7ZNhPLE99x_wQ@mail.gmail.com>
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

2013/11/1 Rafał Miłecki <zajec5@gmail.com>:
> 2013/11/1 Anssi Hannula <anssi.hannula@iki.fi>:
>> Strange. One other thing to check (in addition to trying fglrx) would be
>> to try 192kHz 8ch audio with a different (non-ATI/AMD) card altogether,
>> to see if this is a receiver issue.
>
> What about this:
> 01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GF108
> [GeForce GT 540M] [10de:0df4] (rev a1)
> 01:00.1 Audio device [0403]: NVIDIA Corporation GF108 High Definition
> Audio Controller [10de:0bea] (rev a1)
> ? Chip & family:
> [    2.738343] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0c1a00a1
> [    2.738347] nouveau  [  DEVICE][0000:01:00.0] Chipset: GF108 (NVC1)
> [    2.738348] nouveau  [  DEVICE][0000:01:00.0] Family : NVC0
>
> (...)
>
> Unfortunately speaker-test fails :|
>
> linux@linux:~> speaker-test -D hdmi:CARD=NVidia,DEV=0 -c6 -r 48000 -F S16_LE
>
> speaker-test 1.0.26
>
> Playback device is hdmi:CARD=NVidia,DEV=0
> Stream parameters are 48000Hz, S16_LE, 6 channels
> Using 16 octaves of pink noise
> Rate set to 48000Hz (requested 48000Hz)
> Buffer size range from 64 to 87360
> Period size range from 32 to 43680
> Using max buffer size 87360
> Periods = 4
> was set period_size = 17472
> was set buffer_size = 87360
> *** Error in `speaker-test': corrupted double-linked list:
> 0x0000000000cc48a0 ***
> ^C

So I've decided to try mplayer. List of tested cases:

mplayer -ao alsa:device=hw=1.7 Canyon-5.1-48khz-448kbit.ac3 -channels
6 -srate 96000
mplayer -ao alsa:device=hw=1.7 Canyon-5.1-48khz-448kbit.ac3 -channels
6 -srate 176400
mplayer -ao alsa:device=hw=1.7 Canyon-5.1-48khz-448kbit.ac3 -channels
6 -srate 192000

mplayer -ao alsa:device=hw=1.7 Broadway-5.1-48khz-448kbit.ac3
-channels 6 -srate 96000
mplayer -ao alsa:device=hw=1.7 Broadway-5.1-48khz-448kbit.ac3
-channels 6 -srate 176400
mplayer -ao alsa:device=hw=1.7 Broadway-5.1-48khz-448kbit.ac3
-channels 6 -srate 192000

Rear right and real left were always working fine.
The rest (front  & center & front) were working for 96000 only.

So it seems to be some issue with my Onkyo TX-SR605 that reports
support for 192000 but can't fully handle it. Weird :|

-- 
Rafał

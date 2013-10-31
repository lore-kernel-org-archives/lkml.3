Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3JaXfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:35:16 -0400
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:48244 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755636Ab3JaXfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:35:14 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <5272E920.6030606@iki.fi>
Date: Fri, 01 Nov 2013 01:34:56 +0200
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        =?UTF-8?B?UGV0ZXIgRnLDvGhiZXJnZXI=?= <fritsch@xbmc.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ALSA: hda - hdmi: Add ATI/AMD multi-channel audio
 support
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>	<1380659456-3746-2-git-send-email-anssi.hannula@iki.fi>	<CACna6ryr37WRvKbMFmLEGt_A2zUD46rZOtJMVom+B_xK9WNLuw@mail.gmail.com>	<07e8973b4665cc23c3f4a77e9c7e2b7c@mail.onse.fi>	<CACna6ryFtmZHAhmCPEsoxZc5h4mLuM4ajnKGsp=q0jag2f_SYw@mail.gmail.com>	<5272BCE1.7010700@iki.fi> <CACna6rzejyTOF2Fvvw1m2SAob7uU5-hJ+yRVk6HS5pDTz7+JWg@mail.gmail.com>
In-Reply-To: <CACna6rzejyTOF2Fvvw1m2SAob7uU5-hJ+yRVk6HS5pDTz7+JWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

01.11.2013 01:25, Rafał Miłecki kirjoitti:
> 2013/10/31 Anssi Hannula <anssi.hannula@iki.fi>:
>>> But I can hear sound for rear right and rear left only :(
>>>
>>> Is there anything more I can provide to help resolve this? Do you have
>>> any idea how we can resolve this?
>>
>> According to the below the receiver has separate PCM SADs for 2-channel
>> and multichannel playback. However, due to a radeon driver bug (see
>> "[PATCH] drm/radeon/audio: fix missing multichannel PCM SAD in some
>> cases", you were CCd) the multichannel SAD is lost and not shown below.
>>
>> However, that is not (or at least should not be) the reason you are not
>> getting audio.
>> I suspect that the receiver does not support 192kHz multichannel audio
>> (which would be indicated in the missing multichannel PCM SAD). Does it
>> work with 48kHz or 96kHz?
>> (TODO: refuse PCM playback in such cases)
>>
>> If it does not work with 48kHz or 96kHz either, then we have a bug to
>> solve :)
> 
> First of all, you're right about 2 SADs for PCM.
> 
> The weird thing is that 192kHz support... According to the EDID (SADs)
> it should be supported:
> Format: 1 (PCM)        Channels:1    Freq:0x7F (32-192)    B2:0x07 (16-24b)
> Format: 1 (PCM)        Channels:7    Freq:0x7F (32-192)    B2:0x07 (16-24b)
> Format: 2 (AC3)        Channels:7    Freq:0x07 (32-48)    B2:0x50 (640?)
> Format: 7 (DTS)        Channels:7    Freq:0x06 (44-48)    B2:0xC0 (1536?)
> Format: 10 (EAC3)    Channels:7    Freq:0x06 (44-48)    B2:0x00
> Format: 11 (DTS_HD)    Channels:7    Freq:0x7E (44-192)    B2:0x01
> Format: 12 (MLP)    Channels:7    Freq:0x1E (44-96)    B2:0x00
> 
> So I performed more tests and:
> 
> 1) speaker-test -D hdmi:CARD=Generic,DEV=0 -c6 -r192000 -F S16_LE
> A nice noise for rear right and rear left, silent for the rest
> 
> 2) speaker-test -D hdmi:CARD=Generic,DEV=0 -c6 -r176400 -F S16_LE
> A nice noise for rear right and rear left, short "bump" sound for the rest
> 
> 3) speaker-test -D hdmi:CARD=Generic,DEV=0 -c6 -r96000 -F S16_LE
> A nice noise for all speakers (the same applies to 88200, 48000, 44100, 32000)
> 
> I don't get it. Onkyo reports support for 192kHz and it supports it,
> but only for 2 rear speakers... does it make any sense do you?

Just to check, is the display mode 720p50 or higher (as per HDMI spec
7.3.3)? Though I guess too small mode would cause something else, not
this...

Also, does DTS-HD/TrueHD work with this receiver (interesting since
those require 8-channel 192kHz link)?

Would be interesting to check if this works in Windows I guess (or maybe
even just fglrx, though I can't think of a reason it'd make a difference).

-- 
Anssi Hannula


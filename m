Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3JaXZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:25:46 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:38327 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3JaXZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <5272BCE1.7010700@iki.fi>
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
	<1380659456-3746-2-git-send-email-anssi.hannula@iki.fi>
	<CACna6ryr37WRvKbMFmLEGt_A2zUD46rZOtJMVom+B_xK9WNLuw@mail.gmail.com>
	<07e8973b4665cc23c3f4a77e9c7e2b7c@mail.onse.fi>
	<CACna6ryFtmZHAhmCPEsoxZc5h4mLuM4ajnKGsp=q0jag2f_SYw@mail.gmail.com>
	<5272BCE1.7010700@iki.fi>
Date: Fri, 1 Nov 2013 00:25:44 +0100
Message-ID: <CACna6rzejyTOF2Fvvw1m2SAob7uU5-hJ+yRVk6HS5pDTz7+JWg@mail.gmail.com>
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

2013/10/31 Anssi Hannula <anssi.hannula@iki.fi>:
>> But I can hear sound for rear right and rear left only :(
>>
>> Is there anything more I can provide to help resolve this? Do you have
>> any idea how we can resolve this?
>
> According to the below the receiver has separate PCM SADs for 2-channel
> and multichannel playback. However, due to a radeon driver bug (see
> "[PATCH] drm/radeon/audio: fix missing multichannel PCM SAD in some
> cases", you were CCd) the multichannel SAD is lost and not shown below.
>
> However, that is not (or at least should not be) the reason you are not
> getting audio.
> I suspect that the receiver does not support 192kHz multichannel audio
> (which would be indicated in the missing multichannel PCM SAD). Does it
> work with 48kHz or 96kHz?
> (TODO: refuse PCM playback in such cases)
>
> If it does not work with 48kHz or 96kHz either, then we have a bug to
> solve :)

First of all, you're right about 2 SADs for PCM.

The weird thing is that 192kHz support... According to the EDID (SADs)
it should be supported:
Format: 1 (PCM)        Channels:1    Freq:0x7F (32-192)    B2:0x07 (16-24b)
Format: 1 (PCM)        Channels:7    Freq:0x7F (32-192)    B2:0x07 (16-24b)
Format: 2 (AC3)        Channels:7    Freq:0x07 (32-48)    B2:0x50 (640?)
Format: 7 (DTS)        Channels:7    Freq:0x06 (44-48)    B2:0xC0 (1536?)
Format: 10 (EAC3)    Channels:7    Freq:0x06 (44-48)    B2:0x00
Format: 11 (DTS_HD)    Channels:7    Freq:0x7E (44-192)    B2:0x01
Format: 12 (MLP)    Channels:7    Freq:0x1E (44-96)    B2:0x00

So I performed more tests and:

1) speaker-test -D hdmi:CARD=Generic,DEV=0 -c6 -r192000 -F S16_LE
A nice noise for rear right and rear left, silent for the rest

2) speaker-test -D hdmi:CARD=Generic,DEV=0 -c6 -r176400 -F S16_LE
A nice noise for rear right and rear left, short "bump" sound for the rest

3) speaker-test -D hdmi:CARD=Generic,DEV=0 -c6 -r96000 -F S16_LE
A nice noise for all speakers (the same applies to 88200, 48000, 44100, 32000)

I don't get it. Onkyo reports support for 192kHz and it supports it,
but only for 2 rear speakers... does it make any sense do you?

-- 
Rafał

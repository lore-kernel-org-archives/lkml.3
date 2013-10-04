Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab3JDXkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 19:40:00 -0400
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:57023 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126Ab3JDXj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 19:39:59 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <524F51C6.7050203@iki.fi>
Date: Sat, 05 Oct 2013 02:39:50 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130914 Thunderbird/17.0.9
MIME-Version: 1.0
To: Olivier Langlois <olivier@trillion01.com>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        =?UTF-8?B?UGV0ZXIgRnLDvGhiZXJnZXI=?= <fritsch@xbmc.org>,
        =?UTF-8?B?UmFmYQ==?= =?UTF-8?B?xYIgTWnFgmVja2k=?= 
	<zajec5@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT v2 0/4] ALSA: hda - hdmi: ATI/AMD multi-channel and
 HBR support
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi> <1380870371.875.14.camel@Wailaba2>
In-Reply-To: <1380870371.875.14.camel@Wailaba2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

04.10.2013 10:06, Olivier Langlois kirjoitti:
> Anssi,
> 
> Your patch has been applied on 3.11.3

OK.

>>
>> I'm especially interested in testers with:
>>
>> - Older codecs other than 0x1002aa01. My best guess still is that the
>>   new code works on them as well.
>>   o On these I'd like to know if multichannel and the new formats
>>     work, i.e. e.g.
>>     speaker-test -D hdmi:CARD=Generic,DEV=0 -c8 -r192000 -F S32_LE
> 
> This is working with Codec 0x1002aa01 revisions 0x100300 (Rev ID 3)
> except for a small detail. I cannot tell if it is a regression from v1
> of the patch or it was there and I did not noticed when I tested.
> 
> Rear left and rear right channels are flipped.

Thanks for testing.

That seems a bit strange, I would've expected everything to be flipped
if there was a bug there.

Are you sure about that? Note that speaker-test speaker order is
reversed in the rear when compared to front, i.e. "front left, front
right, center, rear right, rear left", since it uses a circular pattern.

If you can confirm this, could you enable SND_CONFIG_DEBUG and
SND_CONFIG_DEBUG_VERBOSE and CONFIG_SND_VERBOSE_PRINTK, and then provide
the dmesg during playback?

Thanks.

>>
>> - Codec 0x1002aa01 revisions 0x100300 (Rev ID 3) or later (see
>>   /proc/asound/cardX/codec#Y). These are HD7750+ I think. Stuff to be
>>   tested on these:
>>   o The ramp up/down stuff, i.e. patch 4. Is there any difference seen
>>     with these, in the beginning/end (i.e. fade-out/in):
>>     speaker-test -D hdmi:CARD=Generic,DEV=0,AES0=0x04 -c2 -r48000
> 
> No noticeable difference than when it is run without the AES0 param
> 
>>     speaker-test -D hdmi:CARD=Generic,DEV=0,AES0=0x06 -c2 -r48000
> 
> From the application the sound is sent normally but no sound at all is
> outputed from the speakers.
> 
>>     Also, is there a difference in the beginning of these
>>     (maybe garbage sound and/or slightly slower startup?):
>>     aplay -Dhdmi:CARD=Generic,DEV=0,AES0=4 -r44100 -f s16_le -c2 testi.dts.cut.spdif
>>     aplay -Dhdmi:CARD=Generic,DEV=0,AES0=6 -r44100 -f s16_le -c2 testi.dts.cut.spdif
> 
> Both works. No garbage is heard from neither of them. maybe maybe AES04
> starts playing few ms earlier but if there is a difference, it is
> extremely subtle.

OK, that is actually reverse what I would've expected.

Takashi, do you think we should add the ramp-up/down setting (to spec
recommended pcm/non-pcm values) anyway?

>>
>>   o Contents of /proc/asound/cardX/eld#0. I'd like to see the contents
>>     both with radeon and with the proprietary fglrx driver in use
>>
> With fglrx 13.10 Beta 2:
> 
> lano1106@whippet2 /proc/asound/card0 $ cat codec#0 

Note I said eld#0, not codec#0 :)

Though I guess the correct filename is actually eld#0.0.

[...]

-- 
Anssi Hannula

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3GIIjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:39:37 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:23051 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752811Ab3GIIje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:39:34 -0400
Message-ID: <51DBCBD0.8060901@atmel.com>
Date: Tue, 9 Jul 2013 16:37:36 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <devicetree-discuss@lists.ozlabs.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v2 1/5] sound: sam9x5_wm8731: machine driver for at91sam9x5
 wm8731 boards
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com> <1373290193-25300-2-git-send-email-richard.genoud@gmail.com> <20130708150721.GK27646@sirena.org.uk> <CACQ1gAgJyTSdxAKK7uwG-ybE2ddC90podM3+tOAqQwZUspsU8Q@mail.gmail.com>
In-Reply-To: <CACQ1gAgJyTSdxAKK7uwG-ybE2ddC90podM3+tOAqQwZUspsU8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 7/9/2013 16:19, Richard Genoud wrote:
> 2013/7/8 Mark Brown <broonie@kernel.org>:
>> On Mon, Jul 08, 2013 at 03:29:49PM +0200, Richard Genoud wrote:
>>
>>> + *             Nicolas Ferre <nicolas.ferre@atmel.com>
>>> + *
>>> + * Based on sam9g20_wm8731.c by:
>>> + * Sedji Gaouaou <sedji.gaouaou@atmel.com>
>>
>> The obvious question here is of course if we can use the same driver for
>> both of them.
> I haven't got a g20 to test that, but that's the goal.
> For now, g20 is still non-DT, so I think it's best to have a DT-only
> driver like this one for the 9x5 family (9g15, 9g25, 9x25, 9g35,
> 9x25).
> When the g20 will move to DT completely, we can drop sam9g20_wm8731.c
> and adjust sam9x5_wm8731.c (mainly master clock and widgets it seems)

The at91sam9g20ek board can work in DT mode, and the sound has support 
in DT mode already.

Sure, the mainly thing we need deal with is the master clock and 
widgets. If put them together will make code ugly or need many many 
#ifdef, I suggest to keep them separately.

> By the way, maybe g45 could use that also (and SAMA5 ?)

For g45ek board, it use AC97 interface, not the case.

>>
>>> +     codec_dai->driver->playback.rates &= SNDRV_PCM_RATE_8000 |
>>> +             SNDRV_PCM_RATE_32000 |
>>> +             SNDRV_PCM_RATE_48000 |
>>> +             SNDRV_PCM_RATE_96000;
>>> +     codec_dai->driver->capture.rates &= SNDRV_PCM_RATE_8000 |
>>> +             SNDRV_PCM_RATE_32000 |
>>> +             SNDRV_PCM_RATE_48000 |
>>> +             SNDRV_PCM_RATE_96000;
>>
>> You definitely shouldn't be fiddling with a driver's constant static
>> data.  You want to be using snd_pcm_hw_constraint() APIs to set
>> additional constraints intead.
> Ok, I'll change that.
>
>
> Thanks !
>

Best Regards,
Bo Shen

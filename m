Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3GIHhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:37:52 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:59705 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3GIHhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:37:51 -0400
MIME-Version: 1.0
In-Reply-To: <51DACF15.9080303@metafoo.de>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373290193-25300-2-git-send-email-richard.genoud@gmail.com> <51DACF15.9080303@metafoo.de>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 9 Jul 2013 09:37:31 +0200
Message-ID: <CACQ1gAh2Cy8VTx4Mgdv2NdrjdX1M7m-5M+8LqY6ncz3kS16O6g@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v2 1/5] sound: sam9x5_wm8731: machine driver
 for at91sam9x5 wm8731 boards
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/8 Lars-Peter Clausen <lars@metafoo.de>:
> On 07/08/2013 03:29 PM, Richard Genoud wrote:
> [...]
>> +/*
>> + * Logic for a wm8731 as connected on a at91sam9x5 based board.
>> + */
>> +static int at91sam9x5ek_wm8731_init(struct snd_soc_pcm_runtime *rtd)
>> +{
> [...]
>> +     codec_dai->driver->playback.rates &= SNDRV_PCM_RATE_8000 |
>> +             SNDRV_PCM_RATE_32000 |
>> +             SNDRV_PCM_RATE_48000 |
>> +             SNDRV_PCM_RATE_96000;
>> +     codec_dai->driver->capture.rates &= SNDRV_PCM_RATE_8000 |
>> +             SNDRV_PCM_RATE_32000 |
>> +             SNDRV_PCM_RATE_48000 |
>> +             SNDRV_PCM_RATE_96000;
>
> That's not right. The driver structure is shared between all instances of
> the codec, a single instance should not modify it. If you need to constrain
> the list of supported rates use snd_pcm_hw_constraint_list().
Ok, I'll do that.

>
>> +
>> +     /* set the codec system clock for DAC and ADC */
>> +     ret = snd_soc_dai_set_sysclk(codec_dai, WM8731_SYSCLK_XTAL,
>> +                                  MCLK_RATE, SND_SOC_CLOCK_IN);
>> +     if (ret < 0) {
>> +             dev_err(dev, "ASoC: Failed to set WM8731 SYSCLK: %d\n", ret);
>> +             return ret;
>> +     }
>> +
>> +     /* signal a DAPM event */
>> +     snd_soc_dapm_sync(dapm);
>
> This should not be necessary.
ok
>
>> +     return 0;
>> +}
>

Thanks !

-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?

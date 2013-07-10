Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3GJJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:25:59 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:50790 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3GJJZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:25:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130709145917.GA27646@sirena.org.uk>
References: <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-2-git-send-email-richard.genoud@gmail.com> <20130709145917.GA27646@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 10 Jul 2013 11:25:37 +0200
Message-ID: <CACQ1gAgHuAcBAAgYaP-n9grrM6X0L9b1mFFfkRg0HH_RnRuXMg@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] sound: sam9x5_wm8731: machine driver for
 at91sam9x5 wm8731 boards
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/9 Mark Brown <broonie@kernel.org>:
> On Tue, Jul 09, 2013 at 04:25:27PM +0200, Richard Genoud wrote:
>
>> +/*
>> + * Authorized rates are:
>> + * Rate = MCLK_RATE / (n * 2)
>> + * Where n is in [1..4095]
>> + * (cf register SSC_CMR)
>> + */
>> +static unsigned int rates[] = {
>> +     8000,
>> +     16000,
>> +     32000,
>> +     48000,
>> +     64000,
>> +     96000,
>> +};
>
> Shouldn't the SSC driver be enforcing this constraint if it comes from
> the SSC hardware?  If the clock is reprogrammable the usual convention
> for drivers is to not constrain if the clock is set to zero so a machine
> driver could remove the constraint.
Actually, my comment is buggy here (or at least, unrelated to the
authorized rates).
The "MCLK_RATE" is the master clock of the wm8731 codec (a 12.288MHz crystal).
According to the datasheet of wm8731, when a 12.288 crystal is used,
the authorized rates are 8, 32, 48 and 96kHz (I have to remove 16 and
64kHz).

So, is this the right place for the rates ?

>> +     ret = atmel_ssc_set_audio(0);
>> +     if (ret != 0) {
>> +             dev_err(&pdev->dev,
>> +                     "ASoC: Failed to set SSC 0 for audio: %d\n", ret);
>> +             return ret;
>> +     }
>
> Shouldn't this be a parameter in the DT too?
Yes, I'll add that to the DT.

>> +     cpu_np = of_parse_phandle(np, "atmel,ssc-controller", 0);
>> +     if (!cpu_np) {
>> +             dev_err(&pdev->dev, "ssc controller node missing\n");
>> +             ret = -EINVAL;
>> +             goto out;
>> +     }
>> +     at91sam9x5ek_dai.cpu_of_node = cpu_np;
>> +     at91sam9x5ek_dai.platform_of_node = cpu_np;
>
> After all we're looking things up in the DT...
>
>> +     at91sam9x5ek_dai.dai_fmt = snd_soc_of_parse_daifmt(np, "atmel,");
>
> Is this really something that machines would want to reconfigure?  If so
> why?
That's right. There's no point reconfiguring that because I2S is the
only possible interface.


Thanks for your comments !


Richard.

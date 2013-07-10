Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3GJJaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:30:46 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34267 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3GJJap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:30:45 -0400
MIME-Version: 1.0
In-Reply-To: <51DCFB24.4080107@atmel.com>
References: <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-2-git-send-email-richard.genoud@gmail.com> <51DCFB24.4080107@atmel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 10 Jul 2013 11:30:24 +0200
Message-ID: <CACQ1gAjEvrKQ8Amb_fKj-VUJqmbtGuRm6=9zdtVj9MBsVcn18Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] sound: sam9x5_wm8731: machine driver for
 at91sam9x5 wm8731 boards
To: Bo Shen <voice.shen@atmel.com>
Cc: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/10 Bo Shen <voice.shen@atmel.com>:
> Hi Richard,
Hi !

> On 7/9/2013 22:25, Richard Genoud wrote:
> [snip]
>
>
>> +#include <linux/module.h>
>> +#include <linux/moduleparam.h>
>> +#include <linux/kernel.h>
>> +#include <linux/clk.h>
>> +#include <linux/timer.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/i2c.h>
>> +
>> +#include <linux/atmel-ssc.h>
>> +
>> +#include <sound/core.h>
>> +#include <sound/pcm.h>
>> +#include <sound/pcm_params.h>
>> +#include <sound/soc.h>
>> +
>> +#include <asm/mach-types.h>
>> +#include <mach/hardware.h>
>> +#include <mach/gpio.h>
>> +
>> +#include "../codecs/wm8731.h"
>> +#include "atmel-pcm.h"
>> +#include "atmel_ssc_dai.h"
>
>
> I think some of the header file include is not needed. I keep them as simple
> as following:
> ---8>---
> #include <linux/clk.h>
> #include <linux/module.h>
> #include <linux/of.h>
> #include <linux/of_device.h>
> #include <linux/pinctrl/consumer.h>
>
> #include <sound/soc.h>
>
> #include "../codecs/wm8731.h"
> #include "atmel_ssc_dai.h"
> ---<8---
ooopps ! I forgot to do some cleaning in those after the file rework. Thanks !

>
>> +#define MCLK_RATE 12288000
>> +
>> +#define DRV_NAME "sam9x5-snd-wm8731"
>> +
>> +/*
>> + * Authorized rates are:
>> + * Rate = MCLK_RATE / (n * 2)
>> + * Where n is in [1..4095]
>> + * (cf register SSC_CMR)
>> + */
>> +static unsigned int rates[] = {
>> +       8000,
>> +       16000,
>> +       32000,
>> +       48000,
>> +       64000,
>> +       96000,
>> +};
>
>
> This is decided by the codec, while not ssc when ssc in slave mode.
yes.

>> +static struct snd_pcm_hw_constraint_list hw_rates = {
>> +       .count = ARRAY_SIZE(rates),
>> +       .list = rates,
>> +};
>> +
>
>
> [snip]
>
>
>> +
>> +       at91sam9x5ek_dai.dai_fmt = snd_soc_of_parse_daifmt(np, "atmel,");
>
>
> We can put this into at91sam9x5ek_dai directly, not need to parse it then.
> example as following:
> ---8>---
> .dai_fmt = SND_SOC_DAIFMT_I2S
>                 | SND_SOC_DAIFMT_NB_NF
>                 | SND_SOC_DAIFMT_CBM_CFM,
> ---<8---
yes, I removed that for the older machine driver, without thinking that much.
It's better hardcorded like that.


Thanks for your comments !

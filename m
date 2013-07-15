Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab3GOO7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:59:43 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58729 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3GOO7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:59:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130712114926.GE24508@sirena.org.uk>
References: <1373559359-31607-1-git-send-email-richard.genoud@gmail.com>
 <1373559359-31607-3-git-send-email-richard.genoud@gmail.com> <20130712114926.GE24508@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 15 Jul 2013 16:59:21 +0200
Message-ID: <CACQ1gAiJ8ww-gYfcUsux00DmpWUpfqyzzqfxZjWZSaObgsz29g@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] sound: sam9x5_wm8731: machine driver for
 at91sam9x5 wm8731 boards
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/12 Mark Brown <broonie@kernel.org>:
> On Thu, Jul 11, 2013 at 06:15:54PM +0200, Richard Genoud wrote:
>> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> Description of the Asoc machine driver for an at91sam9x5 based board
>
> ASoC.
>
>> +sam9x5 pins:
>> + * LOUT
>> + * ROUT
>> + * LHPOUT
>> + * RHPOUT
>> + * LLINEIN
>> + * RLINEIN
>> + * MICIN
>
> These aren't pins on the CPU, they're pins on the CODEC, and you should
> be adding this to the binding document for the CODEC and referring to
> that rather than having them in each individual binding document.  This
> also helps if any new variants are added (not that this is likely for
> the WM8731).
ok, I'll move that

>
>> +static struct sam9x5_drvdata sam9x5_priv;
>
> Why is this a global static?
>
>> +     ret = snd_soc_register_card(&snd_soc_sam9x5);
>> +     if (ret) {
>> +             dev_err(&pdev->dev,
>> +                     "ASoC: Platform device allocation failed\n");
>> +             goto out_put_audio;
>> +     }
>
>> +     platform_set_drvdata(pdev, &snd_soc_sam9x5);
>
> It should be being dynamically allocated and retrieved as driver data
> when needed.
ok.

Thanks !


-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?

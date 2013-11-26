Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3KZLyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:54:20 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38445 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3KZLyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:54:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHz1HL65megQ9vDZovZr9oBo8UsrgGS+umWiT9FmHrnK3Q@mail.gmail.com>
References: <1385100726-32165-1-git-send-email-ch.naveen@samsung.com>
 <1385439977-19077-1-git-send-email-ch.naveen@samsung.com> <CAK9yfHz1HL65megQ9vDZovZr9oBo8UsrgGS+umWiT9FmHrnK3Q@mail.gmail.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Tue, 26 Nov 2013 17:23:56 +0530
Message-ID: <CAHfPSqACobcw-qEA+Pa2KTG3vJN6hPhS=ond3z4L6=BABbh8TQ@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] i2c: exynos5: add support for HSI2C on Exynos5260 SoC
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, sjg@chromium.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>,
        cpgs@samsung.com, Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sachin,

On 26 November 2013 16:59, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 26 November 2013 09:56, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> This patch adds new compatible to support HSI2C module on Exynos5260
>> HSI2C module on Exynos5260 needs to be reset during during initialization.
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> [snip]
>>
>>  Required properties:
>>    - compatible: value should be.
>> -      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
>> +       -> "samsung,exynos5-hsi2c", for i2c compatible with HSI2C available on
>> +                               Exynos5250/5420 SoCs.
The first HSI2C module is available on Exynos5 SoCs from Samsung.
Hence, "samsung,exynos5-hsi2c"
HSI2C Module on  Exynos5250 and Exynos5420 was exactly similar

HSI2C Module on Exynos5260 differs in hardware.
Hence, "samsung,exynos5260-hsi2c".

And as the new variants come we use "samsung,exynosXXX-hsi2c"
or we can go by "samsung,exynos5-hsi2c-v2"

Changing an existing compatible needs modification in the DT nodes as well.

I will change the compatible string, if anyone else also thinks its wise.
>
> This string could be made more specific ("samsung,exynos5250-hsi2c")
> now that we have variants for this.
>
>> +       -> "samsung,exynos5260-hsi2c", for i2c compatible with HSI2C available
>> +                               on Exynos5260 SoCs.
>> +
>>    - reg: physical base address of the controller and length of memory mapped
>>      region.
>>    - interrupts: interrupt number to the cpu.
>> diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
>> index da39ff0..497ff91 100644
>> --- a/drivers/i2c/busses/i2c-exynos5.c
>> +++ b/drivers/i2c/busses/i2c-exynos5.c
>> @@ -184,14 +184,35 @@ struct exynos5_i2c {
>>          * 2. Fast speed upto 1Mbps
>>          */
>>         int                     speed_mode;
>> +
>> +       /* Version of HS-I2C Hardware */
>> +       unsigned int            version;
>> +};
>> +
>> +enum hsi2c_version {
>> +       EXYNOS_5,
>
> ditto.
>
>> +       EXYNOS_5260
>>  };
>>
>
> --
> With warm regards,
> Sachin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shine bright,
(: Nav :)

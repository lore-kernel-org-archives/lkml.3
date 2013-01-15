Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3AONbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:31:02 -0500
Received: from antcom.de ([188.40.178.216]:54155 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab3AONbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:31:00 -0500
Message-ID: <50F55A0F.6010303@antcom.de>
Date: Tue, 15 Jan 2013 14:30:55 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com,
        tru@work-microwave.de, mark.rutland@arm.com
Subject: Re: [PATCH RESEND 6/6 v13] gpio: Add block gpio to several gpio drivers
References: <1358250716-21986-1-git-send-email-stigge@antcom.de> <1358250716-21986-7-git-send-email-stigge@antcom.de> <50F5573D.4060007@atmel.com>
In-Reply-To: <50F5573D.4060007@atmel.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 02:18 PM, Nicolas Ferre wrote:
>> --- linux-2.6.orig/drivers/pinctrl/pinctrl-at91.c
>> +++ linux-2.6/drivers/pinctrl/pinctrl-at91.c
>> @@ -49,6 +49,7 @@ struct at91_gpio_chip {
>>       struct clk        *clock;        /* associated clock */
>>       struct irq_domain    *domain;    /* associated irq domain */
>>       struct at91_pinctrl_mux_ops *ops;    /* ops */
>> +    unsigned long        mask_cache;    /* cached mask for block gpio */
>>   };
>>
>>   #define to_at91_gpio_chip(c) container_of(c, struct at91_gpio_chip,
>> chip)
>> @@ -1125,6 +1126,32 @@ static void at91_gpio_set(struct gpio_ch
>>       writel_relaxed(mask, pio + (val ? PIO_SODR : PIO_CODR));
>>   }
>>
>> +static unsigned long at91_gpio_get_block(struct gpio_chip *chip,
>> +                     unsigned long mask)
>> +{
>> +    struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
>> +    void __iomem *pio = at91_gpio->regbase;
>> +    u32 pdsr;
>> +
>> +    pdsr = __raw_readl(pio + PIO_PDSR);
> 
> Maybe you should use readl_relaxed() here as it is used in the
> at91_gpio_[get|set]() functions.

Thanks for the note! Seem to have missed this when forward porting in
pinctrl-at91.c was due.

Will include the respective change in a subsequent update.

Roland

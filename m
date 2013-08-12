Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab3HLQPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:15:18 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64521 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab3HLQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:15:14 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        kernel-janitors@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers/gpio/gpio-omap.c: convert comma to semicolon
References: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376149225-3997-2-git-send-email-Julia.Lawall@lip6.fr>
	<1376151231.2083.32.camel@joe-AO722>
Date: Mon, 12 Aug 2013 09:15:10 -0700
In-Reply-To: <1376151231.2083.32.camel@joe-AO722> (Joe Perches's message of
	"Sat, 10 Aug 2013 09:13:51 -0700")
Message-ID: <87ob92rilt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Sat, 2013-08-10 at 17:40 +0200, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>> Replace a comma between expression statements by a semicolon.
> []
>> I can't tell if the assignment to ct->regs.mask is really intended to be
>> under the if.  The proposed patch preserves the current semantics, but not
>> the current indentation.
>
> I'd suspect more that the indentation is correct
> and the comma use incorrect.
>
> It also looks more like a copy/paste error from
> commit f8b46b583 when the code was restructured
> a bit.
>
> Kevin?

Yes, looks like a copy/paste error.  The comma should simply be replaced
by a semi-colon.

Kevin


> --------------------
>
> -#ifdef CONFIG_ARCH_OMAP16XX
> -       /* REVISIT: assuming only 16xx supports MPUIO wake events */
> -       .irq_set_wake   = gpio_wake_enable,
> -#endif
> -};
>
> --------------------
>
> +       /* REVISIT: assuming only 16xx supports MPUIO wake events */
> +       if (cpu_is_omap16xx())
> +               ct->chip.irq_set_wake = gpio_wake_enable,
>
> --------------------
>
>> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> []
>> @@ -1029,10 +1029,10 @@ omap_mpuio_alloc_gc(struct gpio_bank *bank, unsigned int irq_start,
>>  	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
>>  	ct->chip.irq_set_type = gpio_irq_type;
>>  
>> -	if (bank->regs->wkup_en)
>> -		ct->chip.irq_set_wake = gpio_wake_enable,
>> -
>> -	ct->regs.mask = OMAP_MPUIO_GPIO_INT / bank->stride;
>> +	if (bank->regs->wkup_en) {
>> +		ct->chip.irq_set_wake = gpio_wake_enable;
>> +		ct->regs.mask = OMAP_MPUIO_GPIO_INT / bank->stride;
>> +	}
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

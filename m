Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030446Ab3HJQNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:13:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52459 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965219Ab3HJQNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:13:52 -0400
Message-ID: <1376151231.2083.32.camel@joe-AO722>
Subject: Re: [PATCH 1/5] drivers/gpio/gpio-omap.c: convert comma to semicolon
From: Joe Perches <joe@perches.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        kernel-janitors@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 10 Aug 2013 09:13:51 -0700
In-Reply-To: <1376149225-3997-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1376149225-3997-2-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-10 at 17:40 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> Replace a comma between expression statements by a semicolon.
[]
> I can't tell if the assignment to ct->regs.mask is really intended to be
> under the if.  The proposed patch preserves the current semantics, but not
> the current indentation.

I'd suspect more that the indentation is correct
and the comma use incorrect.

It also looks more like a copy/paste error from
commit f8b46b583 when the code was restructured
a bit.

Kevin?

--------------------

-#ifdef CONFIG_ARCH_OMAP16XX
-       /* REVISIT: assuming only 16xx supports MPUIO wake events */
-       .irq_set_wake   = gpio_wake_enable,
-#endif
-};

--------------------

+       /* REVISIT: assuming only 16xx supports MPUIO wake events */
+       if (cpu_is_omap16xx())
+               ct->chip.irq_set_wake = gpio_wake_enable,

--------------------

> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
[]
> @@ -1029,10 +1029,10 @@ omap_mpuio_alloc_gc(struct gpio_bank *bank, unsigned int irq_start,
>  	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
>  	ct->chip.irq_set_type = gpio_irq_type;
>  
> -	if (bank->regs->wkup_en)
> -		ct->chip.irq_set_wake = gpio_wake_enable,
> -
> -	ct->regs.mask = OMAP_MPUIO_GPIO_INT / bank->stride;
> +	if (bank->regs->wkup_en) {
> +		ct->chip.irq_set_wake = gpio_wake_enable;
> +		ct->regs.mask = OMAP_MPUIO_GPIO_INT / bank->stride;
> +	}



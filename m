Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3HMPHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:07:52 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:53025 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab3HMPHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:07:50 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        kernel-janitors@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5 v2] drivers/gpio/gpio-omap.c: convert comma to semicolon
References: <1376378216-18473-1-git-send-email-Julia.Lawall@lip6.fr>
Date: Tue, 13 Aug 2013 08:07:46 -0700
In-Reply-To: <1376378216-18473-1-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Tue, 13 Aug 2013 09:16:56 +0200")
Message-ID: <87txitochp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Replace a comma between expression statements by a semicolon.  This changes
> the semantics of the code, but given the current indentation appears to be
> what is intended.
>
> A simplified version of the semantic patch that performs this
> transformation is as follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r@
> expression e1,e2,e;
> type T;
> identifier i;
> @@
>
>  e1
> -,
> +;
>  e2;
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
> Not tested.  The first version did a different transformation to avoid
> changing the semantics.  This one leaves the layout as it is, but changes
> the semantics.

This is the right one, the previous semantics were wrong due to a
copy/paste error.

Acked-by: Kevin Hilman <khilman@linaro.org>

>  drivers/gpio/gpio-omap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index dfeb3a3..9f19ec9 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -1030,7 +1030,7 @@ omap_mpuio_alloc_gc(struct gpio_bank *bank, unsigned int irq_start,
>  	ct->chip.irq_set_type = gpio_irq_type;
>  
>  	if (bank->regs->wkup_en)
> -		ct->chip.irq_set_wake = gpio_wake_enable,
> +		ct->chip.irq_set_wake = gpio_wake_enable;
>  
>  	ct->regs.mask = OMAP_MPUIO_GPIO_INT / bank->stride;
>  	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

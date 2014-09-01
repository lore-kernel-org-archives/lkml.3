Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaIAJvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:51:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58458 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752808AbaIAJvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:51:52 -0400
Date: Mon, 1 Sep 2014 11:51:48 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux@openrisc.net, mark.rutland@arm.com,
        tony@atomide.com, catalin.marinas@arm.com, will.deacon@arm.com,
        tglx@linutronix.de, jonas@southpole.se, lorenzo.pieralisi@arm.com,
        linux@arm.linux.org.uk, shc_work@mail.ru, khilman@linaro.org,
        jason@lakedaemon.net, stefan.kristiansson@saunalahti.fi,
        larry.bassel@linaro.org, shawn.guo@freescale.com, baohua@kernel.org,
        sboyd@codeaurora.org, kernel@pengutronix.de, sudeep.holla@arm.com,
        schwidefsky@de.ibm.com, maxime.ripard@free-electrons.com,
        vkale@apm.com
Subject: Re: [PATCH v2 20/26] irqchip: atmel-aic5: convert to
 handle_domain_irq
Message-ID: <20140901115148.256bb4bb@bbrezillon>
In-Reply-To: <1409047421-27649-21-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
	<1409047421-27649-21-git-send-email-marc.zyngier@arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014 11:03:35 +0100
Marc Zyngier <marc.zyngier@arm.com> wrote:

> Use the new handle_domain_irq method to handle interrupts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/irqchip/irq-atmel-aic5.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
> index edb2270..04fe2c1 100644
> --- a/drivers/irqchip/irq-atmel-aic5.c
> +++ b/drivers/irqchip/irq-atmel-aic5.c
> @@ -78,12 +78,10 @@ aic5_handle(struct pt_regs *regs)
>  	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC5_IVR);
>  	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC5_ISR);
>  
> -	irqnr = irq_find_mapping(aic5_domain, irqnr);
> -
>  	if (!irqstat)
>  		irq_reg_writel(0, gc->reg_base + AT91_AIC5_EOICR);
>  	else
> -		handle_IRQ(irqnr, regs);
> +		handle_domain_irq(aic5_domain, irqnr, regs);
>  }
>  
>  static void aic5_mask(struct irq_data *d)



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

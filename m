Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaIAKQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:16:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58648 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752389AbaIAKQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:16:30 -0400
Date: Mon, 1 Sep 2014 12:16:26 +0200
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
Subject: Re: [PATCH v2 19/26] irqchip: atmel-aic: convert to
 handle_domain_irq
Message-ID: <20140901121626.7bd01dbe@bbrezillon>
In-Reply-To: <1409047421-27649-20-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
	<1409047421-27649-20-git-send-email-marc.zyngier@arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014 11:03:34 +0100
Marc Zyngier <marc.zyngier@arm.com> wrote:

> Use the new handle_domain_irq method to handle interrupts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/irqchip/irq-atmel-aic.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
> index a82869e..9a2cf3c 100644
> --- a/drivers/irqchip/irq-atmel-aic.c
> +++ b/drivers/irqchip/irq-atmel-aic.c
> @@ -68,12 +68,10 @@ aic_handle(struct pt_regs *regs)
>  	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC_IVR);
>  	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC_ISR);
>  
> -	irqnr = irq_find_mapping(aic_domain, irqnr);
> -
>  	if (!irqstat)
>  		irq_reg_writel(0, gc->reg_base + AT91_AIC_EOICR);
>  	else
> -		handle_IRQ(irqnr, regs);
> +		handle_domain_irq(aic_domain, irqnr, regs);
>  }
>  
>  static int aic_retrigger(struct irq_data *d)



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaIAJdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:33:36 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:46461 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaIAJdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:33:35 -0400
Message-ID: <54043D6B.5020401@atmel.com>
Date: Mon, 1 Sep 2014 11:33:31 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux@openrisc.net>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: <mark.rutland@arm.com>, <tony@atomide.com>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <tglx@linutronix.de>, <jonas@southpole.se>,
        <lorenzo.pieralisi@arm.com>, <linux@arm.linux.org.uk>,
        <shc_work@mail.ru>, <khilman@linaro.org>, <jason@lakedaemon.net>,
        <stefan.kristiansson@saunalahti.fi>, <larry.bassel@linaro.org>,
        <shawn.guo@freescale.com>, <baohua@kernel.org>, <sboyd@codeaurora.org>,
        <kernel@pengutronix.de>, <sudeep.holla@arm.com>,
        <schwidefsky@de.ibm.com>, <maxime.ripard@free-electrons.com>,
        <vkale@apm.com>
Subject: Re: [PATCH v2 20/26] irqchip: atmel-aic5: convert to handle_domain_irq
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com> <1409047421-27649-21-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1409047421-27649-21-git-send-email-marc.zyngier@arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/2014 12:03, Marc Zyngier :
> Use the new handle_domain_irq method to handle interrupts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Ok, thanks:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

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
> 


-- 
Nicolas Ferre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753AbaJ2Qyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:54:39 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64657 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271AbaJ2Qyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:54:36 -0400
Message-ID: <54511BB1.2070202@gmail.com>
Date: Wed, 29 Oct 2014 09:54:09 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 06/11] irqchip: bcm7120-l2: Use irq_reg_* accessors
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-6-git-send-email-cernekee@gmail.com>
In-Reply-To: <1414555138-6500-6-git-send-email-cernekee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 08:58 PM, Kevin Cernekee wrote:
> This keeps things consistent between the "core" bcm7120-l2 driver and the
> helpers in generic-chip.c.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  drivers/irqchip/irq-bcm7120-l2.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
> index 6472b71..f041992 100644
> --- a/drivers/irqchip/irq-bcm7120-l2.c
> +++ b/drivers/irqchip/irq-bcm7120-l2.c
> @@ -48,7 +48,7 @@ static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
>  
>  	chained_irq_enter(chip, desc);
>  
> -	status = __raw_readl(b->base + IRQSTAT);
> +	status = irq_reg_readl(b->base + IRQSTAT);
>  	do {
>  		irq = ffs(status) - 1;
>  		status &= ~(1 << irq);
> @@ -66,10 +66,10 @@ static void bcm7120_l2_intc_suspend(struct irq_data *d)
>  
>  	irq_gc_lock(gc);
>  	/* Save the current mask and the interrupt forward mask */
> -	b->saved_mask = __raw_readl(b->base + IRQEN) | b->irq_fwd_mask;
> +	b->saved_mask = irq_reg_readl(b->base + IRQEN) | b->irq_fwd_mask;
>  	if (b->can_wake) {
>  		reg = b->saved_mask | gc->wake_active;
> -		__raw_writel(reg, b->base + IRQEN);
> +		irq_reg_writel(reg, b->base + IRQEN);
>  	}
>  	irq_gc_unlock(gc);
>  }
> @@ -81,7 +81,7 @@ static void bcm7120_l2_intc_resume(struct irq_data *d)
>  
>  	/* Restore the saved mask */
>  	irq_gc_lock(gc);
> -	__raw_writel(b->saved_mask, b->base + IRQEN);
> +	irq_reg_writel(b->saved_mask, b->base + IRQEN);
>  	irq_gc_unlock(gc);
>  }
>  
> @@ -133,7 +133,7 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
>  	/* Enable all interrupt specified in the interrupt forward mask and have
>  	 * the other disabled
>  	 */
> -	__raw_writel(data->irq_fwd_mask, data->base + IRQEN);
> +	irq_reg_writel(data->irq_fwd_mask, data->base + IRQEN);
>  
>  	num_parent_irqs = of_irq_count(dn);
>  	if (num_parent_irqs <= 0) {
> 


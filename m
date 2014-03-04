Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaCDLOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:14:39 -0500
Received: from mailapp01.imgtec.com ([195.89.28.114]:45342 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbaCDLOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:14:38 -0500
Message-ID: <5315B598.5020207@imgtec.com>
Date: Tue, 4 Mar 2014 11:14:32 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <linus.walleij@linaro.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irq: Changed the return type of irq_chip.irq_startup()
 from unsigned int to int
References: <CACh+v5Nkuct0J65OHcnSd6Dfq4EyfafY8RpTvdwKXUA7A8_+Xw@mail.gmail.com> <1393521679-32331-1-git-send-email-jjhiblot@traphandler.com> <7150036.UpHTd1PK1K@radagast> <alpine.DEB.2.02.1403011629540.18573@ionos.tec.linutronix.de> <20140301160114.GE21483@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1403041134410.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403041134410.18573@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/14 10:57, Thomas Gleixner wrote:
> The reason is the usage of commata instead of semicolons. You can work
> around that with cocci, but that gets ugly ....
> 
> Thanks,
> 
> 	tglx
> 
> --- a/drivers/gpio/gpio-tz1090.c
> +++ b/drivers/gpio/gpio-tz1090.c
> @@ -488,26 +488,26 @@ static int tz1090_gpio_bank_probe(struct tz1090_gpio_bank_info *info)
>  	gc->chip_types[0].handler		= handle_level_irq;
>  	gc->chip_types[0].regs.ack		= REG_GPIO_IRQ_STS;
>  	gc->chip_types[0].regs.mask		= REG_GPIO_IRQ_EN;
> -	gc->chip_types[0].chip.irq_startup	= gpio_startup_irq,
> -	gc->chip_types[0].chip.irq_ack		= irq_gc_ack_clr_bit,
> -	gc->chip_types[0].chip.irq_mask		= irq_gc_mask_clr_bit,
> -	gc->chip_types[0].chip.irq_unmask	= irq_gc_mask_set_bit,
> -	gc->chip_types[0].chip.irq_set_type	= gpio_set_irq_type,
> -	gc->chip_types[0].chip.irq_set_wake	= gpio_set_irq_wake,
> -	gc->chip_types[0].chip.flags		= IRQCHIP_MASK_ON_SUSPEND,
> +	gc->chip_types[0].chip.irq_startup	= gpio_startup_irq;
> +	gc->chip_types[0].chip.irq_ack		= irq_gc_ack_clr_bit;
> +	gc->chip_types[0].chip.irq_mask		= irq_gc_mask_clr_bit;
> +	gc->chip_types[0].chip.irq_unmask	= irq_gc_mask_set_bit;
> +	gc->chip_types[0].chip.irq_set_type	= gpio_set_irq_type;
> +	gc->chip_types[0].chip.irq_set_wake	= gpio_set_irq_wake;
> +	gc->chip_types[0].chip.flags		= IRQCHIP_MASK_ON_SUSPEND;
>  
>  	/* edge chip type */
>  	gc->chip_types[1].type			= IRQ_TYPE_EDGE_BOTH;
>  	gc->chip_types[1].handler		= handle_edge_irq;
>  	gc->chip_types[1].regs.ack		= REG_GPIO_IRQ_STS;
>  	gc->chip_types[1].regs.mask		= REG_GPIO_IRQ_EN;
> -	gc->chip_types[1].chip.irq_startup	= gpio_startup_irq,
> -	gc->chip_types[1].chip.irq_ack		= irq_gc_ack_clr_bit,
> -	gc->chip_types[1].chip.irq_mask		= irq_gc_mask_clr_bit,
> -	gc->chip_types[1].chip.irq_unmask	= irq_gc_mask_set_bit,
> -	gc->chip_types[1].chip.irq_set_type	= gpio_set_irq_type,
> -	gc->chip_types[1].chip.irq_set_wake	= gpio_set_irq_wake,
> -	gc->chip_types[1].chip.flags		= IRQCHIP_MASK_ON_SUSPEND,
> +	gc->chip_types[1].chip.irq_startup	= gpio_startup_irq;
> +	gc->chip_types[1].chip.irq_ack		= irq_gc_ack_clr_bit;
> +	gc->chip_types[1].chip.irq_mask		= irq_gc_mask_clr_bit;
> +	gc->chip_types[1].chip.irq_unmask	= irq_gc_mask_set_bit;
> +	gc->chip_types[1].chip.irq_set_type	= gpio_set_irq_type;
> +	gc->chip_types[1].chip.irq_set_wake	= gpio_set_irq_wake;
> +	gc->chip_types[1].chip.flags		= IRQCHIP_MASK_ON_SUSPEND;
>  
>  	/* Setup chained handler for this GPIO bank */
>  	irq_set_handler_data(bank->irq, bank);
> 

Whoops, that was a subtle mistake from when I converted it from static
irqchips to using the generic irqchip stuff. Thanks for the patch, I'll
add a commit message and resubmit.

Cheers
James

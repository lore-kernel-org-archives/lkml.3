Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbaGOJSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:18:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52674 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753497AbaGOJSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:18:14 -0400
Date: Tue, 15 Jul 2014 11:18:09 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Barry Song <baohua@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Alexander Shiyan <shc_work@mail.ru>,
        Larry Bassel <larry.bassel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 11/15] irqchip: sun4i: convert to handle_domain_irq
Message-ID: <20140715091809.GD1011@kwain>
References: <1404825038-547-1-git-send-email-marc.zyngier@arm.com>
 <1404825038-547-12-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404825038-547-12-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Tue, Jul 08, 2014 at 02:10:34PM +0100, Marc Zyngier wrote:
> Use the new handle_domain_irq method to handle interrupts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

I tested this one on an A13 olinuxino. It worked well. I also tested
with CONFIG_PROVE_RCU enabled.

Antoine

> ---
>  drivers/irqchip/irq-sun4i.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
> index 6fcef4a..64155b6 100644
> --- a/drivers/irqchip/irq-sun4i.c
> +++ b/drivers/irqchip/irq-sun4i.c
> @@ -136,7 +136,7 @@ IRQCHIP_DECLARE(allwinner_sun4i_ic, "allwinner,sun4i-a10-ic", sun4i_of_init);
>  
>  static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
>  {
> -	u32 irq, hwirq;
> +	u32 hwirq;
>  
>  	/*
>  	 * hwirq == 0 can mean one of 3 things:
> @@ -154,8 +154,7 @@ static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
>  		return;
>  
>  	do {
> -		irq = irq_find_mapping(sun4i_irq_domain, hwirq);
> -		handle_IRQ(irq, regs);
> +		handle_domain_irq(sun4i_irq_domain, hwirq, regs);
>  		hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
>  	} while (hwirq != 0);
>  }
> -- 
> 2.0.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

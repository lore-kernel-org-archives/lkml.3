Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaHZU5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 16:57:48 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27543 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753324AbaHZU5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 16:57:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+/EP08lyCtjBazgx9zkuQ6
Date: Tue, 26 Aug 2014 13:57:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux@openrisc.net, linux@arm.linux.org.uk,
        shawn.guo@freescale.com, kernel@pengutronix.de,
        catalin.marinas@arm.com, will.deacon@arm.com, jonas@southpole.se,
        tglx@linutronix.de, jason@lakedaemon.net, shc_work@mail.ru,
        baohua@kernel.org, maxime.ripard@free-electrons.com,
        khilman@linaro.org, sboyd@codeaurora.org, lorenzo.pieralisi@arm.com,
        larry.bassel@linaro.org, mark.rutland@arm.com, sudeep.holla@arm.com,
        stefan.kristiansson@saunalahti.fi, vkale@apm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH v2 24/26] ARM: omap2: irq: convert to handle_domain_irq
Message-ID: <20140826205729.GB16006@atomide.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
 <1409047421-27649-25-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409047421-27649-25-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marc Zyngier <marc.zyngier@arm.com> [140826 03:05]:
> Use the new handle_domain_irq method to handle interrupts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Seems to boot:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/irq.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
> index 35b8590..a62ba5a 100644
> --- a/arch/arm/mach-omap2/irq.c
> +++ b/arch/arm/mach-omap2/irq.c
> @@ -248,8 +248,7 @@ out:
>  		irqnr &= ACTIVEIRQ_MASK;
>  
>  		if (irqnr) {
> -			irqnr = irq_find_mapping(domain, irqnr);
> -			handle_IRQ(irqnr, regs);
> +			handle_domain_irq(domain, irqnr, regs);
>  			handled_irq = 1;
>  		}
>  	} while (irqnr);
> -- 
> 2.0.4
> 

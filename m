Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaI2SNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:13:41 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26039 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753991AbaI2SNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:13:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+dS8+4Q3O7ItvbFRKGREH+
Date: Mon, 29 Sep 2014 11:12:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jason Cooper <jason@lakedaemon.net>, Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the tip tree with the arm-soc tree
Message-ID: <20140929181258.GF3122@atomide.com>
References: <20140926162512.07ef4957@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926162512.07ef4957@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [140925 23:26]:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> arch/arm/mach-omap2/irq.c between commit 8598066cddd1 ("arm: omap: irq:
> move irq.c to drivers/irqchip/") from the arm-soc tree and commit
> f978999f6096 ("Use the new handle_domain_irq method to handle
> interrupts") from the tip tree.
> 
> I fixed it up (I applied the latter patch to the moved file - see
> below) and can carry the fix as necessary (no action is required).
> 
> diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-intc.c
> index f3814e79192d..28718d3e8281 100644
> --- a/drivers/irqchip/irq-omap-intc.c
> +++ b/drivers/irqchip/irq-omap-intc.c
> @@ -334,8 +334,7 @@ out:
>  		irqnr &= ACTIVEIRQ_MASK;
>  
>  		if (irqnr) {
> -			irqnr = irq_find_mapping(domain, irqnr);
> -			handle_IRQ(irqnr, regs);
> +			handle_domain_irq(domain, irqnr, regs);
>  			handled_irq = 1;
>  		}
>  	} while (irqnr);
> 

Thanks I've verified things are booting fine with linux next.

Regards,

Tony

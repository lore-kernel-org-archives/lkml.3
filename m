Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaG2MDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:03:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:10401 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaG2MDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:03:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/5kOOb6L+IcKHkQB+L/GIg
Date: Tue, 29 Jul 2014 05:01:33 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        bcousson@baylibre.com, linux@arm.linux.org.uk,
        khilman@deeprootsystems.com, tglx@linutronix.de, jason@lakedaemon.net,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 30/35] irqchip: add irq-omap-intc.h header
Message-ID: <20140729120133.GQ29045@atomide.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-31-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406582183-696-31-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140728 14:19]:
> OMAP INTC irqchip driver will be moved under
> drivers/irqchip/ soon but we still have a dependency
> with mach-omap2 when it comes to idle functions.
> 
> In order to make it easy to share those function
> prototypes with OMAP PM code, we introduce this new
> header.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  arch/arm/mach-omap2/board-3430sdp.c        |  1 +
>  arch/arm/mach-omap2/board-am3517crane.c    |  1 +
>  arch/arm/mach-omap2/board-am3517evm.c      |  1 +
>  arch/arm/mach-omap2/board-cm-t35.c         |  1 +
>  arch/arm/mach-omap2/board-cm-t3517.c       |  1 +
>  arch/arm/mach-omap2/board-devkit8000.c     |  1 +
>  arch/arm/mach-omap2/board-ldp.c            |  1 +
>  arch/arm/mach-omap2/board-omap3beagle.c    |  1 +
>  arch/arm/mach-omap2/board-omap3logic.c     |  1 +
>  arch/arm/mach-omap2/board-omap3pandora.c   |  1 +
>  arch/arm/mach-omap2/board-omap3stalker.c   |  1 +
>  arch/arm/mach-omap2/board-omap3touchbook.c |  1 +
>  arch/arm/mach-omap2/board-overo.c          |  1 +
>  arch/arm/mach-omap2/board-rx51.c           |  1 +
>  arch/arm/mach-omap2/board-ti8168evm.c      |  1 +
>  arch/arm/mach-omap2/common.h               |  9 ---------
>  arch/arm/mach-omap2/cpuidle34xx.c          |  1 +
>  arch/arm/mach-omap2/irq.c                  |  1 +
>  arch/arm/mach-omap2/pm24xx.c               |  1 +
>  arch/arm/mach-omap2/pm34xx.c               |  1 +
>  include/linux/irqchip/irq-omap-intc.h      | 32 ++++++++++++++++++++++++++++++
...

> +void omap2_init_irq(void);
> +void omap3_init_irq(void);
> +void ti81xx_init_irq(void);

I think these will all go away with DT based booting?
So it might be worth waiting for that rather than churn
all these files, or..

> +int omap_irq_pending(void);
> +void omap_intc_save_context(void);
> +void omap_intc_restore_context(void);
> +void omap3_intc_suspend(void);
> +void omap3_intc_prepare_idle(void);
> +void omap3_intc_resume_idle(void);

..how about we pass something like struct omap_intc_data
as pdata and let the intc driver populate function pointers
for these if runtime PM calls are not enough here?

That way we could have just minimal pdata header file.

Regards,

Tony

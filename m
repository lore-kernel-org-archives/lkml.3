Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbaGQNkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:40:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22920 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113AbaGQNkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:40:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+x7a6waOXuqQJImi6uGTjg99ketHGvR5U=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8F5115AE3D6
Date: Thu, 17 Jul 2014 09:39:51 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] irqchip: atmel-aic: Add irq RTC fixups
Message-ID: <20140717133951.GQ13108@titan.lakedaemon.net>
References: <1405016741-2407-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405016741-2407-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 08:25:38PM +0200, Boris BREZILLON wrote:
> Hello,
> 
> This patch series introduce the notion of irq fixups for atmel SoCs.
> 
> In most at91 SoCs the first interrupt line is shared by several IPs, and
> some of these HW blocks might be in an unknown state when booting the
> Linux kernel.
> Hence these IPs might generate spurious interrupts if they've not masked
> their irqs and the shared irq line is requested by another peripheral.
> 
> These fixups were previously done in arch/arm/mach-at91/sysirq_mask.c
> but as we're trying to use standard implementation (IRQCHIP_DECLARE and
> automatic call of irqchip_init within arch/arm/kernel/irq.c) we need to
> do those fixups in the irqchip driver.
> 
> This series only fix RTC irqs, but other HW blocks (RTT, PMC, ...) will
> be added later on.
> 
> This series depends on this one [1].
> 
> Best Regards,
> 
> Boris
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/271413.html
> 
> Boris BREZILLON (3):
>   irqchip: atmel-aic: Add irq fixup infrastructure
>   irqchip: atmel-aic: Implement RTC irq fixup
>   irqchip: atmel-aic: Define irq fixups for atmel SoCs
> 
>  drivers/irqchip/irq-atmel-aic-common.c | 47 ++++++++++++++++++++++++++++++++++
>  drivers/irqchip/irq-atmel-aic-common.h |  4 +++
>  drivers/irqchip/irq-atmel-aic.c        | 15 +++++++++++
>  drivers/irqchip/irq-atmel-aic5.c       | 12 +++++++++
>  4 files changed, 78 insertions(+)

Whole series applied on top of irqchip/atmel-aic.

thx,

Jason.

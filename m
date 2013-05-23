Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab3EWMNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:13:51 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:44442 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162Ab3EWMNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:13:50 -0400
Date: Thu, 23 May 2013 14:13:44 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: at91: move at91 aic driver to drivers/irqchip
Message-ID: <20130523141344.7a01ce88@skate>
In-Reply-To: <20130523101825.GL18614@n2100.arm.linux.org.uk>
References: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com>
	<1369299909-10078-2-git-send-email-b.brezillon@overkiz.com>
	<20130523101825.GL18614@n2100.arm.linux.org.uk>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell King - ARM Linux,

On Thu, 23 May 2013 11:18:25 +0100, Russell King - ARM Linux wrote:

> I notice arch/arm/mach-at91/pm.c makes use of some of the register
> definitions:
> 
>         at91_irq_suspend();
> 
>         pr_debug("AT91: PM - wake mask %08x, pm state %d\n",
>                         /* remember all the always-wake irqs */
>                         (at91_pmc_read(AT91_PMC_PCSR)
>                                         | (1 << AT91_ID_FIQ)
>                                         | (1 << AT91_ID_SYS)
>                                         | (at91_extern_irq))
>                                 & at91_aic_read(AT91_AIC_IMR),
>                         state);
> 
> at91_irq_suspend() is in arch/arm/mach-at91/irq.c already, so there's no
> reason that fragment can't be moved there.

The problem is that the goal of the patch set is to move
arch/arm/mach-at91/irq.c into drivers/irqchip/.

However, if you move that chunk of code to drivers/irqchip/irq-at91.c,
you are using at91_pmc_read() which is defined in
arch/arm/mach-at91/include/mach/at91_pmc.h. So,
drivers/irqchip/irq-at91.c would have to include such an header file,
which is something we want to avoid since drivers/ code should not
include something in <mach/...>, as it breaks multiplatform kernels.

So, I'm afraid, simply moving this chunk of code in at91_irq_suspend()
doesn't make the thing any better.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

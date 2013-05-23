Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3EWKUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:20:10 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43672 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab3EWKUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:20:05 -0400
Date: Thu, 23 May 2013 12:20:00 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: boris brezillon <b.brezillon@overkiz.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: at91: move at91 aic driver to drivers/irqchip
Message-ID: <20130523122000.22a9a4d0@skate>
In-Reply-To: <20130523100951.GH9937@game.jcrosoft.org>
References: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com>
	<1369299909-10078-2-git-send-email-b.brezillon@overkiz.com>
	<20130523090611.GG9937@game.jcrosoft.org>
	<519DE6A8.6040502@overkiz.com>
	<20130523120920.1df8e23a@skate>
	<20130523100951.GH9937@game.jcrosoft.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jean-Christophe PLAGNIOL-VILLARD,

On Thu, 23 May 2013 12:09:51 +0200, Jean-Christophe PLAGNIOL-VILLARD
wrote:

> > You can put it in <linux/irqchip/at91-aic.h>, there are already a few
> > headers there. But I think it's not the right solution.
> > 
> > *However*, ideally, this header should disappear completely. All the
> > register defines should go directly into the driver C file. The only
> > usage of the AIC defines outside of the IRQ driver are for debug prints
> > in the pm.c code, which I think you could get rid of.
> > 
> > Ditto for the at91_aic_{read,write} macros.
> > 
> > The NR_AIC5_IRQS can also move to the driver itself.
> > 
> > The only remaining one would be NR_AIC_IRQS, you can't get rid of it,
> > because it's used for the IRQ priority arrays. But I believe keeping
> > this one in <linux/irqchip/at91-aic.h> is reasonable.
> 
> do want either as we expose the register acces for pm & co

Did you read what I write? In arch/arm/mach-at91/pm.c, the only
accesses made to the AIC registers are for pr_debug() calls, i.e only
to print some debugging messages. I believe those ones can simply be
removed to decouple the pm.c code from the irq.c code.

> until this is cleanup NACK

Is this really the way we want to welcome contributions in the kernel
community?

Boris, what you'd have to do is just do a few preparations patches
in your patch set. Something like:

 * PATCH 1: remove usage of AIC registers for debug messages in pm.c
 * PATCH 2: move all of at91_aic.h in irq.c, except NR_AIC_IRQS
 * PATCH 3: move irq.c to drivers/irqchip/, and at91_aic.h to
   include/linux/irqchip/, and adjust what's necessary
 * and then your other patches.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

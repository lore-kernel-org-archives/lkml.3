Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab3CLT1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:27:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52209 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab3CLT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:27:12 -0400
Date: Tue, 12 Mar 2013 20:27:02 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: Add support for ARMv7-M's NVIC
Message-ID: <20130312192702.GQ15375@pengutronix.de>
References: <1363103673-24720-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20130312160101.GW4977@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130312160101.GW4977@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 04:01:01PM +0000, Russell King - ARM Linux wrote:
> On Tue, Mar 12, 2013 at 04:54:33PM +0100, Uwe Kleine-König wrote:
> > +#include <asm/irq.h>
> > +#include <asm/io.h>
> 
> linux/io.h
> 
> > +	unsigned int irqs, i, irq_base;
> > +
> > +	irq_base = irq_alloc_descs(-1, 16, irqs - 16, numa_node_id());
> > +	if (IS_ERR_VALUE(irq_base)) {
> 
> Erm... irq_alloc_descs() returns a negative number on error.
> 
> 	if ((int)irq_base < 0)
> 
> or make irq_base an int, and use:
> 
> 	if (irq_base < 0)
Just for me: So the check using IS_ERR_VALUE is as wrong as the other
occurences in arch/arm that you just kicked out or is it just ugly?

I thought about it and went the "make irq_base int" route (and even
fixed the asm includes) even before I sent my patch. Just failed to pass
the right hash to format-patch after rebasing :-|

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

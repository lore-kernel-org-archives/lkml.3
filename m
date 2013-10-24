Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3JXI5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:57:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:34441 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3JXI5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:57:08 -0400
Date: Thu, 24 Oct 2013 10:57:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rob Herring <robherring2@gmail.com>
cc: Sricharan R <r.sricharan@ti.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, santosh.shilimkar@ti.com,
        linux@arm.linux.org.uk, tony@atomide.com, rnayak@ti.com,
        marc.zyngier@arm.com, grant.likely@linaro.org, mark.rutland@arm.com
Subject: Re: [RFC PATCH 0/6] DRIVERS: IRQCHIP: Add support for crossbar IP
In-Reply-To: <524AD290.207@gmail.com>
Message-ID: <alpine.DEB.2.02.1310241045120.4983@ionos.tec.linutronix.de>
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com> <52499441.1030403@gmail.com> <524AAE69.8060703@ti.com> <524AD290.207@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013, Rob Herring wrote:
> On 10/01/2013 06:13 AM, Sricharan R wrote:
> 
> Is there an actual usecase on a single h/w design that you run out of
> interrupts and it is a user decision which interrupts to use?

I don't think that matters. What matters is that you have a single DT
entry which tells the driver which crossbar irq to use for that
particular device. And that is the only information which is relevant
because the IP block is connected to a crossbar input and not to a GIC
line. The crossbar provides the mapping and this is really best done
at runtime w/o having hardcoded information in the DT or at some other
place.
 
> You could fill in the interrupt-map at run-time. It would have to be
> early (bootloader or early kernel init) and can't be at request_irq time.

How is that supposed to work when you have no idea at early boot time
which particular IP blocks are going to be used later on?

> >   http://www.spinics.net/lists/linux-omap/msg97085.html
> 
> This has nothing to do with the GIC, so it does not belong there.

Errm. crossbar is a mapping device which happens to sit between the
GIC and the IP blocks. So how is this NOT related to GIC ?

Thanks,

	tglx

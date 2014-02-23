Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaBWVkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:40:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:52355 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaBWVkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:15 -0500
Message-Id: <20140223212737.983433636@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        s390 <linux-s390@vger.kernel.org>
Subject: [patch 16/26] s390: cio: Use the core irq stats function
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline;
 filename=s390-cio-use-core-irq-stats-function.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: s390 <linux-s390@vger.kernel.org>
---
 drivers/s390/cio/cio.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: tip/drivers/s390/cio/cio.c
===================================================================
--- tip.orig/drivers/s390/cio/cio.c
+++ tip/drivers/s390/cio/cio.c
@@ -584,8 +584,6 @@ static irqreturn_t do_cio_interrupt(int
 	return IRQ_HANDLED;
 }
 
-static struct irq_desc *irq_desc_io;
-
 static struct irqaction io_interrupt = {
 	.name	 = "IO",
 	.handler = do_cio_interrupt,
@@ -596,7 +594,6 @@ void __init init_cio_interrupts(void)
 	irq_set_chip_and_handler(IO_INTERRUPT,
 				 &dummy_irq_chip, handle_percpu_irq);
 	setup_irq(IO_INTERRUPT, &io_interrupt);
-	irq_desc_io = irq_to_desc(IO_INTERRUPT);
 }
 
 #ifdef CONFIG_CCW_CONSOLE
@@ -623,7 +620,7 @@ void cio_tsch(struct subchannel *sch)
 		local_bh_disable();
 		irq_enter();
 	}
-	kstat_incr_irqs_this_cpu(IO_INTERRUPT, irq_desc_io);
+	kstat_incr_irq_this_cpu(IO_INTERRUPT);
 	if (sch->driver && sch->driver->irq)
 		sch->driver->irq(sch);
 	else



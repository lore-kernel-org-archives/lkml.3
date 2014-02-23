Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaBWVrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:47:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:52236 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaBWVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:05 -0500
Message-Id: <20140223212737.517340416@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>, mips <inux-mips@linux-mips.org>
Subject: [patch 12/26] mips: Use the core irq stats function
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=mips-use-core-irq-stats-function.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: mips <inux-mips@linux-mips.org>
---
 arch/mips/kernel/smtc.c        |    2 +-
 arch/mips/sgi-ip22/ip22-int.c  |    2 +-
 arch/mips/sgi-ip22/ip22-time.c |    2 +-
 arch/mips/sibyte/bcm1480/smp.c |    2 +-
 arch/mips/sibyte/sb1250/smp.c  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

Index: tip/arch/mips/kernel/smtc.c
===================================================================
--- tip.orig/arch/mips/kernel/smtc.c
+++ tip/arch/mips/kernel/smtc.c
@@ -1007,7 +1007,7 @@ static void __irq_entry smtc_clock_tick_
 	int irq = MIPS_CPU_IRQ_BASE + 1;
 
 	irq_enter();
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	cd = &per_cpu(mips_clockevent_device, cpu);
 	cd->event_handler(cd);
 	irq_exit();
Index: tip/arch/mips/sgi-ip22/ip22-int.c
===================================================================
--- tip.orig/arch/mips/sgi-ip22/ip22-int.c
+++ tip/arch/mips/sgi-ip22/ip22-int.c
@@ -148,7 +148,7 @@ static void __irq_entry indy_buserror_ir
 	int irq = SGI_BUSERR_IRQ;
 
 	irq_enter();
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	ip22_be_interrupt(irq);
 	irq_exit();
 }
Index: tip/arch/mips/sgi-ip22/ip22-time.c
===================================================================
--- tip.orig/arch/mips/sgi-ip22/ip22-time.c
+++ tip/arch/mips/sgi-ip22/ip22-time.c
@@ -123,7 +123,7 @@ void __irq_entry indy_8254timer_irq(void
 	char c;
 
 	irq_enter();
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	printk(KERN_ALERT "Oops, got 8254 interrupt.\n");
 	ArcRead(0, &c, 1, &cnt);
 	ArcEnterInteractiveMode();
Index: tip/arch/mips/sibyte/bcm1480/smp.c
===================================================================
--- tip.orig/arch/mips/sibyte/bcm1480/smp.c
+++ tip/arch/mips/sibyte/bcm1480/smp.c
@@ -182,7 +182,7 @@ void bcm1480_mailbox_interrupt(void)
 	int irq = K_BCM1480_INT_MBOX_0_0;
 	unsigned int action;
 
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (__raw_readq(mailbox_0_regs[cpu]) >> 48) & 0xffff;
 
Index: tip/arch/mips/sibyte/sb1250/smp.c
===================================================================
--- tip.orig/arch/mips/sibyte/sb1250/smp.c
+++ tip/arch/mips/sibyte/sb1250/smp.c
@@ -170,7 +170,7 @@ void sb1250_mailbox_interrupt(void)
 	int irq = K_INT_MBOX_0;
 	unsigned int action;
 
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (____raw_readq(mailbox_regs[cpu]) >> 48) & 0xffff;
 



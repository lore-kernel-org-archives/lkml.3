Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3IQSxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:53:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:54485 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab3IQSxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:53:07 -0400
Message-Id: <20130917183628.534494408@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 17 Sep 2013 18:53:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 1/6] hardirq: Make hardirq bits generic
References: <20130917082838.218329307@infradead.org>
 <20130917182350.449685712@linutronix.de>
Content-Disposition: inline;
 filename=hardirqs-remove-arch-specific-HARDIRQ_BITS.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason for per arch hardirq bits. Make them all generic

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/blackfin/include/asm/hardirq.h |    3 ---
 arch/cris/include/asm/hardirq.h     |   12 ------------
 arch/h8300/include/asm/hardirq.h    |   12 ------------
 arch/m32r/include/asm/hardirq.h     |   16 ----------------
 arch/m68k/include/asm/hardirq.h     |   11 -----------
 arch/s390/include/asm/hardirq.h     |    2 --
 arch/sparc/include/asm/hardirq_32.h |    1 -
 arch/sparc/include/asm/hardirq_64.h |    2 --
 arch/tile/include/asm/hardirq.h     |    2 --
 include/linux/preempt_mask.h        |   30 ++++++++----------------------
 10 files changed, 8 insertions(+), 83 deletions(-)

Index: linux-2.6/arch/blackfin/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/blackfin/include/asm/hardirq.h
+++ linux-2.6/arch/blackfin/include/asm/hardirq.h
@@ -12,9 +12,6 @@
 extern void ack_bad_irq(unsigned int irq);
 #define ack_bad_irq ack_bad_irq
 
-/* Define until common code gets sane defaults */
-#define HARDIRQ_BITS 9
-
 #include <asm-generic/hardirq.h>
 
 #endif
Index: linux-2.6/arch/cris/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/hardirq.h
+++ linux-2.6/arch/cris/include/asm/hardirq.h
@@ -2,18 +2,6 @@
 #define __ASM_HARDIRQ_H
 
 #include <asm/irq.h>
-
-#define HARDIRQ_BITS	8
-
-/*
- * The hardirq mask has to be large enough to have
- * space for potentially all IRQ sources in the system
- * nesting on a single CPU:
- */
-#if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-#endif
-
 #include <asm-generic/hardirq.h>
 
 #endif /* __ASM_HARDIRQ_H */
Index: linux-2.6/arch/h8300/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/hardirq.h
+++ linux-2.6/arch/h8300/include/asm/hardirq.h
@@ -2,18 +2,6 @@
 #define __H8300_HARDIRQ_H
 
 #include <asm/irq.h>
-
-#define HARDIRQ_BITS	8
-
-/*
- * The hardirq mask has to be large enough to have
- * space for potentially all IRQ sources in the system
- * nesting on a single CPU:
- */
-#if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-#endif
-
 #include <asm-generic/hardirq.h>
 
 #endif
Index: linux-2.6/arch/m32r/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/hardirq.h
+++ linux-2.6/arch/m32r/include/asm/hardirq.h
@@ -3,22 +3,6 @@
 #define __ASM_HARDIRQ_H
 
 #include <asm/irq.h>
-
-#if NR_IRQS > 256
-#define HARDIRQ_BITS	9
-#else
-#define HARDIRQ_BITS	8
-#endif
-
-/*
- * The hardirq mask has to be large enough to have
- * space for potentially all IRQ sources in the system
- * nesting on a single CPU:
- */
-#if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-#endif
-
 #include <asm-generic/hardirq.h>
 
 #endif /* __ASM_HARDIRQ_H */
Index: linux-2.6/arch/m68k/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/hardirq.h
+++ linux-2.6/arch/m68k/include/asm/hardirq.h
@@ -5,17 +5,6 @@
 #include <linux/cache.h>
 #include <asm/irq.h>
 
-#define HARDIRQ_BITS	8
-
-/*
- * The hardirq mask has to be large enough to have
- * space for potentially all IRQ sources in the system
- * nesting on a single CPU:
- */
-#if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-#endif
-
 #ifdef CONFIG_MMU
 
 static inline void ack_bad_irq(unsigned int irq)
Index: linux-2.6/arch/s390/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/hardirq.h
+++ linux-2.6/arch/s390/include/asm/hardirq.h
@@ -18,8 +18,6 @@
 #define __ARCH_HAS_DO_SOFTIRQ
 #define __ARCH_IRQ_EXIT_IRQS_DISABLED
 
-#define HARDIRQ_BITS	8
-
 static inline void ack_bad_irq(unsigned int irq)
 {
 	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", irq);
Index: linux-2.6/arch/sparc/include/asm/hardirq_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/hardirq_32.h
+++ linux-2.6/arch/sparc/include/asm/hardirq_32.h
@@ -7,7 +7,6 @@
 #ifndef __SPARC_HARDIRQ_H
 #define __SPARC_HARDIRQ_H
 
-#define HARDIRQ_BITS    8
 #include <asm-generic/hardirq.h>
 
 #endif /* __SPARC_HARDIRQ_H */
Index: linux-2.6/arch/sparc/include/asm/hardirq_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/hardirq_64.h
+++ linux-2.6/arch/sparc/include/asm/hardirq_64.h
@@ -14,6 +14,4 @@
 
 void ack_bad_irq(unsigned int irq);
 
-#define HARDIRQ_BITS	8
-
 #endif /* !(__SPARC64_HARDIRQ_H) */
Index: linux-2.6/arch/tile/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/tile/include/asm/hardirq.h
+++ linux-2.6/arch/tile/include/asm/hardirq.h
@@ -42,6 +42,4 @@ DECLARE_PER_CPU(irq_cpustat_t, irq_stat)
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
-#define HARDIRQ_BITS	8
-
 #endif /* _ASM_TILE_HARDIRQ_H */
Index: linux-2.6/include/linux/preempt_mask.h
===================================================================
--- linux-2.6.orig/include/linux/preempt_mask.h
+++ linux-2.6/include/linux/preempt_mask.h
@@ -11,36 +11,22 @@
  * - bits 0-7 are the preemption count (max preemption depth: 256)
  * - bits 8-15 are the softirq count (max # of softirqs: 256)
  *
- * The hardirq count can in theory reach the same as NR_IRQS.
- * In reality, the number of nested IRQS is limited to the stack
- * size as well. For archs with over 1000 IRQS it is not practical
- * to expect that they will all nest. We give a max of 10 bits for
- * hardirq nesting. An arch may choose to give less than 10 bits.
- * m68k expects it to be 8.
- *
- * - bits 16-25 are the hardirq count (max # of nested hardirqs: 1024)
- * - bit 26 is the NMI_MASK
- * - bit 27 is the PREEMPT_ACTIVE flag
+ * The hardirq count could in theory be the same as the number of
+ * interrupts in the system, but we run all interrupt handlers with
+ * interrupts disabled, so we cannot have nesting interrupts. Though
+ * there are a few palaeontologic drivers which reenable interrupts in
+ * the handler, so we need more than one bit here.
  *
  * PREEMPT_MASK: 0x000000ff
  * SOFTIRQ_MASK: 0x0000ff00
- * HARDIRQ_MASK: 0x03ff0000
- *     NMI_MASK: 0x04000000
+ * HARDIRQ_MASK: 0x000f0000
+ *     NMI_MASK: 0x00100000
  */
 #define PREEMPT_BITS	8
 #define SOFTIRQ_BITS	8
+#define HARDIRQ_BITS	4
 #define NMI_BITS	1
 
-#define MAX_HARDIRQ_BITS 10
-
-#ifndef HARDIRQ_BITS
-# define HARDIRQ_BITS	MAX_HARDIRQ_BITS
-#endif
-
-#if HARDIRQ_BITS > MAX_HARDIRQ_BITS
-#error HARDIRQ_BITS too high!
-#endif
-
 #define PREEMPT_SHIFT	0
 #define SOFTIRQ_SHIFT	(PREEMPT_SHIFT + PREEMPT_BITS)
 #define HARDIRQ_SHIFT	(SOFTIRQ_SHIFT + SOFTIRQ_BITS)



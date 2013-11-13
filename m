Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3KMTnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:43:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab3KMTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:43:23 -0500
Date: Wed, 13 Nov 2013 11:42:48 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-54197e43a4a9a0f3fc406d72d9815754e84fab1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130917183628.534494408@linutronix.de>
References: <20130917183628.534494408@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] hardirq: Make hardirq bits generic
Git-Commit-ID: 54197e43a4a9a0f3fc406d72d9815754e84fab1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 11:42:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54197e43a4a9a0f3fc406d72d9815754e84fab1e
Gitweb:     http://git.kernel.org/tip/54197e43a4a9a0f3fc406d72d9815754e84fab1e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 17 Sep 2013 18:53:05 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Nov 2013 20:21:46 +0100

hardirq: Make hardirq bits generic

There is no reason for per arch hardirq bits. Make them all generic

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130917183628.534494408@linutronix.de
---
 arch/blackfin/include/asm/hardirq.h |  3 ---
 arch/cris/include/asm/hardirq.h     | 12 ------------
 arch/m32r/include/asm/hardirq.h     | 16 ----------------
 arch/m68k/include/asm/hardirq.h     | 11 -----------
 arch/s390/include/asm/hardirq.h     |  2 --
 arch/sparc/include/asm/hardirq_32.h |  1 -
 arch/sparc/include/asm/hardirq_64.h |  2 --
 arch/tile/include/asm/hardirq.h     |  2 --
 include/linux/preempt_mask.h        | 30 ++++++++----------------------
 9 files changed, 8 insertions(+), 71 deletions(-)

diff --git a/arch/blackfin/include/asm/hardirq.h b/arch/blackfin/include/asm/hardirq.h
index c078dd7..58b54a6 100644
--- a/arch/blackfin/include/asm/hardirq.h
+++ b/arch/blackfin/include/asm/hardirq.h
@@ -12,9 +12,6 @@
 extern void ack_bad_irq(unsigned int irq);
 #define ack_bad_irq ack_bad_irq
 
-/* Define until common code gets sane defaults */
-#define HARDIRQ_BITS 9
-
 #include <asm-generic/hardirq.h>
 
 #endif
diff --git a/arch/cris/include/asm/hardirq.h b/arch/cris/include/asm/hardirq.h
index 17bb12d..04126f7 100644
--- a/arch/cris/include/asm/hardirq.h
+++ b/arch/cris/include/asm/hardirq.h
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
diff --git a/arch/m32r/include/asm/hardirq.h b/arch/m32r/include/asm/hardirq.h
index 4c31c0a..5f2ac4f 100644
--- a/arch/m32r/include/asm/hardirq.h
+++ b/arch/m32r/include/asm/hardirq.h
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
diff --git a/arch/m68k/include/asm/hardirq.h b/arch/m68k/include/asm/hardirq.h
index db30ed2..6c61852 100644
--- a/arch/m68k/include/asm/hardirq.h
+++ b/arch/m68k/include/asm/hardirq.h
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
diff --git a/arch/s390/include/asm/hardirq.h b/arch/s390/include/asm/hardirq.h
index a908d29..b7eabaa 100644
--- a/arch/s390/include/asm/hardirq.h
+++ b/arch/s390/include/asm/hardirq.h
@@ -18,8 +18,6 @@
 #define __ARCH_HAS_DO_SOFTIRQ
 #define __ARCH_IRQ_EXIT_IRQS_DISABLED
 
-#define HARDIRQ_BITS	8
-
 static inline void ack_bad_irq(unsigned int irq)
 {
 	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", irq);
diff --git a/arch/sparc/include/asm/hardirq_32.h b/arch/sparc/include/asm/hardirq_32.h
index 1620076..ee93923 100644
--- a/arch/sparc/include/asm/hardirq_32.h
+++ b/arch/sparc/include/asm/hardirq_32.h
@@ -7,7 +7,6 @@
 #ifndef __SPARC_HARDIRQ_H
 #define __SPARC_HARDIRQ_H
 
-#define HARDIRQ_BITS    8
 #include <asm-generic/hardirq.h>
 
 #endif /* __SPARC_HARDIRQ_H */
diff --git a/arch/sparc/include/asm/hardirq_64.h b/arch/sparc/include/asm/hardirq_64.h
index 7c29fd1..f478ff1 100644
--- a/arch/sparc/include/asm/hardirq_64.h
+++ b/arch/sparc/include/asm/hardirq_64.h
@@ -14,6 +14,4 @@
 
 void ack_bad_irq(unsigned int irq);
 
-#define HARDIRQ_BITS	8
-
 #endif /* !(__SPARC64_HARDIRQ_H) */
diff --git a/arch/tile/include/asm/hardirq.h b/arch/tile/include/asm/hardirq.h
index 822390f..54110af 100644
--- a/arch/tile/include/asm/hardirq.h
+++ b/arch/tile/include/asm/hardirq.h
@@ -42,6 +42,4 @@ DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
-#define HARDIRQ_BITS	8
-
 #endif /* _ASM_TILE_HARDIRQ_H */
diff --git a/include/linux/preempt_mask.h b/include/linux/preempt_mask.h
index 931bc61..810d7e3 100644
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
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

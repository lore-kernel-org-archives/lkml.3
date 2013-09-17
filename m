Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3IQSxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:53:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:54507 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab3IQSxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:53:11 -0400
Message-Id: <20130917183629.090698799@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 17 Sep 2013 18:53:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 6/6] preempt: Make PREEMPT_ACTIVE generic
References: <20130917082838.218329307@infradead.org>
 <20130917182350.449685712@linutronix.de>
Content-Disposition: inline;
 filename=preempt-get-rid-of-preempt-active-arch-magic.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in having this bit defined by architecture.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/thread_info.h      |    2 --
 arch/arc/include/asm/thread_info.h        |    2 --
 arch/arm/include/asm/thread_info.h        |    6 ------
 arch/arm64/include/asm/thread_info.h      |    6 ------
 arch/avr32/include/asm/thread_info.h      |    2 --
 arch/blackfin/include/asm/thread_info.h   |    2 --
 arch/c6x/include/asm/thread_info.h        |    2 --
 arch/cris/include/asm/thread_info.h       |    2 --
 arch/frv/include/asm/thread_info.h        |    2 --
 arch/h8300/include/asm/thread_info.h      |    2 --
 arch/hexagon/include/asm/thread_info.h    |    4 ----
 arch/ia64/include/asm/thread_info.h       |    3 ---
 arch/m32r/include/asm/thread_info.h       |    2 --
 arch/m68k/include/asm/thread_info.h       |    2 --
 arch/metag/include/asm/thread_info.h      |    2 --
 arch/microblaze/include/asm/thread_info.h |    2 --
 arch/mips/include/asm/thread_info.h       |    2 --
 arch/mn10300/include/asm/thread_info.h    |    2 --
 arch/parisc/include/asm/thread_info.h     |    3 ---
 arch/powerpc/include/asm/thread_info.h    |    2 --
 arch/s390/include/asm/thread_info.h       |    2 --
 arch/score/include/asm/thread_info.h      |    2 --
 arch/sh/include/asm/thread_info.h         |    2 --
 arch/sh/kernel/entry-common.S             |    6 ++----
 arch/sparc/include/asm/thread_info_32.h   |    2 --
 arch/sparc/include/asm/thread_info_64.h   |    2 --
 arch/tile/include/asm/thread_info.h       |    2 --
 arch/um/include/asm/thread_info.h         |    2 --
 arch/unicore32/include/asm/thread_info.h  |    6 ------
 arch/x86/include/asm/thread_info.h        |    2 --
 arch/xtensa/include/asm/thread_info.h     |    2 --
 include/linux/preempt_mask.h              |   15 +++++----------
 32 files changed, 7 insertions(+), 90 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/thread_info.h
+++ linux-2.6/arch/alpha/include/asm/thread_info.h
@@ -58,8 +58,6 @@ register struct thread_info *__current_t
 #define THREAD_SIZE_ORDER 1
 #define THREAD_SIZE (2*PAGE_SIZE)
 
-#define PREEMPT_ACTIVE		0x40000000
-
 /*
  * Thread information flags:
  * - these are process state flags and used from assembly
Index: linux-2.6/arch/arc/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/arc/include/asm/thread_info.h
+++ linux-2.6/arch/arc/include/asm/thread_info.h
@@ -80,8 +80,6 @@ static inline __attribute_const__ struct
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE      0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may need to
Index: linux-2.6/arch/arm/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/thread_info.h
+++ linux-2.6/arch/arm/include/asm/thread_info.h
@@ -141,12 +141,6 @@ extern int vfp_restore_user_hwstate(stru
 #endif
 
 /*
- * We use bit 30 of the preempt_count to indicate that kernel
- * preemption is occurring.  See <asm/hardirq.h>.
- */
-#define PREEMPT_ACTIVE	0x40000000
-
-/*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
  *  TIF_SYSCAL_AUDIT	- syscall auditing active
Index: linux-2.6/arch/arm64/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/arm64/include/asm/thread_info.h
+++ linux-2.6/arch/arm64/include/asm/thread_info.h
@@ -89,12 +89,6 @@ static inline struct thread_info *curren
 #endif
 
 /*
- * We use bit 30 of the preempt_count to indicate that kernel
- * preemption is occurring.  See <asm/hardirq.h>.
- */
-#define PREEMPT_ACTIVE	0x40000000
-
-/*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
  *  TIF_SIGPENDING	- signal pending
Index: linux-2.6/arch/avr32/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/thread_info.h
+++ linux-2.6/arch/avr32/include/asm/thread_info.h
@@ -66,8 +66,6 @@ static inline struct thread_info *curren
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x40000000
-
 /*
  * Thread information flags
  * - these are process state flags that various assembly files may need to access
Index: linux-2.6/arch/blackfin/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/blackfin/include/asm/thread_info.h
+++ linux-2.6/arch/blackfin/include/asm/thread_info.h
@@ -88,8 +88,6 @@ static inline struct thread_info *curren
 #define TI_CPU		12
 #define TI_PREEMPT	16
 
-#define	PREEMPT_ACTIVE	0x4000000
-
 /*
  * thread information flag bit numbers
  */
Index: linux-2.6/arch/c6x/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/c6x/include/asm/thread_info.h
+++ linux-2.6/arch/c6x/include/asm/thread_info.h
@@ -84,8 +84,6 @@ struct thread_info *current_thread_info(
 #define put_thread_info(ti)	put_task_struct((ti)->task)
 #endif /* __ASSEMBLY__ */
 
-#define	PREEMPT_ACTIVE	0x10000000
-
 /*
  * thread information flag bit numbers
  * - pending work-to-be-done flags are in LSW
Index: linux-2.6/arch/cris/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/thread_info.h
+++ linux-2.6/arch/cris/include/asm/thread_info.h
@@ -44,8 +44,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
Index: linux-2.6/arch/frv/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/thread_info.h
+++ linux-2.6/arch/frv/include/asm/thread_info.h
@@ -52,8 +52,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
Index: linux-2.6/arch/h8300/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/thread_info.h
+++ linux-2.6/arch/h8300/include/asm/thread_info.h
@@ -77,8 +77,6 @@ static inline struct thread_info *curren
 #define TI_CPU		12
 #define TI_PRE_COUNT	16
 
-#define	PREEMPT_ACTIVE	0x4000000
-
 /*
  * thread information flag bit numbers
  */
Index: linux-2.6/arch/hexagon/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/hexagon/include/asm/thread_info.h
+++ linux-2.6/arch/hexagon/include/asm/thread_info.h
@@ -73,10 +73,6 @@ struct thread_info {
 
 #endif  /* __ASSEMBLY__  */
 
-/*  looks like "linux/hardirq.h" uses this.  */
-
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifndef __ASSEMBLY__
 
 #define INIT_THREAD_INFO(tsk)                   \
Index: linux-2.6/arch/ia64/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/thread_info.h
+++ linux-2.6/arch/ia64/include/asm/thread_info.h
@@ -11,9 +11,6 @@
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 
-#define PREEMPT_ACTIVE_BIT 30
-#define PREEMPT_ACTIVE	(1 << PREEMPT_ACTIVE_BIT)
-
 #ifndef __ASSEMBLY__
 
 /*
Index: linux-2.6/arch/m32r/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/thread_info.h
+++ linux-2.6/arch/m32r/include/asm/thread_info.h
@@ -53,8 +53,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #define THREAD_SIZE		(PAGE_SIZE << 1)
 #define THREAD_SIZE_ORDER	1
 /*
Index: linux-2.6/arch/m68k/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/thread_info.h
+++ linux-2.6/arch/m68k/include/asm/thread_info.h
@@ -35,8 +35,6 @@ struct thread_info {
 };
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x4000000
-
 #define INIT_THREAD_INFO(tsk)			\
 {						\
 	.task		= &tsk,			\
Index: linux-2.6/arch/metag/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/metag/include/asm/thread_info.h
+++ linux-2.6/arch/metag/include/asm/thread_info.h
@@ -46,8 +46,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SHIFT		12
 #else
Index: linux-2.6/arch/microblaze/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/thread_info.h
+++ linux-2.6/arch/microblaze/include/asm/thread_info.h
@@ -106,8 +106,6 @@ static inline struct thread_info *curren
 /* thread information allocation */
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may
Index: linux-2.6/arch/mips/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/thread_info.h
+++ linux-2.6/arch/mips/include/asm/thread_info.h
@@ -92,8 +92,6 @@ static inline struct thread_info *curren
 
 #define STACK_WARN	(THREAD_SIZE / 8)
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may need to
Index: linux-2.6/arch/mn10300/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/thread_info.h
+++ linux-2.6/arch/mn10300/include/asm/thread_info.h
@@ -16,8 +16,6 @@
 
 #include <asm/page.h>
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SIZE		(4096)
 #define THREAD_SIZE_ORDER	(0)
Index: linux-2.6/arch/parisc/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/thread_info.h
+++ linux-2.6/arch/parisc/include/asm/thread_info.h
@@ -46,9 +46,6 @@ struct thread_info {
 #define THREAD_SIZE             (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define THREAD_SHIFT            (PAGE_SHIFT + THREAD_SIZE_ORDER)
 
-#define PREEMPT_ACTIVE_BIT	28
-#define PREEMPT_ACTIVE		(1 << PREEMPT_ACTIVE_BIT)
-
 /*
  * thread information flags
  */
Index: linux-2.6/arch/powerpc/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/thread_info.h
+++ linux-2.6/arch/powerpc/include/asm/thread_info.h
@@ -82,8 +82,6 @@ static inline struct thread_info *curren
 
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flag bit numbers
  */
Index: linux-2.6/arch/s390/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/thread_info.h
+++ linux-2.6/arch/s390/include/asm/thread_info.h
@@ -111,6 +111,4 @@ static inline struct thread_info *curren
 #define is_32bit_task()		(1)
 #endif
 
-#define PREEMPT_ACTIVE		0x4000000
-
 #endif /* _ASM_THREAD_INFO_H */
Index: linux-2.6/arch/score/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/score/include/asm/thread_info.h
+++ linux-2.6/arch/score/include/asm/thread_info.h
@@ -72,8 +72,6 @@ register struct thread_info *__current_t
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may need to
Index: linux-2.6/arch/sh/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/thread_info.h
+++ linux-2.6/arch/sh/include/asm/thread_info.h
@@ -41,8 +41,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #if defined(CONFIG_4KSTACKS)
 #define THREAD_SHIFT	12
 #else
Index: linux-2.6/arch/sh/kernel/entry-common.S
===================================================================
--- linux-2.6.orig/arch/sh/kernel/entry-common.S
+++ linux-2.6/arch/sh/kernel/entry-common.S
@@ -108,7 +108,7 @@ need_resched:
 	and	#(0xf0>>1), r0		! interrupts off (exception path)?
 	cmp/eq	#(0xf0>>1), r0
 	bt	noresched
-	mov.l	3f, r0
+	mov.l	1f, r0
 	jsr	@r0			! call preempt_schedule_irq
 	 nop
 	bra	need_resched
@@ -119,9 +119,7 @@ noresched:
 	 nop
 
 	.align 2
-1:	.long	PREEMPT_ACTIVE
-2:	.long	schedule
-3:	.long	preempt_schedule_irq
+1:	.long	preempt_schedule_irq
 #endif
 
 ENTRY(resume_userspace)
Index: linux-2.6/arch/sparc/include/asm/thread_info_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/thread_info_32.h
+++ linux-2.6/arch/sparc/include/asm/thread_info_32.h
@@ -105,8 +105,6 @@ register struct thread_info *current_thr
 #define TI_W_SAVED	0x250
 /* #define TI_RESTART_BLOCK 0x25n */ /* Nobody cares */
 
-#define PREEMPT_ACTIVE		0x4000000
-
 /*
  * thread information flag bit numbers
  */
Index: linux-2.6/arch/sparc/include/asm/thread_info_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/thread_info_64.h
+++ linux-2.6/arch/sparc/include/asm/thread_info_64.h
@@ -111,8 +111,6 @@ struct thread_info {
 #define THREAD_SHIFT PAGE_SHIFT
 #endif /* PAGE_SHIFT == 13 */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
Index: linux-2.6/arch/tile/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/tile/include/asm/thread_info.h
+++ linux-2.6/arch/tile/include/asm/thread_info.h
@@ -113,8 +113,6 @@ extern void _cpu_idle(void);
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * Thread information flags that various assembly files may need to access.
  * Keep flags accessed frequently in low bits, particular since it makes
Index: linux-2.6/arch/um/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/um/include/asm/thread_info.h
+++ linux-2.6/arch/um/include/asm/thread_info.h
@@ -60,8 +60,6 @@ static inline struct thread_info *curren
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
Index: linux-2.6/arch/unicore32/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/unicore32/include/asm/thread_info.h
+++ linux-2.6/arch/unicore32/include/asm/thread_info.h
@@ -118,12 +118,6 @@ static inline struct thread_info *curren
 #endif
 
 /*
- * We use bit 30 of the preempt_count to indicate that kernel
- * preemption is occurring.  See <asm/hardirq.h>.
- */
-#define PREEMPT_ACTIVE	0x40000000
-
-/*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
  *  TIF_SIGPENDING	- signal pending
Index: linux-2.6/arch/x86/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/thread_info.h
+++ linux-2.6/arch/x86/include/asm/thread_info.h
@@ -154,8 +154,6 @@ struct thread_info {
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifdef CONFIG_X86_32
 
 #define STACK_WARN	(THREAD_SIZE/8)
Index: linux-2.6/arch/xtensa/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/thread_info.h
+++ linux-2.6/arch/xtensa/include/asm/thread_info.h
@@ -76,8 +76,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
Index: linux-2.6/include/linux/preempt_mask.h
===================================================================
--- linux-2.6.orig/include/linux/preempt_mask.h
+++ linux-2.6/include/linux/preempt_mask.h
@@ -17,10 +17,11 @@
  * there are a few palaeontologic drivers which reenable interrupts in
  * the handler, so we need more than one bit here.
  *
- * PREEMPT_MASK: 0x000000ff
- * SOFTIRQ_MASK: 0x0000ff00
- * HARDIRQ_MASK: 0x000f0000
- *     NMI_MASK: 0x00100000
+ * PREEMPT_MASK:	0x000000ff
+ * SOFTIRQ_MASK:	0x0000ff00
+ * HARDIRQ_MASK:	0x000f0000
+ *     NMI_MASK:	0x00100000
+ * PREEMPT_ACTIVE:	0x00200000
  */
 #define PREEMPT_BITS	8
 #define SOFTIRQ_BITS	8
@@ -46,15 +47,9 @@
 
 #define SOFTIRQ_DISABLE_OFFSET	(2 * SOFTIRQ_OFFSET)
 
-#ifndef PREEMPT_ACTIVE
 #define PREEMPT_ACTIVE_BITS	1
 #define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
 #define PREEMPT_ACTIVE	(__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_ACTIVE_SHIFT)
-#endif
-
-#if PREEMPT_ACTIVE < (1 << (NMI_SHIFT + NMI_BITS))
-#error PREEMPT_ACTIVE is too low!
-#endif
 
 #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
 #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)



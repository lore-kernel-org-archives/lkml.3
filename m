Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab3KMToW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:44:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54619 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab3KMToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:44:00 -0500
Date: Wed, 13 Nov 2013 11:43:25 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-00d1a39e69d5afa7523dad515a05b21abd17c389@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130917183629.090698799@linutronix.de>
References: <20130917183629.090698799@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] preempt: Make PREEMPT_ACTIVE generic
Git-Commit-ID: 00d1a39e69d5afa7523dad515a05b21abd17c389
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 11:43:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00d1a39e69d5afa7523dad515a05b21abd17c389
Gitweb:     http://git.kernel.org/tip/00d1a39e69d5afa7523dad515a05b21abd17c389
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 17 Sep 2013 18:53:09 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Nov 2013 20:21:47 +0100

preempt: Make PREEMPT_ACTIVE generic

No point in having this bit defined by architecture.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130917183629.090698799@linutronix.de
---
 arch/alpha/include/asm/thread_info.h      |  2 --
 arch/arc/include/asm/thread_info.h        |  2 --
 arch/arm/include/asm/thread_info.h        |  6 ------
 arch/arm64/include/asm/thread_info.h      |  6 ------
 arch/avr32/include/asm/thread_info.h      |  2 --
 arch/blackfin/include/asm/thread_info.h   |  2 --
 arch/c6x/include/asm/thread_info.h        |  2 --
 arch/cris/include/asm/thread_info.h       |  2 --
 arch/frv/include/asm/thread_info.h        |  2 --
 arch/hexagon/include/asm/thread_info.h    |  4 ----
 arch/ia64/include/asm/thread_info.h       |  3 ---
 arch/m32r/include/asm/thread_info.h       |  2 --
 arch/m68k/include/asm/thread_info.h       |  2 --
 arch/metag/include/asm/thread_info.h      |  2 --
 arch/microblaze/include/asm/thread_info.h |  2 --
 arch/mips/include/asm/thread_info.h       |  2 --
 arch/mn10300/include/asm/thread_info.h    |  2 --
 arch/parisc/include/asm/thread_info.h     |  3 ---
 arch/powerpc/include/asm/thread_info.h    |  2 --
 arch/s390/include/asm/thread_info.h       |  2 --
 arch/score/include/asm/thread_info.h      |  2 --
 arch/sh/include/asm/thread_info.h         |  2 --
 arch/sh/kernel/entry-common.S             |  6 ++----
 arch/sparc/include/asm/thread_info_32.h   |  2 --
 arch/sparc/include/asm/thread_info_64.h   |  2 --
 arch/tile/include/asm/thread_info.h       |  2 --
 arch/um/include/asm/thread_info.h         |  2 --
 arch/unicore32/include/asm/thread_info.h  |  6 ------
 arch/x86/include/asm/thread_info.h        |  2 --
 arch/xtensa/include/asm/thread_info.h     |  2 --
 include/linux/preempt_mask.h              | 15 +++++----------
 include/linux/sched.h                     |  2 +-
 32 files changed, 8 insertions(+), 89 deletions(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 52cd2a4..453597b 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -58,8 +58,6 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define THREAD_SIZE_ORDER 1
 #define THREAD_SIZE (2*PAGE_SIZE)
 
-#define PREEMPT_ACTIVE		0x40000000
-
 /*
  * Thread information flags:
  * - these are process state flags and used from assembly
diff --git a/arch/arc/include/asm/thread_info.h b/arch/arc/include/asm/thread_info.h
index 2d50a4c..45be216 100644
--- a/arch/arc/include/asm/thread_info.h
+++ b/arch/arc/include/asm/thread_info.h
@@ -80,8 +80,6 @@ static inline __attribute_const__ struct thread_info *current_thread_info(void)
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE      0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may need to
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index df5e13d..71a06b2 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -141,12 +141,6 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
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
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 23a3c47..720e70b 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -89,12 +89,6 @@ static inline struct thread_info *current_thread_info(void)
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
diff --git a/arch/avr32/include/asm/thread_info.h b/arch/avr32/include/asm/thread_info.h
index 6dc62e1..a978f3f 100644
--- a/arch/avr32/include/asm/thread_info.h
+++ b/arch/avr32/include/asm/thread_info.h
@@ -66,8 +66,6 @@ static inline struct thread_info *current_thread_info(void)
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x40000000
-
 /*
  * Thread information flags
  * - these are process state flags that various assembly files may need to access
diff --git a/arch/blackfin/include/asm/thread_info.h b/arch/blackfin/include/asm/thread_info.h
index 3894005..55f473b 100644
--- a/arch/blackfin/include/asm/thread_info.h
+++ b/arch/blackfin/include/asm/thread_info.h
@@ -88,8 +88,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TI_CPU		12
 #define TI_PREEMPT	16
 
-#define	PREEMPT_ACTIVE	0x4000000
-
 /*
  * thread information flag bit numbers
  */
diff --git a/arch/c6x/include/asm/thread_info.h b/arch/c6x/include/asm/thread_info.h
index 4c8dc56..d4e9ef8 100644
--- a/arch/c6x/include/asm/thread_info.h
+++ b/arch/c6x/include/asm/thread_info.h
@@ -84,8 +84,6 @@ struct thread_info *current_thread_info(void)
 #define put_thread_info(ti)	put_task_struct((ti)->task)
 #endif /* __ASSEMBLY__ */
 
-#define	PREEMPT_ACTIVE	0x10000000
-
 /*
  * thread information flag bit numbers
  * - pending work-to-be-done flags are in LSW
diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/thread_info.h
index 07c8c40..55dede1 100644
--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -44,8 +44,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index bebd7ea..af29e17 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -52,8 +52,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
diff --git a/arch/hexagon/include/asm/thread_info.h b/arch/hexagon/include/asm/thread_info.h
index f7c3240..a59dad3 100644
--- a/arch/hexagon/include/asm/thread_info.h
+++ b/arch/hexagon/include/asm/thread_info.h
@@ -73,10 +73,6 @@ struct thread_info {
 
 #endif  /* __ASSEMBLY__  */
 
-/*  looks like "linux/hardirq.h" uses this.  */
-
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifndef __ASSEMBLY__
 
 #define INIT_THREAD_INFO(tsk)                   \
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index cade13d..5957cf6 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -11,9 +11,6 @@
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 
-#define PREEMPT_ACTIVE_BIT 30
-#define PREEMPT_ACTIVE	(1 << PREEMPT_ACTIVE_BIT)
-
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/arch/m32r/include/asm/thread_info.h b/arch/m32r/include/asm/thread_info.h
index c074f4c..0017170 100644
--- a/arch/m32r/include/asm/thread_info.h
+++ b/arch/m32r/include/asm/thread_info.h
@@ -53,8 +53,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #define THREAD_SIZE		(PAGE_SIZE << 1)
 #define THREAD_SIZE_ORDER	1
 /*
diff --git a/arch/m68k/include/asm/thread_info.h b/arch/m68k/include/asm/thread_info.h
index 126131f..21a4784 100644
--- a/arch/m68k/include/asm/thread_info.h
+++ b/arch/m68k/include/asm/thread_info.h
@@ -35,8 +35,6 @@ struct thread_info {
 };
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x4000000
-
 #define INIT_THREAD_INFO(tsk)			\
 {						\
 	.task		= &tsk,			\
diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/asm/thread_info.h
index 7c4a330..b19e9c5 100644
--- a/arch/metag/include/asm/thread_info.h
+++ b/arch/metag/include/asm/thread_info.h
@@ -46,8 +46,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SHIFT		12
 #else
diff --git a/arch/microblaze/include/asm/thread_info.h b/arch/microblaze/include/asm/thread_info.h
index de26ea6..8c9d365 100644
--- a/arch/microblaze/include/asm/thread_info.h
+++ b/arch/microblaze/include/asm/thread_info.h
@@ -106,8 +106,6 @@ static inline struct thread_info *current_thread_info(void)
 /* thread information allocation */
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index f9b24bf..4f58ef6 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -92,8 +92,6 @@ static inline struct thread_info *current_thread_info(void)
 
 #define STACK_WARN	(THREAD_SIZE / 8)
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may need to
diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index 224b426..bf280ea 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -16,8 +16,6 @@
 
 #include <asm/page.h>
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SIZE		(4096)
 #define THREAD_SIZE_ORDER	(0)
diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index bc7cf12..d5f97ea 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -46,9 +46,6 @@ struct thread_info {
 #define THREAD_SIZE             (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define THREAD_SHIFT            (PAGE_SHIFT + THREAD_SIZE_ORDER)
 
-#define PREEMPT_ACTIVE_BIT	28
-#define PREEMPT_ACTIVE		(1 << PREEMPT_ACTIVE_BIT)
-
 /*
  * thread information flags
  */
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index ba7b197..8fd6cf6 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -82,8 +82,6 @@ static inline struct thread_info *current_thread_info(void)
 
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flag bit numbers
  */
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index eb5f64d..10e0fcd 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -111,6 +111,4 @@ static inline struct thread_info *current_thread_info(void)
 #define is_32bit_task()		(1)
 #endif
 
-#define PREEMPT_ACTIVE		0x4000000
-
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/score/include/asm/thread_info.h b/arch/score/include/asm/thread_info.h
index 1425cc0..656b7ad 100644
--- a/arch/score/include/asm/thread_info.h
+++ b/arch/score/include/asm/thread_info.h
@@ -72,8 +72,6 @@ register struct thread_info *__current_thread_info __asm__("r28");
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may need to
diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index 45a9366..ad27ffa 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -41,8 +41,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #if defined(CONFIG_4KSTACKS)
 #define THREAD_SHIFT	12
 #else
diff --git a/arch/sh/kernel/entry-common.S b/arch/sh/kernel/entry-common.S
index 9b6e4be..ca46834 100644
--- a/arch/sh/kernel/entry-common.S
+++ b/arch/sh/kernel/entry-common.S
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
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index dd38075..96efa7a 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -105,8 +105,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define TI_W_SAVED	0x250
 /* #define TI_RESTART_BLOCK 0x25n */ /* Nobody cares */
 
-#define PREEMPT_ACTIVE		0x4000000
-
 /*
  * thread information flag bit numbers
  */
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index d5e5042..2b4e17b 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -111,8 +111,6 @@ struct thread_info {
 #define THREAD_SHIFT PAGE_SHIFT
 #endif /* PAGE_SHIFT == 13 */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index b8aa6df..729aa10 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -113,8 +113,6 @@ extern void _cpu_idle(void);
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * Thread information flags that various assembly files may need to access.
  * Keep flags accessed frequently in low bits, particular since it makes
diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index 2c8eeb2..1c5b2a8 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -60,8 +60,6 @@ static inline struct thread_info *current_thread_info(void)
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
diff --git a/arch/unicore32/include/asm/thread_info.h b/arch/unicore32/include/asm/thread_info.h
index 818b4a1..af36d8e 100644
--- a/arch/unicore32/include/asm/thread_info.h
+++ b/arch/unicore32/include/asm/thread_info.h
@@ -118,12 +118,6 @@ static inline struct thread_info *current_thread_info(void)
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
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index c46a46b..3ba3de4 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -153,8 +153,6 @@ struct thread_info {
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifdef CONFIG_X86_32
 
 #define STACK_WARN	(THREAD_SIZE/8)
diff --git a/arch/xtensa/include/asm/thread_info.h b/arch/xtensa/include/asm/thread_info.h
index 9481004..470153e 100644
--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -76,8 +76,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
diff --git a/include/linux/preempt_mask.h b/include/linux/preempt_mask.h
index 810d7e3..d169820 100644
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 045b0d2..55080df 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -22,7 +22,7 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
-#include <linux/preempt.h>
+#include <linux/preempt_mask.h>
 
 #include <asm/page.h>
 #include <asm/ptrace.h>

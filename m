Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaJZRC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 13:02:27 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57771 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaJZRCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 13:02:24 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arch <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] all arches, signal: Move restart_block to struct task_struct
Date: Sun, 26 Oct 2014 10:02:16 -0700
Message-Id: <90d5683679179df27ffeef18c3e1010ed4e72695.1414342681.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an attacker can cause a controlled kernel stack overflow,
overwriting the restart block is a very juicy exploit target.
Moving the restart block to struct task_struct prevents this type of
exploit.

It's also a decent simplification, since the restart code is more or
less identical on all architectures.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Do any of you know how to test this for real?  It boots for me, but that
doesn't mean all that much.

The kbuild bot hasn't complained about this yet :)

In the interest of keeping the cc list manageable, I haven't cc'd every
single arch maintainer.  Hopefully linux-arch is good enough.

 arch/alpha/include/asm/thread_info.h      | 5 -----
 arch/alpha/kernel/signal.c                | 2 +-
 arch/arc/include/asm/thread_info.h        | 4 ----
 arch/arc/kernel/signal.c                  | 2 +-
 arch/arm/include/asm/thread_info.h        | 4 ----
 arch/arm/kernel/signal.c                  | 4 ++--
 arch/arm/kernel/traps.c                   | 2 +-
 arch/arm64/include/asm/thread_info.h      | 4 ----
 arch/arm64/kernel/signal.c                | 2 +-
 arch/arm64/kernel/signal32.c              | 4 ++--
 arch/avr32/include/asm/thread_info.h      | 4 ----
 arch/avr32/kernel/asm-offsets.c           | 1 -
 arch/avr32/kernel/signal.c                | 2 +-
 arch/blackfin/include/asm/thread_info.h   | 4 ----
 arch/blackfin/kernel/signal.c             | 2 +-
 arch/c6x/include/asm/thread_info.h        | 4 ----
 arch/c6x/kernel/signal.c                  | 2 +-
 arch/cris/arch-v10/kernel/signal.c        | 2 +-
 arch/cris/arch-v32/kernel/signal.c        | 2 +-
 arch/cris/include/asm/thread_info.h       | 4 ----
 arch/frv/include/asm/thread_info.h        | 4 ----
 arch/frv/kernel/asm-offsets.c             | 1 -
 arch/frv/kernel/signal.c                  | 2 +-
 arch/hexagon/include/asm/thread_info.h    | 4 ----
 arch/hexagon/kernel/signal.c              | 2 +-
 arch/ia64/include/asm/thread_info.h       | 4 ----
 arch/ia64/kernel/signal.c                 | 2 +-
 arch/m32r/include/asm/thread_info.h       | 4 ----
 arch/m32r/kernel/signal.c                 | 2 +-
 arch/m68k/include/asm/thread_info.h       | 4 ----
 arch/m68k/kernel/signal.c                 | 4 ++--
 arch/metag/include/asm/thread_info.h      | 4 ----
 arch/metag/kernel/signal.c                | 2 +-
 arch/microblaze/include/asm/thread_info.h | 4 ----
 arch/microblaze/kernel/signal.c           | 2 +-
 arch/mips/include/asm/thread_info.h       | 4 ----
 arch/mips/kernel/asm-offsets.c            | 1 -
 arch/mips/kernel/signal.c                 | 2 +-
 arch/mips/kernel/signal32.c               | 2 +-
 arch/mn10300/include/asm/thread_info.h    | 4 ----
 arch/mn10300/kernel/asm-offsets.c         | 1 -
 arch/mn10300/kernel/signal.c              | 2 +-
 arch/openrisc/include/asm/thread_info.h   | 4 ----
 arch/openrisc/kernel/signal.c             | 2 +-
 arch/parisc/include/asm/thread_info.h     | 4 ----
 arch/parisc/kernel/signal.c               | 2 +-
 arch/powerpc/include/asm/thread_info.h    | 4 ----
 arch/powerpc/kernel/signal_32.c           | 4 ++--
 arch/powerpc/kernel/signal_64.c           | 2 +-
 arch/s390/include/asm/thread_info.h       | 4 ----
 arch/s390/kernel/compat_signal.c          | 2 +-
 arch/s390/kernel/signal.c                 | 2 +-
 arch/score/include/asm/thread_info.h      | 4 ----
 arch/score/kernel/asm-offsets.c           | 1 -
 arch/score/kernel/signal.c                | 2 +-
 arch/sh/include/asm/thread_info.h         | 4 ----
 arch/sh/kernel/asm-offsets.c              | 1 -
 arch/sh/kernel/signal_32.c                | 4 ++--
 arch/sh/kernel/signal_64.c                | 4 ++--
 arch/sparc/include/asm/thread_info_32.h   | 3 ---
 arch/sparc/include/asm/thread_info_64.h   | 3 ---
 arch/sparc/kernel/signal32.c              | 4 ++--
 arch/sparc/kernel/signal_32.c             | 2 +-
 arch/sparc/kernel/signal_64.c             | 2 +-
 arch/sparc/kernel/traps_64.c              | 2 --
 arch/tile/include/asm/thread_info.h       | 4 ----
 arch/tile/kernel/signal.c                 | 2 +-
 arch/um/include/asm/thread_info.h         | 4 ----
 arch/unicore32/include/asm/thread_info.h  | 4 ----
 arch/unicore32/kernel/signal.c            | 2 +-
 arch/x86/ia32/ia32_signal.c               | 2 +-
 arch/x86/include/asm/thread_info.h        | 4 ----
 arch/x86/kernel/signal.c                  | 2 +-
 arch/x86/um/signal.c                      | 2 +-
 arch/xtensa/include/asm/thread_info.h     | 4 ----
 arch/xtensa/kernel/signal.c               | 2 +-
 fs/select.c                               | 2 +-
 include/linux/init_task.h                 | 3 +++
 include/linux/sched.h                     | 2 ++
 kernel/compat.c                           | 5 ++---
 kernel/futex.c                            | 2 +-
 kernel/signal.c                           | 2 +-
 kernel/time/alarmtimer.c                  | 2 +-
 kernel/time/hrtimer.c                     | 2 +-
 kernel/time/posix-cpu-timers.c            | 3 +--
 85 files changed, 59 insertions(+), 183 deletions(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 48bbea6898b3..d5b98ab514bb 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -27,8 +27,6 @@ struct thread_info {
 	int bpt_nsaved;
 	unsigned long bpt_addr[2];		/* breakpoint handling  */
 	unsigned int bpt_insn[2];
-
-	struct restart_block	restart_block;
 };
 
 /*
@@ -40,9 +38,6 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index 6cec2881acbf..8dbfb15f1745 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -150,7 +150,7 @@ restore_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs)
 	struct switch_stack *sw = (struct switch_stack *)regs - 1;
 	long i, err = __get_user(regs->pc, &sc->sc_pc);
 
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	sw->r26 = (unsigned long) ret_from_sys_call;
 
diff --git a/arch/arc/include/asm/thread_info.h b/arch/arc/include/asm/thread_info.h
index 02bc5ec0fb2e..1163a1838ac1 100644
--- a/arch/arc/include/asm/thread_info.h
+++ b/arch/arc/include/asm/thread_info.h
@@ -46,7 +46,6 @@ struct thread_info {
 	struct exec_domain *exec_domain;/* execution domain */
 	__u32 cpu;			/* current CPU */
 	unsigned long thr_ptr;		/* TLS ptr */
-	struct restart_block restart_block;
 };
 
 /*
@@ -62,9 +61,6 @@ struct thread_info {
 	.cpu        = 0,			\
 	.preempt_count  = INIT_PREEMPT_COUNT,	\
 	.addr_limit = KERNEL_DS,		\
-	.restart_block  = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info    (init_thread_union.thread_info)
diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index cb3142a2d40b..114234e83caa 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -104,7 +104,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	struct pt_regs *regs = current_pt_regs();
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* Since we stacked the signal on a word boundary,
 	 * then 'sp' should be word aligned here.  If it's
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index fc44d3761f9e..629e4e2b0996 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -78,7 +78,6 @@ struct thread_info {
 #ifdef CONFIG_ARM_THUMBEE
 	unsigned long		thumbee_state;	/* ThumbEE Handler Base register */
 #endif
-	struct restart_block	restart_block;
 	struct arm_restart_block	arm_restart_block;
 };
 
@@ -92,9 +91,6 @@ struct thread_info {
 	.cpu_domain	= domain_val(DOMAIN_USER, DOMAIN_MANAGER) |	\
 			  domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) |	\
 			  domain_val(DOMAIN_IO, DOMAIN_CLIENT),		\
-	.restart_block	= {						\
-		.fn	= do_no_restart_syscall,			\
-	},								\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index bd1983437205..316dd7d2edb6 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -191,7 +191,7 @@ asmlinkage int sys_sigreturn(struct pt_regs *regs)
 	struct sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 64-bit boundary,
@@ -221,7 +221,7 @@ asmlinkage int sys_rt_sigreturn(struct pt_regs *regs)
 	struct rt_sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 64-bit boundary,
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 0c8b10801d36..c0cfd510ea3e 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -546,7 +546,7 @@ __do_cache_op(unsigned long start, unsigned long end)
 		if (signal_pending(current)) {
 			struct thread_info *ti = current_thread_info();
 
-			ti->restart_block = (struct restart_block) {
+			current->restart_block = (struct restart_block) {
 				.fn	= do_cache_op_restart,
 			};
 
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 459bf8e53208..702e1e6a0d80 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -48,7 +48,6 @@ struct thread_info {
 	mm_segment_t		addr_limit;	/* address limit */
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain	*exec_domain;	/* execution domain */
-	struct restart_block	restart_block;
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
 	int			cpu;		/* cpu */
 };
@@ -60,9 +59,6 @@ struct thread_info {
 	.flags		= 0,						\
 	.preempt_count	= INIT_PREEMPT_COUNT,				\
 	.addr_limit	= KERNEL_DS,					\
-	.restart_block	= {						\
-		.fn	= do_no_restart_syscall,			\
-	},								\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 6fa792137eda..660ccf9f7524 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -131,7 +131,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	struct rt_sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 128-bit boundary, then 'sp' should
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index 1b9ad02837cf..7eca6f212d3b 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -341,7 +341,7 @@ asmlinkage int compat_sys_sigreturn(struct pt_regs *regs)
 	struct compat_sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 64-bit boundary,
@@ -375,7 +375,7 @@ asmlinkage int compat_sys_rt_sigreturn(struct pt_regs *regs)
 	struct compat_rt_sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 64-bit boundary,
diff --git a/arch/avr32/include/asm/thread_info.h b/arch/avr32/include/asm/thread_info.h
index a978f3fe7c25..d56afa99a514 100644
--- a/arch/avr32/include/asm/thread_info.h
+++ b/arch/avr32/include/asm/thread_info.h
@@ -30,7 +30,6 @@ struct thread_info {
 						   saved by debug handler
 						   when setting up
 						   trampoline */
-	struct restart_block	restart_block;
 	__u8			supervisor_stack[0];
 };
 
@@ -41,9 +40,6 @@ struct thread_info {
 	.flags		= 0,						\
 	.cpu		= 0,						\
 	.preempt_count	= INIT_PREEMPT_COUNT,				\
-	.restart_block	= {						\
-		.fn	= do_no_restart_syscall				\
-	}								\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/avr32/kernel/asm-offsets.c b/arch/avr32/kernel/asm-offsets.c
index d6a8193a1d2f..e41c84516e5d 100644
--- a/arch/avr32/kernel/asm-offsets.c
+++ b/arch/avr32/kernel/asm-offsets.c
@@ -18,7 +18,6 @@ void foo(void)
 	OFFSET(TI_preempt_count, thread_info, preempt_count);
 	OFFSET(TI_rar_saved, thread_info, rar_saved);
 	OFFSET(TI_rsr_saved, thread_info, rsr_saved);
-	OFFSET(TI_restart_block, thread_info, restart_block);
 	BLANK();
 	OFFSET(TSK_active_mm, task_struct, active_mm);
 	BLANK();
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index d309fbcc3bd6..8f1c63b9b983 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -69,7 +69,7 @@ asmlinkage int sys_rt_sigreturn(struct pt_regs *regs)
 	sigset_t set;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	frame = (struct rt_sigframe __user *)regs->sp;
 	pr_debug("SIG return: frame = %p\n", frame);
diff --git a/arch/blackfin/include/asm/thread_info.h b/arch/blackfin/include/asm/thread_info.h
index 55f473bdad36..57c3a8bd583d 100644
--- a/arch/blackfin/include/asm/thread_info.h
+++ b/arch/blackfin/include/asm/thread_info.h
@@ -42,7 +42,6 @@ struct thread_info {
 	int cpu;		/* cpu we're on */
 	int preempt_count;	/* 0 => preemptable, <0 => BUG */
 	mm_segment_t addr_limit;	/* address limit */
-	struct restart_block restart_block;
 #ifndef CONFIG_SMP
 	struct l1_scratch_task_info l1_task_info;
 #endif
@@ -58,9 +57,6 @@ struct thread_info {
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 #define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index ef275571d885..f2a8b5493bd3 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -44,7 +44,7 @@ rt_restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *p
 	int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 #define RESTORE(x) err |= __get_user(regs->x, &sc->sc_##x)
 
diff --git a/arch/c6x/include/asm/thread_info.h b/arch/c6x/include/asm/thread_info.h
index d4e9ef87076d..584e253f3217 100644
--- a/arch/c6x/include/asm/thread_info.h
+++ b/arch/c6x/include/asm/thread_info.h
@@ -45,7 +45,6 @@ struct thread_info {
 	int			cpu;		/* cpu we're on */
 	int			preempt_count;	/* 0 = preemptable, <0 = BUG */
 	mm_segment_t		addr_limit;	/* thread address space */
-	struct restart_block	restart_block;
 };
 
 /*
@@ -61,9 +60,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/c6x/kernel/signal.c b/arch/c6x/kernel/signal.c
index fe68226f6c4d..3c4bb5a5c382 100644
--- a/arch/c6x/kernel/signal.c
+++ b/arch/c6x/kernel/signal.c
@@ -68,7 +68,7 @@ asmlinkage int do_rt_sigreturn(struct pt_regs *regs)
 	sigset_t set;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a dword boundary,
diff --git a/arch/cris/arch-v10/kernel/signal.c b/arch/cris/arch-v10/kernel/signal.c
index 9b32d338838b..74d7ba35120d 100644
--- a/arch/cris/arch-v10/kernel/signal.c
+++ b/arch/cris/arch-v10/kernel/signal.c
@@ -67,7 +67,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 	unsigned long old_usp;
 
         /* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* restore the regs from &sc->regs (same as sc, since regs is first)
 	 * (sc is already checked for VERIFY_READ since the sigframe was
diff --git a/arch/cris/arch-v32/kernel/signal.c b/arch/cris/arch-v32/kernel/signal.c
index 78ce3b1c9bcb..870e3e069318 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -59,7 +59,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 	unsigned long old_usp;
 
         /* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Restore the registers from &sc->regs. sc is already checked
diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/thread_info.h
index 55dede18c032..7286db5ed90e 100644
--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -38,7 +38,6 @@ struct thread_info {
 					 	   0-0xBFFFFFFF for user-thead
 						   0-0xFFFFFFFF for kernel-thread
 						*/
-	struct restart_block    restart_block;
 	__u8			supervisor_stack[0];
 };
 
@@ -56,9 +55,6 @@ struct thread_info {
 	.cpu		= 0,				\
 	.preempt_count	= INIT_PREEMPT_COUNT,		\
 	.addr_limit	= KERNEL_DS,			\
-	.restart_block = {				\
-		       .fn = do_no_restart_syscall,	\
-	},						\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index af29e17c0181..6b917f1c2955 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -41,7 +41,6 @@ struct thread_info {
 						 * 0-0xBFFFFFFF for user-thead
 						 * 0-0xFFFFFFFF for kernel-thread
 						 */
-	struct restart_block    restart_block;
 
 	__u8			supervisor_stack[0];
 };
@@ -65,9 +64,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/frv/kernel/asm-offsets.c b/arch/frv/kernel/asm-offsets.c
index 9de96843a278..446e89d500cc 100644
--- a/arch/frv/kernel/asm-offsets.c
+++ b/arch/frv/kernel/asm-offsets.c
@@ -40,7 +40,6 @@ void foo(void)
 	OFFSET(TI_CPU,			thread_info, cpu);
 	OFFSET(TI_PREEMPT_COUNT,	thread_info, preempt_count);
 	OFFSET(TI_ADDR_LIMIT,		thread_info, addr_limit);
-	OFFSET(TI_RESTART_BLOCK,	thread_info, restart_block);
 	BLANK();
 
 	/* offsets into register file storage */
diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index dc3d59de0870..336713ab4745 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -62,7 +62,7 @@ static int restore_sigcontext(struct sigcontext __user *sc, int *_gr8)
 	unsigned long tbr, psr;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	tbr = user->i.tbr;
 	psr = user->i.psr;
diff --git a/arch/hexagon/include/asm/thread_info.h b/arch/hexagon/include/asm/thread_info.h
index a59dad3b3695..bacd3d6030c5 100644
--- a/arch/hexagon/include/asm/thread_info.h
+++ b/arch/hexagon/include/asm/thread_info.h
@@ -56,7 +56,6 @@ struct thread_info {
 	 * used for syscalls somehow;
 	 * seems to have a function pointer and four arguments
 	 */
-	struct restart_block    restart_block;
 	/* Points to the current pt_regs frame  */
 	struct pt_regs		*regs;
 	/*
@@ -83,9 +82,6 @@ struct thread_info {
 	.cpu            = 0,                    \
 	.preempt_count  = 1,                    \
 	.addr_limit     = KERNEL_DS,            \
-	.restart_block = {                      \
-		.fn = do_no_restart_syscall,    \
-	},                                      \
 	.sp = 0,				\
 	.regs = NULL,			\
 }
diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
index eadd70e47e7e..b039a624c170 100644
--- a/arch/hexagon/kernel/signal.c
+++ b/arch/hexagon/kernel/signal.c
@@ -239,7 +239,7 @@ asmlinkage int sys_rt_sigreturn(void)
 	sigset_t blocked;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	frame = (struct rt_sigframe __user *)pt_psp(regs);
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index 5b17418b4223..c16f21a068ff 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -27,7 +27,6 @@ struct thread_info {
 	__u32 status;			/* Thread synchronous flags */
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
-	struct restart_block restart_block;
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	__u64 ac_stamp;
 	__u64 ac_leave;
@@ -46,9 +45,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #ifndef ASM_OFFSETS_C
diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 6d92170be457..b3a124da71e5 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -46,7 +46,7 @@ restore_sigcontext (struct sigcontext __user *sc, struct sigscratch *scr)
 	long err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* restore scratch that always needs gets updated during signal delivery: */
 	err  = __get_user(flags, &sc->sc_flags);
diff --git a/arch/m32r/include/asm/thread_info.h b/arch/m32r/include/asm/thread_info.h
index 00171703402f..173af7c499d8 100644
--- a/arch/m32r/include/asm/thread_info.h
+++ b/arch/m32r/include/asm/thread_info.h
@@ -34,7 +34,6 @@ struct thread_info {
 					 	   0-0xBFFFFFFF for user-thread
 						   0-0xFFFFFFFF for kernel-thread
 						*/
-	struct restart_block    restart_block;
 
 	__u8			supervisor_stack[0];
 };
@@ -68,9 +67,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index 95408b8f130a..7736c6660a15 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -48,7 +48,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	unsigned int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 #define COPY(x)		err |= __get_user(regs->x, &sc->sc_##x)
 	COPY(r4);
diff --git a/arch/m68k/include/asm/thread_info.h b/arch/m68k/include/asm/thread_info.h
index 21a4784ca5a1..c54256e69e64 100644
--- a/arch/m68k/include/asm/thread_info.h
+++ b/arch/m68k/include/asm/thread_info.h
@@ -31,7 +31,6 @@ struct thread_info {
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
 	__u32			cpu;		/* should always be 0 on m68k */
 	unsigned long		tp_value;	/* thread pointer */
-	struct restart_block    restart_block;
 };
 #endif /* __ASSEMBLY__ */
 
@@ -41,9 +40,6 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_stack		(init_thread_union.stack)
diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index 967a8b7e1527..d7179281e74a 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -655,7 +655,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *usc, void __u
 	int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* get previous context */
 	if (copy_from_user(&context, usc, sizeof(context)))
@@ -693,7 +693,7 @@ rt_restore_ucontext(struct pt_regs *regs, struct switch_stack *sw,
 	int err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	err = __get_user(temp, &uc->uc_mcontext.version);
 	if (temp != MCONTEXT_VERSION)
diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/asm/thread_info.h
index 47711336119e..ff4332435d15 100644
--- a/arch/metag/include/asm/thread_info.h
+++ b/arch/metag/include/asm/thread_info.h
@@ -35,7 +35,6 @@ struct thread_info {
 	int preempt_count;	/* 0 => preemptable, <0 => BUG */
 
 	mm_segment_t addr_limit;	/* thread address space */
-	struct restart_block restart_block;
 
 	u8 supervisor_stack[0];
 };
@@ -74,9 +73,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/metag/kernel/signal.c b/arch/metag/kernel/signal.c
index 0d100d5c1407..ce49d429c74a 100644
--- a/arch/metag/kernel/signal.c
+++ b/arch/metag/kernel/signal.c
@@ -48,7 +48,7 @@ static int restore_sigcontext(struct pt_regs *regs,
 	int err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	err = metag_gp_regs_copyin(regs, 0, sizeof(struct user_gp_regs), NULL,
 				   &sc->regs);
diff --git a/arch/microblaze/include/asm/thread_info.h b/arch/microblaze/include/asm/thread_info.h
index 8c9d36591a03..b699fbd7de4a 100644
--- a/arch/microblaze/include/asm/thread_info.h
+++ b/arch/microblaze/include/asm/thread_info.h
@@ -71,7 +71,6 @@ struct thread_info {
 	__u32			cpu; /* current CPU */
 	__s32			preempt_count; /* 0 => preemptable,< 0 => BUG*/
 	mm_segment_t		addr_limit; /* thread address space */
-	struct restart_block	restart_block;
 
 	struct cpu_context	cpu_context;
 };
@@ -87,9 +86,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index 8955a3829cf0..0245c27fa720 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -89,7 +89,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	int rval;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 7de865805deb..955bc921855a 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -34,7 +34,6 @@ struct thread_info {
 						 * 0x7fffffff for user-thead
 						 * 0xffffffff for kernel-thread
 						 */
-	struct restart_block	restart_block;
 	struct pt_regs		*regs;
 };
 
@@ -49,9 +48,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/mips/kernel/asm-offsets.c b/arch/mips/kernel/asm-offsets.c
index b1d84bd4efb3..3b2dfdb4865f 100644
--- a/arch/mips/kernel/asm-offsets.c
+++ b/arch/mips/kernel/asm-offsets.c
@@ -98,7 +98,6 @@ void output_thread_info_defines(void)
 	OFFSET(TI_CPU, thread_info, cpu);
 	OFFSET(TI_PRE_COUNT, thread_info, preempt_count);
 	OFFSET(TI_ADDR_LIMIT, thread_info, addr_limit);
-	OFFSET(TI_RESTART_BLOCK, thread_info, restart_block);
 	OFFSET(TI_REGS, thread_info, regs);
 	DEFINE(_THREAD_SIZE, THREAD_SIZE);
 	DEFINE(_THREAD_MASK, THREAD_MASK);
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index 1d57605e4615..784e78a2ceb9 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -243,7 +243,7 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 	int i;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	err |= __get_user(regs->cp0_epc, &sc->sc_pc);
 
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index d69179c0d49d..19a7705f2a01 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -220,7 +220,7 @@ static int restore_sigcontext32(struct pt_regs *regs,
 	int i;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	err |= __get_user(regs->cp0_epc, &sc->sc_pc);
 	err |= __get_user(regs->hi, &sc->sc_mdhi);
diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index bf280eaccd36..c1c374f0ec12 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -50,7 +50,6 @@ struct thread_info {
 						   0-0xBFFFFFFF for user-thead
 						   0-0xFFFFFFFF for kernel-thread
 						*/
-	struct restart_block    restart_block;
 
 	__u8			supervisor_stack[0];
 };
@@ -80,9 +79,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/mn10300/kernel/asm-offsets.c b/arch/mn10300/kernel/asm-offsets.c
index 47b3bb0c04ff..d780670cbaf3 100644
--- a/arch/mn10300/kernel/asm-offsets.c
+++ b/arch/mn10300/kernel/asm-offsets.c
@@ -28,7 +28,6 @@ void foo(void)
 	OFFSET(TI_cpu,			thread_info, cpu);
 	OFFSET(TI_preempt_count,	thread_info, preempt_count);
 	OFFSET(TI_addr_limit,		thread_info, addr_limit);
-	OFFSET(TI_restart_block,	thread_info, restart_block);
 	BLANK();
 
 	OFFSET(REG_D0,			pt_regs, d0);
diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index a6c0858592c3..8609845f12c5 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -40,7 +40,7 @@ static int restore_sigcontext(struct pt_regs *regs,
 	unsigned int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (is_using_fpu(current))
 		fpu_kill_state(current);
diff --git a/arch/openrisc/include/asm/thread_info.h b/arch/openrisc/include/asm/thread_info.h
index d797acc901e4..875f0845a707 100644
--- a/arch/openrisc/include/asm/thread_info.h
+++ b/arch/openrisc/include/asm/thread_info.h
@@ -57,7 +57,6 @@ struct thread_info {
 					       0-0x7FFFFFFF for user-thead
 					       0-0xFFFFFFFF for kernel-thread
 					     */
-	struct restart_block    restart_block;
 	__u8			supervisor_stack[0];
 
 	/* saved context data */
@@ -79,9 +78,6 @@ struct thread_info {
 	.cpu		= 0,				\
 	.preempt_count	= 1,				\
 	.addr_limit	= KERNEL_DS,			\
-	.restart_block  = {				\
-			  .fn = do_no_restart_syscall,	\
-	},						\
 	.ksp            = 0,                            \
 }
 
diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index 7d1b8235bf90..4112175bf803 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -46,7 +46,7 @@ static int restore_sigcontext(struct pt_regs *regs,
 	int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Restore the regs from &sc->regs.
diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index a84611835549..fb13e3865563 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -14,7 +14,6 @@ struct thread_info {
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	__u32 cpu;			/* current CPU */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
-	struct restart_block restart_block;
 };
 
 #define INIT_THREAD_INFO(tsk)			\
@@ -25,9 +24,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-  	.restart_block	= {			\
-		.fn = do_no_restart_syscall	\
-	}					\
 }
 
 #define init_thread_info        (init_thread_union.thread_info)
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 012d4fa63d97..9b910a0251b8 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -99,7 +99,7 @@ sys_rt_sigreturn(struct pt_regs *regs, int in_syscall)
 		sigframe_size = PARISC_RT_SIGFRAME_SIZE32;
 #endif
 
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* Unwind the user stack to get the rt_sigframe structure. */
 	frame = (struct rt_sigframe __user *)
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index b034ecdb7c74..9344114b1037 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -43,7 +43,6 @@ struct thread_info {
 	int		cpu;			/* cpu we're on */
 	int		preempt_count;		/* 0 => preemptable,
 						   <0 => BUG */
-	struct restart_block restart_block;
 	unsigned long	local_flags;		/* private flags for thread */
 
 	/* low level flags - has atomic operations done on it */
@@ -59,9 +58,6 @@ struct thread_info {
 	.exec_domain =	&default_exec_domain,	\
 	.cpu =		0,			\
 	.preempt_count = INIT_PREEMPT_COUNT,	\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 	.flags =	0,			\
 }
 
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index b171001698ff..d3a831ac0f92 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1231,7 +1231,7 @@ long sys_rt_sigreturn(int r3, int r4, int r5, int r6, int r7, int r8,
 	int tm_restore = 0;
 #endif
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	rt_sf = (struct rt_sigframe __user *)
 		(regs->gpr[1] + __SIGNAL_FRAMESIZE + 16);
@@ -1504,7 +1504,7 @@ long sys_sigreturn(int r3, int r4, int r5, int r6, int r7, int r8,
 #endif
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	sf = (struct sigframe __user *)(regs->gpr[1] + __SIGNAL_FRAMESIZE);
 	sc = &sf->sctx;
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 2cb0c94cafa5..c7c24d2e2bdb 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -666,7 +666,7 @@ int sys_rt_sigreturn(unsigned long r3, unsigned long r4, unsigned long r5,
 #endif
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, uc, sizeof(*uc)))
 		goto badframe;
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index 4d62fd5b56e5..ef1df718642d 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -39,7 +39,6 @@ struct thread_info {
 	unsigned long		sys_call_table;	/* System call table address */
 	unsigned int		cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
-	struct restart_block	restart_block;
 	unsigned int		system_call;
 	__u64			user_timer;
 	__u64			system_timer;
@@ -56,9 +55,6 @@ struct thread_info {
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index 009f5eb11125..5d42186071e2 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -209,7 +209,7 @@ static int restore_sigregs32(struct pt_regs *regs,_sigregs32 __user *sregs)
 	int i;
 
 	/* Alwys make any pending restarted system call return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (__copy_from_user(&user_sregs, &sregs->regs, sizeof(user_sregs)))
 		return -EFAULT;
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 0c1a0ff0a558..237f878f3fb7 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -162,7 +162,7 @@ static int restore_sigregs(struct pt_regs *regs, _sigregs __user *sregs)
 	_sigregs user_sregs;
 
 	/* Alwys make any pending restarted system call return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (__copy_from_user(&user_sregs, sregs, sizeof(user_sregs)))
 		return -EFAULT;
diff --git a/arch/score/include/asm/thread_info.h b/arch/score/include/asm/thread_info.h
index 656b7ada9326..33864fa2a8d4 100644
--- a/arch/score/include/asm/thread_info.h
+++ b/arch/score/include/asm/thread_info.h
@@ -42,7 +42,6 @@ struct thread_info {
 	 * 0-0xFFFFFFFF for kernel-thread
 	 */
 	mm_segment_t		addr_limit;
-	struct restart_block	restart_block;
 	struct pt_regs		*regs;
 };
 
@@ -58,9 +57,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/score/kernel/asm-offsets.c b/arch/score/kernel/asm-offsets.c
index 57788f44c6fb..b4d5214a7a7e 100644
--- a/arch/score/kernel/asm-offsets.c
+++ b/arch/score/kernel/asm-offsets.c
@@ -106,7 +106,6 @@ void output_thread_info_defines(void)
 	OFFSET(TI_CPU, thread_info, cpu);
 	OFFSET(TI_PRE_COUNT, thread_info, preempt_count);
 	OFFSET(TI_ADDR_LIMIT, thread_info, addr_limit);
-	OFFSET(TI_RESTART_BLOCK, thread_info, restart_block);
 	OFFSET(TI_REGS, thread_info, regs);
 	DEFINE(KERNEL_STACK_SIZE, THREAD_SIZE);
 	DEFINE(KERNEL_STACK_MASK, THREAD_MASK);
diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
index 1651807774ad..e381c8c4ff65 100644
--- a/arch/score/kernel/signal.c
+++ b/arch/score/kernel/signal.c
@@ -141,7 +141,7 @@ score_rt_sigreturn(struct pt_regs *regs)
 	int sig;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	frame = (struct rt_sigframe __user *) regs->regs[0];
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index ad27ffa65e2e..657c03919627 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -33,7 +33,6 @@ struct thread_info {
 	__u32			cpu;
 	int			preempt_count; /* 0 => preemptable, <0 => BUG */
 	mm_segment_t		addr_limit;	/* thread address space */
-	struct restart_block	restart_block;
 	unsigned long		previous_sp;	/* sp of previous stack in case
 						   of nested IRQ stacks */
 	__u8			supervisor_stack[0];
@@ -63,9 +62,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/sh/kernel/asm-offsets.c b/arch/sh/kernel/asm-offsets.c
index 08a2be775b6c..542225fedb11 100644
--- a/arch/sh/kernel/asm-offsets.c
+++ b/arch/sh/kernel/asm-offsets.c
@@ -25,7 +25,6 @@ int main(void)
 	DEFINE(TI_FLAGS,	offsetof(struct thread_info, flags));
 	DEFINE(TI_CPU,		offsetof(struct thread_info, cpu));
 	DEFINE(TI_PRE_COUNT,	offsetof(struct thread_info, preempt_count));
-	DEFINE(TI_RESTART_BLOCK,offsetof(struct thread_info, restart_block));
 	DEFINE(TI_SIZE,		sizeof(struct thread_info));
 
 #ifdef CONFIG_HIBERNATION
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 2f002b24fb92..0b34f2a704fe 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -156,7 +156,7 @@ asmlinkage int sys_sigreturn(void)
 	int r0;
 
         /* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -186,7 +186,7 @@ asmlinkage int sys_rt_sigreturn(void)
 	int r0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 897abe7b871e..71993c6a7d94 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -260,7 +260,7 @@ asmlinkage int sys_sigreturn(unsigned long r2, unsigned long r3,
 	long long ret;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -294,7 +294,7 @@ asmlinkage int sys_rt_sigreturn(unsigned long r2, unsigned long r3,
 	long long ret;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index 025c98446b1e..88719dbb12f5 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -62,9 +62,6 @@ struct thread_info {
 	.flags		=	0,			\
 	.cpu		=	0,			\
 	.preempt_count	=	INIT_PREEMPT_COUNT,	\
-	.restart_block	= {				\
-		.fn	=	do_no_restart_syscall,	\
-	},						\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 798f0279a4b5..a11f1e551a58 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -124,9 +124,6 @@ struct thread_info {
 	.current_ds	=	ASI_P,			\
 	.exec_domain	=	&default_exec_domain,	\
 	.preempt_count	=	INIT_PREEMPT_COUNT,	\
-	.restart_block	= {				\
-		.fn	=	do_no_restart_syscall,	\
-	},						\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index 62deba7be1a9..4eed773a7735 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -150,7 +150,7 @@ void do_sigreturn32(struct pt_regs *regs)
 	int err, i;
 	
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	synchronize_user_stack();
 
@@ -235,7 +235,7 @@ asmlinkage void do_rt_sigreturn32(struct pt_regs *regs)
 	int err, i;
 	
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	synchronize_user_stack();
 	regs->u_regs[UREG_FP] &= 0x00000000ffffffffUL;
diff --git a/arch/sparc/kernel/signal_32.c b/arch/sparc/kernel/signal_32.c
index 9ee72fc8e0e4..52aa5e4ce5e7 100644
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -70,7 +70,7 @@ asmlinkage void do_sigreturn(struct pt_regs *regs)
 	int err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	synchronize_user_stack();
 
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index 1a6999868031..d88beff47bab 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -254,7 +254,7 @@ void do_rt_sigreturn(struct pt_regs *regs)
 	int err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	synchronize_user_stack ();
 	sf = (struct rt_signal_frame __user *)
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 981a769b9558..a27651e866e7 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2730,8 +2730,6 @@ void __init trap_init(void)
 		     TI_NEW_CHILD != offsetof(struct thread_info, new_child) ||
 		     TI_CURRENT_DS != offsetof(struct thread_info,
 						current_ds) ||
-		     TI_RESTART_BLOCK != offsetof(struct thread_info,
-						  restart_block) ||
 		     TI_KUNA_REGS != offsetof(struct thread_info,
 					      kern_una_regs) ||
 		     TI_KUNA_INSN != offsetof(struct thread_info,
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index 48e4fd0f38e4..96c14c1430d8 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -36,7 +36,6 @@ struct thread_info {
 
 	mm_segment_t		addr_limit;	/* thread address space
 						   (KERNEL_DS or USER_DS) */
-	struct restart_block	restart_block;
 	struct single_step_state *step_state;	/* single step state
 						   (if non-zero) */
 	int			align_ctl;	/* controls unaligned access */
@@ -57,9 +56,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 	.step_state	= NULL,			\
 	.align_ctl	= 0,			\
 }
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 7c2fecc52177..886a4076034f 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -49,7 +49,7 @@ int restore_sigcontext(struct pt_regs *regs,
 	int i;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Enforce that sigcontext is like pt_regs, and doesn't mess
diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index 1c5b2a83046a..e04114c4fcd9 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -22,7 +22,6 @@ struct thread_info {
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user
 						   0-0xFFFFFFFF for kernel */
-	struct restart_block    restart_block;
 	struct thread_info	*real_thread;    /* Points to non-IRQ stack */
 };
 
@@ -34,9 +33,6 @@ struct thread_info {
 	.cpu =		0,			\
 	.preempt_count = INIT_PREEMPT_COUNT,	\
 	.addr_limit =	KERNEL_DS,		\
-	.restart_block =  {			\
-		.fn =  do_no_restart_syscall,	\
-	},					\
 	.real_thread = NULL,			\
 }
 
diff --git a/arch/unicore32/include/asm/thread_info.h b/arch/unicore32/include/asm/thread_info.h
index af36d8eabdf1..63e2839dfeb8 100644
--- a/arch/unicore32/include/asm/thread_info.h
+++ b/arch/unicore32/include/asm/thread_info.h
@@ -79,7 +79,6 @@ struct thread_info {
 #ifdef CONFIG_UNICORE_FPU_F64
 	struct fp_state		fpstate __attribute__((aligned(8)));
 #endif
-	struct restart_block	restart_block;
 };
 
 #define INIT_THREAD_INFO(tsk)						\
@@ -89,9 +88,6 @@ struct thread_info {
 	.flags		= 0,						\
 	.preempt_count	= INIT_PREEMPT_COUNT,				\
 	.addr_limit	= KERNEL_DS,					\
-	.restart_block	= {						\
-		.fn	= do_no_restart_syscall,			\
-	},								\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
index 7c8fb7018dc6..d329f85766cc 100644
--- a/arch/unicore32/kernel/signal.c
+++ b/arch/unicore32/kernel/signal.c
@@ -105,7 +105,7 @@ asmlinkage int __sys_rt_sigreturn(struct pt_regs *regs)
 	struct rt_sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 64-bit boundary,
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index f9e181aaba97..d0165c9a2932 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -169,7 +169,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	u32 tmp;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	get_user_try {
 		/*
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 854053889d4d..04667118b2ba 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -31,7 +31,6 @@ struct thread_info {
 	__u32			cpu;		/* current CPU */
 	int			saved_preempt_count;
 	mm_segment_t		addr_limit;
-	struct restart_block    restart_block;
 	void __user		*sysenter_return;
 	unsigned int		sig_on_uaccess_error:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
@@ -45,9 +44,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.saved_preempt_count = INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index ed37a768d0fc..0a62df4abcf7 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -69,7 +69,7 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	unsigned int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	get_user_try {
 
diff --git a/arch/x86/um/signal.c b/arch/x86/um/signal.c
index 79d824551c1a..0c8c32bfd792 100644
--- a/arch/x86/um/signal.c
+++ b/arch/x86/um/signal.c
@@ -157,7 +157,7 @@ static int copy_sc_from_user(struct pt_regs *regs,
 	int err, pid;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	err = copy_from_user(&sc, from, sizeof(sc));
 	if (err)
diff --git a/arch/xtensa/include/asm/thread_info.h b/arch/xtensa/include/asm/thread_info.h
index 470153e8547c..b276ccf06320 100644
--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -51,7 +51,6 @@ struct thread_info {
 	__s32			preempt_count;	/* 0 => preemptable,< 0 => BUG*/
 
 	mm_segment_t		addr_limit;	/* thread address space */
-	struct restart_block    restart_block;
 
 	unsigned long		cpenable;
 
@@ -90,9 +89,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index 4612321c73cc..3d733ba16f28 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -245,7 +245,7 @@ asmlinkage long xtensa_rt_sigreturn(long a0, long a1, long a2, long a3,
 	int ret;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (regs->depc > 64)
 		panic("rt_sigreturn in double exception!\n");
diff --git a/fs/select.c b/fs/select.c
index 467bb1cb3ea5..f684c750e08a 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -971,7 +971,7 @@ SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
 	if (ret == -EINTR) {
 		struct restart_block *restart_block;
 
-		restart_block = &current_thread_info()->restart_block;
+		restart_block = &current->restart_block;
 		restart_block->fn = do_restart_poll;
 		restart_block->poll.ufds = ufds;
 		restart_block->poll.nfds = nfds;
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 77fc43f8fb72..254ef93e99d0 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -184,6 +184,9 @@ extern struct task_group root_task_group;
 	.nr_cpus_allowed= NR_CPUS,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
+	.restart_block = {						\
+		.fn = do_no_restart_syscall,				\
+	},								\
 	.se		= {						\
 		.group_node 	= LIST_HEAD_INIT(tsk.se.group_node),	\
 	},								\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bbe63ec..94917a7ecb60 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1327,6 +1327,8 @@ struct task_struct {
 
 	unsigned long atomic_flags; /* Flags needing atomic access. */
 
+	struct restart_block restart_block;
+
 	pid_t pid;
 	pid_t tgid;
 
diff --git a/kernel/compat.c b/kernel/compat.c
index ebb3c369d03d..24f00610c575 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -276,8 +276,7 @@ COMPAT_SYSCALL_DEFINE2(nanosleep, struct compat_timespec __user *, rqtp,
 	 * core implementation decides to return random nonsense.
 	 */
 	if (ret == -ERESTART_RESTARTBLOCK) {
-		struct restart_block *restart
-			= &current_thread_info()->restart_block;
+		struct restart_block *restart = &current->restart_block;
 
 		restart->fn = compat_nanosleep_restart;
 		restart->nanosleep.compat_rmtp = rmtp;
@@ -860,7 +859,7 @@ COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
 		return -EFAULT;
 
 	if (err == -ERESTART_RESTARTBLOCK) {
-		restart = &current_thread_info()->restart_block;
+		restart = &current->restart_block;
 		restart->fn = compat_clock_nanosleep_restart;
 		restart->nanosleep.compat_rmtp = rmtp;
 	}
diff --git a/kernel/futex.c b/kernel/futex.c
index f3a3a071283c..15605c143646 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2211,7 +2211,7 @@ retry:
 	if (!abs_time)
 		goto out;
 
-	restart = &current_thread_info()->restart_block;
+	restart = &current->restart_block;
 	restart->fn = futex_wait_restart;
 	restart->futex.uaddr = uaddr;
 	restart->futex.val = val;
diff --git a/kernel/signal.c b/kernel/signal.c
index 8f0876f9f6dd..d3706358a0c2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2493,7 +2493,7 @@ EXPORT_SYMBOL(unblock_all_signals);
  */
 SYSCALL_DEFINE0(restart_syscall)
 {
-	struct restart_block *restart = &current_thread_info()->restart_block;
+	struct restart_block *restart = &current->restart_block;
 	return restart->fn(restart);
 }
 
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index a7077d3ae52f..1b001ed1edb9 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -788,7 +788,7 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 			goto out;
 	}
 
-	restart = &current_thread_info()->restart_block;
+	restart = &current->restart_block;
 	restart->fn = alarm_timer_nsleep_restart;
 	restart->nanosleep.clockid = type;
 	restart->nanosleep.expires = exp.tv64;
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 37e50aadd471..dbcec65d08c4 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1591,7 +1591,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 			goto out;
 	}
 
-	restart = &current_thread_info()->restart_block;
+	restart = &current->restart_block;
 	restart->fn = hrtimer_nanosleep_restart;
 	restart->nanosleep.clockid = t.timer.base->clockid;
 	restart->nanosleep.rmtp = rmtp;
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 492b986195d5..3c02c3b1aa0f 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1334,8 +1334,7 @@ static long posix_cpu_nsleep_restart(struct restart_block *restart_block);
 static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 			    struct timespec *rqtp, struct timespec __user *rmtp)
 {
-	struct restart_block *restart_block =
-		&current_thread_info()->restart_block;
+	struct restart_block *restart_block = &current->restart_block;
 	struct itimerspec it;
 	int error;
 
-- 
1.9.3


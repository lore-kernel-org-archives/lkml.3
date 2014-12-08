Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaLHO1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:27:42 -0500
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:51460 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755383AbaLHO1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:27:37 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::,RULES_HIT:69:334:355:371:372:379:421:541:960:966:968:973:981:982:988:989:1260:1277:1311:1313:1314:1345:1431:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1801:1981:2194:2196:2197:2198:2199:2200:2201:2202:2393:2559:2562:2689:2693:2731:2892:2895:2898:2899:2903:2904:2907:2923:2924:2925:2926:3138:3139:3140:3141:3142:3308:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4384:4385:4395:4398:4605:5007:6238:6261:7875:7903:7904:8603:8604:8660:8784:9010:9121:9163:9393:9592:10226:10394:10848:11026:11232:11233:11657:11876:11914:12043:12257:12291:12294:12295:12296:12438:12517:12519:12555:12679:12683:13138:13141:13148:13161:13229:13230:13231:13869:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:2:0
X-HE-Tag: voice24_7bca6c31a8b55
X-Filterd-Recvd-Size: 179787
Date: Mon, 8 Dec 2014 09:27:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] tracing: Updates for 3.19
Message-ID: <20141208092729.454d7194@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

There was a lot of clean ups and minor fixes. One of those clean ups was
to the trace_seq code. It also removed the return values to the
trace_seq_*() functions and use trace_seq_has_overflowed() to see if
the buffer filled up or not. This is similar to work being done to the
seq_file code as well in another tree.

Some of the other goodies include:

 o Added some "!" (NOT) logic to the tracing filter.

 o Fixed the frame pointer logic to the x86_64 mcount trampolines

 o Added the logic for dynamic trampolines on !CONFIG_PREEMPT systems.
   That is, the ftrace trampoline can be dynamically allocated
   and be called directly by functions that only have a single hook
   to them.

Please pull the latest trace-3.19 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.19

Tag SHA1: f455bc99a1a3da6c147845ad18c4f33cdbf22e53
Head SHA1: 3558a5ac50dbb2419cc649d5e154af161d661037


Byungchul Park (2):
      function_graph: Fix micro seconds notations
      tracing: Add additional marks to signal very large time deltas

Dan Carpenter (1):
      tracing: Truncated output is better than nothing

Daniel Bristot de Oliveira (1):
      ftrace-graph: show latency-format on print_graph_irq()

Daniel Thompson (2):
      tracing: kdb: Fix kernel panic during ftdump
      tracing: kdb: Fix kernel livelock with empty buffers

Jiang Liu (1):
      tracing: Add entry->next_cpu to trace_ctxwake_bin()

Joonsoo Kim (1):
      Documentation: describe trace_buf_size parameter more accurately

Luis Claudio R. Goncalves (1):
      tracing: Fix traceoff_on_warning handling on boot command line

Markus Elfring (1):
      tracing: Deletion of an unnecessary check before iput()

Masami Hiramatsu (3):
      kprobes/ftrace: Recover original IP if pre_handler doesn't change it
      ftrace, kprobes: Support IPMODIFY flag to find IP modify conflict
      kprobes: Add IPMODIFY flag to kprobe_ftrace_ops

Oleg Nesterov (2):
      tracing: Kill tracing_{start,stop}_sched_switch_record() and tracing_sched_switch_assign_trace()
      tracing: Kill the dead code in probe_sched_switch() and probe_sched_wakeup()

Rasmus Villemoes (3):
      tracing: Replace seq_printf by simpler equivalents
      tracing: Merge consecutive seq_puts calls
      trace: Replace single-character seq_puts with seq_putc

Steven Rostedt (Red Hat) (39):
      ftrace: Set ops->old_hash on modifying what an ops hooks to
      ftrace: Fix checking of trampoline ftrace_ops in finding trampoline
      ftrace/x86: Add dynamic allocated trampoline for ftrace_ops
      ftrace/x86: Show trampoline call function in enabled_functions
      ftrace/x86: Allow !CONFIG_PREEMPT dynamic ops to use allocated trampolines
      ftrace: Add more information to ftrace_bug() output
      tracing: Move tracing_sched_{switch,wakeup}() into wakeup tracer
      ftrace: Have the control_ops get a trampoline
      tracing: Fix race of function probes counting
      ftrace/x86: Add frames pointers to trampoline as necessary
      ftrace/x86/extable: Add is_ftrace_trampoline() function
      x86/kvm/tracing: Use helper function trace_seq_buffer_ptr()
      RAS/tracing: Use trace_seq_buffer_ptr() helper instead of open coded
      tracing: Fix trace_seq_bitmask() to start at current position
      tracing: Add trace_seq_has_overflowed() and trace_handle_return()
      blktrace/tracing: Use trace_seq_has_overflowed() helper function
      ring-buffer: Remove check of trace_seq_{puts,printf}() return values
      tracing: Have branch tracer use trace_handle_return() helper function
      tracing: Have function_graph use trace_seq_has_overflowed()
      kprobes/tracing: Use trace_seq_has_overflowed() for overflow checks
      tracing: Do not check return values of trace_seq_p*() for mmio tracer
      tracing/probes: Do not use return value of trace_seq_printf()
      tracing/uprobes: Do not use return values of trace_seq_printf()
      tracing: Do not use return values of trace_seq_printf() in syscall tracing
      tracing: Remove return values of most trace_seq_*() functions
      tracing: Fix return value of ftrace_raw_output_prep()
      tracing/trivial: Fix typos and make an int into a bool
      ftrace/x86: Have static function tracing always test for function graph
      ftrace/x86: Have static tracing also use ftrace_caller_setup
      ftrace/x86: Move MCOUNT_SAVE_FRAME out of header file
      ftrace/x86: Rename MCOUNT_SAVE_FRAME and add more detailed comments
      ftrace/x86: Have save_mcount_regs store RIP in %rdi for first parameter
      ftrace/x86: Simplify save_mcount_regs on getting RIP
      ftrace/x86: Add macro MCOUNT_REG_SIZE for amount of stack used to save mcount regs
      ftrace/x86: Have save_mcount_regs macro also save stack frames if needed
      ftrace/x86: Get rid of ftrace_caller_setup
      ftrace/fgraph/x86: Have prepare_ftrace_return() take ip as first parameter
      tracing: Add NOT to filtering logic
      tracing: Allow NOT to filter AND and OR clauses

----
 Documentation/kernel-parameters.txt  |   2 +-
 Documentation/trace/ftrace.txt       |  15 +-
 arch/powerpc/kernel/ftrace.c         |   2 +-
 arch/x86/include/asm/ftrace.h        |  33 ---
 arch/x86/kernel/ftrace.c             | 288 +++++++++++++++++++++-
 arch/x86/kernel/kprobes/ftrace.c     |   9 +-
 arch/x86/kernel/mcount_64.S          | 224 ++++++++++++++----
 arch/x86/kvm/mmutrace.h              |   4 +-
 drivers/firmware/efi/cper.c          |   2 +-
 include/linux/ftrace.h               |  36 ++-
 include/linux/ftrace_event.h         |  11 +
 include/linux/trace_seq.h            |  49 ++--
 include/trace/ftrace.h               |   8 +-
 kernel/extable.c                     |   7 +-
 kernel/kprobes.c                     |   2 +-
 kernel/trace/blktrace.c              | 148 ++++++------
 kernel/trace/ftrace.c                | 384 ++++++++++++++++++++++++++----
 kernel/trace/ring_buffer.c           |  75 +++---
 kernel/trace/trace.c                 | 159 +++++++------
 kernel/trace/trace.h                 |  17 +-
 kernel/trace/trace_branch.c          |  47 ++--
 kernel/trace/trace_events.c          |   4 +-
 kernel/trace/trace_events_filter.c   |  29 ++-
 kernel/trace/trace_events_trigger.c  |   6 +-
 kernel/trace/trace_functions.c       | 119 ++++++++--
 kernel/trace/trace_functions_graph.c | 412 ++++++++++----------------------
 kernel/trace/trace_kdb.c             |  21 +-
 kernel/trace/trace_kprobe.c          |  46 ++--
 kernel/trace/trace_mmiotrace.c       |  52 ++--
 kernel/trace/trace_output.c          | 446 +++++++++++++++--------------------
 kernel/trace/trace_output.h          |  16 +-
 kernel/trace/trace_printk.c          |   2 +-
 kernel/trace/trace_probe.c           |  10 +-
 kernel/trace/trace_sched_switch.c    | 144 -----------
 kernel/trace/trace_sched_wakeup.c    |  56 +++++
 kernel/trace/trace_seq.c             |  86 ++-----
 kernel/trace/trace_syscalls.c        |  47 ++--
 kernel/trace/trace_uprobe.c          |  28 +--
 38 files changed, 1717 insertions(+), 1329 deletions(-)
---------------------------
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7dbe5ec9d9cd..1d09eb37c562 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3477,7 +3477,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			are saved.
 
 	trace_buf_size=nn[KMG]
-			[FTRACE] will set tracing buffer size.
+			[FTRACE] will set tracing buffer size on each cpu.
 
 	trace_event=[event-list]
 			[FTRACE] Set and start specified trace events in order
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 4da42616939f..8408e040f06f 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -234,6 +234,11 @@ of ftrace. Here is a list of some of the key files:
 	will be displayed on the same line as the function that
 	is returning registers.
 
+	If the callback registered to be traced by a function with
+	the "ip modify" attribute (thus the regs->ip can be changed),
+	an 'I' will be displayed on the same line as the function that
+	can be overridden.
+
   function_profile_enabled:
 
 	When set it will enable all functions with either the function
@@ -680,9 +685,11 @@ The above is mostly meaningful for kernel developers.
 	 needs to be fixed to be only relative to the same CPU.
 	 The marks are determined by the difference between this
 	 current trace and the next trace.
-	  '!' - greater than preempt_mark_thresh (default 100)
-	  '+' - greater than 1 microsecond
-	  ' ' - less than or equal to 1 microsecond.
+	  '$' - greater than 1 second
+	  '#' - greater than 1000 microsecond
+	  '!' - greater than 100 microsecond
+	  '+' - greater than 10 microsecond
+	  ' ' - less than or equal to 10 microsecond.
 
   The rest is the same as the 'trace' file.
 
@@ -1951,6 +1958,8 @@ want, depending on your needs.
 
   + means that the function exceeded 10 usecs.
   ! means that the function exceeded 100 usecs.
+  # means that the function exceeded 1000 usecs.
+  $ means that the function exceeded 1 sec.
 
 
 - The task/pid field displays the thread cmdline and pid which
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 390311c0f03d..e66af6d265e8 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -449,7 +449,7 @@ void ftrace_replace_code(int enable)
 		rec = ftrace_rec_iter_record(iter);
 		ret = __ftrace_replace_code(rec, enable);
 		if (ret) {
-			ftrace_bug(ret, rec->ip);
+			ftrace_bug(ret, rec);
 			return;
 		}
 	}
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index e1f7fecaa7d6..f45acad3c4b6 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -1,39 +1,6 @@
 #ifndef _ASM_X86_FTRACE_H
 #define _ASM_X86_FTRACE_H
 
-#ifdef __ASSEMBLY__
-
-	/* skip is set if the stack was already partially adjusted */
-	.macro MCOUNT_SAVE_FRAME skip=0
-	 /*
-	  * We add enough stack to save all regs.
-	  */
-	subq $(SS+8-\skip), %rsp
-	movq %rax, RAX(%rsp)
-	movq %rcx, RCX(%rsp)
-	movq %rdx, RDX(%rsp)
-	movq %rsi, RSI(%rsp)
-	movq %rdi, RDI(%rsp)
-	movq %r8, R8(%rsp)
-	movq %r9, R9(%rsp)
-	 /* Move RIP to its proper location */
-	movq SS+8(%rsp), %rdx
-	movq %rdx, RIP(%rsp)
-	.endm
-
-	.macro MCOUNT_RESTORE_FRAME skip=0
-	movq R9(%rsp), %r9
-	movq R8(%rsp), %r8
-	movq RDI(%rsp), %rdi
-	movq RSI(%rsp), %rsi
-	movq RDX(%rsp), %rdx
-	movq RCX(%rsp), %rcx
-	movq RAX(%rsp), %rax
-	addq $(SS+8-\skip), %rsp
-	.endm
-
-#endif
-
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CC_USING_FENTRY
 # define MCOUNT_ADDR		((long)(__fentry__))
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3386dc9aa333..2142376dc8c6 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -17,6 +17,7 @@
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -47,7 +48,7 @@ int ftrace_arch_code_modify_post_process(void)
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
 	struct {
-		char e8;
+		unsigned char e8;
 		int offset;
 	} __attribute__((packed));
 };
@@ -582,7 +583,7 @@ void ftrace_replace_code(int enable)
 
  remove_breakpoints:
 	pr_warn("Failed on %s (%d):\n", report, count);
-	ftrace_bug(ret, rec ? rec->ip : 0);
+	ftrace_bug(ret, rec);
 	for_ftrace_rec_iter(iter) {
 		rec = ftrace_rec_iter_record(iter);
 		/*
@@ -644,13 +645,8 @@ int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
-#endif
-
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-
-#ifdef CONFIG_DYNAMIC_FTRACE
-extern void ftrace_graph_call(void);
 
+#if defined(CONFIG_X86_64) || defined(CONFIG_FUNCTION_GRAPH_TRACER)
 static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
 {
 	static union ftrace_code_union calc;
@@ -664,6 +660,280 @@ static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
 	 */
 	return calc.code;
 }
+#endif
+
+/* Currently only x86_64 supports dynamic trampolines */
+#ifdef CONFIG_X86_64
+
+#ifdef CONFIG_MODULES
+#include <linux/moduleloader.h>
+/* Module allocation simplifies allocating memory for code */
+static inline void *alloc_tramp(unsigned long size)
+{
+	return module_alloc(size);
+}
+static inline void tramp_free(void *tramp)
+{
+	module_free(NULL, tramp);
+}
+#else
+/* Trampolines can only be created if modules are supported */
+static inline void *alloc_tramp(unsigned long size)
+{
+	return NULL;
+}
+static inline void tramp_free(void *tramp) { }
+#endif
+
+/* Defined as markers to the end of the ftrace default trampolines */
+extern void ftrace_caller_end(void);
+extern void ftrace_regs_caller_end(void);
+extern void ftrace_return(void);
+extern void ftrace_caller_op_ptr(void);
+extern void ftrace_regs_caller_op_ptr(void);
+
+/* movq function_trace_op(%rip), %rdx */
+/* 0x48 0x8b 0x15 <offset-to-ftrace_trace_op (4 bytes)> */
+#define OP_REF_SIZE	7
+
+/*
+ * The ftrace_ops is passed to the function callback. Since the
+ * trampoline only services a single ftrace_ops, we can pass in
+ * that ops directly.
+ *
+ * The ftrace_op_code_union is used to create a pointer to the
+ * ftrace_ops that will be passed to the callback function.
+ */
+union ftrace_op_code_union {
+	char code[OP_REF_SIZE];
+	struct {
+		char op[3];
+		int offset;
+	} __attribute__((packed));
+};
+
+static unsigned long
+create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
+{
+	unsigned const char *jmp;
+	unsigned long start_offset;
+	unsigned long end_offset;
+	unsigned long op_offset;
+	unsigned long offset;
+	unsigned long size;
+	unsigned long ip;
+	unsigned long *ptr;
+	void *trampoline;
+	/* 48 8b 15 <offset> is movq <offset>(%rip), %rdx */
+	unsigned const char op_ref[] = { 0x48, 0x8b, 0x15 };
+	union ftrace_op_code_union op_ptr;
+	int ret;
+
+	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
+		start_offset = (unsigned long)ftrace_regs_caller;
+		end_offset = (unsigned long)ftrace_regs_caller_end;
+		op_offset = (unsigned long)ftrace_regs_caller_op_ptr;
+	} else {
+		start_offset = (unsigned long)ftrace_caller;
+		end_offset = (unsigned long)ftrace_caller_end;
+		op_offset = (unsigned long)ftrace_caller_op_ptr;
+	}
+
+	size = end_offset - start_offset;
+
+	/*
+	 * Allocate enough size to store the ftrace_caller code,
+	 * the jmp to ftrace_return, as well as the address of
+	 * the ftrace_ops this trampoline is used for.
+	 */
+	trampoline = alloc_tramp(size + MCOUNT_INSN_SIZE + sizeof(void *));
+	if (!trampoline)
+		return 0;
+
+	*tramp_size = size + MCOUNT_INSN_SIZE + sizeof(void *);
+
+	/* Copy ftrace_caller onto the trampoline memory */
+	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
+	if (WARN_ON(ret < 0)) {
+		tramp_free(trampoline);
+		return 0;
+	}
+
+	ip = (unsigned long)trampoline + size;
+
+	/* The trampoline ends with a jmp to ftrace_return */
+	jmp = ftrace_jmp_replace(ip, (unsigned long)ftrace_return);
+	memcpy(trampoline + size, jmp, MCOUNT_INSN_SIZE);
+
+	/*
+	 * The address of the ftrace_ops that is used for this trampoline
+	 * is stored at the end of the trampoline. This will be used to
+	 * load the third parameter for the callback. Basically, that
+	 * location at the end of the trampoline takes the place of
+	 * the global function_trace_op variable.
+	 */
+
+	ptr = (unsigned long *)(trampoline + size + MCOUNT_INSN_SIZE);
+	*ptr = (unsigned long)ops;
+
+	op_offset -= start_offset;
+	memcpy(&op_ptr, trampoline + op_offset, OP_REF_SIZE);
+
+	/* Are we pointing to the reference? */
+	if (WARN_ON(memcmp(op_ptr.op, op_ref, 3) != 0)) {
+		tramp_free(trampoline);
+		return 0;
+	}
+
+	/* Load the contents of ptr into the callback parameter */
+	offset = (unsigned long)ptr;
+	offset -= (unsigned long)trampoline + op_offset + OP_REF_SIZE;
+
+	op_ptr.offset = offset;
+
+	/* put in the new offset to the ftrace_ops */
+	memcpy(trampoline + op_offset, &op_ptr, OP_REF_SIZE);
+
+	/* ALLOC_TRAMP flags lets us know we created it */
+	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
+
+	return (unsigned long)trampoline;
+}
+
+static unsigned long calc_trampoline_call_offset(bool save_regs)
+{
+	unsigned long start_offset;
+	unsigned long call_offset;
+
+	if (save_regs) {
+		start_offset = (unsigned long)ftrace_regs_caller;
+		call_offset = (unsigned long)ftrace_regs_call;
+	} else {
+		start_offset = (unsigned long)ftrace_caller;
+		call_offset = (unsigned long)ftrace_call;
+	}
+
+	return call_offset - start_offset;
+}
+
+void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
+{
+	ftrace_func_t func;
+	unsigned char *new;
+	unsigned long offset;
+	unsigned long ip;
+	unsigned int size;
+	int ret;
+
+	if (ops->trampoline) {
+		/*
+		 * The ftrace_ops caller may set up its own trampoline.
+		 * In such a case, this code must not modify it.
+		 */
+		if (!(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
+			return;
+	} else {
+		ops->trampoline = create_trampoline(ops, &size);
+		if (!ops->trampoline)
+			return;
+		ops->trampoline_size = size;
+	}
+
+	offset = calc_trampoline_call_offset(ops->flags & FTRACE_OPS_FL_SAVE_REGS);
+	ip = ops->trampoline + offset;
+
+	func = ftrace_ops_get_func(ops);
+
+	/* Do a safe modify in case the trampoline is executing */
+	new = ftrace_call_replace(ip, (unsigned long)func);
+	ret = update_ftrace_func(ip, new);
+
+	/* The update should never fail */
+	WARN_ON(ret);
+}
+
+/* Return the address of the function the trampoline calls */
+static void *addr_from_call(void *ptr)
+{
+	union ftrace_code_union calc;
+	int ret;
+
+	ret = probe_kernel_read(&calc, ptr, MCOUNT_INSN_SIZE);
+	if (WARN_ON_ONCE(ret < 0))
+		return NULL;
+
+	/* Make sure this is a call */
+	if (WARN_ON_ONCE(calc.e8 != 0xe8)) {
+		pr_warn("Expected e8, got %x\n", calc.e8);
+		return NULL;
+	}
+
+	return ptr + MCOUNT_INSN_SIZE + calc.offset;
+}
+
+void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
+			   unsigned long frame_pointer);
+
+/*
+ * If the ops->trampoline was not allocated, then it probably
+ * has a static trampoline func, or is the ftrace caller itself.
+ */
+static void *static_tramp_func(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	unsigned long offset;
+	bool save_regs = rec->flags & FTRACE_FL_REGS_EN;
+	void *ptr;
+
+	if (ops && ops->trampoline) {
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+		/*
+		 * We only know about function graph tracer setting as static
+		 * trampoline.
+		 */
+		if (ops->trampoline == FTRACE_GRAPH_ADDR)
+			return (void *)prepare_ftrace_return;
+#endif
+		return NULL;
+	}
+
+	offset = calc_trampoline_call_offset(save_regs);
+
+	if (save_regs)
+		ptr = (void *)FTRACE_REGS_ADDR + offset;
+	else
+		ptr = (void *)FTRACE_ADDR + offset;
+
+	return addr_from_call(ptr);
+}
+
+void *arch_ftrace_trampoline_func(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	unsigned long offset;
+
+	/* If we didn't allocate this trampoline, consider it static */
+	if (!ops || !(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
+		return static_tramp_func(ops, rec);
+
+	offset = calc_trampoline_call_offset(ops->flags & FTRACE_OPS_FL_SAVE_REGS);
+	return addr_from_call((void *)ops->trampoline + offset);
+}
+
+void arch_ftrace_trampoline_free(struct ftrace_ops *ops)
+{
+	if (!ops || !(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
+		return;
+
+	tramp_free((void *)ops->trampoline);
+	ops->trampoline = 0;
+}
+
+#endif /* CONFIG_X86_64 */
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+extern void ftrace_graph_call(void);
 
 static int ftrace_mod_jmp(unsigned long ip, void *func)
 {
@@ -694,7 +964,7 @@ int ftrace_disable_ftrace_graph_caller(void)
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
  */
-void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 			   unsigned long frame_pointer)
 {
 	unsigned long old;
diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index 717b02a22e67..5f8f0b3cc674 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -27,7 +27,7 @@
 
 static nokprobe_inline
 int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
-		      struct kprobe_ctlblk *kcb)
+		      struct kprobe_ctlblk *kcb, unsigned long orig_ip)
 {
 	/*
 	 * Emulate singlestep (and also recover regs->ip)
@@ -39,6 +39,8 @@ int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 		p->post_handler(p, regs, 0);
 	}
 	__this_cpu_write(current_kprobe, NULL);
+	if (orig_ip)
+		regs->ip = orig_ip;
 	return 1;
 }
 
@@ -46,7 +48,7 @@ int skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 		    struct kprobe_ctlblk *kcb)
 {
 	if (kprobe_ftrace(p))
-		return __skip_singlestep(p, regs, kcb);
+		return __skip_singlestep(p, regs, kcb, 0);
 	else
 		return 0;
 }
@@ -71,13 +73,14 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(p);
 	} else {
+		unsigned long orig_ip = regs->ip;
 		/* Kprobe handler expects regs->ip = ip + 1 as breakpoint hit */
 		regs->ip = ip + sizeof(kprobe_opcode_t);
 
 		__this_cpu_write(current_kprobe, p);
 		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
 		if (!p->pre_handler || !p->pre_handler(p, regs))
-			__skip_singlestep(p, regs, kcb);
+			__skip_singlestep(p, regs, kcb, orig_ip);
 		/*
 		 * If pre_handler returns !0, it sets regs->ip and
 		 * resets current kprobe.
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index c73aecf10d34..94ea120fa21f 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -21,40 +21,159 @@
 # define function_hook	mcount
 #endif
 
+/* All cases save the original rbp (8 bytes) */
+#ifdef CONFIG_FRAME_POINTER
+# ifdef CC_USING_FENTRY
+/* Save parent and function stack frames (rip and rbp) */
+#  define MCOUNT_FRAME_SIZE	(8+16*2)
+# else
+/* Save just function stack frame (rip and rbp) */
+#  define MCOUNT_FRAME_SIZE	(8+16)
+# endif
+#else
+/* No need to save a stack frame */
+# define MCOUNT_FRAME_SIZE	8
+#endif /* CONFIG_FRAME_POINTER */
+
+/* Size of stack used to save mcount regs in save_mcount_regs */
+#define MCOUNT_REG_SIZE		(SS+8 + MCOUNT_FRAME_SIZE)
+
+/*
+ * gcc -pg option adds a call to 'mcount' in most functions.
+ * When -mfentry is used, the call is to 'fentry' and not 'mcount'
+ * and is done before the function's stack frame is set up.
+ * They both require a set of regs to be saved before calling
+ * any C code and restored before returning back to the function.
+ *
+ * On boot up, all these calls are converted into nops. When tracing
+ * is enabled, the call can jump to either ftrace_caller or
+ * ftrace_regs_caller. Callbacks (tracing functions) that require
+ * ftrace_regs_caller (like kprobes) need to have pt_regs passed to
+ * it. For this reason, the size of the pt_regs structure will be
+ * allocated on the stack and the required mcount registers will
+ * be saved in the locations that pt_regs has them in.
+ */
+
+/*
+ * @added: the amount of stack added before calling this
+ *
+ * After this is called, the following registers contain:
+ *
+ *  %rdi - holds the address that called the trampoline
+ *  %rsi - holds the parent function (traced function's return address)
+ *  %rdx - holds the original %rbp
+ */
+.macro save_mcount_regs added=0
+
+	/* Always save the original rbp */
+	pushq %rbp
+
+#ifdef CONFIG_FRAME_POINTER
+	/*
+	 * Stack traces will stop at the ftrace trampoline if the frame pointer
+	 * is not set up properly. If fentry is used, we need to save a frame
+	 * pointer for the parent as well as the function traced, because the
+	 * fentry is called before the stack frame is set up, where as mcount
+	 * is called afterward.
+	 */
+#ifdef CC_USING_FENTRY
+	/* Save the parent pointer (skip orig rbp and our return address) */
+	pushq \added+8*2(%rsp)
+	pushq %rbp
+	movq %rsp, %rbp
+	/* Save the return address (now skip orig rbp, rbp and parent) */
+	pushq \added+8*3(%rsp)
+#else
+	/* Can't assume that rip is before this (unless added was zero) */
+	pushq \added+8(%rsp)
+#endif
+	pushq %rbp
+	movq %rsp, %rbp
+#endif /* CONFIG_FRAME_POINTER */
+
+	/*
+	 * We add enough stack to save all regs.
+	 */
+	subq $(MCOUNT_REG_SIZE - MCOUNT_FRAME_SIZE), %rsp
+	movq %rax, RAX(%rsp)
+	movq %rcx, RCX(%rsp)
+	movq %rdx, RDX(%rsp)
+	movq %rsi, RSI(%rsp)
+	movq %rdi, RDI(%rsp)
+	movq %r8, R8(%rsp)
+	movq %r9, R9(%rsp)
+	/*
+	 * Save the original RBP. Even though the mcount ABI does not
+	 * require this, it helps out callers.
+	 */
+	movq MCOUNT_REG_SIZE-8(%rsp), %rdx
+	movq %rdx, RBP(%rsp)
+
+	/* Copy the parent address into %rsi (second parameter) */
+#ifdef CC_USING_FENTRY
+	movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
+#else
+	/* %rdx contains original %rbp */
+	movq 8(%rdx), %rsi
+#endif
+
+	 /* Move RIP to its proper location */
+	movq MCOUNT_REG_SIZE+\added(%rsp), %rdi
+	movq %rdi, RIP(%rsp)
+
+	/*
+	 * Now %rdi (the first parameter) has the return address of
+	 * where ftrace_call returns. But the callbacks expect the
+	 * address of the call itself.
+	 */
+	subq $MCOUNT_INSN_SIZE, %rdi
+	.endm
+
+.macro restore_mcount_regs
+	movq R9(%rsp), %r9
+	movq R8(%rsp), %r8
+	movq RDI(%rsp), %rdi
+	movq RSI(%rsp), %rsi
+	movq RDX(%rsp), %rdx
+	movq RCX(%rsp), %rcx
+	movq RAX(%rsp), %rax
+
+	/* ftrace_regs_caller can modify %rbp */
+	movq RBP(%rsp), %rbp
+
+	addq $MCOUNT_REG_SIZE, %rsp
+
+	.endm
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 ENTRY(function_hook)
 	retq
 END(function_hook)
 
-/* skip is set if stack has been adjusted */
-.macro ftrace_caller_setup skip=0
-	MCOUNT_SAVE_FRAME \skip
+ENTRY(ftrace_caller)
+	/* save_mcount_regs fills in first two parameters */
+	save_mcount_regs
 
+GLOBAL(ftrace_caller_op_ptr)
 	/* Load the ftrace_ops into the 3rd parameter */
 	movq function_trace_op(%rip), %rdx
 
-	/* Load ip into the first parameter */
-	movq RIP(%rsp), %rdi
-	subq $MCOUNT_INSN_SIZE, %rdi
-	/* Load the parent_ip into the second parameter */
-#ifdef CC_USING_FENTRY
-	movq SS+16(%rsp), %rsi
-#else
-	movq 8(%rbp), %rsi
-#endif
-.endm
-
-ENTRY(ftrace_caller)
-	ftrace_caller_setup
 	/* regs go into 4th parameter (but make it NULL) */
 	movq $0, %rcx
 
 GLOBAL(ftrace_call)
 	call ftrace_stub
 
-	MCOUNT_RESTORE_FRAME
-ftrace_return:
+	restore_mcount_regs
+
+	/*
+	 * The copied trampoline must call ftrace_return as it
+	 * still may need to call the function graph tracer.
+	 */
+GLOBAL(ftrace_caller_end)
+
+GLOBAL(ftrace_return)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 GLOBAL(ftrace_graph_call)
@@ -66,11 +185,16 @@ GLOBAL(ftrace_stub)
 END(ftrace_caller)
 
 ENTRY(ftrace_regs_caller)
-	/* Save the current flags before compare (in SS location)*/
+	/* Save the current flags before any operations that can change them */
 	pushfq
 
-	/* skip=8 to skip flags saved in SS */
-	ftrace_caller_setup 8
+	/* added 8 bytes to save flags */
+	save_mcount_regs 8
+	/* save_mcount_regs fills in first two parameters */
+
+GLOBAL(ftrace_regs_caller_op_ptr)
+	/* Load the ftrace_ops into the 3rd parameter */
+	movq function_trace_op(%rip), %rdx
 
 	/* Save the rest of pt_regs */
 	movq %r15, R15(%rsp)
@@ -79,18 +203,17 @@ ENTRY(ftrace_regs_caller)
 	movq %r12, R12(%rsp)
 	movq %r11, R11(%rsp)
 	movq %r10, R10(%rsp)
-	movq %rbp, RBP(%rsp)
 	movq %rbx, RBX(%rsp)
 	/* Copy saved flags */
-	movq SS(%rsp), %rcx
+	movq MCOUNT_REG_SIZE(%rsp), %rcx
 	movq %rcx, EFLAGS(%rsp)
 	/* Kernel segments */
 	movq $__KERNEL_DS, %rcx
 	movq %rcx, SS(%rsp)
 	movq $__KERNEL_CS, %rcx
 	movq %rcx, CS(%rsp)
-	/* Stack - skipping return address */
-	leaq SS+16(%rsp), %rcx
+	/* Stack - skipping return address and flags */
+	leaq MCOUNT_REG_SIZE+8*2(%rsp), %rcx
 	movq %rcx, RSP(%rsp)
 
 	/* regs go into 4th parameter */
@@ -101,11 +224,11 @@ GLOBAL(ftrace_regs_call)
 
 	/* Copy flags back to SS, to restore them */
 	movq EFLAGS(%rsp), %rax
-	movq %rax, SS(%rsp)
+	movq %rax, MCOUNT_REG_SIZE(%rsp)
 
 	/* Handlers can change the RIP */
 	movq RIP(%rsp), %rax
-	movq %rax, SS+8(%rsp)
+	movq %rax, MCOUNT_REG_SIZE+8(%rsp)
 
 	/* restore the rest of pt_regs */
 	movq R15(%rsp), %r15
@@ -113,19 +236,22 @@ GLOBAL(ftrace_regs_call)
 	movq R13(%rsp), %r13
 	movq R12(%rsp), %r12
 	movq R10(%rsp), %r10
-	movq RBP(%rsp), %rbp
 	movq RBX(%rsp), %rbx
 
-	/* skip=8 to skip flags saved in SS */
-	MCOUNT_RESTORE_FRAME 8
+	restore_mcount_regs
 
 	/* Restore flags */
 	popfq
 
-	jmp ftrace_return
+	/*
+	 * As this jmp to ftrace_return can be a short jump
+	 * it must not be copied into the trampoline.
+	 * The trampoline will add the code to jump
+	 * to the return.
+	 */
+GLOBAL(ftrace_regs_caller_end)
 
-	popfq
-	jmp  ftrace_stub
+	jmp ftrace_return
 
 END(ftrace_regs_caller)
 
@@ -136,6 +262,7 @@ ENTRY(function_hook)
 	cmpq $ftrace_stub, ftrace_trace_function
 	jnz trace
 
+fgraph_trace:
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	cmpq $ftrace_stub, ftrace_graph_return
 	jnz ftrace_graph_caller
@@ -148,42 +275,35 @@ GLOBAL(ftrace_stub)
 	retq
 
 trace:
-	MCOUNT_SAVE_FRAME
-
-	movq RIP(%rsp), %rdi
-#ifdef CC_USING_FENTRY
-	movq SS+16(%rsp), %rsi
-#else
-	movq 8(%rbp), %rsi
-#endif
-	subq $MCOUNT_INSN_SIZE, %rdi
+	/* save_mcount_regs fills in first two parameters */
+	save_mcount_regs
 
 	call   *ftrace_trace_function
 
-	MCOUNT_RESTORE_FRAME
+	restore_mcount_regs
 
-	jmp ftrace_stub
+	jmp fgraph_trace
 END(function_hook)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	MCOUNT_SAVE_FRAME
+	/* Saves rbp into %rdx and fills first parameter  */
+	save_mcount_regs
 
 #ifdef CC_USING_FENTRY
-	leaq SS+16(%rsp), %rdi
+	leaq MCOUNT_REG_SIZE+8(%rsp), %rsi
 	movq $0, %rdx	/* No framepointers needed */
 #else
-	leaq 8(%rbp), %rdi
-	movq (%rbp), %rdx
+	/* Save address of the return address of traced function */
+	leaq 8(%rdx), %rsi
+	/* ftrace does sanity checks against frame pointers */
+	movq (%rdx), %rdx
 #endif
-	movq RIP(%rsp), %rsi
-	subq $MCOUNT_INSN_SIZE, %rsi
-
 	call	prepare_ftrace_return
 
-	MCOUNT_RESTORE_FRAME
+	restore_mcount_regs
 
 	retq
 END(ftrace_graph_caller)
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 5aaf35641768..ce463a9cc8fb 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -22,7 +22,7 @@
 	__entry->unsync = sp->unsync;
 
 #define KVM_MMU_PAGE_PRINTK() ({				        \
-	const u32 saved_len = p->len;					\
+	const char *saved_ptr = trace_seq_buffer_ptr(p);		\
 	static const char *access_str[] = {			        \
 		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  \
 	};							        \
@@ -41,7 +41,7 @@
 			 role.nxe ? "" : "!",				\
 			 __entry->root_count,				\
 			 __entry->unsync ? "unsync" : "sync", 0);	\
-	p->buffer + saved_len;						\
+	saved_ptr;							\
 		})
 
 #define kvm_mmu_trace_pferr_flags       \
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 5b53d6183b6b..4fd9961d552e 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -294,7 +294,7 @@ void cper_mem_err_pack(const struct cper_sec_mem_err *mem,
 const char *cper_mem_err_unpack(struct trace_seq *p,
 				struct cper_mem_err_compact *cmem)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 
 	if (cper_mem_err_location(cmem, rcd_decode_str))
 		trace_seq_printf(p, "%s", rcd_decode_str);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 662697babd48..ed501953f0b2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -61,6 +61,11 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
 /*
  * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
  * set in the flags member.
+ * CONTROL, SAVE_REGS, SAVE_REGS_IF_SUPPORTED, RECURSION_SAFE, STUB and
+ * IPMODIFY are a kind of attribute flags which can be set only before
+ * registering the ftrace_ops, and can not be modified while registered.
+ * Changing those attribute flags after regsitering ftrace_ops will
+ * cause unexpected results.
  *
  * ENABLED - set/unset when ftrace_ops is registered/unregistered
  * DYNAMIC - set when ftrace_ops is registered to denote dynamically
@@ -94,6 +99,17 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
  * ADDING  - The ops is in the process of being added.
  * REMOVING - The ops is in the process of being removed.
  * MODIFYING - The ops is in the process of changing its filter functions.
+ * ALLOC_TRAMP - A dynamic trampoline was allocated by the core code.
+ *            The arch specific code sets this flag when it allocated a
+ *            trampoline. This lets the arch know that it can update the
+ *            trampoline in case the callback function changes.
+ *            The ftrace_ops trampoline can be set by the ftrace users, and
+ *            in such cases the arch must not modify it. Only the arch ftrace
+ *            core code should set this flag.
+ * IPMODIFY - The ops can modify the IP register. This can only be set with
+ *            SAVE_REGS. If another ops with this flag set is already registered
+ *            for any of the functions that this ops will be registered for, then
+ *            this ops will fail to register or set_filter_ip.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -108,6 +124,8 @@ enum {
 	FTRACE_OPS_FL_ADDING			= 1 << 9,
 	FTRACE_OPS_FL_REMOVING			= 1 << 10,
 	FTRACE_OPS_FL_MODIFYING			= 1 << 11,
+	FTRACE_OPS_FL_ALLOC_TRAMP		= 1 << 12,
+	FTRACE_OPS_FL_IPMODIFY			= 1 << 13,
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -142,6 +160,7 @@ struct ftrace_ops {
 	struct ftrace_ops_hash		*func_hash;
 	struct ftrace_ops_hash		old_hash;
 	unsigned long			trampoline;
+	unsigned long			trampoline_size;
 #endif
 };
 
@@ -255,7 +274,9 @@ struct ftrace_func_command {
 int ftrace_arch_code_modify_prepare(void);
 int ftrace_arch_code_modify_post_process(void);
 
-void ftrace_bug(int err, unsigned long ip);
+struct dyn_ftrace;
+
+void ftrace_bug(int err, struct dyn_ftrace *rec);
 
 struct seq_file;
 
@@ -287,6 +308,8 @@ extern int ftrace_text_reserved(const void *start, const void *end);
 
 extern int ftrace_nr_registered_ops(void);
 
+bool is_ftrace_trampoline(unsigned long addr);
+
 /*
  * The dyn_ftrace record's flags field is split into two parts.
  * the first part which is '0-FTRACE_REF_MAX' is a counter of
@@ -297,6 +320,7 @@ extern int ftrace_nr_registered_ops(void);
  *  ENABLED - the function is being traced
  *  REGS    - the record wants the function to save regs
  *  REGS_EN - the function is set up to save regs.
+ *  IPMODIFY - the record allows for the IP address to be changed.
  *
  * When a new ftrace_ops is registered and wants a function to save
  * pt_regs, the rec->flag REGS is set. When the function has been
@@ -310,10 +334,11 @@ enum {
 	FTRACE_FL_REGS_EN	= (1UL << 29),
 	FTRACE_FL_TRAMP		= (1UL << 28),
 	FTRACE_FL_TRAMP_EN	= (1UL << 27),
+	FTRACE_FL_IPMODIFY	= (1UL << 26),
 };
 
-#define FTRACE_REF_MAX_SHIFT	27
-#define FTRACE_FL_BITS		5
+#define FTRACE_REF_MAX_SHIFT	26
+#define FTRACE_FL_BITS		6
 #define FTRACE_FL_MASKED_BITS	((1UL << FTRACE_FL_BITS) - 1)
 #define FTRACE_FL_MASK		(FTRACE_FL_MASKED_BITS << FTRACE_REF_MAX_SHIFT)
 #define FTRACE_REF_MAX		((1UL << FTRACE_REF_MAX_SHIFT) - 1)
@@ -586,6 +611,11 @@ static inline ssize_t ftrace_notrace_write(struct file *file, const char __user
 			     size_t cnt, loff_t *ppos) { return -ENODEV; }
 static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
+
+static inline bool is_ftrace_trampoline(unsigned long addr)
+{
+	return false;
+}
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /* totally disable ftrace - can not re-enable after this */
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 28672e87e910..0bebb5c348b8 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -138,6 +138,17 @@ enum print_line_t {
 	TRACE_TYPE_NO_CONSUME	= 3	/* Handled but ask to not consume */
 };
 
+/*
+ * Several functions return TRACE_TYPE_PARTIAL_LINE if the trace_seq
+ * overflowed, and TRACE_TYPE_HANDLED otherwise. This helper function
+ * simplifies those functions and keeps them in sync.
+ */
+static inline enum print_line_t trace_handle_return(struct trace_seq *s)
+{
+	return trace_seq_has_overflowed(s) ?
+		TRACE_TYPE_PARTIAL_LINE : TRACE_TYPE_HANDLED;
+}
+
 void tracing_generic_entry_update(struct trace_entry *entry,
 				  unsigned long flags,
 				  int pc);
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index ea6c9dea79e3..db8a73224f1a 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -40,45 +40,54 @@ trace_seq_buffer_ptr(struct trace_seq *s)
 	return s->buffer + s->len;
 }
 
+/**
+ * trace_seq_has_overflowed - return true if the trace_seq took too much
+ * @s: trace sequence descriptor
+ *
+ * Returns true if too much data was added to the trace_seq and it is
+ * now full and will not take anymore.
+ */
+static inline bool trace_seq_has_overflowed(struct trace_seq *s)
+{
+	return s->full || s->len > PAGE_SIZE - 1;
+}
+
 /*
  * Currently only defined when tracing is enabled.
  */
 #ifdef CONFIG_TRACING
 extern __printf(2, 3)
-int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
+void trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
 extern __printf(2, 0)
-int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args);
-extern int
+void trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args);
+extern void
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
 extern int trace_print_seq(struct seq_file *m, struct trace_seq *s);
 extern int trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 			     int cnt);
-extern int trace_seq_puts(struct trace_seq *s, const char *str);
-extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
-extern int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len);
-extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+extern void trace_seq_puts(struct trace_seq *s, const char *str);
+extern void trace_seq_putc(struct trace_seq *s, unsigned char c);
+extern void trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len);
+extern void trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 				unsigned int len);
 extern int trace_seq_path(struct trace_seq *s, const struct path *path);
 
-extern int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+extern void trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 			     int nmaskbits);
 
 #else /* CONFIG_TRACING */
-static inline int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+static inline void trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
-	return 0;
 }
-static inline int
+static inline void
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
-	return 0;
 }
 
-static inline int
+static inline void
 trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 		  int nmaskbits)
 {
-	return 0;
 }
 
 static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
@@ -90,23 +99,19 @@ static inline int trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 {
 	return 0;
 }
-static inline int trace_seq_puts(struct trace_seq *s, const char *str)
+static inline void trace_seq_puts(struct trace_seq *s, const char *str)
 {
-	return 0;
 }
-static inline int trace_seq_putc(struct trace_seq *s, unsigned char c)
+static inline void trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
-	return 0;
 }
-static inline int
+static inline void
 trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 {
-	return 0;
 }
-static inline int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+static inline void trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 				       unsigned int len)
 {
-	return 0;
 }
 static inline int trace_seq_path(struct trace_seq *s, const struct path *path)
 {
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 26b4f2e13275..139b5067345b 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -277,14 +277,12 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	field = (typeof(field))iter->ent;				\
 									\
 	ret = ftrace_raw_output_prep(iter, trace_event);		\
-	if (ret)							\
+	if (ret != TRACE_TYPE_HANDLED)					\
 		return ret;						\
 									\
-	ret = trace_seq_printf(s, print);				\
-	if (!ret)							\
-		return TRACE_TYPE_PARTIAL_LINE;				\
+	trace_seq_printf(s, print);					\
 									\
-	return TRACE_TYPE_HANDLED;					\
+	return trace_handle_return(s);					\
 }									\
 static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 	.trace			= ftrace_raw_output_##call,		\
diff --git a/kernel/extable.c b/kernel/extable.c
index d8a6446adbcb..c98f926277a8 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -18,6 +18,7 @@
 #include <linux/ftrace.h>
 #include <linux/memory.h>
 #include <linux/module.h>
+#include <linux/ftrace.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
 
@@ -102,6 +103,8 @@ int __kernel_text_address(unsigned long addr)
 		return 1;
 	if (is_module_text_address(addr))
 		return 1;
+	if (is_ftrace_trampoline(addr))
+		return 1;
 	/*
 	 * There might be init symbols in saved stacktraces.
 	 * Give those symbols a chance to be printed in
@@ -119,7 +122,9 @@ int kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
 		return 1;
-	return is_module_text_address(addr);
+	if (is_module_text_address(addr))
+		return 1;
+	return is_ftrace_trampoline(addr);
 }
 
 /*
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3995f546d0f3..831978cebf1d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -915,7 +915,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 #ifdef CONFIG_KPROBES_ON_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
-	.flags = FTRACE_OPS_FL_SAVE_REGS,
+	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
 };
 static int kprobe_ftrace_enabled;
 
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c1bd4ada2a04..11b9cb36092b 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1142,9 +1142,9 @@ static void get_pdu_remap(const struct trace_entry *ent,
 	r->sector_from = be64_to_cpu(sector_from);
 }
 
-typedef int (blk_log_action_t) (struct trace_iterator *iter, const char *act);
+typedef void (blk_log_action_t) (struct trace_iterator *iter, const char *act);
 
-static int blk_log_action_classic(struct trace_iterator *iter, const char *act)
+static void blk_log_action_classic(struct trace_iterator *iter, const char *act)
 {
 	char rwbs[RWBS_LEN];
 	unsigned long long ts  = iter->ts;
@@ -1154,33 +1154,33 @@ static int blk_log_action_classic(struct trace_iterator *iter, const char *act)
 
 	fill_rwbs(rwbs, t);
 
-	return trace_seq_printf(&iter->seq,
-				"%3d,%-3d %2d %5d.%09lu %5u %2s %3s ",
-				MAJOR(t->device), MINOR(t->device), iter->cpu,
-				secs, nsec_rem, iter->ent->pid, act, rwbs);
+	trace_seq_printf(&iter->seq,
+			 "%3d,%-3d %2d %5d.%09lu %5u %2s %3s ",
+			 MAJOR(t->device), MINOR(t->device), iter->cpu,
+			 secs, nsec_rem, iter->ent->pid, act, rwbs);
 }
 
-static int blk_log_action(struct trace_iterator *iter, const char *act)
+static void blk_log_action(struct trace_iterator *iter, const char *act)
 {
 	char rwbs[RWBS_LEN];
 	const struct blk_io_trace *t = te_blk_io_trace(iter->ent);
 
 	fill_rwbs(rwbs, t);
-	return trace_seq_printf(&iter->seq, "%3d,%-3d %2s %3s ",
-				MAJOR(t->device), MINOR(t->device), act, rwbs);
+	trace_seq_printf(&iter->seq, "%3d,%-3d %2s %3s ",
+			 MAJOR(t->device), MINOR(t->device), act, rwbs);
 }
 
-static int blk_log_dump_pdu(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_dump_pdu(struct trace_seq *s, const struct trace_entry *ent)
 {
 	const unsigned char *pdu_buf;
 	int pdu_len;
-	int i, end, ret;
+	int i, end;
 
 	pdu_buf = pdu_start(ent);
 	pdu_len = te_blk_io_trace(ent)->pdu_len;
 
 	if (!pdu_len)
-		return 1;
+		return;
 
 	/* find the last zero that needs to be printed */
 	for (end = pdu_len - 1; end >= 0; end--)
@@ -1188,119 +1188,107 @@ static int blk_log_dump_pdu(struct trace_seq *s, const struct trace_entry *ent)
 			break;
 	end++;
 
-	if (!trace_seq_putc(s, '('))
-		return 0;
+	trace_seq_putc(s, '(');
 
 	for (i = 0; i < pdu_len; i++) {
 
-		ret = trace_seq_printf(s, "%s%02x",
-				       i == 0 ? "" : " ", pdu_buf[i]);
-		if (!ret)
-			return ret;
+		trace_seq_printf(s, "%s%02x",
+				 i == 0 ? "" : " ", pdu_buf[i]);
 
 		/*
 		 * stop when the rest is just zeroes and indicate so
 		 * with a ".." appended
 		 */
-		if (i == end && end != pdu_len - 1)
-			return trace_seq_puts(s, " ..) ");
+		if (i == end && end != pdu_len - 1) {
+			trace_seq_puts(s, " ..) ");
+			return;
+		}
 	}
 
-	return trace_seq_puts(s, ") ");
+	trace_seq_puts(s, ") ");
 }
 
-static int blk_log_generic(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_generic(struct trace_seq *s, const struct trace_entry *ent)
 {
 	char cmd[TASK_COMM_LEN];
 
 	trace_find_cmdline(ent->pid, cmd);
 
 	if (t_action(ent) & BLK_TC_ACT(BLK_TC_PC)) {
-		int ret;
-
-		ret = trace_seq_printf(s, "%u ", t_bytes(ent));
-		if (!ret)
-			return 0;
-		ret = blk_log_dump_pdu(s, ent);
-		if (!ret)
-			return 0;
-		return trace_seq_printf(s, "[%s]\n", cmd);
+		trace_seq_printf(s, "%u ", t_bytes(ent));
+		blk_log_dump_pdu(s, ent);
+		trace_seq_printf(s, "[%s]\n", cmd);
 	} else {
 		if (t_sec(ent))
-			return trace_seq_printf(s, "%llu + %u [%s]\n",
+			trace_seq_printf(s, "%llu + %u [%s]\n",
 						t_sector(ent), t_sec(ent), cmd);
-		return trace_seq_printf(s, "[%s]\n", cmd);
+		else
+			trace_seq_printf(s, "[%s]\n", cmd);
 	}
 }
 
-static int blk_log_with_error(struct trace_seq *s,
+static void blk_log_with_error(struct trace_seq *s,
 			      const struct trace_entry *ent)
 {
 	if (t_action(ent) & BLK_TC_ACT(BLK_TC_PC)) {
-		int ret;
-
-		ret = blk_log_dump_pdu(s, ent);
-		if (ret)
-			return trace_seq_printf(s, "[%d]\n", t_error(ent));
-		return 0;
+		blk_log_dump_pdu(s, ent);
+		trace_seq_printf(s, "[%d]\n", t_error(ent));
 	} else {
 		if (t_sec(ent))
-			return trace_seq_printf(s, "%llu + %u [%d]\n",
-						t_sector(ent),
-						t_sec(ent), t_error(ent));
-		return trace_seq_printf(s, "%llu [%d]\n",
-					t_sector(ent), t_error(ent));
+			trace_seq_printf(s, "%llu + %u [%d]\n",
+					 t_sector(ent),
+					 t_sec(ent), t_error(ent));
+		else
+			trace_seq_printf(s, "%llu [%d]\n",
+					 t_sector(ent), t_error(ent));
 	}
 }
 
-static int blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
 {
 	struct blk_io_trace_remap r = { .device_from = 0, };
 
 	get_pdu_remap(ent, &r);
-	return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
-				t_sector(ent), t_sec(ent),
-				MAJOR(r.device_from), MINOR(r.device_from),
-				(unsigned long long)r.sector_from);
+	trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
+			 t_sector(ent), t_sec(ent),
+			 MAJOR(r.device_from), MINOR(r.device_from),
+			 (unsigned long long)r.sector_from);
 }
 
-static int blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
 {
 	char cmd[TASK_COMM_LEN];
 
 	trace_find_cmdline(ent->pid, cmd);
 
-	return trace_seq_printf(s, "[%s]\n", cmd);
+	trace_seq_printf(s, "[%s]\n", cmd);
 }
 
-static int blk_log_unplug(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_unplug(struct trace_seq *s, const struct trace_entry *ent)
 {
 	char cmd[TASK_COMM_LEN];
 
 	trace_find_cmdline(ent->pid, cmd);
 
-	return trace_seq_printf(s, "[%s] %llu\n", cmd, get_pdu_int(ent));
+	trace_seq_printf(s, "[%s] %llu\n", cmd, get_pdu_int(ent));
 }
 
-static int blk_log_split(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_split(struct trace_seq *s, const struct trace_entry *ent)
 {
 	char cmd[TASK_COMM_LEN];
 
 	trace_find_cmdline(ent->pid, cmd);
 
-	return trace_seq_printf(s, "%llu / %llu [%s]\n", t_sector(ent),
-				get_pdu_int(ent), cmd);
+	trace_seq_printf(s, "%llu / %llu [%s]\n", t_sector(ent),
+			 get_pdu_int(ent), cmd);
 }
 
-static int blk_log_msg(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_msg(struct trace_seq *s, const struct trace_entry *ent)
 {
-	int ret;
 	const struct blk_io_trace *t = te_blk_io_trace(ent);
 
-	ret = trace_seq_putmem(s, t + 1, t->pdu_len);
-	if (ret)
-		return trace_seq_putc(s, '\n');
-	return ret;
+	trace_seq_putmem(s, t + 1, t->pdu_len);
+	trace_seq_putc(s, '\n');
 }
 
 /*
@@ -1339,7 +1327,7 @@ static void blk_tracer_reset(struct trace_array *tr)
 
 static const struct {
 	const char *act[2];
-	int	   (*print)(struct trace_seq *s, const struct trace_entry *ent);
+	void	   (*print)(struct trace_seq *s, const struct trace_entry *ent);
 } what2act[] = {
 	[__BLK_TA_QUEUE]	= {{  "Q", "queue" },	   blk_log_generic },
 	[__BLK_TA_BACKMERGE]	= {{  "M", "backmerge" },  blk_log_generic },
@@ -1364,7 +1352,6 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
 	struct trace_seq *s = &iter->seq;
 	const struct blk_io_trace *t;
 	u16 what;
-	int ret;
 	bool long_act;
 	blk_log_action_t *log_action;
 
@@ -1374,21 +1361,18 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
 	log_action = classic ? &blk_log_action_classic : &blk_log_action;
 
 	if (t->action == BLK_TN_MESSAGE) {
-		ret = log_action(iter, long_act ? "message" : "m");
-		if (ret)
-			ret = blk_log_msg(s, iter->ent);
-		goto out;
+		log_action(iter, long_act ? "message" : "m");
+		blk_log_msg(s, iter->ent);
 	}
 
 	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
-		ret = trace_seq_printf(s, "Unknown action %x\n", what);
+		trace_seq_printf(s, "Unknown action %x\n", what);
 	else {
-		ret = log_action(iter, what2act[what].act[long_act]);
-		if (ret)
-			ret = what2act[what].print(s, iter->ent);
+		log_action(iter, what2act[what].act[long_act]);
+		what2act[what].print(s, iter->ent);
 	}
-out:
-	return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+
+	return trace_handle_return(s);
 }
 
 static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
@@ -1397,7 +1381,7 @@ static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
 	return print_one_line(iter, false);
 }
 
-static int blk_trace_synthesize_old_trace(struct trace_iterator *iter)
+static void blk_trace_synthesize_old_trace(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct blk_io_trace *t = (struct blk_io_trace *)iter->ent;
@@ -1407,18 +1391,18 @@ static int blk_trace_synthesize_old_trace(struct trace_iterator *iter)
 		.time     = iter->ts,
 	};
 
-	if (!trace_seq_putmem(s, &old, offset))
-		return 0;
-	return trace_seq_putmem(s, &t->sector,
-				sizeof(old) - offset + t->pdu_len);
+	trace_seq_putmem(s, &old, offset);
+	trace_seq_putmem(s, &t->sector,
+			 sizeof(old) - offset + t->pdu_len);
 }
 
 static enum print_line_t
 blk_trace_event_print_binary(struct trace_iterator *iter, int flags,
 			     struct trace_event *event)
 {
-	return blk_trace_synthesize_old_trace(iter) ?
-			TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+	blk_trace_synthesize_old_trace(iter);
+
+	return trace_handle_return(&iter->seq);
 }
 
 static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fb186b9ddf51..929a733d302e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -387,6 +387,8 @@ static int remove_ftrace_list_ops(struct ftrace_ops **list,
 	return ret;
 }
 
+static void ftrace_update_trampoline(struct ftrace_ops *ops);
+
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
 	if (ops->flags & FTRACE_OPS_FL_DELETED)
@@ -416,9 +418,13 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 		if (control_ops_alloc(ops))
 			return -ENOMEM;
 		add_ftrace_list_ops(&ftrace_control_list, &control_ops, ops);
+		/* The control_ops needs the trampoline update */
+		ops = &control_ops;
 	} else
 		add_ftrace_ops(&ftrace_ops_list, ops);
 
+	ftrace_update_trampoline(ops);
+
 	if (ftrace_enabled)
 		update_ftrace_function();
 
@@ -565,13 +571,13 @@ static int function_stat_cmp(void *p1, void *p2)
 static int function_stat_headers(struct seq_file *m)
 {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	seq_printf(m, "  Function                               "
-		   "Hit    Time            Avg             s^2\n"
-		      "  --------                               "
-		   "---    ----            ---             ---\n");
+	seq_puts(m, "  Function                               "
+		 "Hit    Time            Avg             s^2\n"
+		    "  --------                               "
+		 "---    ----            ---             ---\n");
 #else
-	seq_printf(m, "  Function                               Hit\n"
-		      "  --------                               ---\n");
+	seq_puts(m, "  Function                               Hit\n"
+		    "  --------                               ---\n");
 #endif
 	return 0;
 }
@@ -598,7 +604,7 @@ static int function_stat_show(struct seq_file *m, void *v)
 	seq_printf(m, "  %-30.30s  %10lu", str, rec->counter);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	seq_printf(m, "    ");
+	seq_puts(m, "    ");
 	avg = rec->time;
 	do_div(avg, rec->counter);
 
@@ -1111,6 +1117,43 @@ static struct ftrace_ops global_ops = {
 					  FTRACE_OPS_FL_INITIALIZED,
 };
 
+/*
+ * This is used by __kernel_text_address() to return true if the
+ * address is on a dynamically allocated trampoline that would
+ * not return true for either core_kernel_text() or
+ * is_module_text_address().
+ */
+bool is_ftrace_trampoline(unsigned long addr)
+{
+	struct ftrace_ops *op;
+	bool ret = false;
+
+	/*
+	 * Some of the ops may be dynamically allocated,
+	 * they are freed after a synchronize_sched().
+	 */
+	preempt_disable_notrace();
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		/*
+		 * This is to check for dynamically allocated trampolines.
+		 * Trampolines that are in kernel text will have
+		 * core_kernel_text() return true.
+		 */
+		if (op->trampoline && op->trampoline_size)
+			if (addr >= op->trampoline &&
+			    addr < op->trampoline + op->trampoline_size) {
+				ret = true;
+				goto out;
+			}
+	} while_for_each_ftrace_op(op);
+
+ out:
+	preempt_enable_notrace();
+
+	return ret;
+}
+
 struct ftrace_page {
 	struct ftrace_page	*next;
 	struct dyn_ftrace	*records;
@@ -1315,6 +1358,9 @@ ftrace_hash_rec_disable_modify(struct ftrace_ops *ops, int filter_hash);
 static void
 ftrace_hash_rec_enable_modify(struct ftrace_ops *ops, int filter_hash);
 
+static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
+				       struct ftrace_hash *new_hash);
+
 static int
 ftrace_hash_move(struct ftrace_ops *ops, int enable,
 		 struct ftrace_hash **dst, struct ftrace_hash *src)
@@ -1325,8 +1371,13 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	struct ftrace_hash *new_hash;
 	int size = src->count;
 	int bits = 0;
+	int ret;
 	int i;
 
+	/* Reject setting notrace hash on IPMODIFY ftrace_ops */
+	if (ops->flags & FTRACE_OPS_FL_IPMODIFY && !enable)
+		return -EINVAL;
+
 	/*
 	 * If the new source is empty, just free dst and assign it
 	 * the empty_hash.
@@ -1360,6 +1411,16 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	}
 
 update:
+	/* Make sure this can be applied if it is IPMODIFY ftrace_ops */
+	if (enable) {
+		/* IPMODIFY should be updated only when filter_hash updating */
+		ret = ftrace_hash_ipmodify_update(ops, new_hash);
+		if (ret < 0) {
+			free_ftrace_hash(new_hash);
+			return ret;
+		}
+	}
+
 	/*
 	 * Remove the current set, update the hash and add
 	 * them back.
@@ -1724,6 +1785,114 @@ static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops,
 	ftrace_hash_rec_update_modify(ops, filter_hash, 1);
 }
 
+/*
+ * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
+ * or no-needed to update, -EBUSY if it detects a conflict of the flag
+ * on a ftrace_rec, and -EINVAL if the new_hash tries to trace all recs.
+ * Note that old_hash and new_hash has below meanings
+ *  - If the hash is NULL, it hits all recs (if IPMODIFY is set, this is rejected)
+ *  - If the hash is EMPTY_HASH, it hits nothing
+ *  - Anything else hits the recs which match the hash entries.
+ */
+static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
+					 struct ftrace_hash *old_hash,
+					 struct ftrace_hash *new_hash)
+{
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec, *end = NULL;
+	int in_old, in_new;
+
+	/* Only update if the ops has been registered */
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return 0;
+
+	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
+		return 0;
+
+	/*
+	 * Since the IPMODIFY is a very address sensitive action, we do not
+	 * allow ftrace_ops to set all functions to new hash.
+	 */
+	if (!new_hash || !old_hash)
+		return -EINVAL;
+
+	/* Update rec->flags */
+	do_for_each_ftrace_rec(pg, rec) {
+		/* We need to update only differences of filter_hash */
+		in_old = !!ftrace_lookup_ip(old_hash, rec->ip);
+		in_new = !!ftrace_lookup_ip(new_hash, rec->ip);
+		if (in_old == in_new)
+			continue;
+
+		if (in_new) {
+			/* New entries must ensure no others are using it */
+			if (rec->flags & FTRACE_FL_IPMODIFY)
+				goto rollback;
+			rec->flags |= FTRACE_FL_IPMODIFY;
+		} else /* Removed entry */
+			rec->flags &= ~FTRACE_FL_IPMODIFY;
+	} while_for_each_ftrace_rec();
+
+	return 0;
+
+rollback:
+	end = rec;
+
+	/* Roll back what we did above */
+	do_for_each_ftrace_rec(pg, rec) {
+		if (rec == end)
+			goto err_out;
+
+		in_old = !!ftrace_lookup_ip(old_hash, rec->ip);
+		in_new = !!ftrace_lookup_ip(new_hash, rec->ip);
+		if (in_old == in_new)
+			continue;
+
+		if (in_new)
+			rec->flags &= ~FTRACE_FL_IPMODIFY;
+		else
+			rec->flags |= FTRACE_FL_IPMODIFY;
+	} while_for_each_ftrace_rec();
+
+err_out:
+	return -EBUSY;
+}
+
+static int ftrace_hash_ipmodify_enable(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
+
+	if (ftrace_hash_empty(hash))
+		hash = NULL;
+
+	return __ftrace_hash_update_ipmodify(ops, EMPTY_HASH, hash);
+}
+
+/* Disabling always succeeds */
+static void ftrace_hash_ipmodify_disable(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
+
+	if (ftrace_hash_empty(hash))
+		hash = NULL;
+
+	__ftrace_hash_update_ipmodify(ops, hash, EMPTY_HASH);
+}
+
+static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
+				       struct ftrace_hash *new_hash)
+{
+	struct ftrace_hash *old_hash = ops->func_hash->filter_hash;
+
+	if (ftrace_hash_empty(old_hash))
+		old_hash = NULL;
+
+	if (ftrace_hash_empty(new_hash))
+		new_hash = NULL;
+
+	return __ftrace_hash_update_ipmodify(ops, old_hash, new_hash);
+}
+
 static void print_ip_ins(const char *fmt, unsigned char *p)
 {
 	int i;
@@ -1734,10 +1903,13 @@ static void print_ip_ins(const char *fmt, unsigned char *p)
 		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
 }
 
+static struct ftrace_ops *
+ftrace_find_tramp_ops_any(struct dyn_ftrace *rec);
+
 /**
  * ftrace_bug - report and shutdown function tracer
  * @failed: The failed type (EFAULT, EINVAL, EPERM)
- * @ip: The address that failed
+ * @rec: The record that failed
  *
  * The arch code that enables or disables the function tracing
  * can call ftrace_bug() when it has detected a problem in
@@ -1746,8 +1918,10 @@ static void print_ip_ins(const char *fmt, unsigned char *p)
  * EINVAL - if what is read at @ip is not what was expected
  * EPERM - if the problem happens on writting to the @ip address
  */
-void ftrace_bug(int failed, unsigned long ip)
+void ftrace_bug(int failed, struct dyn_ftrace *rec)
 {
+	unsigned long ip = rec ? rec->ip : 0;
+
 	switch (failed) {
 	case -EFAULT:
 		FTRACE_WARN_ON_ONCE(1);
@@ -1759,7 +1933,7 @@ void ftrace_bug(int failed, unsigned long ip)
 		pr_info("ftrace failed to modify ");
 		print_ip_sym(ip);
 		print_ip_ins(" actual: ", (unsigned char *)ip);
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 		break;
 	case -EPERM:
 		FTRACE_WARN_ON_ONCE(1);
@@ -1771,6 +1945,24 @@ void ftrace_bug(int failed, unsigned long ip)
 		pr_info("ftrace faulted on unknown error ");
 		print_ip_sym(ip);
 	}
+	if (rec) {
+		struct ftrace_ops *ops = NULL;
+
+		pr_info("ftrace record flags: %lx\n", rec->flags);
+		pr_cont(" (%ld)%s", ftrace_rec_count(rec),
+			rec->flags & FTRACE_FL_REGS ? " R" : "  ");
+		if (rec->flags & FTRACE_FL_TRAMP_EN) {
+			ops = ftrace_find_tramp_ops_any(rec);
+			if (ops)
+				pr_cont("\ttramp: %pS",
+					(void *)ops->trampoline);
+			else
+				pr_cont("\ttramp: ERROR!");
+
+		}
+		ip = ftrace_get_addr_curr(rec);
+		pr_cont(" expected tramp: %lx\n", ip);
+	}
 }
 
 static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
@@ -1925,8 +2117,16 @@ ftrace_find_tramp_ops_curr(struct dyn_ftrace *rec)
 	 * when we are adding another op to the rec or removing the
 	 * current one. Thus, if the op is being added, we can
 	 * ignore it because it hasn't attached itself to the rec
-	 * yet. That means we just need to find the op that has a
-	 * trampoline and is not beeing added.
+	 * yet.
+	 *
+	 * If an ops is being modified (hooking to different functions)
+	 * then we don't care about the new functions that are being
+	 * added, just the old ones (that are probably being removed).
+	 *
+	 * If we are adding an ops to a function that already is using
+	 * a trampoline, it needs to be removed (trampolines are only
+	 * for single ops connected), then an ops that is not being
+	 * modified also needs to be checked.
 	 */
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
 
@@ -1940,17 +2140,23 @@ ftrace_find_tramp_ops_curr(struct dyn_ftrace *rec)
 		if (op->flags & FTRACE_OPS_FL_ADDING)
 			continue;
 
+
 		/*
-		 * If the ops is not being added and has a trampoline,
-		 * then it must be the one that we want!
+		 * If the ops is being modified and is in the old
+		 * hash, then it is probably being removed from this
+		 * function.
 		 */
-		if (hash_contains_ip(ip, op->func_hash))
-			return op;
-
-		/* If the ops is being modified, it may be in the old hash. */
 		if ((op->flags & FTRACE_OPS_FL_MODIFYING) &&
 		    hash_contains_ip(ip, &op->old_hash))
 			return op;
+		/*
+		 * If the ops is not being added or modified, and it's
+		 * in its normal filter hash, then this must be the one
+		 * we want!
+		 */
+		if (!(op->flags & FTRACE_OPS_FL_MODIFYING) &&
+		    hash_contains_ip(ip, op->func_hash))
+			return op;
 
 	} while_for_each_ftrace_op(op);
 
@@ -2079,7 +2285,7 @@ void __weak ftrace_replace_code(int enable)
 	do_for_each_ftrace_rec(pg, rec) {
 		failed = __ftrace_replace_code(rec, enable);
 		if (failed) {
-			ftrace_bug(failed, rec->ip);
+			ftrace_bug(failed, rec);
 			/* Stop processing */
 			return;
 		}
@@ -2161,17 +2367,14 @@ struct dyn_ftrace *ftrace_rec_iter_record(struct ftrace_rec_iter *iter)
 static int
 ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
 {
-	unsigned long ip;
 	int ret;
 
-	ip = rec->ip;
-
 	if (unlikely(ftrace_disabled))
 		return 0;
 
 	ret = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
 	if (ret) {
-		ftrace_bug(ret, ip);
+		ftrace_bug(ret, rec);
 		return 0;
 	}
 	return 1;
@@ -2293,16 +2496,23 @@ static void ftrace_run_update_code(int command)
 	FTRACE_WARN_ON(ret);
 }
 
-static void ftrace_run_modify_code(struct ftrace_ops *ops, int command)
+static void ftrace_run_modify_code(struct ftrace_ops *ops, int command,
+				   struct ftrace_hash *old_hash)
 {
 	ops->flags |= FTRACE_OPS_FL_MODIFYING;
+	ops->old_hash.filter_hash = old_hash;
 	ftrace_run_update_code(command);
+	ops->old_hash.filter_hash = NULL;
 	ops->flags &= ~FTRACE_OPS_FL_MODIFYING;
 }
 
 static ftrace_func_t saved_ftrace_func;
 static int ftrace_start_up;
 
+void __weak arch_ftrace_trampoline_free(struct ftrace_ops *ops)
+{
+}
+
 static void control_ops_free(struct ftrace_ops *ops)
 {
 	free_percpu(ops->disabled);
@@ -2352,6 +2562,15 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 	 */
 	ops->flags |= FTRACE_OPS_FL_ENABLED | FTRACE_OPS_FL_ADDING;
 
+	ret = ftrace_hash_ipmodify_enable(ops);
+	if (ret < 0) {
+		/* Rollback registration process */
+		__unregister_ftrace_function(ops);
+		ftrace_start_up--;
+		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+		return ret;
+	}
+
 	ftrace_hash_rec_enable(ops, 1);
 
 	ftrace_startup_enable(command);
@@ -2380,6 +2599,8 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	 */
 	WARN_ON_ONCE(ftrace_start_up < 0);
 
+	/* Disabling ipmodify never fails */
+	ftrace_hash_ipmodify_disable(ops);
 	ftrace_hash_rec_disable(ops, 1);
 
 	ops->flags &= ~FTRACE_OPS_FL_ENABLED;
@@ -2454,6 +2675,8 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	if (ops->flags & (FTRACE_OPS_FL_DYNAMIC | FTRACE_OPS_FL_CONTROL)) {
 		schedule_on_each_cpu(ftrace_sync);
 
+		arch_ftrace_trampoline_free(ops);
+
 		if (ops->flags & FTRACE_OPS_FL_CONTROL)
 			control_ops_free(ops);
 	}
@@ -2606,7 +2829,7 @@ static int ftrace_update_code(struct module *mod, struct ftrace_page *new_pgs)
 			if (ftrace_start_up && cnt) {
 				int failed = __ftrace_replace_code(p, 1);
 				if (failed)
-					ftrace_bug(failed, p->ip);
+					ftrace_bug(failed, p);
 			}
 		}
 	}
@@ -2931,6 +3154,22 @@ static void t_stop(struct seq_file *m, void *p)
 	mutex_unlock(&ftrace_lock);
 }
 
+void * __weak
+arch_ftrace_trampoline_func(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	return NULL;
+}
+
+static void add_trampoline_func(struct seq_file *m, struct ftrace_ops *ops,
+				struct dyn_ftrace *rec)
+{
+	void *ptr;
+
+	ptr = arch_ftrace_trampoline_func(ops, rec);
+	if (ptr)
+		seq_printf(m, " ->%pS", ptr);
+}
+
 static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_iterator *iter = m->private;
@@ -2941,9 +3180,9 @@ static int t_show(struct seq_file *m, void *v)
 
 	if (iter->flags & FTRACE_ITER_PRINTALL) {
 		if (iter->flags & FTRACE_ITER_NOTRACE)
-			seq_printf(m, "#### no functions disabled ####\n");
+			seq_puts(m, "#### no functions disabled ####\n");
 		else
-			seq_printf(m, "#### all functions enabled ####\n");
+			seq_puts(m, "#### all functions enabled ####\n");
 		return 0;
 	}
 
@@ -2954,22 +3193,25 @@ static int t_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "%ps", (void *)rec->ip);
 	if (iter->flags & FTRACE_ITER_ENABLED) {
-		seq_printf(m, " (%ld)%s",
+		struct ftrace_ops *ops = NULL;
+
+		seq_printf(m, " (%ld)%s%s",
 			   ftrace_rec_count(rec),
-			   rec->flags & FTRACE_FL_REGS ? " R" : "  ");
+			   rec->flags & FTRACE_FL_REGS ? " R" : "  ",
+			   rec->flags & FTRACE_FL_IPMODIFY ? " I" : "  ");
 		if (rec->flags & FTRACE_FL_TRAMP_EN) {
-			struct ftrace_ops *ops;
-
 			ops = ftrace_find_tramp_ops_any(rec);
 			if (ops)
 				seq_printf(m, "\ttramp: %pS",
 					   (void *)ops->trampoline);
 			else
-				seq_printf(m, "\ttramp: ERROR!");
+				seq_puts(m, "\ttramp: ERROR!");
+
 		}
+		add_trampoline_func(m, ops, rec);
 	}	
 
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -3003,9 +3245,6 @@ ftrace_enabled_open(struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
 
-	if (unlikely(ftrace_disabled))
-		return -ENODEV;
-
 	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
 	if (iter) {
 		iter->pg = ftrace_pages_start;
@@ -3340,7 +3579,7 @@ static struct ftrace_ops trace_probe_ops __read_mostly =
 
 static int ftrace_probe_registered;
 
-static void __enable_ftrace_function_probe(void)
+static void __enable_ftrace_function_probe(struct ftrace_hash *old_hash)
 {
 	int ret;
 	int i;
@@ -3348,7 +3587,8 @@ static void __enable_ftrace_function_probe(void)
 	if (ftrace_probe_registered) {
 		/* still need to update the function call sites */
 		if (ftrace_enabled)
-			ftrace_run_modify_code(&trace_probe_ops, FTRACE_UPDATE_CALLS);
+			ftrace_run_modify_code(&trace_probe_ops, FTRACE_UPDATE_CALLS,
+					       old_hash);
 		return;
 	}
 
@@ -3477,13 +3717,14 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	} while_for_each_ftrace_rec();
 
 	ret = ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
+
+	__enable_ftrace_function_probe(old_hash);
+
 	if (!ret)
 		free_ftrace_hash_rcu(old_hash);
 	else
 		count = ret;
 
-	__enable_ftrace_function_probe();
-
  out_unlock:
 	mutex_unlock(&ftrace_lock);
  out:
@@ -3764,10 +4005,11 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
 	return add_hash_entry(hash, ip);
 }
 
-static void ftrace_ops_update_code(struct ftrace_ops *ops)
+static void ftrace_ops_update_code(struct ftrace_ops *ops,
+				   struct ftrace_hash *old_hash)
 {
 	if (ops->flags & FTRACE_OPS_FL_ENABLED && ftrace_enabled)
-		ftrace_run_modify_code(ops, FTRACE_UPDATE_CALLS);
+		ftrace_run_modify_code(ops, FTRACE_UPDATE_CALLS, old_hash);
 }
 
 static int
@@ -3813,7 +4055,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	old_hash = *orig_hash;
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
 	if (!ret) {
-		ftrace_ops_update_code(ops);
+		ftrace_ops_update_code(ops, old_hash);
 		free_ftrace_hash_rcu(old_hash);
 	}
 	mutex_unlock(&ftrace_lock);
@@ -3955,6 +4197,9 @@ static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
 static char ftrace_graph_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
 static int ftrace_set_func(unsigned long *array, int *idx, int size, char *buffer);
 
+static unsigned long save_global_trampoline;
+static unsigned long save_global_flags;
+
 static int __init set_graph_function(char *str)
 {
 	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
@@ -4058,7 +4303,7 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 		ret = ftrace_hash_move(iter->ops, filter_hash,
 				       orig_hash, iter->hash);
 		if (!ret) {
-			ftrace_ops_update_code(iter->ops);
+			ftrace_ops_update_code(iter->ops, old_hash);
 			free_ftrace_hash_rcu(old_hash);
 		}
 		mutex_unlock(&ftrace_lock);
@@ -4163,9 +4408,9 @@ static int g_show(struct seq_file *m, void *v)
 		struct ftrace_graph_data *fgd = m->private;
 
 		if (fgd->table == ftrace_graph_funcs)
-			seq_printf(m, "#### all functions enabled ####\n");
+			seq_puts(m, "#### all functions enabled ####\n");
 		else
-			seq_printf(m, "#### no functions disabled ####\n");
+			seq_puts(m, "#### no functions disabled ####\n");
 		return 0;
 	}
 
@@ -4676,6 +4921,32 @@ void __init ftrace_init(void)
 	ftrace_disabled = 1;
 }
 
+/* Do nothing if arch does not support this */
+void __weak arch_ftrace_update_trampoline(struct ftrace_ops *ops)
+{
+}
+
+static void ftrace_update_trampoline(struct ftrace_ops *ops)
+{
+
+/*
+ * Currently there's no safe way to free a trampoline when the kernel
+ * is configured with PREEMPT. That is because a task could be preempted
+ * when it jumped to the trampoline, it may be preempted for a long time
+ * depending on the system load, and currently there's no way to know
+ * when it will be off the trampoline. If the trampoline is freed
+ * too early, when the task runs again, it will be executing on freed
+ * memory and crash.
+ */
+#ifdef CONFIG_PREEMPT
+	/* Currently, only non dynamic ops can have a trampoline */
+	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
+		return;
+#endif
+
+	arch_ftrace_update_trampoline(ops);
+}
+
 #else
 
 static struct ftrace_ops global_ops = {
@@ -4718,6 +4989,10 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 	return 1;
 }
 
+static void ftrace_update_trampoline(struct ftrace_ops *ops)
+{
+}
+
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 __init void ftrace_init_global_array_ops(struct trace_array *tr)
@@ -5055,12 +5330,12 @@ static int fpid_show(struct seq_file *m, void *v)
 	const struct ftrace_pid *fpid = list_entry(v, struct ftrace_pid, list);
 
 	if (v == (void *)1) {
-		seq_printf(m, "no pid\n");
+		seq_puts(m, "no pid\n");
 		return 0;
 	}
 
 	if (fpid->pid == ftrace_swapper_pid)
-		seq_printf(m, "swapper tasks\n");
+		seq_puts(m, "swapper tasks\n");
 	else
 		seq_printf(m, "%u\n", pid_vnr(fpid->pid));
 
@@ -5273,6 +5548,7 @@ static struct ftrace_ops graph_ops = {
 				   FTRACE_OPS_FL_STUB,
 #ifdef FTRACE_GRAPH_TRAMP_ADDR
 	.trampoline		= FTRACE_GRAPH_TRAMP_ADDR,
+	/* trampoline_size is only needed for dynamically allocated tramps */
 #endif
 	ASSIGN_OPS_HASH(graph_ops, &global_ops.local_hash)
 };
@@ -5502,7 +5778,6 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	update_function_graph_func();
 
 	ret = ftrace_startup(&graph_ops, FTRACE_START_FUNC_RET);
-
 out:
 	mutex_unlock(&ftrace_lock);
 	return ret;
@@ -5523,6 +5798,17 @@ void unregister_ftrace_graph(void)
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	/*
+	 * Function graph does not allocate the trampoline, but
+	 * other global_ops do. We need to reset the ALLOC_TRAMP flag
+	 * if one was used.
+	 */
+	global_ops.trampoline = save_global_trampoline;
+	if (save_global_flags & FTRACE_OPS_FL_ALLOC_TRAMP)
+		global_ops.flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
+#endif
+
  out:
 	mutex_unlock(&ftrace_lock);
 }
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2d75c94ae87d..a28bdd17c853 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -34,21 +34,19 @@ static void update_pages_handler(struct work_struct *work);
  */
 int ring_buffer_print_entry_header(struct trace_seq *s)
 {
-	int ret;
-
-	ret = trace_seq_puts(s, "# compressed entry header\n");
-	ret = trace_seq_puts(s, "\ttype_len    :    5 bits\n");
-	ret = trace_seq_puts(s, "\ttime_delta  :   27 bits\n");
-	ret = trace_seq_puts(s, "\tarray       :   32 bits\n");
-	ret = trace_seq_putc(s, '\n');
-	ret = trace_seq_printf(s, "\tpadding     : type == %d\n",
-			       RINGBUF_TYPE_PADDING);
-	ret = trace_seq_printf(s, "\ttime_extend : type == %d\n",
-			       RINGBUF_TYPE_TIME_EXTEND);
-	ret = trace_seq_printf(s, "\tdata max type_len  == %d\n",
-			       RINGBUF_TYPE_DATA_TYPE_LEN_MAX);
+	trace_seq_puts(s, "# compressed entry header\n");
+	trace_seq_puts(s, "\ttype_len    :    5 bits\n");
+	trace_seq_puts(s, "\ttime_delta  :   27 bits\n");
+	trace_seq_puts(s, "\tarray       :   32 bits\n");
+	trace_seq_putc(s, '\n');
+	trace_seq_printf(s, "\tpadding     : type == %d\n",
+			 RINGBUF_TYPE_PADDING);
+	trace_seq_printf(s, "\ttime_extend : type == %d\n",
+			 RINGBUF_TYPE_TIME_EXTEND);
+	trace_seq_printf(s, "\tdata max type_len  == %d\n",
+			 RINGBUF_TYPE_DATA_TYPE_LEN_MAX);
 
-	return ret;
+	return !trace_seq_has_overflowed(s);
 }
 
 /*
@@ -419,32 +417,31 @@ static inline int test_time_stamp(u64 delta)
 int ring_buffer_print_page_header(struct trace_seq *s)
 {
 	struct buffer_data_page field;
-	int ret;
-
-	ret = trace_seq_printf(s, "\tfield: u64 timestamp;\t"
-			       "offset:0;\tsize:%u;\tsigned:%u;\n",
-			       (unsigned int)sizeof(field.time_stamp),
-			       (unsigned int)is_signed_type(u64));
-
-	ret = trace_seq_printf(s, "\tfield: local_t commit;\t"
-			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			       (unsigned int)offsetof(typeof(field), commit),
-			       (unsigned int)sizeof(field.commit),
-			       (unsigned int)is_signed_type(long));
-
-	ret = trace_seq_printf(s, "\tfield: int overwrite;\t"
-			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			       (unsigned int)offsetof(typeof(field), commit),
-			       1,
-			       (unsigned int)is_signed_type(long));
-
-	ret = trace_seq_printf(s, "\tfield: char data;\t"
-			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			       (unsigned int)offsetof(typeof(field), data),
-			       (unsigned int)BUF_PAGE_SIZE,
-			       (unsigned int)is_signed_type(char));
 
-	return ret;
+	trace_seq_printf(s, "\tfield: u64 timestamp;\t"
+			 "offset:0;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)sizeof(field.time_stamp),
+			 (unsigned int)is_signed_type(u64));
+
+	trace_seq_printf(s, "\tfield: local_t commit;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), commit),
+			 (unsigned int)sizeof(field.commit),
+			 (unsigned int)is_signed_type(long));
+
+	trace_seq_printf(s, "\tfield: int overwrite;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), commit),
+			 1,
+			 (unsigned int)is_signed_type(long));
+
+	trace_seq_printf(s, "\tfield: char data;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), data),
+			 (unsigned int)BUF_PAGE_SIZE,
+			 (unsigned int)is_signed_type(char));
+
+	return !trace_seq_has_overflowed(s);
 }
 
 struct rb_irq_work {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a528392b1f4..4ceb2546c7ef 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -155,10 +155,11 @@ __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
 
 static int __init stop_trace_on_warning(char *str)
 {
-	__disable_trace_on_warning = 1;
+	if ((strcmp(str, "=0") != 0 && strcmp(str, "=off") != 0))
+		__disable_trace_on_warning = 1;
 	return 1;
 }
-__setup("traceoff_on_warning=", stop_trace_on_warning);
+__setup("traceoff_on_warning", stop_trace_on_warning);
 
 static int __init boot_alloc_snapshot(char *str)
 {
@@ -2157,9 +2158,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 		goto out;
 	}
 
-	len = vsnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
-	if (len > TRACE_BUF_SIZE)
-		goto out;
+	len = vscnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
 
 	local_save_flags(flags);
 	size = sizeof(*entry) + len + 1;
@@ -2170,8 +2169,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 	entry = ring_buffer_event_data(event);
 	entry->ip = ip;
 
-	memcpy(&entry->buf, tbuffer, len);
-	entry->buf[len] = '\0';
+	memcpy(&entry->buf, tbuffer, len + 1);
 	if (!call_filter_check_discard(call, entry, buffer, event)) {
 		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
@@ -2508,14 +2506,14 @@ get_total_entries(struct trace_buffer *buf,
 
 static void print_lat_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#                  _------=> CPU#            \n");
-	seq_puts(m, "#                 / _-----=> irqs-off        \n");
-	seq_puts(m, "#                | / _----=> need-resched    \n");
-	seq_puts(m, "#                || / _---=> hardirq/softirq \n");
-	seq_puts(m, "#                ||| / _--=> preempt-depth   \n");
-	seq_puts(m, "#                |||| /     delay             \n");
-	seq_puts(m, "#  cmd     pid   ||||| time  |   caller      \n");
-	seq_puts(m, "#     \\   /      |||||  \\    |   /           \n");
+	seq_puts(m, "#                  _------=> CPU#            \n"
+		    "#                 / _-----=> irqs-off        \n"
+		    "#                | / _----=> need-resched    \n"
+		    "#                || / _---=> hardirq/softirq \n"
+		    "#                ||| / _--=> preempt-depth   \n"
+		    "#                |||| /     delay            \n"
+		    "#  cmd     pid   ||||| time  |   caller      \n"
+		    "#     \\   /      |||||  \\    |   /         \n");
 }
 
 static void print_event_info(struct trace_buffer *buf, struct seq_file *m)
@@ -2532,20 +2530,20 @@ static void print_event_info(struct trace_buffer *buf, struct seq_file *m)
 static void print_func_help_header(struct trace_buffer *buf, struct seq_file *m)
 {
 	print_event_info(buf, m);
-	seq_puts(m, "#           TASK-PID   CPU#      TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |       |          |         |\n");
+	seq_puts(m, "#           TASK-PID   CPU#      TIMESTAMP  FUNCTION\n"
+		    "#              | |       |          |         |\n");
 }
 
 static void print_func_help_header_irq(struct trace_buffer *buf, struct seq_file *m)
 {
 	print_event_info(buf, m);
-	seq_puts(m, "#                              _-----=> irqs-off\n");
-	seq_puts(m, "#                             / _----=> need-resched\n");
-	seq_puts(m, "#                            | / _---=> hardirq/softirq\n");
-	seq_puts(m, "#                            || / _--=> preempt-depth\n");
-	seq_puts(m, "#                            ||| /     delay\n");
-	seq_puts(m, "#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |       |   ||||       |         |\n");
+	seq_puts(m, "#                              _-----=> irqs-off\n"
+		    "#                             / _----=> need-resched\n"
+		    "#                            | / _---=> hardirq/softirq\n"
+		    "#                            || / _--=> preempt-depth\n"
+		    "#                            ||| /     delay\n"
+		    "#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION\n"
+		    "#              | |       |   ||||       |         |\n");
 }
 
 void
@@ -2648,24 +2646,21 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	event = ftrace_find_event(entry->type);
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
-			if (!trace_print_lat_context(iter))
-				goto partial;
-		} else {
-			if (!trace_print_context(iter))
-				goto partial;
-		}
+		if (iter->iter_flags & TRACE_FILE_LAT_FMT)
+			trace_print_lat_context(iter);
+		else
+			trace_print_context(iter);
 	}
 
+	if (trace_seq_has_overflowed(s))
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	if (event)
 		return event->funcs->trace(iter, sym_flags, event);
 
-	if (!trace_seq_printf(s, "Unknown type %d\n", entry->type))
-		goto partial;
+	trace_seq_printf(s, "Unknown type %d\n", entry->type);
 
-	return TRACE_TYPE_HANDLED;
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
@@ -2676,22 +2671,20 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		if (!trace_seq_printf(s, "%d %d %llu ",
-				      entry->pid, iter->cpu, iter->ts))
-			goto partial;
-	}
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO)
+		trace_seq_printf(s, "%d %d %llu ",
+				 entry->pid, iter->cpu, iter->ts);
+
+	if (trace_seq_has_overflowed(s))
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	event = ftrace_find_event(entry->type);
 	if (event)
 		return event->funcs->raw(iter, 0, event);
 
-	if (!trace_seq_printf(s, "%d ?\n", entry->type))
-		goto partial;
+	trace_seq_printf(s, "%d ?\n", entry->type);
 
-	return TRACE_TYPE_HANDLED;
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
@@ -2704,9 +2697,11 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 	entry = iter->ent;
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
-		SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
-		SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
+		SEQ_PUT_HEX_FIELD(s, entry->pid);
+		SEQ_PUT_HEX_FIELD(s, iter->cpu);
+		SEQ_PUT_HEX_FIELD(s, iter->ts);
+		if (trace_seq_has_overflowed(s))
+			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	event = ftrace_find_event(entry->type);
@@ -2716,9 +2711,9 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 			return ret;
 	}
 
-	SEQ_PUT_FIELD_RET(s, newline);
+	SEQ_PUT_FIELD(s, newline);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
@@ -2730,9 +2725,11 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	entry = iter->ent;
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		SEQ_PUT_FIELD_RET(s, entry->pid);
-		SEQ_PUT_FIELD_RET(s, iter->cpu);
-		SEQ_PUT_FIELD_RET(s, iter->ts);
+		SEQ_PUT_FIELD(s, entry->pid);
+		SEQ_PUT_FIELD(s, iter->cpu);
+		SEQ_PUT_FIELD(s, iter->ts);
+		if (trace_seq_has_overflowed(s))
+			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	event = ftrace_find_event(entry->type);
@@ -2778,10 +2775,12 @@ enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
-	if (iter->lost_events &&
-	    !trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
-				 iter->cpu, iter->lost_events))
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (iter->lost_events) {
+		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->cpu, iter->lost_events);
+		if (trace_seq_has_overflowed(&iter->seq))
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	if (iter->trace && iter->trace->print_line) {
 		ret = iter->trace->print_line(iter);
@@ -2859,44 +2858,44 @@ static void test_ftrace_alive(struct seq_file *m)
 {
 	if (!ftrace_is_dead())
 		return;
-	seq_printf(m, "# WARNING: FUNCTION TRACING IS CORRUPTED\n");
-	seq_printf(m, "#          MAY BE MISSING FUNCTION EVENTS\n");
+	seq_puts(m, "# WARNING: FUNCTION TRACING IS CORRUPTED\n"
+		    "#          MAY BE MISSING FUNCTION EVENTS\n");
 }
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 static void show_snapshot_main_help(struct seq_file *m)
 {
-	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
-	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
-	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
-	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate or free)\n");
-	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
-	seq_printf(m, "#                       is not a '0' or '1')\n");
+	seq_puts(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n"
+		    "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n"
+		    "#                      Takes a snapshot of the main buffer.\n"
+		    "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate or free)\n"
+		    "#                      (Doesn't have to be '2' works with any number that\n"
+		    "#                       is not a '0' or '1')\n");
 }
 
 static void show_snapshot_percpu_help(struct seq_file *m)
 {
-	seq_printf(m, "# echo 0 > snapshot : Invalid for per_cpu snapshot file.\n");
+	seq_puts(m, "# echo 0 > snapshot : Invalid for per_cpu snapshot file.\n");
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
-	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
-	seq_printf(m, "#                      Takes a snapshot of the main buffer for this cpu.\n");
+	seq_puts(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n"
+		    "#                      Takes a snapshot of the main buffer for this cpu.\n");
 #else
-	seq_printf(m, "# echo 1 > snapshot : Not supported with this kernel.\n");
-	seq_printf(m, "#                     Must use main snapshot file to allocate.\n");
+	seq_puts(m, "# echo 1 > snapshot : Not supported with this kernel.\n"
+		    "#                     Must use main snapshot file to allocate.\n");
 #endif
-	seq_printf(m, "# echo 2 > snapshot : Clears this cpu's snapshot buffer (but does not allocate)\n");
-	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
-	seq_printf(m, "#                       is not a '0' or '1')\n");
+	seq_puts(m, "# echo 2 > snapshot : Clears this cpu's snapshot buffer (but does not allocate)\n"
+		    "#                      (Doesn't have to be '2' works with any number that\n"
+		    "#                       is not a '0' or '1')\n");
 }
 
 static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
 {
 	if (iter->tr->allocated_snapshot)
-		seq_printf(m, "#\n# * Snapshot is allocated *\n#\n");
+		seq_puts(m, "#\n# * Snapshot is allocated *\n#\n");
 	else
-		seq_printf(m, "#\n# * Snapshot is freed *\n#\n");
+		seq_puts(m, "#\n# * Snapshot is freed *\n#\n");
 
-	seq_printf(m, "# Snapshot commands:\n");
+	seq_puts(m, "# Snapshot commands:\n");
 	if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
 		show_snapshot_main_help(m);
 	else
@@ -3250,7 +3249,7 @@ static int t_show(struct seq_file *m, void *v)
 	if (!t)
 		return 0;
 
-	seq_printf(m, "%s", t->name);
+	seq_puts(m, t->name);
 	if (t->next)
 		seq_putc(m, ' ');
 	else
@@ -5752,10 +5751,10 @@ ftrace_snapshot_print(struct seq_file *m, unsigned long ip,
 
 	seq_printf(m, "%ps:", (void *)ip);
 
-	seq_printf(m, "snapshot");
+	seq_puts(m, "snapshot");
 
 	if (count == -1)
-		seq_printf(m, ":unlimited\n");
+		seq_puts(m, ":unlimited\n");
 	else
 		seq_printf(m, ":count=%ld\n", count);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 385391fb1d3b..3255dfb054a0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -14,6 +14,7 @@
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
 #include <linux/compiler.h>
+#include <linux/trace_seq.h>
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #include <asm/unistd.h>		/* For NR_SYSCALLS	     */
@@ -569,15 +570,6 @@ void trace_init_global_iter(struct trace_iterator *iter);
 
 void tracing_iter_reset(struct trace_iterator *iter, int cpu);
 
-void tracing_sched_switch_trace(struct trace_array *tr,
-				struct task_struct *prev,
-				struct task_struct *next,
-				unsigned long flags, int pc);
-
-void tracing_sched_wakeup_trace(struct trace_array *tr,
-				struct task_struct *wakee,
-				struct task_struct *cur,
-				unsigned long flags, int pc);
 void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
@@ -597,9 +589,6 @@ void set_graph_array(struct trace_array *tr);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
-void tracing_sched_switch_assign_trace(struct trace_array *tr);
-void tracing_stop_sched_switch_record(void);
-void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 int is_tracing_stopped(void);
 
@@ -719,6 +708,8 @@ enum print_line_t print_trace_line(struct trace_iterator *iter);
 
 extern unsigned long trace_flags;
 
+extern char trace_find_mark(unsigned long long duration);
+
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
@@ -737,7 +728,7 @@ extern unsigned long trace_flags;
 extern enum print_line_t
 print_graph_function_flags(struct trace_iterator *iter, u32 flags);
 extern void print_graph_headers_flags(struct seq_file *s, u32 flags);
-extern enum print_line_t
+extern void
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
 extern void graph_trace_open(struct trace_iterator *iter);
 extern void graph_trace_close(struct trace_iterator *iter);
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 697fb9bac8f0..7d6e2afde669 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -151,22 +151,21 @@ static enum print_line_t trace_branch_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	if (trace_seq_printf(&iter->seq, "[%s] %s:%s:%d\n",
-			     field->correct ? "  ok  " : " MISS ",
-			     field->func,
-			     field->file,
-			     field->line))
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_printf(&iter->seq, "[%s] %s:%s:%d\n",
+			 field->correct ? "  ok  " : " MISS ",
+			 field->func,
+			 field->file,
+			 field->line);
+
+	return trace_handle_return(&iter->seq);
 }
 
 static void branch_print_header(struct seq_file *s)
 {
 	seq_puts(s, "#           TASK-PID    CPU#    TIMESTAMP  CORRECT"
-		"  FUNC:FILE:LINE\n");
-	seq_puts(s, "#              | |       |          |         |   "
-		"    |\n");
+		    "  FUNC:FILE:LINE\n"
+		    "#              | |       |          |         |   "
+		    "    |\n");
 }
 
 static struct trace_event_functions trace_branch_funcs = {
@@ -233,12 +232,12 @@ extern unsigned long __stop_annotated_branch_profile[];
 
 static int annotated_branch_stat_headers(struct seq_file *m)
 {
-	seq_printf(m, " correct incorrect  %% ");
-	seq_printf(m, "       Function                "
-			      "  File              Line\n"
-			      " ------- ---------  - "
-			      "       --------                "
-			      "  ----              ----\n");
+	seq_puts(m, " correct incorrect  % "
+		    "       Function                "
+		    "  File              Line\n"
+		    " ------- ---------  - "
+		    "       --------                "
+		    "  ----              ----\n");
 	return 0;
 }
 
@@ -274,7 +273,7 @@ static int branch_stat_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "%8lu %8lu ",  p->correct, p->incorrect);
 	if (percent < 0)
-		seq_printf(m, "  X ");
+		seq_puts(m, "  X ");
 	else
 		seq_printf(m, "%3ld ", percent);
 	seq_printf(m, "%-30.30s %-20.20s %d\n", p->func, f, p->line);
@@ -362,12 +361,12 @@ extern unsigned long __stop_branch_profile[];
 
 static int all_branch_stat_headers(struct seq_file *m)
 {
-	seq_printf(m, "   miss      hit    %% ");
-	seq_printf(m, "       Function                "
-			      "  File              Line\n"
-			      " ------- ---------  - "
-			      "       --------                "
-			      "  ----              ----\n");
+	seq_puts(m, "   miss      hit    % "
+		    "       Function                "
+		    "  File              Line\n"
+		    " ------- ---------  - "
+		    "       --------                "
+		    "  ----              ----\n");
 	return 0;
 }
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0cc51edde3a8..f9d0cbe014b7 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -918,7 +918,7 @@ static int f_show(struct seq_file *m, void *v)
 	case FORMAT_HEADER:
 		seq_printf(m, "name: %s\n", ftrace_event_name(call));
 		seq_printf(m, "ID: %d\n", call->event.type);
-		seq_printf(m, "format:\n");
+		seq_puts(m, "format:\n");
 		return 0;
 
 	case FORMAT_FIELD_SEPERATOR:
@@ -1988,7 +1988,7 @@ event_enable_print(struct seq_file *m, unsigned long ip,
 		   ftrace_event_name(data->file->event_call));
 
 	if (data->count == -1)
-		seq_printf(m, ":unlimited\n");
+		seq_puts(m, ":unlimited\n");
 	else
 		seq_printf(m, ":count=%ld\n", data->count);
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 7a8c1528e141..ced69da0ff55 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -45,6 +45,7 @@ enum filter_op_ids
 	OP_GT,
 	OP_GE,
 	OP_BAND,
+	OP_NOT,
 	OP_NONE,
 	OP_OPEN_PAREN,
 };
@@ -67,6 +68,7 @@ static struct filter_op filter_ops[] = {
 	{ OP_GT,	">",		5 },
 	{ OP_GE,	">=",		5 },
 	{ OP_BAND,	"&",		6 },
+	{ OP_NOT,	"!",		6 },
 	{ OP_NONE,	"OP_NONE",	0 },
 	{ OP_OPEN_PAREN, "(",		0 },
 };
@@ -85,6 +87,7 @@ enum {
 	FILT_ERR_MISSING_FIELD,
 	FILT_ERR_INVALID_FILTER,
 	FILT_ERR_IP_FIELD_ONLY,
+	FILT_ERR_ILLEGAL_NOT_OP,
 };
 
 static char *err_text[] = {
@@ -101,6 +104,7 @@ static char *err_text[] = {
 	"Missing field name and/or value",
 	"Meaningless filter expression",
 	"Only 'ip' field is supported for function trace",
+	"Illegal use of '!'",
 };
 
 struct opstack_op {
@@ -139,6 +143,7 @@ struct pred_stack {
 	int			index;
 };
 
+/* If not of not match is equal to not of not, then it is a match */
 #define DEFINE_COMPARISON_PRED(type)					\
 static int filter_pred_##type(struct filter_pred *pred, void *event)	\
 {									\
@@ -166,7 +171,7 @@ static int filter_pred_##type(struct filter_pred *pred, void *event)	\
 		break;							\
 	}								\
 									\
-	return match;							\
+	return !!match == !pred->not;					\
 }
 
 #define DEFINE_EQUALITY_PRED(size)					\
@@ -484,9 +489,10 @@ static int process_ops(struct filter_pred *preds,
 		if (!WARN_ON_ONCE(!pred->fn))
 			match = pred->fn(pred, rec);
 		if (!!match == type)
-			return match;
+			break;
 	}
-	return match;
+	/* If not of not match is equal to not of not, then it is a match */
+	return !!match == !op->not;
 }
 
 struct filter_match_preds_data {
@@ -735,10 +741,10 @@ static int filter_set_pred(struct event_filter *filter,
 		 * then this op can be folded.
 		 */
 		if (left->index & FILTER_PRED_FOLD &&
-		    (left->op == dest->op ||
+		    ((left->op == dest->op && !left->not) ||
 		     left->left == FILTER_PRED_INVALID) &&
 		    right->index & FILTER_PRED_FOLD &&
-		    (right->op == dest->op ||
+		    ((right->op == dest->op && !right->not) ||
 		     right->left == FILTER_PRED_INVALID))
 			dest->index |= FILTER_PRED_FOLD;
 
@@ -1028,7 +1034,7 @@ static int init_pred(struct filter_parse_state *ps,
 	}
 
 	if (pred->op == OP_NE)
-		pred->not = 1;
+		pred->not ^= 1;
 
 	pred->fn = fn;
 	return 0;
@@ -1590,6 +1596,17 @@ static int replace_preds(struct ftrace_event_call *call,
 			continue;
 		}
 
+		if (elt->op == OP_NOT) {
+			if (!n_preds || operand1 || operand2) {
+				parse_error(ps, FILT_ERR_ILLEGAL_NOT_OP, 0);
+				err = -EINVAL;
+				goto fail;
+			}
+			if (!dry_run)
+				filter->preds[n_preds - 1].not ^= 1;
+			continue;
+		}
+
 		if (WARN_ON(n_preds++ == MAX_FILTER_PRED)) {
 			parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
 			err = -ENOSPC;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 4747b476a030..8712df9decb4 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -373,7 +373,7 @@ event_trigger_print(const char *name, struct seq_file *m,
 {
 	long count = (long)data;
 
-	seq_printf(m, "%s", name);
+	seq_puts(m, name);
 
 	if (count == -1)
 		seq_puts(m, ":unlimited");
@@ -383,7 +383,7 @@ event_trigger_print(const char *name, struct seq_file *m,
 	if (filter_str)
 		seq_printf(m, " if %s\n", filter_str);
 	else
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 
 	return 0;
 }
@@ -1105,7 +1105,7 @@ event_enable_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
 	if (data->filter_str)
 		seq_printf(m, " if %s\n", data->filter_str);
 	else
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 
 	return 0;
 }
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 57f0ec962d2c..fcd41a166405 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -261,37 +261,74 @@ static struct tracer function_trace __tracer_data =
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-static int update_count(void **data)
+static void update_traceon_count(void **data, bool on)
 {
-	unsigned long *count = (long *)data;
+	long *count = (long *)data;
+	long old_count = *count;
 
-	if (!*count)
-		return 0;
+	/*
+	 * Tracing gets disabled (or enabled) once per count.
+	 * This function can be called at the same time on multiple CPUs.
+	 * It is fine if both disable (or enable) tracing, as disabling
+	 * (or enabling) the second time doesn't do anything as the
+	 * state of the tracer is already disabled (or enabled).
+	 * What needs to be synchronized in this case is that the count
+	 * only gets decremented once, even if the tracer is disabled
+	 * (or enabled) twice, as the second one is really a nop.
+	 *
+	 * The memory barriers guarantee that we only decrement the
+	 * counter once. First the count is read to a local variable
+	 * and a read barrier is used to make sure that it is loaded
+	 * before checking if the tracer is in the state we want.
+	 * If the tracer is not in the state we want, then the count
+	 * is guaranteed to be the old count.
+	 *
+	 * Next the tracer is set to the state we want (disabled or enabled)
+	 * then a write memory barrier is used to make sure that
+	 * the new state is visible before changing the counter by
+	 * one minus the old counter. This guarantees that another CPU
+	 * executing this code will see the new state before seeing
+	 * the new counter value, and would not do anything if the new
+	 * counter is seen.
+	 *
+	 * Note, there is no synchronization between this and a user
+	 * setting the tracing_on file. But we currently don't care
+	 * about that.
+	 */
+	if (!old_count)
+		return;
 
-	if (*count != -1)
-		(*count)--;
+	/* Make sure we see count before checking tracing state */
+	smp_rmb();
 
-	return 1;
+	if (on == !!tracing_is_on())
+		return;
+
+	if (on)
+		tracing_on();
+	else
+		tracing_off();
+
+	/* unlimited? */
+	if (old_count == -1)
+		return;
+
+	/* Make sure tracing state is visible before updating count */
+	smp_wmb();
+
+	*count = old_count - 1;
 }
 
 static void
 ftrace_traceon_count(unsigned long ip, unsigned long parent_ip, void **data)
 {
-	if (tracing_is_on())
-		return;
-
-	if (update_count(data))
-		tracing_on();
+	update_traceon_count(data, 1);
 }
 
 static void
 ftrace_traceoff_count(unsigned long ip, unsigned long parent_ip, void **data)
 {
-	if (!tracing_is_on())
-		return;
-
-	if (update_count(data))
-		tracing_off();
+	update_traceon_count(data, 0);
 }
 
 static void
@@ -330,11 +367,49 @@ ftrace_stacktrace(unsigned long ip, unsigned long parent_ip, void **data)
 static void
 ftrace_stacktrace_count(unsigned long ip, unsigned long parent_ip, void **data)
 {
-	if (!tracing_is_on())
-		return;
+	long *count = (long *)data;
+	long old_count;
+	long new_count;
 
-	if (update_count(data))
-		trace_dump_stack(STACK_SKIP);
+	/*
+	 * Stack traces should only execute the number of times the
+	 * user specified in the counter.
+	 */
+	do {
+
+		if (!tracing_is_on())
+			return;
+
+		old_count = *count;
+
+		if (!old_count)
+			return;
+
+		/* unlimited? */
+		if (old_count == -1) {
+			trace_dump_stack(STACK_SKIP);
+			return;
+		}
+
+		new_count = old_count - 1;
+		new_count = cmpxchg(count, old_count, new_count);
+		if (new_count == old_count)
+			trace_dump_stack(STACK_SKIP);
+
+	} while (new_count != old_count);
+}
+
+static int update_count(void **data)
+{
+	unsigned long *count = (long *)data;
+
+	if (!*count)
+		return 0;
+
+	if (*count != -1)
+		(*count)--;
+
+	return 1;
 }
 
 static void
@@ -361,7 +436,7 @@ ftrace_probe_print(const char *name, struct seq_file *m,
 	seq_printf(m, "%ps:%s", (void *)ip, name);
 
 	if (count == -1)
-		seq_printf(m, ":unlimited\n");
+		seq_puts(m, ":unlimited\n");
 	else
 		seq_printf(m, ":count=%ld\n", count);
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index f0a0c982cde3..6c2ab955018c 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -107,7 +107,7 @@ enum {
 	FLAGS_FILL_END   = 3 << TRACE_GRAPH_PRINT_FILL_SHIFT,
 };
 
-static enum print_line_t
+static void
 print_graph_duration(unsigned long long duration, struct trace_seq *s,
 		     u32 flags);
 
@@ -483,33 +483,24 @@ static int graph_trace_update_thresh(struct trace_array *tr)
 
 static int max_bytes_for_cpu;
 
-static enum print_line_t
-print_graph_cpu(struct trace_seq *s, int cpu)
+static void print_graph_cpu(struct trace_seq *s, int cpu)
 {
-	int ret;
-
 	/*
 	 * Start with a space character - to make it stand out
 	 * to the right a bit when trace output is pasted into
 	 * email:
 	 */
-	ret = trace_seq_printf(s, " %*d) ", max_bytes_for_cpu, cpu);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_printf(s, " %*d) ", max_bytes_for_cpu, cpu);
 }
 
 #define TRACE_GRAPH_PROCINFO_LENGTH	14
 
-static enum print_line_t
-print_graph_proc(struct trace_seq *s, pid_t pid)
+static void print_graph_proc(struct trace_seq *s, pid_t pid)
 {
 	char comm[TASK_COMM_LEN];
 	/* sign + log10(MAX_INT) + '\0' */
 	char pid_str[11];
 	int spaces = 0;
-	int ret;
 	int len;
 	int i;
 
@@ -524,56 +515,43 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
 		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
 
 	/* First spaces to align center */
-	for (i = 0; i < spaces / 2; i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	for (i = 0; i < spaces / 2; i++)
+		trace_seq_putc(s, ' ');
 
-	ret = trace_seq_printf(s, "%s-%s", comm, pid_str);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%s-%s", comm, pid_str);
 
 	/* Last spaces to align center */
-	for (i = 0; i < spaces - (spaces / 2); i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-	return TRACE_TYPE_HANDLED;
+	for (i = 0; i < spaces - (spaces / 2); i++)
+		trace_seq_putc(s, ' ');
 }
 
 
-static enum print_line_t
-print_graph_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
+static void print_graph_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 {
-	if (!trace_seq_putc(s, ' '))
-		return 0;
-
-	return trace_print_lat_fmt(s, entry);
+	trace_seq_putc(s, ' ');
+	trace_print_lat_fmt(s, entry);
 }
 
 /* If the pid changed since the last trace, output this event */
-static enum print_line_t
+static void
 verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
 {
 	pid_t prev_pid;
 	pid_t *last_pid;
-	int ret;
 
 	if (!data)
-		return TRACE_TYPE_HANDLED;
+		return;
 
 	last_pid = &(per_cpu_ptr(data->cpu_data, cpu)->last_pid);
 
 	if (*last_pid == pid)
-		return TRACE_TYPE_HANDLED;
+		return;
 
 	prev_pid = *last_pid;
 	*last_pid = pid;
 
 	if (prev_pid == -1)
-		return TRACE_TYPE_HANDLED;
+		return;
 /*
  * Context-switch trace line:
 
@@ -582,33 +560,12 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
  ------------------------------------------
 
  */
-	ret = trace_seq_puts(s,
-		" ------------------------------------------\n");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = print_graph_cpu(s, cpu);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = print_graph_proc(s, prev_pid);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_puts(s, " => ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = print_graph_proc(s, pid);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_puts(s,
-		"\n ------------------------------------------\n\n");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_puts(s, " ------------------------------------------\n");
+	print_graph_cpu(s, cpu);
+	print_graph_proc(s, prev_pid);
+	trace_seq_puts(s, " => ");
+	print_graph_proc(s, pid);
+	trace_seq_puts(s, "\n ------------------------------------------\n\n");
 }
 
 static struct ftrace_graph_ret_entry *
@@ -682,175 +639,122 @@ get_return_for_leaf(struct trace_iterator *iter,
 	return next;
 }
 
-static int print_graph_abs_time(u64 t, struct trace_seq *s)
+static void print_graph_abs_time(u64 t, struct trace_seq *s)
 {
 	unsigned long usecs_rem;
 
 	usecs_rem = do_div(t, NSEC_PER_SEC);
 	usecs_rem /= 1000;
 
-	return trace_seq_printf(s, "%5lu.%06lu |  ",
-			(unsigned long)t, usecs_rem);
+	trace_seq_printf(s, "%5lu.%06lu |  ",
+			 (unsigned long)t, usecs_rem);
 }
 
-static enum print_line_t
+static void
 print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		enum trace_type type, int cpu, pid_t pid, u32 flags)
 {
-	int ret;
 	struct trace_seq *s = &iter->seq;
+	struct trace_entry *ent = iter->ent;
 
 	if (addr < (unsigned long)__irqentry_text_start ||
 		addr >= (unsigned long)__irqentry_text_end)
-		return TRACE_TYPE_UNHANDLED;
+		return;
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
 		/* Absolute time */
-		if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
-			ret = print_graph_abs_time(iter->ts, s);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+		if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
+			print_graph_abs_time(iter->ts, s);
 
 		/* Cpu */
-		if (flags & TRACE_GRAPH_PRINT_CPU) {
-			ret = print_graph_cpu(s, cpu);
-			if (ret == TRACE_TYPE_PARTIAL_LINE)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+		if (flags & TRACE_GRAPH_PRINT_CPU)
+			print_graph_cpu(s, cpu);
 
 		/* Proc */
 		if (flags & TRACE_GRAPH_PRINT_PROC) {
-			ret = print_graph_proc(s, pid);
-			if (ret == TRACE_TYPE_PARTIAL_LINE)
-				return TRACE_TYPE_PARTIAL_LINE;
-			ret = trace_seq_puts(s, " | ");
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
+			print_graph_proc(s, pid);
+			trace_seq_puts(s, " | ");
 		}
+
+		/* Latency format */
+		if (trace_flags & TRACE_ITER_LATENCY_FMT)
+			print_graph_lat_fmt(s, ent);
 	}
 
 	/* No overhead */
-	ret = print_graph_duration(0, s, flags | FLAGS_FILL_START);
-	if (ret != TRACE_TYPE_HANDLED)
-		return ret;
+	print_graph_duration(0, s, flags | FLAGS_FILL_START);
 
 	if (type == TRACE_GRAPH_ENT)
-		ret = trace_seq_puts(s, "==========>");
+		trace_seq_puts(s, "==========>");
 	else
-		ret = trace_seq_puts(s, "<==========");
-
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_puts(s, "<==========");
 
-	ret = print_graph_duration(0, s, flags | FLAGS_FILL_END);
-	if (ret != TRACE_TYPE_HANDLED)
-		return ret;
-
-	ret = trace_seq_putc(s, '\n');
-
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-	return TRACE_TYPE_HANDLED;
+	print_graph_duration(0, s, flags | FLAGS_FILL_END);
+	trace_seq_putc(s, '\n');
 }
 
-enum print_line_t
+void
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 {
 	unsigned long nsecs_rem = do_div(duration, 1000);
 	/* log10(ULONG_MAX) + '\0' */
-	char msecs_str[21];
+	char usecs_str[21];
 	char nsecs_str[5];
-	int ret, len;
+	int len;
 	int i;
 
-	sprintf(msecs_str, "%lu", (unsigned long) duration);
+	sprintf(usecs_str, "%lu", (unsigned long) duration);
 
 	/* Print msecs */
-	ret = trace_seq_printf(s, "%s", msecs_str);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%s", usecs_str);
 
-	len = strlen(msecs_str);
+	len = strlen(usecs_str);
 
 	/* Print nsecs (we don't want to exceed 7 numbers) */
 	if (len < 7) {
 		size_t slen = min_t(size_t, sizeof(nsecs_str), 8UL - len);
 
 		snprintf(nsecs_str, slen, "%03lu", nsecs_rem);
-		ret = trace_seq_printf(s, ".%s", nsecs_str);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_printf(s, ".%s", nsecs_str);
 		len += strlen(nsecs_str);
 	}
 
-	ret = trace_seq_puts(s, " us ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_puts(s, " us ");
 
 	/* Print remaining spaces to fit the row's width */
-	for (i = len; i < 7; i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-	return TRACE_TYPE_HANDLED;
+	for (i = len; i < 7; i++)
+		trace_seq_putc(s, ' ');
 }
 
-static enum print_line_t
+static void
 print_graph_duration(unsigned long long duration, struct trace_seq *s,
 		     u32 flags)
 {
-	int ret = -1;
-
 	if (!(flags & TRACE_GRAPH_PRINT_DURATION) ||
 	    !(trace_flags & TRACE_ITER_CONTEXT_INFO))
-			return TRACE_TYPE_HANDLED;
+		return;
 
 	/* No real adata, just filling the column with spaces */
 	switch (flags & TRACE_GRAPH_PRINT_FILL_MASK) {
 	case FLAGS_FILL_FULL:
-		ret = trace_seq_puts(s, "              |  ");
-		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_puts(s, "              |  ");
+		return;
 	case FLAGS_FILL_START:
-		ret = trace_seq_puts(s, "  ");
-		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_puts(s, "  ");
+		return;
 	case FLAGS_FILL_END:
-		ret = trace_seq_puts(s, " |");
-		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_puts(s, " |");
+		return;
 	}
 
 	/* Signal a overhead of time execution to the output */
-	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
-		/* Duration exceeded 100 msecs */
-		if (duration > 100000ULL)
-			ret = trace_seq_puts(s, "! ");
-		/* Duration exceeded 10 msecs */
-		else if (duration > 10000ULL)
-			ret = trace_seq_puts(s, "+ ");
-	}
-
-	/*
-	 * The -1 means we either did not exceed the duration tresholds
-	 * or we dont want to print out the overhead. Either way we need
-	 * to fill out the space.
-	 */
-	if (ret == -1)
-		ret = trace_seq_puts(s, "  ");
-
-	/* Catching here any failure happenned above */
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_print_graph_duration(duration, s);
-	if (ret != TRACE_TYPE_HANDLED)
-		return ret;
-
-	ret = trace_seq_puts(s, "|  ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (flags & TRACE_GRAPH_PRINT_OVERHEAD)
+		trace_seq_printf(s, "%c ", trace_find_mark(duration));
+	else
+		trace_seq_puts(s, "  ");
 
-	return TRACE_TYPE_HANDLED;
+	trace_print_graph_duration(duration, s);
+	trace_seq_puts(s, "|  ");
 }
 
 /* Case of a leaf function on its call entry */
@@ -864,7 +768,6 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	struct ftrace_graph_ret *graph_ret;
 	struct ftrace_graph_ent *call;
 	unsigned long long duration;
-	int ret;
 	int i;
 
 	graph_ret = &ret_entry->ret;
@@ -890,22 +793,15 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	}
 
 	/* Overhead and duration */
-	ret = print_graph_duration(duration, s, flags);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_duration(duration, s, flags);
 
 	/* Function */
-	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++)
+		trace_seq_putc(s, ' ');
 
-	ret = trace_seq_printf(s, "%ps();\n", (void *)call->func);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%ps();\n", (void *)call->func);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t
@@ -915,7 +811,6 @@ print_graph_entry_nested(struct trace_iterator *iter,
 {
 	struct ftrace_graph_ent *call = &entry->graph_ent;
 	struct fgraph_data *data = iter->private;
-	int ret;
 	int i;
 
 	if (data) {
@@ -931,19 +826,15 @@ print_graph_entry_nested(struct trace_iterator *iter,
 	}
 
 	/* No time */
-	ret = print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
-	if (ret != TRACE_TYPE_HANDLED)
-		return ret;
+	print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
 
 	/* Function */
-	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++)
+		trace_seq_putc(s, ' ');
 
-	ret = trace_seq_printf(s, "%ps() {\n", (void *)call->func);
-	if (!ret)
+	trace_seq_printf(s, "%ps() {\n", (void *)call->func);
+
+	if (trace_seq_has_overflowed(s))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/*
@@ -953,62 +844,43 @@ print_graph_entry_nested(struct trace_iterator *iter,
 	return TRACE_TYPE_NO_CONSUME;
 }
 
-static enum print_line_t
+static void
 print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 		     int type, unsigned long addr, u32 flags)
 {
 	struct fgraph_data *data = iter->private;
 	struct trace_entry *ent = iter->ent;
 	int cpu = iter->cpu;
-	int ret;
 
 	/* Pid */
-	if (verif_pid(s, ent->pid, cpu, data) == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	verif_pid(s, ent->pid, cpu, data);
 
-	if (type) {
+	if (type)
 		/* Interrupt */
-		ret = print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+		print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
 
 	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
-		return 0;
+		return;
 
 	/* Absolute time */
-	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
-		ret = print_graph_abs_time(iter->ts, s);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
+		print_graph_abs_time(iter->ts, s);
 
 	/* Cpu */
-	if (flags & TRACE_GRAPH_PRINT_CPU) {
-		ret = print_graph_cpu(s, cpu);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (flags & TRACE_GRAPH_PRINT_CPU)
+		print_graph_cpu(s, cpu);
 
 	/* Proc */
 	if (flags & TRACE_GRAPH_PRINT_PROC) {
-		ret = print_graph_proc(s, ent->pid);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-
-		ret = trace_seq_puts(s, " | ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+		print_graph_proc(s, ent->pid);
+		trace_seq_puts(s, " | ");
 	}
 
 	/* Latency format */
-	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
-		ret = print_graph_lat_fmt(s, ent);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (trace_flags & TRACE_ITER_LATENCY_FMT)
+		print_graph_lat_fmt(s, ent);
 
-	return 0;
+	return;
 }
 
 /*
@@ -1126,8 +998,7 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	if (check_irq_entry(iter, flags, call->func, call->depth))
 		return TRACE_TYPE_HANDLED;
 
-	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func, flags))
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func, flags);
 
 	leaf_ret = get_return_for_leaf(iter, field);
 	if (leaf_ret)
@@ -1160,7 +1031,6 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	pid_t pid = ent->pid;
 	int cpu = iter->cpu;
 	int func_match = 1;
-	int ret;
 	int i;
 
 	if (check_irq_return(iter, flags, trace->depth))
@@ -1186,20 +1056,14 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		}
 	}
 
-	if (print_graph_prologue(iter, s, 0, 0, flags))
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_prologue(iter, s, 0, 0, flags);
 
 	/* Overhead and duration */
-	ret = print_graph_duration(duration, s, flags);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_duration(duration, s, flags);
 
 	/* Closing brace */
-	for (i = 0; i < trace->depth * TRACE_GRAPH_INDENT; i++) {
-		ret = trace_seq_putc(s, ' ');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	for (i = 0; i < trace->depth * TRACE_GRAPH_INDENT; i++)
+		trace_seq_putc(s, ' ');
 
 	/*
 	 * If the return function does not have a matching entry,
@@ -1208,30 +1072,20 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	 * belongs to, write out the function name. Always do
 	 * that if the funcgraph-tail option is enabled.
 	 */
-	if (func_match && !(flags & TRACE_GRAPH_PRINT_TAIL)) {
-		ret = trace_seq_puts(s, "}\n");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	} else {
-		ret = trace_seq_printf(s, "} /* %ps */\n", (void *)trace->func);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (func_match && !(flags & TRACE_GRAPH_PRINT_TAIL))
+		trace_seq_puts(s, "}\n");
+	else
+		trace_seq_printf(s, "} /* %ps */\n", (void *)trace->func);
 
 	/* Overrun */
-	if (flags & TRACE_GRAPH_PRINT_OVERRUN) {
-		ret = trace_seq_printf(s, " (Overruns: %lu)\n",
-					trace->overrun);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (flags & TRACE_GRAPH_PRINT_OVERRUN)
+		trace_seq_printf(s, " (Overruns: %lu)\n",
+				 trace->overrun);
 
-	ret = print_graph_irq(iter, trace->func, TRACE_GRAPH_RET,
-			      cpu, pid, flags);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_irq(iter, trace->func, TRACE_GRAPH_RET,
+			cpu, pid, flags);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t
@@ -1248,26 +1102,18 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 	if (data)
 		depth = per_cpu_ptr(data->cpu_data, iter->cpu)->depth;
 
-	if (print_graph_prologue(iter, s, 0, 0, flags))
-		return TRACE_TYPE_PARTIAL_LINE;
+	print_graph_prologue(iter, s, 0, 0, flags);
 
 	/* No time */
-	ret = print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
-	if (ret != TRACE_TYPE_HANDLED)
-		return ret;
+	print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
 
 	/* Indentation */
 	if (depth > 0)
-		for (i = 0; i < (depth + 1) * TRACE_GRAPH_INDENT; i++) {
-			ret = trace_seq_putc(s, ' ');
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+		for (i = 0; i < (depth + 1) * TRACE_GRAPH_INDENT; i++)
+			trace_seq_putc(s, ' ');
 
 	/* The comment */
-	ret = trace_seq_puts(s, "/* ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_puts(s, "/* ");
 
 	switch (iter->ent->type) {
 	case TRACE_BPRINT:
@@ -1296,11 +1142,9 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 		s->len--;
 	}
 
-	ret = trace_seq_puts(s, " */\n");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_puts(s, " */\n");
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 
@@ -1407,32 +1251,32 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 		print_lat_header(s, flags);
 
 	/* 1st line */
-	seq_printf(s, "#");
+	seq_putc(s, '#');
 	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
-		seq_printf(s, "     TIME       ");
+		seq_puts(s, "     TIME       ");
 	if (flags & TRACE_GRAPH_PRINT_CPU)
-		seq_printf(s, " CPU");
+		seq_puts(s, " CPU");
 	if (flags & TRACE_GRAPH_PRINT_PROC)
-		seq_printf(s, "  TASK/PID       ");
+		seq_puts(s, "  TASK/PID       ");
 	if (lat)
-		seq_printf(s, "||||");
+		seq_puts(s, "||||");
 	if (flags & TRACE_GRAPH_PRINT_DURATION)
-		seq_printf(s, "  DURATION   ");
-	seq_printf(s, "               FUNCTION CALLS\n");
+		seq_puts(s, "  DURATION   ");
+	seq_puts(s, "               FUNCTION CALLS\n");
 
 	/* 2nd line */
-	seq_printf(s, "#");
+	seq_putc(s, '#');
 	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
-		seq_printf(s, "      |         ");
+		seq_puts(s, "      |         ");
 	if (flags & TRACE_GRAPH_PRINT_CPU)
-		seq_printf(s, " |  ");
+		seq_puts(s, " |  ");
 	if (flags & TRACE_GRAPH_PRINT_PROC)
-		seq_printf(s, "   |    |        ");
+		seq_puts(s, "   |    |        ");
 	if (lat)
-		seq_printf(s, "||||");
+		seq_puts(s, "||||");
 	if (flags & TRACE_GRAPH_PRINT_DURATION)
-		seq_printf(s, "   |   |      ");
-	seq_printf(s, "               |   |   |   |\n");
+		seq_puts(s, "   |   |      ");
+	seq_puts(s, "               |   |   |   |\n");
 }
 
 static void print_graph_headers(struct seq_file *s)
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index bd90e1b06088..b0b1c44e923a 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -20,10 +20,12 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 {
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
+	static struct ring_buffer_iter *buffer_iter[CONFIG_NR_CPUS];
 	unsigned int old_userobj;
 	int cnt = 0, cpu;
 
 	trace_init_global_iter(&iter);
+	iter.buffer_iter = buffer_iter;
 
 	for_each_tracing_cpu(cpu) {
 		atomic_inc(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
@@ -57,19 +59,19 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 		ring_buffer_read_start(iter.buffer_iter[cpu_file]);
 		tracing_iter_reset(&iter, cpu_file);
 	}
-	if (!trace_empty(&iter))
-		trace_find_next_entry_inc(&iter);
-	while (!trace_empty(&iter)) {
+
+	while (trace_find_next_entry_inc(&iter)) {
 		if (!cnt)
 			kdb_printf("---------------------------------\n");
 		cnt++;
 
-		if (trace_find_next_entry_inc(&iter) != NULL && !skip_lines)
+		if (!skip_lines) {
 			print_trace_line(&iter);
-		if (!skip_lines)
 			trace_printk_seq(&iter.seq);
-		else
+		} else {
 			skip_lines--;
+		}
+
 		if (KDB_FLAG(CMD_INTERRUPT))
 			goto out;
 	}
@@ -86,9 +88,12 @@ out:
 		atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
 	}
 
-	for_each_tracing_cpu(cpu)
-		if (iter.buffer_iter[cpu])
+	for_each_tracing_cpu(cpu) {
+		if (iter.buffer_iter[cpu]) {
 			ring_buffer_read_finish(iter.buffer_iter[cpu]);
+			iter.buffer_iter[cpu] = NULL;
+		}
+	}
 }
 
 /*
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 282f6e4e5539..5edb518be345 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -826,7 +826,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	struct trace_kprobe *tk = v;
 	int i;
 
-	seq_printf(m, "%c", trace_kprobe_is_return(tk) ? 'r' : 'p');
+	seq_putc(m, trace_kprobe_is_return(tk) ? 'r' : 'p');
 	seq_printf(m, ":%s/%s", tk->tp.call.class->system,
 			ftrace_event_name(&tk->tp.call));
 
@@ -840,7 +840,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 
 	for (i = 0; i < tk->tp.nr_args; i++)
 		seq_printf(m, " %s=%s", tk->tp.args[i].name, tk->tp.args[i].comm);
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -1024,27 +1024,22 @@ print_kprobe_event(struct trace_iterator *iter, int flags,
 	field = (struct kprobe_trace_entry_head *)iter->ent;
 	tp = container_of(event, struct trace_probe, call.event);
 
-	if (!trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call)))
-		goto partial;
+	trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call));
 
 	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
-		goto partial;
+		goto out;
 
-	if (!trace_seq_puts(s, ")"))
-		goto partial;
+	trace_seq_putc(s, ')');
 
 	data = (u8 *)&field[1];
 	for (i = 0; i < tp->nr_args; i++)
 		if (!tp->args[i].type->print(s, tp->args[i].name,
 					     data + tp->args[i].offset, field))
-			goto partial;
-
-	if (!trace_seq_puts(s, "\n"))
-		goto partial;
+			goto out;
 
-	return TRACE_TYPE_HANDLED;
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_putc(s, '\n');
+ out:
+	return trace_handle_return(s);
 }
 
 static enum print_line_t
@@ -1060,33 +1055,28 @@ print_kretprobe_event(struct trace_iterator *iter, int flags,
 	field = (struct kretprobe_trace_entry_head *)iter->ent;
 	tp = container_of(event, struct trace_probe, call.event);
 
-	if (!trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call)))
-		goto partial;
+	trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call));
 
 	if (!seq_print_ip_sym(s, field->ret_ip, flags | TRACE_ITER_SYM_OFFSET))
-		goto partial;
+		goto out;
 
-	if (!trace_seq_puts(s, " <- "))
-		goto partial;
+	trace_seq_puts(s, " <- ");
 
 	if (!seq_print_ip_sym(s, field->func, flags & ~TRACE_ITER_SYM_OFFSET))
-		goto partial;
+		goto out;
 
-	if (!trace_seq_puts(s, ")"))
-		goto partial;
+	trace_seq_putc(s, ')');
 
 	data = (u8 *)&field[1];
 	for (i = 0; i < tp->nr_args; i++)
 		if (!tp->args[i].type->print(s, tp->args[i].name,
 					     data + tp->args[i].offset, field))
-			goto partial;
+			goto out;
 
-	if (!trace_seq_puts(s, "\n"))
-		goto partial;
+	trace_seq_putc(s, '\n');
 
-	return TRACE_TYPE_HANDLED;
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+ out:
+	return trace_handle_return(s);
 }
 
 
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 0abd9b863474..7a9ba62e9fef 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -59,17 +59,15 @@ static void mmio_trace_start(struct trace_array *tr)
 	mmio_reset_data(tr);
 }
 
-static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
+static void mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
 {
-	int ret = 0;
 	int i;
 	resource_size_t start, end;
 	const struct pci_driver *drv = pci_dev_driver(dev);
 
-	/* XXX: incomplete checks for trace_seq_printf() return value */
-	ret += trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
-				dev->bus->number, dev->devfn,
-				dev->vendor, dev->device, dev->irq);
+	trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
+			 dev->bus->number, dev->devfn,
+			 dev->vendor, dev->device, dev->irq);
 	/*
 	 * XXX: is pci_resource_to_user() appropriate, since we are
 	 * supposed to interpret the __ioremap() phys_addr argument based on
@@ -77,21 +75,20 @@ static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
 	 */
 	for (i = 0; i < 7; i++) {
 		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
-		ret += trace_seq_printf(s, " %llx",
+		trace_seq_printf(s, " %llx",
 			(unsigned long long)(start |
 			(dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
 	}
 	for (i = 0; i < 7; i++) {
 		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
-		ret += trace_seq_printf(s, " %llx",
+		trace_seq_printf(s, " %llx",
 			dev->resource[i].start < dev->resource[i].end ?
 			(unsigned long long)(end - start) + 1 : 0);
 	}
 	if (drv)
-		ret += trace_seq_printf(s, " %s\n", drv->name);
+		trace_seq_printf(s, " %s\n", drv->name);
 	else
-		ret += trace_seq_puts(s, " \n");
-	return ret;
+		trace_seq_puts(s, " \n");
 }
 
 static void destroy_header_iter(struct header_iter *hiter)
@@ -179,28 +176,27 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
-	int ret = 1;
 
 	trace_assign_type(field, entry);
 	rw = &field->rw;
 
 	switch (rw->opcode) {
 	case MMIO_READ:
-		ret = trace_seq_printf(s,
+		trace_seq_printf(s,
 			"R %d %u.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
 			rw->width, secs, usec_rem, rw->map_id,
 			(unsigned long long)rw->phys,
 			rw->value, rw->pc, 0);
 		break;
 	case MMIO_WRITE:
-		ret = trace_seq_printf(s,
+		trace_seq_printf(s,
 			"W %d %u.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
 			rw->width, secs, usec_rem, rw->map_id,
 			(unsigned long long)rw->phys,
 			rw->value, rw->pc, 0);
 		break;
 	case MMIO_UNKNOWN_OP:
-		ret = trace_seq_printf(s,
+		trace_seq_printf(s,
 			"UNKNOWN %u.%06lu %d 0x%llx %02lx,%02lx,"
 			"%02lx 0x%lx %d\n",
 			secs, usec_rem, rw->map_id,
@@ -209,12 +205,11 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 			(rw->value >> 0) & 0xff, rw->pc, 0);
 		break;
 	default:
-		ret = trace_seq_puts(s, "rw what?\n");
+		trace_seq_puts(s, "rw what?\n");
 		break;
 	}
-	if (ret)
-		return TRACE_TYPE_HANDLED;
-	return TRACE_TYPE_PARTIAL_LINE;
+
+	return trace_handle_return(s);
 }
 
 static enum print_line_t mmio_print_map(struct trace_iterator *iter)
@@ -226,31 +221,29 @@ static enum print_line_t mmio_print_map(struct trace_iterator *iter)
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
-	int ret;
 
 	trace_assign_type(field, entry);
 	m = &field->map;
 
 	switch (m->opcode) {
 	case MMIO_PROBE:
-		ret = trace_seq_printf(s,
+		trace_seq_printf(s,
 			"MAP %u.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
 			secs, usec_rem, m->map_id,
 			(unsigned long long)m->phys, m->virt, m->len,
 			0UL, 0);
 		break;
 	case MMIO_UNPROBE:
-		ret = trace_seq_printf(s,
+		trace_seq_printf(s,
 			"UNMAP %u.%06lu %d 0x%lx %d\n",
 			secs, usec_rem, m->map_id, 0UL, 0);
 		break;
 	default:
-		ret = trace_seq_puts(s, "map what?\n");
+		trace_seq_puts(s, "map what?\n");
 		break;
 	}
-	if (ret)
-		return TRACE_TYPE_HANDLED;
-	return TRACE_TYPE_PARTIAL_LINE;
+
+	return trace_handle_return(s);
 }
 
 static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
@@ -262,14 +255,11 @@ static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
-	int ret;
 
 	/* The trailing newline must be in the message. */
-	ret = trace_seq_printf(s, "MARK %u.%06lu %s", secs, usec_rem, msg);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "MARK %u.%06lu %s", secs, usec_rem, msg);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t mmio_print_line(struct trace_iterator *iter)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c6977d5a9b12..b77b9a697619 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -25,15 +25,12 @@ enum print_line_t trace_print_bputs_msg_only(struct trace_iterator *iter)
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
 	struct bputs_entry *field;
-	int ret;
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_puts(s, field->str);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_puts(s, field->str);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 enum print_line_t trace_print_bprintk_msg_only(struct trace_iterator *iter)
@@ -41,15 +38,12 @@ enum print_line_t trace_print_bprintk_msg_only(struct trace_iterator *iter)
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
 	struct bprint_entry *field;
-	int ret;
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_bprintf(s, field->fmt, field->buf);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_bprintf(s, field->fmt, field->buf);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
@@ -57,15 +51,12 @@ enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
 	struct print_entry *field;
-	int ret;
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_puts(s, field->buf);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_puts(s, field->buf);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 const char *
@@ -124,7 +115,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 
 	if (ret == (const char *)(trace_seq_buffer_ptr(p)))
 		trace_seq_printf(p, "0x%lx", val);
-		
+
 	trace_seq_putc(p, 0);
 
 	return ret;
@@ -193,7 +184,6 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
 	struct trace_seq *s = &iter->seq;
 	struct trace_seq *p = &iter->tmp_seq;
 	struct trace_entry *entry;
-	int ret;
 
 	event = container_of(trace_event, struct ftrace_event_call, event);
 	entry = iter->ent;
@@ -204,11 +194,9 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
 	}
 
 	trace_seq_init(p);
-	ret = trace_seq_printf(s, "%s: ", ftrace_event_name(event));
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%s: ", ftrace_event_name(event));
 
-	return 0;
+	return trace_handle_return(s);
 }
 EXPORT_SYMBOL(ftrace_raw_output_prep);
 
@@ -216,18 +204,11 @@ static int ftrace_output_raw(struct trace_iterator *iter, char *name,
 			     char *fmt, va_list ap)
 {
 	struct trace_seq *s = &iter->seq;
-	int ret;
-
-	ret = trace_seq_printf(s, "%s: ", name);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_vprintf(s, fmt, ap);
 
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%s: ", name);
+	trace_seq_vprintf(s, fmt, ap);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...)
@@ -260,7 +241,7 @@ static inline const char *kretprobed(const char *name)
 }
 #endif /* CONFIG_KRETPROBES */
 
-static int
+static void
 seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
 {
 #ifdef CONFIG_KALLSYMS
@@ -271,12 +252,11 @@ seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
 
 	name = kretprobed(str);
 
-	return trace_seq_printf(s, fmt, name);
+	trace_seq_printf(s, fmt, name);
 #endif
-	return 1;
 }
 
-static int
+static void
 seq_print_sym_offset(struct trace_seq *s, const char *fmt,
 		     unsigned long address)
 {
@@ -287,9 +267,8 @@ seq_print_sym_offset(struct trace_seq *s, const char *fmt,
 	sprint_symbol(str, address);
 	name = kretprobed(str);
 
-	return trace_seq_printf(s, fmt, name);
+	trace_seq_printf(s, fmt, name);
 #endif
-	return 1;
 }
 
 #ifndef CONFIG_64BIT
@@ -320,14 +299,14 @@ int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 		if (file) {
 			ret = trace_seq_path(s, &file->f_path);
 			if (ret)
-				ret = trace_seq_printf(s, "[+0x%lx]",
-						       ip - vmstart);
+				trace_seq_printf(s, "[+0x%lx]",
+						 ip - vmstart);
 		}
 		up_read(&mm->mmap_sem);
 	}
 	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
-		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
-	return ret;
+		trace_seq_printf(s, " <" IP_FMT ">", ip);
+	return !trace_seq_has_overflowed(s);
 }
 
 int
@@ -335,7 +314,6 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 		      unsigned long sym_flags)
 {
 	struct mm_struct *mm = NULL;
-	int ret = 1;
 	unsigned int i;
 
 	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
@@ -354,48 +332,45 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 		unsigned long ip = entry->caller[i];
 
-		if (ip == ULONG_MAX || !ret)
+		if (ip == ULONG_MAX || trace_seq_has_overflowed(s))
 			break;
-		if (ret)
-			ret = trace_seq_puts(s, " => ");
+
+		trace_seq_puts(s, " => ");
+
 		if (!ip) {
-			if (ret)
-				ret = trace_seq_puts(s, "??");
-			if (ret)
-				ret = trace_seq_putc(s, '\n');
+			trace_seq_puts(s, "??");
+			trace_seq_putc(s, '\n');
 			continue;
 		}
-		if (!ret)
-			break;
-		if (ret)
-			ret = seq_print_user_ip(s, mm, ip, sym_flags);
-		ret = trace_seq_putc(s, '\n');
+
+		seq_print_user_ip(s, mm, ip, sym_flags);
+		trace_seq_putc(s, '\n');
 	}
 
 	if (mm)
 		mmput(mm);
-	return ret;
+
+	return !trace_seq_has_overflowed(s);
 }
 
 int
 seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 {
-	int ret;
-
-	if (!ip)
-		return trace_seq_putc(s, '0');
+	if (!ip) {
+		trace_seq_putc(s, '0');
+		goto out;
+	}
 
 	if (sym_flags & TRACE_ITER_SYM_OFFSET)
-		ret = seq_print_sym_offset(s, "%s", ip);
+		seq_print_sym_offset(s, "%s", ip);
 	else
-		ret = seq_print_sym_short(s, "%s", ip);
-
-	if (!ret)
-		return 0;
+		seq_print_sym_short(s, "%s", ip);
 
 	if (sym_flags & TRACE_ITER_SYM_ADDR)
-		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
-	return ret;
+		trace_seq_printf(s, " <" IP_FMT ">", ip);
+
+ out:
+	return !trace_seq_has_overflowed(s);
 }
 
 /**
@@ -413,7 +388,6 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 	char irqs_off;
 	int hardirq;
 	int softirq;
-	int ret;
 
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
 	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
@@ -445,16 +419,15 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 		softirq ? 's' :
 		'.';
 
-	if (!trace_seq_printf(s, "%c%c%c",
-			      irqs_off, need_resched, hardsoft_irq))
-		return 0;
+	trace_seq_printf(s, "%c%c%c",
+			 irqs_off, need_resched, hardsoft_irq);
 
 	if (entry->preempt_count)
-		ret = trace_seq_printf(s, "%x", entry->preempt_count);
+		trace_seq_printf(s, "%x", entry->preempt_count);
 	else
-		ret = trace_seq_putc(s, '.');
+		trace_seq_putc(s, '.');
 
-	return ret;
+	return !trace_seq_has_overflowed(s);
 }
 
 static int
@@ -464,14 +437,38 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 
 	trace_find_cmdline(entry->pid, comm);
 
-	if (!trace_seq_printf(s, "%8.8s-%-5d %3d",
-			      comm, entry->pid, cpu))
-		return 0;
+	trace_seq_printf(s, "%8.8s-%-5d %3d",
+			 comm, entry->pid, cpu);
 
 	return trace_print_lat_fmt(s, entry);
 }
 
-static unsigned long preempt_mark_thresh_us = 100;
+#undef MARK
+#define MARK(v, s) {.val = v, .sym = s}
+/* trace overhead mark */
+static const struct trace_mark {
+	unsigned long long	val; /* unit: nsec */
+	char			sym;
+} mark[] = {
+	MARK(1000000000ULL	, '$'), /* 1 sec */
+	MARK(1000000ULL		, '#'), /* 1000 usecs */
+	MARK(100000ULL		, '!'), /* 100 usecs */
+	MARK(10000ULL		, '+'), /* 10 usecs */
+};
+#undef MARK
+
+char trace_find_mark(unsigned long long d)
+{
+	int i;
+	int size = ARRAY_SIZE(mark);
+
+	for (i = 0; i < size; i++) {
+		if (d >= mark[i].val)
+			break;
+	}
+
+	return (i == size) ? ' ' : mark[i].sym;
+}
 
 static int
 lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
@@ -493,24 +490,28 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 		unsigned long rel_usec = do_div(rel_ts, USEC_PER_MSEC);
 		unsigned long rel_msec = (unsigned long)rel_ts;
 
-		return trace_seq_printf(
-				s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
-				ns2usecs(iter->ts),
-				abs_msec, abs_usec,
-				rel_msec, rel_usec);
+		trace_seq_printf(
+			s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
+			ns2usecs(iter->ts),
+			abs_msec, abs_usec,
+			rel_msec, rel_usec);
+
 	} else if (verbose && !in_ns) {
-		return trace_seq_printf(
-				s, "[%016llx] %lld (+%lld): ",
-				iter->ts, abs_ts, rel_ts);
+		trace_seq_printf(
+			s, "[%016llx] %lld (+%lld): ",
+			iter->ts, abs_ts, rel_ts);
+
 	} else if (!verbose && in_ns) {
-		return trace_seq_printf(
-				s, " %4lldus%c: ",
-				abs_ts,
-				rel_ts > preempt_mark_thresh_us ? '!' :
-				  rel_ts > 1 ? '+' : ' ');
+		trace_seq_printf(
+			s, " %4lldus%c: ",
+			abs_ts,
+			trace_find_mark(rel_ts * NSEC_PER_USEC));
+
 	} else { /* !verbose && !in_ns */
-		return trace_seq_printf(s, " %4lld: ", abs_ts);
+		trace_seq_printf(s, " %4lld: ", abs_ts);
 	}
+
+	return !trace_seq_has_overflowed(s);
 }
 
 int trace_print_context(struct trace_iterator *iter)
@@ -520,34 +521,29 @@ int trace_print_context(struct trace_iterator *iter)
 	unsigned long long t;
 	unsigned long secs, usec_rem;
 	char comm[TASK_COMM_LEN];
-	int ret;
 
 	trace_find_cmdline(entry->pid, comm);
 
-	ret = trace_seq_printf(s, "%16s-%-5d [%03d] ",
+	trace_seq_printf(s, "%16s-%-5d [%03d] ",
 			       comm, entry->pid, iter->cpu);
-	if (!ret)
-		return 0;
 
-	if (trace_flags & TRACE_ITER_IRQ_INFO) {
-		ret = trace_print_lat_fmt(s, entry);
-		if (!ret)
-			return 0;
-	}
+	if (trace_flags & TRACE_ITER_IRQ_INFO)
+		trace_print_lat_fmt(s, entry);
 
 	if (iter->iter_flags & TRACE_FILE_TIME_IN_NS) {
 		t = ns2usecs(iter->ts);
 		usec_rem = do_div(t, USEC_PER_SEC);
 		secs = (unsigned long)t;
-		return trace_seq_printf(s, " %5lu.%06lu: ", secs, usec_rem);
+		trace_seq_printf(s, " %5lu.%06lu: ", secs, usec_rem);
 	} else
-		return trace_seq_printf(s, " %12llu: ", iter->ts);
+		trace_seq_printf(s, " %12llu: ", iter->ts);
+
+	return !trace_seq_has_overflowed(s);
 }
 
 int trace_print_lat_context(struct trace_iterator *iter)
 {
 	u64 next_ts;
-	int ret;
 	/* trace_find_next_entry will reset ent_size */
 	int ent_size = iter->ent_size;
 	struct trace_seq *s = &iter->seq;
@@ -567,18 +563,17 @@ int trace_print_lat_context(struct trace_iterator *iter)
 
 		trace_find_cmdline(entry->pid, comm);
 
-		ret = trace_seq_printf(
-				s, "%16s %5d %3d %d %08x %08lx ",
-				comm, entry->pid, iter->cpu, entry->flags,
-				entry->preempt_count, iter->idx);
+		trace_seq_printf(
+			s, "%16s %5d %3d %d %08x %08lx ",
+			comm, entry->pid, iter->cpu, entry->flags,
+			entry->preempt_count, iter->idx);
 	} else {
-		ret = lat_print_generic(s, entry, iter->cpu);
+		lat_print_generic(s, entry, iter->cpu);
 	}
 
-	if (ret)
-		ret = lat_print_timestamp(iter, next_ts);
+	lat_print_timestamp(iter, next_ts);
 
-	return ret;
+	return !trace_seq_has_overflowed(s);
 }
 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
@@ -692,7 +687,7 @@ int register_ftrace_event(struct trace_event *event)
 				goto out;
 
 		} else {
-			
+
 			event->type = next_event_type++;
 			list = &ftrace_event_list;
 		}
@@ -764,10 +759,9 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_event);
 enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags,
 				  struct trace_event *event)
 {
-	if (!trace_seq_printf(&iter->seq, "type: %d\n", iter->ent->type))
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(&iter->seq, "type: %d\n", iter->ent->type);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(&iter->seq);
 }
 
 /* TRACE_FN */
@@ -779,24 +773,16 @@ static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
+	seq_print_ip_sym(s, field->ip, flags);
 
 	if ((flags & TRACE_ITER_PRINT_PARENT) && field->parent_ip) {
-		if (!trace_seq_puts(s, " <-"))
-			goto partial;
-		if (!seq_print_ip_sym(s,
-				      field->parent_ip,
-				      flags))
-			goto partial;
+		trace_seq_puts(s, " <-");
+		seq_print_ip_sym(s, field->parent_ip, flags);
 	}
-	if (!trace_seq_putc(s, '\n'))
-		goto partial;
 
-	return TRACE_TYPE_HANDLED;
+	trace_seq_putc(s, '\n');
 
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags,
@@ -806,12 +792,11 @@ static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(&iter->seq, "%lx %lx\n",
-			      field->ip,
-			      field->parent_ip))
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(&iter->seq, "%lx %lx\n",
+			 field->ip,
+			 field->parent_ip);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(&iter->seq);
 }
 
 static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags,
@@ -822,10 +807,10 @@ static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	SEQ_PUT_HEX_FIELD_RET(s, field->ip);
-	SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
+	SEQ_PUT_HEX_FIELD(s, field->ip);
+	SEQ_PUT_HEX_FIELD(s, field->parent_ip);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags,
@@ -836,10 +821,10 @@ static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	SEQ_PUT_FIELD_RET(s, field->ip);
-	SEQ_PUT_FIELD_RET(s, field->parent_ip);
+	SEQ_PUT_FIELD(s, field->ip);
+	SEQ_PUT_FIELD(s, field->parent_ip);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_fn_funcs = {
@@ -868,18 +853,17 @@ static enum print_line_t trace_ctxwake_print(struct trace_iterator *iter,
 	T = task_state_char(field->next_state);
 	S = task_state_char(field->prev_state);
 	trace_find_cmdline(field->next_pid, comm);
-	if (!trace_seq_printf(&iter->seq,
-			      " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
-			      field->prev_pid,
-			      field->prev_prio,
-			      S, delim,
-			      field->next_cpu,
-			      field->next_pid,
-			      field->next_prio,
-			      T, comm))
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_printf(&iter->seq,
+			 " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
+			 field->prev_pid,
+			 field->prev_prio,
+			 S, delim,
+			 field->next_cpu,
+			 field->next_pid,
+			 field->next_prio,
+			 T, comm);
+
+	return trace_handle_return(&iter->seq);
 }
 
 static enum print_line_t trace_ctx_print(struct trace_iterator *iter, int flags,
@@ -904,17 +888,16 @@ static int trace_ctxwake_raw(struct trace_iterator *iter, char S)
 	if (!S)
 		S = task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
-	if (!trace_seq_printf(&iter->seq, "%d %d %c %d %d %d %c\n",
-			      field->prev_pid,
-			      field->prev_prio,
-			      S,
-			      field->next_cpu,
-			      field->next_pid,
-			      field->next_prio,
-			      T))
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_printf(&iter->seq, "%d %d %c %d %d %d %c\n",
+			 field->prev_pid,
+			 field->prev_prio,
+			 S,
+			 field->next_cpu,
+			 field->next_pid,
+			 field->next_prio,
+			 T);
+
+	return trace_handle_return(&iter->seq);
 }
 
 static enum print_line_t trace_ctx_raw(struct trace_iterator *iter, int flags,
@@ -942,15 +925,15 @@ static int trace_ctxwake_hex(struct trace_iterator *iter, char S)
 		S = task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
 
-	SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
-	SEQ_PUT_HEX_FIELD_RET(s, field->prev_prio);
-	SEQ_PUT_HEX_FIELD_RET(s, S);
-	SEQ_PUT_HEX_FIELD_RET(s, field->next_cpu);
-	SEQ_PUT_HEX_FIELD_RET(s, field->next_pid);
-	SEQ_PUT_HEX_FIELD_RET(s, field->next_prio);
-	SEQ_PUT_HEX_FIELD_RET(s, T);
+	SEQ_PUT_HEX_FIELD(s, field->prev_pid);
+	SEQ_PUT_HEX_FIELD(s, field->prev_prio);
+	SEQ_PUT_HEX_FIELD(s, S);
+	SEQ_PUT_HEX_FIELD(s, field->next_cpu);
+	SEQ_PUT_HEX_FIELD(s, field->next_pid);
+	SEQ_PUT_HEX_FIELD(s, field->next_prio);
+	SEQ_PUT_HEX_FIELD(s, T);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t trace_ctx_hex(struct trace_iterator *iter, int flags,
@@ -973,14 +956,15 @@ static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	SEQ_PUT_FIELD_RET(s, field->prev_pid);
-	SEQ_PUT_FIELD_RET(s, field->prev_prio);
-	SEQ_PUT_FIELD_RET(s, field->prev_state);
-	SEQ_PUT_FIELD_RET(s, field->next_pid);
-	SEQ_PUT_FIELD_RET(s, field->next_prio);
-	SEQ_PUT_FIELD_RET(s, field->next_state);
+	SEQ_PUT_FIELD(s, field->prev_pid);
+	SEQ_PUT_FIELD(s, field->prev_prio);
+	SEQ_PUT_FIELD(s, field->prev_state);
+	SEQ_PUT_FIELD(s, field->next_cpu);
+	SEQ_PUT_FIELD(s, field->next_pid);
+	SEQ_PUT_FIELD(s, field->next_prio);
+	SEQ_PUT_FIELD(s, field->next_state);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_ctx_funcs = {
@@ -1020,23 +1004,19 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 	trace_assign_type(field, iter->ent);
 	end = (unsigned long *)((long)iter->ent + iter->ent_size);
 
-	if (!trace_seq_puts(s, "<stack trace>\n"))
-		goto partial;
+	trace_seq_puts(s, "<stack trace>\n");
 
 	for (p = field->caller; p && *p != ULONG_MAX && p < end; p++) {
-		if (!trace_seq_puts(s, " => "))
-			goto partial;
 
-		if (!seq_print_ip_sym(s, *p, flags))
-			goto partial;
-		if (!trace_seq_putc(s, '\n'))
-			goto partial;
-	}
+		if (trace_seq_has_overflowed(s))
+			break;
 
-	return TRACE_TYPE_HANDLED;
+		trace_seq_puts(s, " => ");
+		seq_print_ip_sym(s, *p, flags);
+		trace_seq_putc(s, '\n');
+	}
 
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_stack_funcs = {
@@ -1057,16 +1037,10 @@ static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_puts(s, "<user stack trace>\n"))
-		goto partial;
-
-	if (!seq_print_userip_objs(field, s, flags))
-		goto partial;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_puts(s, "<user stack trace>\n");
+	seq_print_userip_objs(field, s, flags);
 
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_user_stack_funcs = {
@@ -1089,19 +1063,11 @@ trace_bputs_print(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, entry);
 
-	if (!seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
+	seq_print_ip_sym(s, field->ip, flags);
+	trace_seq_puts(s, ": ");
+	trace_seq_puts(s, field->str);
 
-	if (!trace_seq_puts(s, ": "))
-		goto partial;
-
-	if (!trace_seq_puts(s, field->str))
-		goto partial;
-
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 
@@ -1114,16 +1080,10 @@ trace_bputs_raw(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(s, ": %lx : ", field->ip))
-		goto partial;
-
-	if (!trace_seq_puts(s, field->str))
-		goto partial;
+	trace_seq_printf(s, ": %lx : ", field->ip);
+	trace_seq_puts(s, field->str);
 
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_bputs_funcs = {
@@ -1147,19 +1107,11 @@ trace_bprint_print(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, entry);
 
-	if (!seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
-
-	if (!trace_seq_puts(s, ": "))
-		goto partial;
-
-	if (!trace_seq_bprintf(s, field->fmt, field->buf))
-		goto partial;
+	seq_print_ip_sym(s, field->ip, flags);
+	trace_seq_puts(s, ": ");
+	trace_seq_bprintf(s, field->fmt, field->buf);
 
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 
@@ -1172,16 +1124,10 @@ trace_bprint_raw(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(s, ": %lx : ", field->ip))
-		goto partial;
-
-	if (!trace_seq_bprintf(s, field->fmt, field->buf))
-		goto partial;
+	trace_seq_printf(s, ": %lx : ", field->ip);
+	trace_seq_bprintf(s, field->fmt, field->buf);
 
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static struct trace_event_functions trace_bprint_funcs = {
@@ -1203,16 +1149,10 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
-
-	if (!trace_seq_printf(s, ": %s", field->buf))
-		goto partial;
+	seq_print_ip_sym(s, field->ip, flags);
+	trace_seq_printf(s, ": %s", field->buf);
 
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
@@ -1222,13 +1162,9 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf))
-		goto partial;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf);
 
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+	return trace_handle_return(&iter->seq);
 }
 
 static struct trace_event_functions trace_print_funcs = {
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 80b25b585a70..8ef2c40efb3c 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -35,17 +35,11 @@ trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);
 extern int __unregister_ftrace_event(struct trace_event *event);
 extern struct rw_semaphore trace_event_sem;
 
-#define SEQ_PUT_FIELD_RET(s, x)				\
-do {							\
-	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
-		return TRACE_TYPE_PARTIAL_LINE;		\
-} while (0)
-
-#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
-do {							\
-	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
-		return TRACE_TYPE_PARTIAL_LINE;		\
-} while (0)
+#define SEQ_PUT_FIELD(s, x)				\
+	trace_seq_putmem(s, &(x), sizeof(x))
+
+#define SEQ_PUT_HEX_FIELD(s, x)				\
+	trace_seq_putmem_hex(s, &(x), sizeof(x))
 
 #endif
 
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 2900817ba65c..c4e70b6bd7fa 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -305,7 +305,7 @@ static int t_show(struct seq_file *m, void *v)
 			seq_puts(m, "\\t");
 			break;
 		case '\\':
-			seq_puts(m, "\\");
+			seq_putc(m, '\\');
 			break;
 		case '"':
 			seq_puts(m, "\\\"");
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index d4b9fc22cd27..b983b2fd2ca1 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -40,7 +40,8 @@ const char *reserved_field_names[] = {
 int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s, const char *name,	\
 				void *data, void *ent)			\
 {									\
-	return trace_seq_printf(s, " %s=" fmt, name, *(type *)data);	\
+	trace_seq_printf(s, " %s=" fmt, name, *(type *)data);		\
+	return !trace_seq_has_overflowed(s);				\
 }									\
 const char PRINT_TYPE_FMT_NAME(type)[] = fmt;				\
 NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(type));
@@ -61,10 +62,11 @@ int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s, const char *name,
 	int len = *(u32 *)data >> 16;
 
 	if (!len)
-		return trace_seq_printf(s, " %s=(fault)", name);
+		trace_seq_printf(s, " %s=(fault)", name);
 	else
-		return trace_seq_printf(s, " %s=\"%s\"", name,
-					(const char *)get_loc_data(data, ent));
+		trace_seq_printf(s, " %s=\"%s\"", name,
+				 (const char *)get_loc_data(data, ent));
+	return !trace_seq_has_overflowed(s);
 }
 NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(string));
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 3f34dc9b40f3..2e293beb186e 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -14,122 +14,26 @@
 
 #include "trace.h"
 
-static struct trace_array	*ctx_trace;
-static int __read_mostly	tracer_enabled;
 static int			sched_ref;
 static DEFINE_MUTEX(sched_register_mutex);
-static int			sched_stopped;
-
-
-void
-tracing_sched_switch_trace(struct trace_array *tr,
-			   struct task_struct *prev,
-			   struct task_struct *next,
-			   unsigned long flags, int pc)
-{
-	struct ftrace_event_call *call = &event_context_switch;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
-	struct ring_buffer_event *event;
-	struct ctx_switch_entry *entry;
-
-	event = trace_buffer_lock_reserve(buffer, TRACE_CTX,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->prev_pid			= prev->pid;
-	entry->prev_prio		= prev->prio;
-	entry->prev_state		= prev->state;
-	entry->next_pid			= next->pid;
-	entry->next_prio		= next->prio;
-	entry->next_state		= next->state;
-	entry->next_cpu	= task_cpu(next);
-
-	if (!call_filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, flags, pc);
-}
 
 static void
 probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *next)
 {
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	int cpu;
-	int pc;
-
 	if (unlikely(!sched_ref))
 		return;
 
 	tracing_record_cmdline(prev);
 	tracing_record_cmdline(next);
-
-	if (!tracer_enabled || sched_stopped)
-		return;
-
-	pc = preempt_count();
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(ctx_trace->trace_buffer.data, cpu);
-
-	if (likely(!atomic_read(&data->disabled)))
-		tracing_sched_switch_trace(ctx_trace, prev, next, flags, pc);
-
-	local_irq_restore(flags);
-}
-
-void
-tracing_sched_wakeup_trace(struct trace_array *tr,
-			   struct task_struct *wakee,
-			   struct task_struct *curr,
-			   unsigned long flags, int pc)
-{
-	struct ftrace_event_call *call = &event_wakeup;
-	struct ring_buffer_event *event;
-	struct ctx_switch_entry *entry;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
-
-	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->prev_pid			= curr->pid;
-	entry->prev_prio		= curr->prio;
-	entry->prev_state		= curr->state;
-	entry->next_pid			= wakee->pid;
-	entry->next_prio		= wakee->prio;
-	entry->next_state		= wakee->state;
-	entry->next_cpu			= task_cpu(wakee);
-
-	if (!call_filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, flags, pc);
 }
 
 static void
 probe_sched_wakeup(void *ignore, struct task_struct *wakee, int success)
 {
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	int cpu, pc;
-
 	if (unlikely(!sched_ref))
 		return;
 
 	tracing_record_cmdline(current);
-
-	if (!tracer_enabled || sched_stopped)
-		return;
-
-	pc = preempt_count();
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(ctx_trace->trace_buffer.data, cpu);
-
-	if (likely(!atomic_read(&data->disabled)))
-		tracing_sched_wakeup_trace(ctx_trace, wakee, current,
-					   flags, pc);
-
-	local_irq_restore(flags);
 }
 
 static int tracing_sched_register(void)
@@ -197,51 +101,3 @@ void tracing_stop_cmdline_record(void)
 {
 	tracing_stop_sched_switch();
 }
-
-/**
- * tracing_start_sched_switch_record - start tracing context switches
- *
- * Turns on context switch tracing for a tracer.
- */
-void tracing_start_sched_switch_record(void)
-{
-	if (unlikely(!ctx_trace)) {
-		WARN_ON(1);
-		return;
-	}
-
-	tracing_start_sched_switch();
-
-	mutex_lock(&sched_register_mutex);
-	tracer_enabled++;
-	mutex_unlock(&sched_register_mutex);
-}
-
-/**
- * tracing_stop_sched_switch_record - start tracing context switches
- *
- * Turns off context switch tracing for a tracer.
- */
-void tracing_stop_sched_switch_record(void)
-{
-	mutex_lock(&sched_register_mutex);
-	tracer_enabled--;
-	WARN_ON(tracer_enabled < 0);
-	mutex_unlock(&sched_register_mutex);
-
-	tracing_stop_sched_switch();
-}
-
-/**
- * tracing_sched_switch_assign_trace - assign a trace array for ctx switch
- * @tr: trace array pointer to assign
- *
- * Some tracers might want to record the context switches in their
- * trace. This function lets those tracers assign the trace array
- * to use.
- */
-void tracing_sched_switch_assign_trace(struct trace_array *tr)
-{
-	ctx_trace = tr;
-}
-
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 19bd8928ce94..8fb84b362816 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -365,6 +365,62 @@ probe_wakeup_migrate_task(void *ignore, struct task_struct *task, int cpu)
 	wakeup_current_cpu = cpu;
 }
 
+static void
+tracing_sched_switch_trace(struct trace_array *tr,
+			   struct task_struct *prev,
+			   struct task_struct *next,
+			   unsigned long flags, int pc)
+{
+	struct ftrace_event_call *call = &event_context_switch;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer_event *event;
+	struct ctx_switch_entry *entry;
+
+	event = trace_buffer_lock_reserve(buffer, TRACE_CTX,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->prev_pid			= prev->pid;
+	entry->prev_prio		= prev->prio;
+	entry->prev_state		= prev->state;
+	entry->next_pid			= next->pid;
+	entry->next_prio		= next->prio;
+	entry->next_state		= next->state;
+	entry->next_cpu	= task_cpu(next);
+
+	if (!call_filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, flags, pc);
+}
+
+static void
+tracing_sched_wakeup_trace(struct trace_array *tr,
+			   struct task_struct *wakee,
+			   struct task_struct *curr,
+			   unsigned long flags, int pc)
+{
+	struct ftrace_event_call *call = &event_wakeup;
+	struct ring_buffer_event *event;
+	struct ctx_switch_entry *entry;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+
+	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->prev_pid			= curr->pid;
+	entry->prev_prio		= curr->prio;
+	entry->prev_state		= curr->state;
+	entry->next_pid			= wakee->pid;
+	entry->next_prio		= wakee->prio;
+	entry->next_state		= wakee->state;
+	entry->next_cpu			= task_cpu(wakee);
+
+	if (!call_filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, flags, pc);
+}
+
 static void notrace
 probe_wakeup_sched_switch(void *ignore,
 			  struct task_struct *prev, struct task_struct *next)
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 1f24ed99dca2..fabfa0f190a3 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -69,20 +69,15 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
  * trace_seq_printf() is used to store strings into a special
  * buffer (@s). Then the output may be either used by
  * the sequencer or pulled into another buffer.
- *
- * Returns 1 if we successfully written all the contents to
- *   the buffer.
-  * Returns 0 if we the length to write is bigger than the
- *   reserved buffer space. In this case, nothing gets written.
  */
-int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+void trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
 	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	va_list ap;
 	int ret;
 
 	if (s->full || !len)
-		return 0;
+		return;
 
 	va_start(ap, fmt);
 	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
@@ -91,12 +86,10 @@ int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	/* If we can't write it all, don't bother writing anything */
 	if (ret >= len) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	s->len += ret;
-
-	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
@@ -107,25 +100,18 @@ EXPORT_SYMBOL_GPL(trace_seq_printf);
  * @nmaskbits:	The number of bits that are valid in @maskp
  *
  * Writes a ASCII representation of a bitmask string into @s.
- *
- * Returns 1 if we successfully written all the contents to
- *   the buffer.
- * Returns 0 if we the length to write is bigger than the
- *   reserved buffer space. In this case, nothing gets written.
  */
-int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+void trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 		      int nmaskbits)
 {
 	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	int ret;
 
 	if (s->full || !len)
-		return 0;
+		return;
 
-	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
+	ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
 	s->len += ret;
-
-	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_bitmask);
 
@@ -139,28 +125,24 @@ EXPORT_SYMBOL_GPL(trace_seq_bitmask);
  * trace_seq_printf is used to store strings into a special
  * buffer (@s). Then the output may be either used by
  * the sequencer or pulled into another buffer.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+void trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 {
 	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	int ret;
 
 	if (s->full || !len)
-		return 0;
+		return;
 
 	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
 
 	/* If we can't write it all, don't bother writing anything */
 	if (ret >= len) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	s->len += ret;
-
-	return len;
 }
 EXPORT_SYMBOL_GPL(trace_seq_vprintf);
 
@@ -178,28 +160,24 @@ EXPORT_SYMBOL_GPL(trace_seq_vprintf);
  *
  * This function will take the format and the binary array and finish
  * the conversion into the ASCII string within the buffer.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
+void trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
 	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
 	int ret;
 
 	if (s->full || !len)
-		return 0;
+		return;
 
 	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
 
 	/* If we can't write it all, don't bother writing anything */
 	if (ret >= len) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	s->len += ret;
-
-	return len;
 }
 EXPORT_SYMBOL_GPL(trace_seq_bprintf);
 
@@ -212,25 +190,21 @@ EXPORT_SYMBOL_GPL(trace_seq_bprintf);
  * copy to user routines. This function records a simple string
  * into a special buffer (@s) for later retrieval by a sequencer
  * or other mechanism.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_puts(struct trace_seq *s, const char *str)
+void trace_seq_puts(struct trace_seq *s, const char *str)
 {
 	unsigned int len = strlen(str);
 
 	if (s->full)
-		return 0;
+		return;
 
 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	memcpy(s->buffer + s->len, str, len);
 	s->len += len;
-
-	return len;
 }
 EXPORT_SYMBOL_GPL(trace_seq_puts);
 
@@ -243,22 +217,18 @@ EXPORT_SYMBOL_GPL(trace_seq_puts);
  * copy to user routines. This function records a simple charater
  * into a special buffer (@s) for later retrieval by a sequencer
  * or other mechanism.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_putc(struct trace_seq *s, unsigned char c)
+void trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
 	if (s->full)
-		return 0;
+		return;
 
 	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	s->buffer[s->len++] = c;
-
-	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_putc);
 
@@ -271,23 +241,19 @@ EXPORT_SYMBOL_GPL(trace_seq_putc);
  * There may be cases where raw memory needs to be written into the
  * buffer and a strcpy() would not work. Using this function allows
  * for such cases.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
+void trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 {
 	if (s->full)
-		return 0;
+		return;
 
 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
-		return 0;
+		return;
 	}
 
 	memcpy(s->buffer + s->len, mem, len);
 	s->len += len;
-
-	return len;
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem);
 
@@ -303,20 +269,17 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem);
  * This is similar to trace_seq_putmem() except instead of just copying the
  * raw memory into the buffer it writes its ASCII representation of it
  * in hex characters.
- *
- * Returns how much it wrote to the buffer.
  */
-int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+void trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 			 unsigned int len)
 {
 	unsigned char hex[HEX_CHARS];
 	const unsigned char *data = mem;
 	unsigned int start_len;
 	int i, j;
-	int cnt = 0;
 
 	if (s->full)
-		return 0;
+		return;
 
 	while (len) {
 		start_len = min(len, HEX_CHARS - 1);
@@ -335,9 +298,8 @@ int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 		len -= j / 2;
 		hex[j++] = ' ';
 
-		cnt += trace_seq_putmem(s, hex, j);
+		trace_seq_putmem(s, hex, j);
 	}
-	return cnt;
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4dc8b79c5f75..a72f3d8d813e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -114,7 +114,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 	struct trace_entry *ent = iter->ent;
 	struct syscall_trace_enter *trace;
 	struct syscall_metadata *entry;
-	int i, ret, syscall;
+	int i, syscall;
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
@@ -128,35 +128,28 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 		goto end;
 	}
 
-	ret = trace_seq_printf(s, "%s(", entry->name);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%s(", entry->name);
 
 	for (i = 0; i < entry->nb_args; i++) {
+
+		if (trace_seq_has_overflowed(s))
+			goto end;
+
 		/* parameter types */
-		if (trace_flags & TRACE_ITER_VERBOSE) {
-			ret = trace_seq_printf(s, "%s ", entry->types[i]);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+		if (trace_flags & TRACE_ITER_VERBOSE)
+			trace_seq_printf(s, "%s ", entry->types[i]);
+
 		/* parameter values */
-		ret = trace_seq_printf(s, "%s: %lx%s", entry->args[i],
-				       trace->args[i],
-				       i == entry->nb_args - 1 ? "" : ", ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_printf(s, "%s: %lx%s", entry->args[i],
+				 trace->args[i],
+				 i == entry->nb_args - 1 ? "" : ", ");
 	}
 
-	ret = trace_seq_putc(s, ')');
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
+	trace_seq_putc(s, ')');
 end:
-	ret =  trace_seq_putc(s, '\n');
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_putc(s, '\n');
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t
@@ -168,7 +161,6 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 	struct syscall_trace_exit *trace;
 	int syscall;
 	struct syscall_metadata *entry;
-	int ret;
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
@@ -176,7 +168,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 
 	if (!entry) {
 		trace_seq_putc(s, '\n');
-		return TRACE_TYPE_HANDLED;
+		goto out;
 	}
 
 	if (entry->exit_event->event.type != ent->type) {
@@ -184,12 +176,11 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 		return TRACE_TYPE_UNHANDLED;
 	}
 
-	ret = trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
+	trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
 				trace->ret);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
 
-	return TRACE_TYPE_HANDLED;
+ out:
+	return trace_handle_return(s);
 }
 
 extern char *__bad_type_size(void);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 33ff6a24b802..8520acc34b18 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -552,8 +552,7 @@ error:
 	return ret;
 
 fail_address_parse:
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	pr_info("Failed to parse address or file.\n");
 
@@ -606,7 +605,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	for (i = 0; i < tu->tp.nr_args; i++)
 		seq_printf(m, " %s=%s", tu->tp.args[i].name, tu->tp.args[i].comm);
 
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 	return 0;
 }
 
@@ -852,16 +851,14 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 	tu = container_of(event, struct trace_uprobe, tp.call.event);
 
 	if (is_ret_probe(tu)) {
-		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)",
-					ftrace_event_name(&tu->tp.call),
-					entry->vaddr[1], entry->vaddr[0]))
-			goto partial;
+		trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)",
+				 ftrace_event_name(&tu->tp.call),
+				 entry->vaddr[1], entry->vaddr[0]);
 		data = DATAOF_TRACE_ENTRY(entry, true);
 	} else {
-		if (!trace_seq_printf(s, "%s: (0x%lx)",
-					ftrace_event_name(&tu->tp.call),
-					entry->vaddr[0]))
-			goto partial;
+		trace_seq_printf(s, "%s: (0x%lx)",
+				 ftrace_event_name(&tu->tp.call),
+				 entry->vaddr[0]);
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
@@ -869,14 +866,13 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 		struct probe_arg *parg = &tu->tp.args[i];
 
 		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
-			goto partial;
+			goto out;
 	}
 
-	if (trace_seq_puts(s, "\n"))
-		return TRACE_TYPE_HANDLED;
+	trace_seq_putc(s, '\n');
 
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+ out:
+	return trace_handle_return(s);
 }
 
 typedef bool (*filter_func_t)(struct uprobe_consumer *self,

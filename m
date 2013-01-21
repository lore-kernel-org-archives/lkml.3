Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3AUVSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:18:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33581 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3AUVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:31 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=t4nrP_t5VqEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=o5MEg2z3Yu4A:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=pGLkceISAAAA:8 a=8bJEbBZwtvVHsQk0D2IA:9 a=EvKJbDF4Ut8A:10 a=Zh68SRI7RUMA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211728.861780747@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 10/13 -next] ftrace: Move ARCH_SUPPORTS_FTRACE_SAVE_REGS in Kconfig
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0010-ftrace-Move-ARCH_SUPPORTS_FTRACE_SAVE_REGS-in-Kconfi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Move SAVE_REGS support flag into Kconfig and rename
it to CONFIG_DYNAMIC_FTRACE_WITH_REGS. This also introduces
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS which indicates
the architecture depending part of ftrace has a code
that saves full registers.
On the other hand, CONFIG_DYNAMIC_FTRACE_WITH_REGS indicates
the code is enabled.

Link: http://lkml.kernel.org/r/20120928081516.3560.72534.stgit@ltc138.sdl.hitachi.co.jp

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig              |    1 +
 arch/x86/include/asm/ftrace.h |    1 -
 include/linux/ftrace.h        |    6 +++---
 kernel/trace/Kconfig          |    8 ++++++++
 kernel/trace/ftrace.c         |    6 +++---
 kernel/trace/trace_selftest.c |    2 +-
 6 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..996ccec 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -44,6 +44,7 @@ config X86
 	select HAVE_FENTRY if X86_64
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DYNAMIC_FTRACE
+	select HAVE_DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_GRAPH_FP_TEST
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 9a25b52..86cb51e 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -44,7 +44,6 @@
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 #define ARCH_SUPPORTS_FTRACE_OPS 1
-#define ARCH_SUPPORTS_FTRACE_SAVE_REGS
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 92691d8..e5ca8ef 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -74,7 +74,7 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  * SAVE_REGS - The ftrace_ops wants regs saved at each function called
  *            and passed to the callback. If this flag is set, but the
  *            architecture does not support passing regs
- *            (ARCH_SUPPORTS_FTRACE_SAVE_REGS is not defined), then the
+ *            (CONFIG_DYNAMIC_FTRACE_WITH_REGS is not defined), then the
  *            ftrace_ops will fail to register, unless the next flag
  *            is set.
  * SAVE_REGS_IF_SUPPORTED - This is the same as SAVE_REGS, but if the
@@ -418,7 +418,7 @@ void ftrace_modify_all_code(int command);
 #endif
 
 #ifndef FTRACE_REGS_ADDR
-#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 # define FTRACE_REGS_ADDR ((unsigned long)ftrace_regs_caller)
 #else
 # define FTRACE_REGS_ADDR FTRACE_ADDR
@@ -480,7 +480,7 @@ extern int ftrace_make_nop(struct module *mod,
  */
 extern int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr);
 
-#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 /**
  * ftrace_modify_call - convert from one addr to another (no nop)
  * @rec: the mcount call site record
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 5d89335..cdc9d28 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -39,6 +39,9 @@ config HAVE_DYNAMIC_FTRACE
 	help
 	  See Documentation/trace/ftrace-design.txt
 
+config HAVE_DYNAMIC_FTRACE_WITH_REGS
+	bool
+
 config HAVE_FTRACE_MCOUNT_RECORD
 	bool
 	help
@@ -434,6 +437,11 @@ config DYNAMIC_FTRACE
 	  were made. If so, it runs stop_machine (stops all CPUS)
 	  and modifies the code to jump over the call to ftrace.
 
+config DYNAMIC_FTRACE_WITH_REGS
+	def_bool y
+	depends on DYNAMIC_FTRACE
+	depends on HAVE_DYNAMIC_FTRACE_WITH_REGS
+
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
 	depends on FUNCTION_TRACER
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 41473b4..6e34dc1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -337,7 +337,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if ((ops->flags & FL_GLOBAL_CONTROL_MASK) == FL_GLOBAL_CONTROL_MASK)
 		return -EINVAL;
 
-#ifndef ARCH_SUPPORTS_FTRACE_SAVE_REGS
+#ifndef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 	/*
 	 * If the ftrace_ops specifies SAVE_REGS, then it only can be used
 	 * if the arch supports it, or SAVE_REGS_IF_SUPPORTED is also set.
@@ -4143,8 +4143,8 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
  * Archs are to support both the regs and ftrace_ops at the same time.
  * If they support ftrace_ops, it is assumed they support regs.
  * If call backs want to use regs, they must either check for regs
- * being NULL, or ARCH_SUPPORTS_FTRACE_SAVE_REGS.
- * Note, ARCH_SUPPORT_SAVE_REGS expects a full regs to be saved.
+ * being NULL, or CONFIG_DYNAMIC_FTRACE_WITH_REGS.
+ * Note, CONFIG_DYNAMIC_FTRACE_WITH_REGS expects a full regs to be saved.
  * An architecture can pass partial regs with ftrace_ops and still
  * set the ARCH_SUPPORT_FTARCE_OPS.
  */
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 4762316..6c62d58 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -568,7 +568,7 @@ trace_selftest_function_regs(void)
 	int ret;
 	int supported = 0;
 
-#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 	supported = 1;
 #endif
 
-- 
1.7.10.4



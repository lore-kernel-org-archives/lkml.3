Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3AXTo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:44:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33854 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3AXTos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:44:48 -0500
Date: Thu, 24 Jan 2013 11:44:11 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-06aeaaeabf69da4a3e86df532425640f51b01cef@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120928081516.3560.72534.stgit@ltc138.sdl.hitachi.co.jp>
References: <20120928081516.3560.72534.stgit@ltc138.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace:
  Move ARCH_SUPPORTS_FTRACE_SAVE_REGS in Kconfig
Git-Commit-ID: 06aeaaeabf69da4a3e86df532425640f51b01cef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:44:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06aeaaeabf69da4a3e86df532425640f51b01cef
Gitweb:     http://git.kernel.org/tip/06aeaaeabf69da4a3e86df532425640f51b01cef
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 28 Sep 2012 17:15:17 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 21 Jan 2013 13:22:35 -0500

ftrace: Move ARCH_SUPPORTS_FTRACE_SAVE_REGS in Kconfig

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
 arch/x86/Kconfig              | 1 +
 arch/x86/include/asm/ftrace.h | 1 -
 include/linux/ftrace.h        | 6 +++---
 kernel/trace/Kconfig          | 8 ++++++++
 kernel/trace/ftrace.c         | 6 +++---
 kernel/trace/trace_selftest.c | 2 +-
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
 

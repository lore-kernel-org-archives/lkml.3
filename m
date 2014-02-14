Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaBNUcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:32:52 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:34014
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbaBNUTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:23 -0500
Message-Id: <20140214201904.652936915@linux.com>
Date: Fri, 14 Feb 2014 14:18:48 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 07/48] tracing: Replace __get_cpu_var uses with this_cpu_ptr
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_trace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace uses of &__get_cpu_var for address calculation with this_cpu_ptr.

CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/kprobes.h
===================================================================
--- linux.orig/include/linux/kprobes.h	2014-01-30 14:39:56.047604482 -0600
+++ linux/include/linux/kprobes.h	2014-01-30 14:39:56.037604677 -0600
@@ -355,7 +355,7 @@
 
 static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
 {
-	return (&__get_cpu_var(kprobe_ctlblk));
+	return this_cpu_ptr(&kprobe_ctlblk);
 }
 
 int register_kprobe(struct kprobe *p);
Index: linux/kernel/trace/ftrace.c
===================================================================
--- linux.orig/kernel/trace/ftrace.c	2014-01-30 14:39:56.047604482 -0600
+++ linux/kernel/trace/ftrace.c	2014-01-30 14:39:56.037604677 -0600
@@ -898,7 +898,7 @@
 
 	local_irq_save(flags);
 
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
@@ -929,7 +929,7 @@
 	unsigned long flags;
 
 	local_irq_save(flags);
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
Index: linux/kernel/trace/trace.c
===================================================================
--- linux.orig/kernel/trace/trace.c	2014-01-30 14:39:56.047604482 -0600
+++ linux/kernel/trace/trace.c	2014-01-30 14:39:56.037604677 -0600
@@ -1718,7 +1718,7 @@
 	 */
 	barrier();
 	if (use_stack == 1) {
-		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
+		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
 		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
 
 		if (regs)


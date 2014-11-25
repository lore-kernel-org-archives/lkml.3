Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaKYMQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:16:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:12389 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752918AbaKYMO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:14:28 -0500
Message-Id: <20141125121426.255215256@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 25 Nov 2014 07:13:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 1/5] tracing/trivial: Fix typos and make an int into a bool
References: <20141125121355.225538266@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracing-trivial-Fix-typos-and-make-an-int-into-a-boo.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Fix up a few typos in comments and convert an int into a bool in
update_traceon_count().

Link: http://lkml.kernel.org/r/546DD445.5080108@hitachi.com

Suggested-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c          | 2 +-
 kernel/trace/trace_functions.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fa0f36bb32e9..588af40d33db 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1119,7 +1119,7 @@ static struct ftrace_ops global_ops = {
 
 /*
  * This is used by __kernel_text_address() to return true if the
- * the address is on a dynamically allocated trampoline that would
+ * address is on a dynamically allocated trampoline that would
  * not return true for either core_kernel_text() or
  * is_module_text_address().
  */
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 973db52eb070..fcd41a166405 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -261,14 +261,14 @@ static struct tracer function_trace __tracer_data =
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-static void update_traceon_count(void **data, int on)
+static void update_traceon_count(void **data, bool on)
 {
 	long *count = (long *)data;
 	long old_count = *count;
 
 	/*
 	 * Tracing gets disabled (or enabled) once per count.
-	 * This function can be called at the same time on mulitple CPUs.
+	 * This function can be called at the same time on multiple CPUs.
 	 * It is fine if both disable (or enable) tracing, as disabling
 	 * (or enabling) the second time doesn't do anything as the
 	 * state of the tracer is already disabled (or enabled).
@@ -288,7 +288,7 @@ static void update_traceon_count(void **data, int on)
 	 * the new state is visible before changing the counter by
 	 * one minus the old counter. This guarantees that another CPU
 	 * executing this code will see the new state before seeing
-	 * the new counter value, and would not do anthing if the new
+	 * the new counter value, and would not do anything if the new
 	 * counter is seen.
 	 *
 	 * Note, there is no synchronization between this and a user
-- 
2.1.1



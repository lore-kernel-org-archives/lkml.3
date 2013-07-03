Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3GCLhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:37:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26138 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3GCLhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:37:22 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ntqIgWCPEJwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fIx3y75S9hgA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=WxQc6l0i2WvwwMm62h0A:9 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703113719.485425469@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 07:36:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 7/8] tracing: Remove ftrace() function
References: <20130703113635.696310819@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Remove-ftrace-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

The only caller of function ftrace(...) was removed a long time ago,
so remove the function body as well.

Link: http://lkml.kernel.org/r/1365564393-10972-10-git-send-email-jovi.zhangwei@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    9 ---------
 kernel/trace/trace.h |    5 -----
 2 files changed, 14 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 48aceb8..f6fed9e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1637,15 +1637,6 @@ trace_function(struct trace_array *tr,
 		__buffer_unlock_commit(buffer, event);
 }
 
-void
-ftrace(struct trace_array *tr, struct trace_array_cpu *data,
-       unsigned long ip, unsigned long parent_ip, unsigned long flags,
-       int pc)
-{
-	if (likely(!atomic_read(&data->disabled)))
-		trace_function(tr, ip, parent_ip, flags, pc);
-}
-
 #ifdef CONFIG_STACKTRACE
 
 #define FTRACE_STACK_MAX_ENTRIES (PAGE_SIZE / sizeof(unsigned long))
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 1cbba04..a4ed382 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -559,11 +559,6 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu);
 
 void poll_wait_pipe(struct trace_iterator *iter);
 
-void ftrace(struct trace_array *tr,
-			    struct trace_array_cpu *data,
-			    unsigned long ip,
-			    unsigned long parent_ip,
-			    unsigned long flags, int pc);
 void tracing_sched_switch_trace(struct trace_array *tr,
 				struct task_struct *prev,
 				struct task_struct *next,
-- 
1.7.10.4



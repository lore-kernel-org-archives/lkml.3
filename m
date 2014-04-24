Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbaDXQI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:08:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:17474 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758611AbaDXQDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:03:25 -0400
Message-Id: <20140424160321.015353094@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:02:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>
Subject: [for-next][PATCH 8/8] tracing: Add static to local functions
References: <20140424160232.271454710@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0008-tracing-Add-static-to-local-functions.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

This patch adds static to the following functions:
-cycle_t buffer_ftrace_now
-void free_snapshot
-int trace_selftest_startup_dynamic_tracing

Link: http://lkml.kernel.org/p/20140417214442.d7abc7c0b0e4b90e7fedecc9@skynet.be

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c          | 4 ++--
 kernel/trace/trace_selftest.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bb5147a..cb41e98 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -275,7 +275,7 @@ int call_filter_check_discard(struct ftrace_event_call *call, void *rec,
 }
 EXPORT_SYMBOL_GPL(call_filter_check_discard);
 
-cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
+static cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
 {
 	u64 ts;
 
@@ -599,7 +599,7 @@ static int alloc_snapshot(struct trace_array *tr)
 	return 0;
 }
 
-void free_snapshot(struct trace_array *tr)
+static void free_snapshot(struct trace_array *tr)
 {
 	/*
 	 * We don't free the ring buffer. instead, resize it because
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 1c95cd7..5ef6049 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -320,9 +320,9 @@ static int trace_selftest_ops(struct trace_array *tr, int cnt)
 }
 
 /* Test dynamic code modification and ftrace filters */
-int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
-					   struct trace_array *tr,
-					   int (*func)(void))
+static int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
+						  struct trace_array *tr,
+						  int (*func)(void))
 {
 	int save_ftrace_enabled = ftrace_enabled;
 	unsigned long count;
-- 
1.8.5.3



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaDQTnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:43:07 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:41374 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbaDQTmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:42:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0UAOAtUFNbsmyI/2dsb2JhbABZgwarHJlWAgKBJhd0gmYcIxhqGCQTh2gDFQHEaw2HAoxJghmEPwEDlwCBbQGMfYVQgzM7
Date: Thu, 17 Apr 2014 21:44:42 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/1] kernel/trace: add static to local functions
Message-Id: <20140417214442.d7abc7c0b0e4b90e7fedecc9@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds static to the following functions:
-cycle_t buffer_ftrace_now
-void free_snapshot
-int trace_selftest_startup_dynamic_tracing

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/trace/trace.c          | 4 ++--
 kernel/trace/trace_selftest.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 737b0ef..6acaeb7 100644
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
index e98fca6..bfecd63 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -315,9 +315,9 @@ static int trace_selftest_ops(int cnt)
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
1.8.4.5


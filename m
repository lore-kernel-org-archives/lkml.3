Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaKDNtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:49:21 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:13127 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754066AbaKDNtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:49:18 -0500
Message-Id: <20141104134915.853403299@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 08:48:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 1/4] tracing: Kill tracing_{start,stop}_sched_switch_record() and
 tracing_sched_switch_assign_trace()
References: <20141104134847.978505265@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracing-Kill-tracing_-start-stop-_sched_switch_recor.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

tracing_{start,stop}_sched_switch_record() have no callers since
87d80de2800d "tracing: Remove obsolete sched_switch tracer".

The last caller of tracing_sched_switch_assign_trace() was removed
by 30dbb20e68e6 "tracing: Remove boot tracer".

Link: http://lkml.kernel.org/p/20140723193501.GA30214@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h              |  3 ---
 kernel/trace/trace_sched_switch.c | 48 ---------------------------------------
 2 files changed, 51 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 385391fb1d3b..a3a82d5f25dc 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -597,9 +597,6 @@ void set_graph_array(struct trace_array *tr);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
-void tracing_sched_switch_assign_trace(struct trace_array *tr);
-void tracing_stop_sched_switch_record(void);
-void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 int is_tracing_stopped(void);
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 3f34dc9b40f3..3b60301c59d2 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -197,51 +197,3 @@ void tracing_stop_cmdline_record(void)
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
-- 
2.1.1



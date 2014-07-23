Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbaGWTgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:36:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbaGWTgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:36:40 -0400
Date: Wed, 23 Jul 2014 21:35:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ftrace: Kill
	tracing_{start,stop}_sched_switch_record() and
	tracing_sched_switch_assign_trace()
Message-ID: <20140723193501.GA30214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723193444.GA30194@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracing_{start,stop}_sched_switch_record() have no callers since
87d80de2800d "tracing: Remove obsolete sched_switch tracer".

The last caller of tracing_sched_switch_assign_trace() was removed
by 30dbb20e68e6 "tracing: Remove boot tracer".

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.h              |    3 --
 kernel/trace/trace_sched_switch.c |   48 -------------------------------------
 2 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9258f5a..df2b33b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -595,9 +595,6 @@ void set_graph_array(struct trace_array *tr);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
-void tracing_sched_switch_assign_trace(struct trace_array *tr);
-void tracing_stop_sched_switch_record(void);
-void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 int is_tracing_stopped(void);
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 3f34dc9..3b60301 100644
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
1.5.5.1


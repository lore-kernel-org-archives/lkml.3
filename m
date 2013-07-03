Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3GCLio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:38:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26138 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3GCLhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:37:21 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5LtoXZIGUdgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=tSMb0sLZ_DwA:10 a=QyXUC8HyAAAA:8 a=YYnUkKA85bs_rLJdTfUA:9 a=jeBq3FmKZ4MA:10 a=dGJ0OcVc7YAA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703113719.150641409@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 07:36:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [for-next][PATCH 5/8] tracing: Make tracer_tracing_{off,on,is_on}() static
References: <20130703113635.696310819@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Make-tracer_tracing_-off-on-is_on-static.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

I have patches that will use tracer_tracing_on/off/is_on() in other
files, but as they are not ready to be merged yet, and Fengguang Wu's
sparse scripts pointed out that these functions were not declared
anywhere, I'll make them static for now.

When these functions are required to be used elsewhere, I'll remove
the static then.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6d9bd9b..48aceb8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -387,7 +387,7 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
 	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
 
-void tracer_tracing_on(struct trace_array *tr)
+static void tracer_tracing_on(struct trace_array *tr)
 {
 	if (tr->trace_buffer.buffer)
 		ring_buffer_record_on(tr->trace_buffer.buffer);
@@ -606,7 +606,7 @@ void tracing_snapshot_alloc(void)
 EXPORT_SYMBOL_GPL(tracing_snapshot_alloc);
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
-void tracer_tracing_off(struct trace_array *tr)
+static void tracer_tracing_off(struct trace_array *tr)
 {
 	if (tr->trace_buffer.buffer)
 		ring_buffer_record_off(tr->trace_buffer.buffer);
@@ -649,7 +649,7 @@ void disable_trace_on_warning(void)
  *
  * Shows real state of the ring buffer if it is enabled or not.
  */
-int tracer_tracing_is_on(struct trace_array *tr)
+static int tracer_tracing_is_on(struct trace_array *tr)
 {
 	if (tr->trace_buffer.buffer)
 		return ring_buffer_record_is_on(tr->trace_buffer.buffer);
-- 
1.7.10.4



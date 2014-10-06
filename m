Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaJFVgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:36:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:24568 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751290AbaJFVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:36:33 -0400
Message-Id: <20141006213631.841903258@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 06 Oct 2014 17:35:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 11/11] ftrace: Only disable ftrace_enabled to test buffer in selftest
References: <20141006213544.344821619@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0011-ftrace-Only-disable-ftrace_enabled-to-test-buffer-in.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The ftrace_enabled variable is set to zero in the self tests to keep
delayed functions from being traced and messing with the checks. This
only needs to be done when the checks are being performed, otherwise,
if ftrace_enabled is off when calls back to the utility that is being
tested, it can cause errors to happen and the tests can fail with
false positives.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_selftest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 5ef60499dc8e..61a6acd6025d 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -382,6 +382,8 @@ static int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 
 	/* check the trace buffer */
 	ret = trace_test_buffer(&tr->trace_buffer, &count);
+
+	ftrace_enabled = 1;
 	tracing_start();
 
 	/* we should only have one item */
@@ -679,6 +681,8 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 
 	/* check the trace buffer */
 	ret = trace_test_buffer(&tr->trace_buffer, &count);
+
+	ftrace_enabled = 1;
 	trace->reset(tr);
 	tracing_start();
 
-- 
2.0.1



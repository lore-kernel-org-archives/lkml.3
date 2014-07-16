Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaGPVFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:05:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:59942 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaGPVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:26 -0400
Message-Id: <20140716205057.643948282@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch V2 64/64] ftrace: Provide trace clocks monotonic
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=ftrace-use-clock-mono-raw.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the new NMI safe accessor to clock monotonic to the tracer.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/trace/trace.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: tip/kernel/trace/trace.c
===================================================================
--- tip.orig/kernel/trace/trace.c
+++ tip/kernel/trace/trace.c
@@ -806,11 +806,12 @@ static struct {
 	const char *name;
 	int in_ns;		/* is this clock in nanoseconds? */
 } trace_clocks[] = {
-	{ trace_clock_local,	"local",	1 },
-	{ trace_clock_global,	"global",	1 },
-	{ trace_clock_counter,	"counter",	0 },
-	{ trace_clock_jiffies,	"uptime",	1 },
-	{ trace_clock,		"perf",		1 },
+	{ trace_clock_local,		"local",	1 },
+	{ trace_clock_global,		"global",	1 },
+	{ trace_clock_counter,		"counter",	0 },
+	{ trace_clock_jiffies,		"uptime",	1 },
+	{ trace_clock,			"perf",		1 },
+	{ ktime_get_mono_fast_ns,	"mono",		1 },
 	ARCH_TRACE_CLOCKS
 };
 



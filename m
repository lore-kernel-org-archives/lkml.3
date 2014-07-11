Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaGKNqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:46:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:56325 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbaGKNpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:45:23 -0400
Message-Id: <20140711133709.924108628@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:45:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch 55/55] ftrace: Provide trace clocks mono and mono_raw
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=ftrace-use-clock-mono-raw.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the new NMI safe accessors to clock monotonic and monotonic raw
to the tracer.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/trace/trace.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: tip/kernel/trace/trace.c
===================================================================
--- tip.orig/kernel/trace/trace.c
+++ tip/kernel/trace/trace.c
@@ -806,11 +806,13 @@ static struct {
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
+	{ ktime_get_raw_ns,		"mono_raw",	1 },
 	ARCH_TRACE_CLOCKS
 };
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311Ab3CHDHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9297 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab3CHDGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:55 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=949vSP0-C2IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=s7E7xITbN5UA:10 a=20KFwNOVAAAA:8 a=Li5wncGz6YGitOIJZLMA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030652.620215061@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 05/17] tracing: Enable snapshot when any latency tracer is enabled
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Enable-snapshot-when-any-latency-tracer-is-e.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

The snapshot utility is extremely useful, and does not add any more
overhead in memory when another latency tracer is enabled. They use
the snapshot underneath. There's no reason to hide the snapshot file
when a latency tracer has been enabled in the kernel.

If any of the latency tracers (irq, preempt or wakeup) is enabled
then also select the snapshot facility.

Note, snapshot can be enabled without the latency tracers enabled.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b516a8e..590a27f 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -191,6 +191,7 @@ config IRQSOFF_TRACER
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
 	select RING_BUFFER_ALLOW_SWAP
+	select TRACER_SNAPSHOT
 	help
 	  This option measures the time spent in irqs-off critical
 	  sections, with microsecond accuracy.
@@ -213,6 +214,7 @@ config PREEMPT_TRACER
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
 	select RING_BUFFER_ALLOW_SWAP
+	select TRACER_SNAPSHOT
 	help
 	  This option measures the time spent in preemption-off critical
 	  sections, with microsecond accuracy.
@@ -232,6 +234,7 @@ config SCHED_TRACER
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
 	select TRACER_MAX_TRACE
+	select TRACER_SNAPSHOT
 	help
 	  This tracer tracks the latency of the highest priority task
 	  to be scheduled in, starting from the point it has woken up.
-- 
1.7.10.4



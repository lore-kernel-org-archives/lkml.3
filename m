Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaBNUas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:30:48 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:48303 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081AbaBNUTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:43 -0500
Message-Id: <20140214201905.601876981@linux.com>
Date: Fri, 14 Feb 2014 14:18:57 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 16/48] metag: Replace __get_cpu_var uses for address calculation
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_metag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace __get_cpu_var uses for address calculation with this_cpu_ptr().

Acked-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/metag/kernel/perf/perf_event.c
===================================================================
--- linux.orig/arch/metag/kernel/perf/perf_event.c	2013-12-02 16:07:50.134624099 -0600
+++ linux/arch/metag/kernel/perf/perf_event.c	2013-12-02 16:07:50.134624099 -0600
@@ -258,7 +258,7 @@ int metag_pmu_event_set_period(struct pe
 
 static void metag_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -306,7 +306,7 @@ static void metag_pmu_stop(struct perf_e
 
 static int metag_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = 0, ret = 0;
 
@@ -348,7 +348,7 @@ out:
 
 static void metag_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -607,7 +607,7 @@ static int _hw_perf_event_init(struct pe
 
 static void metag_pmu_enable_counter(struct hw_perf_event *event, int idx)
 {
-	struct cpu_hw_events *events = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *events = this_cpu_ptr(&cpu_hw_events);
 	unsigned int config = event->config;
 	unsigned int tmp = config & 0xf0;
 	unsigned long flags;
@@ -680,7 +680,7 @@ unlock:
 
 static void metag_pmu_disable_counter(struct hw_perf_event *event, int idx)
 {
-	struct cpu_hw_events *events = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *events = this_cpu_ptr(&cpu_hw_events);
 	unsigned int tmp = 0;
 	unsigned long flags;
 
@@ -728,7 +728,7 @@ out:
 
 static void metag_pmu_write_counter(int idx, u32 val)
 {
-	struct cpu_hw_events *events = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *events = this_cpu_ptr(&cpu_hw_events);
 	u32 tmp = 0;
 	unsigned long flags;
 
@@ -761,7 +761,7 @@ static int metag_pmu_event_map(int idx)
 static irqreturn_t metag_pmu_counter_overflow(int irq, void *dev)
 {
 	int idx = (int)dev;
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event = cpuhw->events[idx];
 	struct hw_perf_event *hwc = &event->hw;
 	struct pt_regs *regs = get_irq_regs();


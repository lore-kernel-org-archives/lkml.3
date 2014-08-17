Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaHQRbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:31:13 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:32964
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbaHQRbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:31:10 -0400
Message-Id: <20140817173035.097075773@linux.com>
Date: Sun, 17 Aug 2014 12:30:37 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 14/35] [PATCH 14/36] metag: Replace __get_cpu_var uses for address
 calculation
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0014-metag-Replace-__get_cpu_var-uses-for-address-calcula.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace __get_cpu_var uses for address calculation with this_cpu_ptr().

Acked-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
---
 arch/metag/kernel/perf/perf_event.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux/arch/metag/kernel/perf/perf_event.c
===================================================================
--- linux.orig/arch/metag/kernel/perf/perf_event.c
+++ linux/arch/metag/kernel/perf/perf_event.c
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
 
@@ -597,7 +597,7 @@ static int _hw_perf_event_init(struct pe
 
 static void metag_pmu_enable_counter(struct hw_perf_event *event, int idx)
 {
-	struct cpu_hw_events *events = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *events = this_cpu_ptr(&cpu_hw_events);
 	unsigned int config = event->config;
 	unsigned int tmp = config & 0xf0;
 	unsigned long flags;
@@ -670,7 +670,7 @@ unlock:
 
 static void metag_pmu_disable_counter(struct hw_perf_event *event, int idx)
 {
-	struct cpu_hw_events *events = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *events = this_cpu_ptr(&cpu_hw_events);
 	unsigned int tmp = 0;
 	unsigned long flags;
 
@@ -718,7 +718,7 @@ out:
 
 static void metag_pmu_write_counter(int idx, u32 val)
 {
-	struct cpu_hw_events *events = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *events = this_cpu_ptr(&cpu_hw_events);
 	u32 tmp = 0;
 	unsigned long flags;
 
@@ -751,7 +751,7 @@ static int metag_pmu_event_map(int idx)
 static irqreturn_t metag_pmu_counter_overflow(int irq, void *dev)
 {
 	int idx = (int)dev;
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event = cpuhw->events[idx];
 	struct hw_perf_event *hwc = &event->hw;
 	struct pt_regs *regs = get_irq_regs();


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaHQReK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:34:10 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:53802 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbaHQRbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:31:44 -0400
Message-Id: <20140817173037.291575591@linux.com>
Date: Sun, 17 Aug 2014 12:30:51 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 28/35] [PATCH 28/36] tile: Use this_cpu_ptr() for hardware counters
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0028-tile-Use-this_cpu_ptr-for-hardware-counters.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 arch/tile/kernel/perf_event.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/arch/tile/kernel/perf_event.c
===================================================================
--- linux.orig/arch/tile/kernel/perf_event.c
+++ linux/arch/tile/kernel/perf_event.c
@@ -590,7 +590,7 @@ static int tile_event_set_period(struct
  */
 static void tile_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -616,7 +616,7 @@ static void tile_pmu_stop(struct perf_ev
  */
 static void tile_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx = event->hw.idx;
 
 	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
@@ -650,7 +650,7 @@ static void tile_pmu_start(struct perf_e
  */
 static int tile_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc;
 	unsigned long mask;
 	int b, max_cnt;
@@ -706,7 +706,7 @@ static int tile_pmu_add(struct perf_even
  */
 static void tile_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int i;
 
 	/*
@@ -880,14 +880,14 @@ static struct pmu tilera_pmu = {
 int tile_pmu_handle_irq(struct pt_regs *regs, int fault)
 {
 	struct perf_sample_data data;
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	u64 val;
 	unsigned long status;
 	int bit;
 
-	__get_cpu_var(perf_irqs)++;
+	__this_cpu_inc(perf_irqs);
 
 	if (!atomic_read(&tile_active_events))
 		return 0;


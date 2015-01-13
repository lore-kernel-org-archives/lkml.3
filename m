Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbbAMS2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:28:21 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56252 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbbAMS2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:28:20 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: events: core: Remove some unused functions
Date: Tue, 13 Jan 2015 19:31:26 +0100
Message-Id: <1421173886-4545-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
perf_cpu_hrtimer_cancel() perf_cgroup_event_cgrp_time()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 kernel/events/core.c |   33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2b02c9f..6287095 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -695,11 +695,6 @@ static inline int is_cgroup_event(struct perf_event *event)
 	return 0;
 }
 
-static inline u64 perf_cgroup_event_cgrp_time(struct perf_event *event)
-{
-	return 0;
-}
-
 static inline void update_cgrp_time_from_event(struct perf_event *event)
 {
 }
@@ -789,34 +784,6 @@ static enum hrtimer_restart perf_cpu_hrtimer_handler(struct hrtimer *hr)
 	return ret;
 }
 
-/* CPU is going down */
-void perf_cpu_hrtimer_cancel(int cpu)
-{
-	struct perf_cpu_context *cpuctx;
-	struct pmu *pmu;
-	unsigned long flags;
-
-	if (WARN_ON(cpu != smp_processor_id()))
-		return;
-
-	local_irq_save(flags);
-
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-
-		if (pmu->task_ctx_nr == perf_sw_context)
-			continue;
-
-		hrtimer_cancel(&cpuctx->hrtimer);
-	}
-
-	rcu_read_unlock();
-
-	local_irq_restore(flags);
-}
-
 static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
 {
 	struct hrtimer *hr = &cpuctx->hrtimer;
-- 
1.7.10.4


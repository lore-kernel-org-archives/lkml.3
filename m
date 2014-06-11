Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaFKEI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:08:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49478 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaFKEIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:08:55 -0400
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH 1/1] perf/amd: NULL return of kzalloc_node should be handled
Date: Wed, 11 Jun 2014 12:08:21 +0800
Message-Id: <1402459701-20477-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 arch/x86/kernel/cpu/perf_event_amd_uncore.c |   32 +++++++++++++++------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
index 3bbdf4c..f60a50e 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -300,24 +300,28 @@ static void amd_uncore_cpu_up_prepare(unsigned int cpu)
 
 	if (amd_uncore_nb) {
 		uncore = amd_uncore_alloc(cpu);
-		uncore->cpu = cpu;
-		uncore->num_counters = NUM_COUNTERS_NB;
-		uncore->rdpmc_base = RDPMC_BASE_NB;
-		uncore->msr_base = MSR_F15H_NB_PERF_CTL;
-		uncore->active_mask = &amd_nb_active_mask;
-		uncore->pmu = &amd_nb_pmu;
-		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore;
+		if (uncore) {
+			uncore->cpu = cpu;
+			uncore->num_counters = NUM_COUNTERS_NB;
+			uncore->rdpmc_base = RDPMC_BASE_NB;
+			uncore->msr_base = MSR_F15H_NB_PERF_CTL;
+			uncore->active_mask = &amd_nb_active_mask;
+			uncore->pmu = &amd_nb_pmu;
+			*per_cpu_ptr(amd_uncore_nb, cpu) = uncore;
+		}
 	}
 
 	if (amd_uncore_l2) {
 		uncore = amd_uncore_alloc(cpu);
-		uncore->cpu = cpu;
-		uncore->num_counters = NUM_COUNTERS_L2;
-		uncore->rdpmc_base = RDPMC_BASE_L2;
-		uncore->msr_base = MSR_F16H_L2I_PERF_CTL;
-		uncore->active_mask = &amd_l2_active_mask;
-		uncore->pmu = &amd_l2_pmu;
-		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore;
+		if (uncore) {
+			uncore->cpu = cpu;
+			uncore->num_counters = NUM_COUNTERS_L2;
+			uncore->rdpmc_base = RDPMC_BASE_L2;
+			uncore->msr_base = MSR_F16H_L2I_PERF_CTL;
+			uncore->active_mask = &amd_l2_active_mask;
+			uncore->pmu = &amd_l2_pmu;
+			*per_cpu_ptr(amd_uncore_l2, cpu) = uncore;
+		}
 	}
 }
 
-- 
1.7.10.4


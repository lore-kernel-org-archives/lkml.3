Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaDRAD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:03:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:55229 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaDRAD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:03:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,882,1389772800"; 
   d="scan'208";a="420549455"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] x86, perf: Update Haswell PEBS event table
Date: Thu, 17 Apr 2014 17:03:44 -0700
Message-Id: <1397779424-10248-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- We were allowing some sub events in c4 that are not in the event list.
Tighten the check slightly.
- We were missing some valid subevents in d1-d3. Allow all subevents.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 7e9546a..07feaa0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -641,7 +641,11 @@ struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PST_HSW_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
 	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x1c4, 0xf),	/* BR_INST_RETIRED.CONDITIONAL */
+	INTEL_UEVENT_CONSTRAINT(0x2c4, 0xf),	/* BR_INST_RETIRED.NEAR_CALL */
+	INTEL_UEVENT_CONSTRAINT(0x4c4, 0xf),	/* BR_INST_RETIRED.ALL_BRANCHES */
+	INTEL_UEVENT_CONSTRAINT(0x8c4, 0xf),	/* BR_INST_RETIRED.NEAR_RETURN */
+	INTEL_UEVENT_CONSTRAINT(0x20c4, 0xf),	/* BR_INST_RETIRED.NEAR_TAKEN */
 	INTEL_UEVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
 	INTEL_UEVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
 	INTEL_UEVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.NEAR_TAKEN */
@@ -656,17 +660,10 @@ struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
 	INTEL_PST_HSW_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
-	INTEL_UEVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
-	INTEL_UEVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
-	/* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
-	INTEL_UEVENT_CONSTRAINT(0x40d1, 0xf),
-	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
-	INTEL_UEVENT_CONSTRAINT(0x01d2, 0xf),
-	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
-	INTEL_UEVENT_CONSTRAINT(0x02d2, 0xf),
-	/* MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM */
-	INTEL_UEVENT_CONSTRAINT(0x01d3, 0xf),
+	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),	/* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),	/* MEM_LOAD_UOPS_L3_HIT_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd3, 0xf),	/* MEM_LOAD_UOPS_L3_MISS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd3, 0xf),	/* MEM_LOAD_UOPS_L3_MISS_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x04c8, 0xf), /* HLE_RETIRED.Abort */
 	INTEL_UEVENT_CONSTRAINT(0x04c9, 0xf), /* RTM_RETIRED.Abort */
 
-- 
1.8.5.3


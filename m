Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaDRVr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:47:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:40999 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbaDRVrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:47:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,886,1389772800"; 
   d="scan'208";a="523092491"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] x86, perf: Update Haswell PEBS event table
Date: Fri, 18 Apr 2014 14:31:14 -0700
Message-Id: <1397856674-11549-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397856674-11549-1-git-send-email-andi@firstfloor.org>
References: <1397856674-11549-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- We were allowing some sub events in c4 (BR_INST_RETIRED.*)
that are not in the event list.  Tighten the check slightly.

- We were missing some valid subevents in d1-d2 (MEM_LOAD_UOPS_RETIRED.*,
MEM_LOAD_UOPS_RETIRED_L3_HIT_RETIRED.*) Allow all subevents.

The full event list supported by this table now:

INST_RETIRED.PREC_DIST cpu/event=0xC0,umask=0x01/pp
UOPS_RETIRED.ALL cpu/event=0xC2,umask=0x01/pp
UOPS_RETIRED.RETIRE_SLOTS cpu/event=0xC2,umask=0x02/pp
BR_INST_RETIRED.CONDITIONAL cpu/event=0xC4,umask=0x01/pp
BR_INST_RETIRED.NEAR_CALL cpu/event=0xC4,umask=0x02/pp
BR_INST_RETIRED.NEAR_RETURN cpu/event=0xC4,umask=0x08/pp
BR_INST_RETIRED.NEAR_TAKEN cpu/event=0xC4,umask=0x20/pp
BR_INST_RETIRED.ALL_BRANCHES_PEBS cpu/event=0xC4,umask=0x04/pp
BR_INST_RETIRED.NEAR_CALL_R3 cpu/event=0xC4,umask=0x02/pp
BR_MISP_RETIRED.CONDITIONAL cpu/event=0xC5,umask=0x01/pp
BR_MISP_RETIRED.ALL_BRANCHES_PEBS cpu/event=0xC5,umask=0x04/pp
HLE_RETIRED.ABORTED cpu/event=0xc8,umask=0x04/pp
RTM_RETIRED.ABORTED cpu/event=0xc9,umask=0x04/pp
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_4 cpu/event=0xCD,umask=0x01,ldlat=0x4/pp
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_8 cpu/event=0xCD,umask=0x01,ldlat=0x8/pp
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_16 cpu/event=0xCD,umask=0x01,ldlat=0x10/pp
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_32 cpu/event=0xCD,umask=0x01,ldlat=0x20/pp
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_64 cpu/event=0xCD,umask=0x01,ldlat=0x40/pp
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_128 cpu/event=0xCD,umask=0x01,ldlat=0x80/pp
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_256 cpu/event=0xCD,umask=0x01,ldlat=0x100/pp
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_512 cpu/event=0xCD,umask=0x01,ldlat=0x200/pp
MEM_UOPS_RETIRED.STLB_MISS_LOADS cpu/event=0xD0,umask=0x11/pp
MEM_UOPS_RETIRED.STLB_MISS_STORES cpu/event=0xD0,umask=0x12/pp
MEM_UOPS_RETIRED.LOCK_LOADS cpu/event=0xD0,umask=0x21/pp
MEM_UOPS_RETIRED.SPLIT_LOADS cpu/event=0xD0,umask=0x41/pp
MEM_UOPS_RETIRED.SPLIT_STORES cpu/event=0xD0,umask=0x42/pp
MEM_UOPS_RETIRED.ALL_LOADS cpu/event=0xD0,umask=0x81/pp
MEM_UOPS_RETIRED.ALL_STORES cpu/event=0xD0,umask=0x82/pp
MEM_LOAD_UOPS_RETIRED.L1_HIT cpu/event=0xD1,umask=0x01/pp
MEM_LOAD_UOPS_RETIRED.L2_HIT cpu/event=0xD1,umask=0x02/pp
MEM_LOAD_UOPS_RETIRED.L3_HIT cpu/event=0xD1,umask=0x04/pp
MEM_LOAD_UOPS_RETIRED.L1_MISS cpu/event=0xD1,umask=0x08/pp
MEM_LOAD_UOPS_RETIRED.L2_MISS cpu/event=0xD1,umask=0x10/pp
MEM_LOAD_UOPS_RETIRED.L3_MISS cpu/event=0xD1,umask=0x20/pp
MEM_LOAD_UOPS_RETIRED.HIT_LFB cpu/event=0xD1,umask=0x40/pp
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_MISS cpu/event=0xD2,umask=0x01/pp
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HIT cpu/event=0xD2,umask=0x02/pp
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HITM cpu/event=0xD2,umask=0x04/pp
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_NONE cpu/event=0xD2,umask=0x08/pp

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
1.9.0


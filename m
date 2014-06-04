Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaFDVoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:44:24 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51966 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaFDVoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:44:22 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com, maria.n.dimakopoulou@gmail.com
Subject: [PATCH 7/9] perf/x86: enforce HT bug workaround with PEBS for SNB/IVB/HSW
Date: Wed,  4 Jun 2014 23:34:16 +0200
Message-Id: <1401917658-26065-8-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401917658-26065-1-git-send-email-eranian@google.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

This patch modifies the PEBS constraint tables for SNB/IVB/HSW
such that corrupting events supporting PEBS activate the HT
workaround.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   40 ++++++++++++++---------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 980970c..b4c6ca5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -630,10 +630,10 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
-	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
 	EVENT_CONSTRAINT_END
 };
@@ -646,10 +646,10 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
         INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
         INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
-        INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+        INTEL_EXCLEVT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
+        INTEL_EXCLEVT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+        INTEL_EXCLEVT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+        INTEL_EXCLEVT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
         EVENT_CONSTRAINT_END
 };
 
@@ -665,24 +665,24 @@ struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	/* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
 	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf),
 	/* MEM_UOPS_RETIRED.STLB_MISS_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf),
-	INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
+	INTEL_EXCLUEVT_CONSTRAINT(0x12d0, 0xf),
+	INTEL_EXCLUEVT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
+	INTEL_EXCLUEVT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
 	/* MEM_UOPS_RETIRED.SPLIT_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf),
-	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
+	INTEL_EXCLUEVT_CONSTRAINT(0x42d0, 0xf),
+	INTEL_EXCLUEVT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
 	INTEL_PST_HSW_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
-	INTEL_UEVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
-	INTEL_UEVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
+	INTEL_EXCLUEVT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
+	INTEL_EXCLUEVT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
+	INTEL_EXCLUEVT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
 	/* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
-	INTEL_UEVENT_CONSTRAINT(0x40d1, 0xf),
+	INTEL_EXCLUEVT_CONSTRAINT(0x40d1, 0xf),
 	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
-	INTEL_UEVENT_CONSTRAINT(0x01d2, 0xf),
+	INTEL_EXCLUEVT_CONSTRAINT(0x01d2, 0xf),
 	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
-	INTEL_UEVENT_CONSTRAINT(0x02d2, 0xf),
+	INTEL_EXCLUEVT_CONSTRAINT(0x02d2, 0xf),
 	/* MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM */
-	INTEL_UEVENT_CONSTRAINT(0x01d3, 0xf),
+	INTEL_EXCLUEVT_CONSTRAINT(0x01d3, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x04c8, 0xf), /* HLE_RETIRED.Abort */
 	INTEL_UEVENT_CONSTRAINT(0x04c9, 0xf), /* RTM_RETIRED.Abort */
 
-- 
1.7.9.5


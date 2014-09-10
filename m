Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaIJAtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 20:49:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:34541 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaIJAtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 20:49:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,494,1406617200"; 
   d="scan'208";a="570875884"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf, x86: Use INTEL_FLAGS_UEVENT_CONSTRAINT for PRECDIST
Date: Tue,  9 Sep 2014 17:49:08 -0700
Message-Id: <1410310148-26260-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410310148-26260-1-git-send-email-andi@firstfloor.org>
References: <1410310148-26260-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The earlier commit 86a04461a made near all PEBS on
Sandy/IvyBridge/Haswell to reject non zero flags.

However this wasn't done for the INST_RETIRED.PREC_DIST event
because no suitable macro existed. Now that we have
INTEL_FLAGS_UEVENT_CONSTRAINT enforce zero flags for
INST_RETIRED.PREC_DIST too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 9dc4199..e578c66 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -606,7 +606,7 @@ struct event_constraint intel_westmere_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_snb_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
@@ -617,7 +617,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_ivb_pebs_event_constraints[] = {
-        INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+        INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
         INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
@@ -628,7 +628,7 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_hsw_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.* */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
 	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
-- 
1.9.3


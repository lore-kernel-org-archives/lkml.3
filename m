Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3EVGXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:23:16 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:50812 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab3EVGXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:23:13 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, peterz@infradead.org,
        eranian@google.com, ak@linux.intel.com, mingo@kernel.org
Subject: [PATCH 4/5] x86, perf: Add conditional branch filtering support
Date: Wed, 22 May 2013 11:52:40 +0530
Message-Id: <1369203761-12649-5-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369203761-12649-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1369203761-12649-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052206-8878-0000-0000-000007357B8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

This patch adds conditional branch filtering support,
enabling it for PERF_SAMPLE_BRANCH_COND in perf branch
stack sampling framework by utilizing an available
software filter X86_BR_JCC.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d978353..a0d6387 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -337,6 +337,10 @@ static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 
 	if (br_type & PERF_SAMPLE_BRANCH_IND_CALL)
 		mask |= X86_BR_IND_CALL;
+
+	if (br_type & PERF_SAMPLE_BRANCH_COND)
+		mask |= X86_BR_JCC;
+
 	/*
 	 * stash actual user request into reg, it may
 	 * be used by fixup code for some CPU
@@ -626,6 +630,7 @@ static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	 * NHM/WSM erratum: must include IND_JMP to capture IND_CALL
 	 */
 	[PERF_SAMPLE_BRANCH_IND_CALL] = LBR_IND_CALL | LBR_IND_JMP,
+	[PERF_SAMPLE_BRANCH_COND]     = LBR_JCC,
 };
 
 static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
@@ -637,6 +642,7 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	[PERF_SAMPLE_BRANCH_ANY_CALL]	= LBR_REL_CALL | LBR_IND_CALL
 					| LBR_FAR,
 	[PERF_SAMPLE_BRANCH_IND_CALL]	= LBR_IND_CALL,
+	[PERF_SAMPLE_BRANCH_COND]	= LBR_JCC,
 };
 
 /* core */
-- 
1.7.11.7


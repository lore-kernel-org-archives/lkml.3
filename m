Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaEVH1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:27:00 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55597 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaEVH07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:26:59 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH V6 3/4] x86, perf: Add conditional branch filtering support
Date: Thu, 22 May 2014 12:50:09 +0530
Message-Id: <1400743210-32289-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1400743210-32289-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1400743210-32289-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052207-9264-0000-0000-00000624B2E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds conditional branch filtering support,
enabling it for PERF_SAMPLE_BRANCH_COND in perf branch
stack sampling framework by utilizing an available
software filter X86_BR_JCC.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d82d155..9dd2459 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -384,6 +384,9 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_NO_TX)
 		mask |= X86_BR_NO_TX;
 
+	if (br_type & PERF_SAMPLE_BRANCH_COND)
+		mask |= X86_BR_JCC;
+
 	/*
 	 * stash actual user request into reg, it may
 	 * be used by fixup code for some CPU
@@ -678,6 +681,7 @@ static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	 * NHM/WSM erratum: must include IND_JMP to capture IND_CALL
 	 */
 	[PERF_SAMPLE_BRANCH_IND_CALL] = LBR_IND_CALL | LBR_IND_JMP,
+	[PERF_SAMPLE_BRANCH_COND]     = LBR_JCC,
 };
 
 static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
@@ -689,6 +693,7 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	[PERF_SAMPLE_BRANCH_ANY_CALL]	= LBR_REL_CALL | LBR_IND_CALL
 					| LBR_FAR,
 	[PERF_SAMPLE_BRANCH_IND_CALL]	= LBR_IND_CALL,
+	[PERF_SAMPLE_BRANCH_COND]       = LBR_JCC,
 };
 
 /* core */
-- 
1.7.11.7


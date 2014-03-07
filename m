Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaCGJKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:10:22 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59065 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaCGJJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:09:17 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [V5 3/4] x86, perf: Add conditional branch filtering support
Date: Fri,  7 Mar 2014 14:36:24 +0530
Message-Id: <1394183185-6219-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1394183185-6219-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1394183185-6219-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030709-1396-0000-0000-000004688CF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds conditional branch filtering support,
enabling it for PERF_SAMPLE_BRANCH_COND in perf branch
stack sampling framework by utilizing an available
software filter X86_BR_JCC.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
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


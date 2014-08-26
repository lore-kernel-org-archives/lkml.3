Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaHZQuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:50:04 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:42892 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaHZQuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:50:01 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] perf/x86/intel: Mark initialization code as such
Date: Tue, 26 Aug 2014 18:49:45 +0200
Message-Id: <1409071785-26015-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few of the initialization functions are missing the __init annotation.
Fix this and thereby allow ~680 additional bytes of code to be released
after initialization.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 696ade311d..5625799f93 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -1055,7 +1055,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
  * BTS, PEBS probe and setup
  */
 
-void intel_ds_init(void)
+void __init intel_ds_init(void)
 {
 	/*
 	 * No support for 32bit formats
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 9dd2459a4c..4af10617de 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -697,7 +697,7 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 };
 
 /* core */
-void intel_pmu_lbr_init_core(void)
+void __init intel_pmu_lbr_init_core(void)
 {
 	x86_pmu.lbr_nr     = 4;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;
@@ -712,7 +712,7 @@ void intel_pmu_lbr_init_core(void)
 }
 
 /* nehalem/westmere */
-void intel_pmu_lbr_init_nhm(void)
+void __init intel_pmu_lbr_init_nhm(void)
 {
 	x86_pmu.lbr_nr     = 16;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;
@@ -733,7 +733,7 @@ void intel_pmu_lbr_init_nhm(void)
 }
 
 /* sandy bridge */
-void intel_pmu_lbr_init_snb(void)
+void __init intel_pmu_lbr_init_snb(void)
 {
 	x86_pmu.lbr_nr	 = 16;
 	x86_pmu.lbr_tos	 = MSR_LBR_TOS;
@@ -753,7 +753,7 @@ void intel_pmu_lbr_init_snb(void)
 }
 
 /* atom */
-void intel_pmu_lbr_init_atom(void)
+void __init intel_pmu_lbr_init_atom(void)
 {
 	/*
 	 * only models starting at stepping 10 seems
-- 
1.7.10.4


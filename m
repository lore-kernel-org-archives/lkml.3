Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbaIIOyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:54:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbaIIOyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:21 -0400
Date: Tue, 9 Sep 2014 07:53:23 -0700
From: tip-bot for Mathias Krause <tipbot@zytor.com>
Message-ID: <tip-066ce64c7e867e95e5fee7c5f6b852710486392a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, minipli@googlemail.com, acme@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        minipli@googlemail.com, peterz@infradead.org, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <1409071785-26015-1-git-send-email-minipli@googlemail.com>
References: <1409071785-26015-1-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Mark initialization code as such
Git-Commit-ID: 066ce64c7e867e95e5fee7c5f6b852710486392a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  066ce64c7e867e95e5fee7c5f6b852710486392a
Gitweb:     http://git.kernel.org/tip/066ce64c7e867e95e5fee7c5f6b852710486392a
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Tue, 26 Aug 2014 18:49:45 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 9 Sep 2014 06:53:06 +0200

perf/x86/intel: Mark initialization code as such

A few of the initialization functions are missing the __init annotation.
Fix this and thereby allow ~680 additional bytes of code to be released
after initialization.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/1409071785-26015-1-git-send-email-minipli@googlemail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c  | 2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 9dc4199..b1553d0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -1014,7 +1014,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
  * BTS, PEBS probe and setup
  */
 
-void intel_ds_init(void)
+void __init intel_ds_init(void)
 {
 	/*
 	 * No support for 32bit formats
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 9dd2459..4af1061 100644
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

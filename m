Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3DUDnn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 23:43:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:63115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3DUDnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 23:43:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,517,1363158000"; 
   d="scan'208";a="322357139"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Fix some broken initconsts
Date: Sat, 20 Apr 2013 20:43:39 -0700
Message-Id: <1366515819-18081-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
index 4b7731b..2cfe648 100644
--- a/arch/x86/kernel/cpu/perf_event_knc.c
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -17,7 +17,7 @@ static const u64 knc_perfmon_event_map[] =
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
 };
 
-static __initconst u64 knc_hw_cache_event_ids
+static __initconst const u64 knc_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -284,7 +284,7 @@ static struct attribute *intel_knc_formats_attr[] = {
 	NULL,
 };
 
-static __initconst struct x86_pmu knc_pmu = {
+static __initconst const struct x86_pmu knc_pmu = {
 	.name			= "knc",
 	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,

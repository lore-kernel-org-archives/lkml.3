Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbaD2HFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:05:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:50632 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaD2HE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:04:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,949,1389772800"; 
   d="scan'208";a="531400805"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86/intel: fix Silvermont's event constraints
Date: Tue, 29 Apr 2014 15:04:41 +0800
Message-Id: <1398755081-12471-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Event 0x013c is not the same as fixed counter2, remove it from
Silvermont's event constraints.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index aa333d9..adb02aa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -169,7 +169,6 @@ static struct event_constraint intel_slm_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
 	EVENT_CONSTRAINT_END
 };
-- 
1.9.0


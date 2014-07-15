Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbaGOI7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:59:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:44633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758343AbaGOI7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:59:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,664,1400050800"; 
   d="scan'208";a="457092220"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v2 6/7] perf, x86: enable large PEBS interrupt threshold for SNB/IVB/HSW
Date: Tue, 15 Jul 2014 16:58:58 +0800
Message-Id: <1405414739-31455-7-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index cb5a838..dba03b3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2456,6 +2456,7 @@ __init int intel_pmu_init(void)
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
 			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
 
+		x86_pmu.multi_pebs = true;
 		pr_cont("SandyBridge events, ");
 		break;
 	case 58: /* IvyBridge */
@@ -2484,6 +2485,7 @@ __init int intel_pmu_init(void)
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
 
+		x86_pmu.multi_pebs = true;
 		pr_cont("IvyBridge events, ");
 		break;
 
@@ -2511,6 +2513,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		x86_pmu.cpu_events = hsw_events_attrs;
 		x86_pmu.lbr_double_abort = true;
+
+		x86_pmu.multi_pebs = true;
 		pr_cont("Haswell events, ");
 		break;
 
-- 
1.9.3


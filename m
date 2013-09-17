Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab3IQGsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 02:48:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:32608 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab3IQGsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 02:48:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,921,1371106800"; 
   d="scan'208";a="361551201"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: peterz@infradead.org
Cc: eranian@google.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86/intel/uncore: don't use smp_processor_id() in validate_group()
Date: Tue, 17 Sep 2013 14:48:13 +0800
Message-Id: <1379400493-11505-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

uncore_validate_group() can't call smp_processor_id() because it is
in preemptible context. Pass NUMA_NO_NODE to the allocator instead.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index fd8011e..11b1582 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3031,7 +3031,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
 	struct intel_uncore_box *fake_box;
 	int ret = -EINVAL, n;
 
-	fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
+	fake_box = uncore_alloc_box(pmu->type, NUMA_NO_NODE);
 	if (!fake_box)
 		return -ENOMEM;
 
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaF3Ivk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:51:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:53494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834AbaF3Ivf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:51:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="536451133"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V4 13/16] perf, x86: re-organize code that implicitly enables LBR/PEBS
Date: Mon, 30 Jun 2014 16:50:50 +0800
Message-Id: <1404118253-19532-14-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make later patch more readable, no logic change.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 59 ++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 41daa7b..cb2259f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -390,36 +390,35 @@ int x86_pmu_hw_config(struct perf_event *event)
 
 		if (event->attr.precise_ip > precise)
 			return -EOPNOTSUPP;
-		/*
-		 * check that PEBS LBR correction does not conflict with
-		 * whatever the user is asking with attr->branch_sample_type
-		 */
-		if (event->attr.precise_ip > 1 &&
-		    x86_pmu.intel_cap.pebs_format < 2) {
-			u64 *br_type = &event->attr.branch_sample_type;
-
-			if (has_branch_stack(event)) {
-				if (!precise_br_compat(event))
-					return -EOPNOTSUPP;
-
-				/* branch_sample_type is compatible */
-
-			} else {
-				/*
-				 * user did not specify  branch_sample_type
-				 *
-				 * For PEBS fixups, we capture all
-				 * the branches at the priv level of the
-				 * event.
-				 */
-				*br_type = PERF_SAMPLE_BRANCH_ANY;
-
-				if (!event->attr.exclude_user)
-					*br_type |= PERF_SAMPLE_BRANCH_USER;
-
-				if (!event->attr.exclude_kernel)
-					*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
-			}
+	}
+	/*
+	 * check that PEBS LBR correction does not conflict with
+	 * whatever the user is asking with attr->branch_sample_type
+	 */
+	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
+		u64 *br_type = &event->attr.branch_sample_type;
+
+		if (has_branch_stack(event)) {
+			if (!precise_br_compat(event))
+				return -EOPNOTSUPP;
+
+			/* branch_sample_type is compatible */
+
+		} else {
+			/*
+			 * user did not specify  branch_sample_type
+			 *
+			 * For PEBS fixups, we capture all
+			 * the branches at the priv level of the
+			 * event.
+			 */
+			*br_type = PERF_SAMPLE_BRANCH_ANY;
+
+			if (!event->attr.exclude_user)
+				*br_type |= PERF_SAMPLE_BRANCH_USER;
+
+			if (!event->attr.exclude_kernel)
+				*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
 		}
 	}
 
-- 
1.9.0


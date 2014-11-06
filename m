Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaKFPLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:11:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:37539 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaKFPJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:09:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,326,1413270000"; 
   d="scan'208";a="627701966"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V8 11/14] perf, x86: re-organize code that implicitly enables LBR/PEBS
Date: Thu,  6 Nov 2014 09:54:28 -0500
Message-Id: <1415285671-16894-12-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
References: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yan, Zheng <zheng.z.yan@intel.com>

make later patch more readable, no logic change.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 59 ++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1fd9492..02be0e4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -395,36 +395,35 @@ int x86_pmu_hw_config(struct perf_event *event)
 
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
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaIJC7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:59:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:28276 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbaIJC6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:58:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,495,1406617200"; 
   d="scan'208";a="597207908"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, ak@linux.intel.com, kan.liang@intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V5 13/16] perf, x86: re-organize code that implicitly enables LBR/PEBS
Date: Sun,  7 Jan 2001 21:32:00 -0500
Message-Id: <978921123-30240-4-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <978921123-30240-1-git-send-email-kan.liang@intel.com>
References: <978921123-30240-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

make later patch more readable, no logic change.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 59 ++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0a71f04..418e953 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -393,36 +393,35 @@ int x86_pmu_hw_config(struct perf_event *event)
 
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


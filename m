Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3HMG37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:29:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:4066 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741Ab3HMG3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:29:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,867,1367996400"; 
   d="scan'208";a="345514427"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 3/3] perf, uncore: enable ev_sel_ext bit for PCU.
Date: Tue, 13 Aug 2013 14:29:42 +0800
Message-Id: <1376375382-21350-4-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376375382-21350-1-git-send-email-zheng.z.yan@intel.com>
References: <1376375382-21350-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

This patch adds support for the SNB-EP PCU uncore PMU extra_sel_bit
(bit 21) which is missing from the documentation in Table-2.75 of
Intel Xeon Processor E5-2600 Product Family Uncore Performance
Monitoring Guide. It is referred to later in Table-2.81. Without
this selection bit explicitly enabled by the kernel, some events
such as COREx_TRANSITION_CYCLES do not count correctly.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 6b8b9c9..e9696d8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -301,7 +301,7 @@ static struct attribute *snbep_uncore_cbox_formats_attr[] = {
 };
 
 static struct attribute *snbep_uncore_pcu_formats_attr[] = {
-	&format_attr_event.attr,
+	&format_attr_event_ext.attr,
 	&format_attr_occ_sel.attr,
 	&format_attr_edge.attr,
 	&format_attr_inv.attr,
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 628500e..a80ab71 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -117,6 +117,7 @@
 				(SNBEP_PMON_CTL_EV_SEL_MASK | \
 				 SNBEP_PCU_MSR_PMON_CTL_OCC_SEL_MASK | \
 				 SNBEP_PMON_CTL_EDGE_DET | \
+				 SNBEP_PMON_CTL_EV_SEL_EXT | \
 				 SNBEP_PMON_CTL_INVERT | \
 				 SNBEP_PCU_MSR_PMON_CTL_TRESH_MASK | \
 				 SNBEP_PCU_MSR_PMON_CTL_OCC_INVERT | \
-- 
1.8.1.4


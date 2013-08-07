Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3HGGRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:17:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:27491 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab3HGGRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:17:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,831,1367996400"; 
   d="scan'208";a="383072155"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 3/3] perf, uncore: enable ev_sel_ext bit for PCU.
Date: Wed,  7 Aug 2013 14:17:25 +0800
Message-Id: <1375856245-10717-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375856245-10717-1-git-send-email-zheng.z.yan@intel.com>
References: <1375856245-10717-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

PCU uncore event control register has a undocumented ev_sel_ext bit.
The bit is needed by Andi's pmu-tools.

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


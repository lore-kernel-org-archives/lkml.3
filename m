Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbaIDXIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:08:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:57231 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbaIDXIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:08:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,469,1406617200"; 
   d="scan'208";a="594820146"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] perf, x86, uncore: Add missing cbox filter flags on IvyBridge-EP uncore driver
Date: Thu,  4 Sep 2014 16:08:28 -0700
Message-Id: <1409872109-31645-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409872109-31645-1-git-send-email-andi@firstfloor.org>
References: <1409872109-31645-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The IvyBridge-EP uncore driver was missing three filter flags:
NC, ISOC, C6 which are useful in some cases. Support them in the same way
as the Haswell EP driver, by allowing to set them and exposing
them in the sysfs formats.

Also fix a typo in a define.

Relies on the Haswell EP driver to be applied earlier.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index a4fe9fa..b237abc2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -139,7 +139,7 @@
 #define IVBEP_CB0_MSR_PMON_BOX_FILTER_OPC		(0x1ffULL << 52)
 #define IVBEP_CB0_MSR_PMON_BOX_FILTER_C6		(0x1ULL << 61)
 #define IVBEP_CB0_MSR_PMON_BOX_FILTER_NC		(0x1ULL << 62)
-#define IVBEP_CB0_MSR_PMON_BOX_FILTER_IOSC	(0x1ULL << 63)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_ISOC	(0x1ULL << 63)
 
 /* IVBEP home agent */
 #define IVBEP_HA_PCI_PMON_CTL_Q_OCC_RST		(1 << 16)
@@ -1214,6 +1214,9 @@ static struct attribute *ivbep_uncore_cbox_formats_attr[] = {
 	&format_attr_filter_state2.attr,
 	&format_attr_filter_nid2.attr,
 	&format_attr_filter_opc2.attr,
+	&format_attr_filter_nc.attr,
+	&format_attr_filter_c6.attr,
+	&format_attr_filter_isoc.attr,
 	NULL,
 };
 
@@ -1350,8 +1353,12 @@ static u64 ivbep_cbox_filter_mask(int fields)
 		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_STATE;
 	if (fields & 0x8)
 		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_NID;
-	if (fields & 0x10)
+	if (fields & 0x10) {
 		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_OPC;
+		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_NC;
+		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_C6;
+		mask |= IVBEP_CB0_MSR_PMON_BOX_FILTER_ISOC;
+	}
 
 	return mask;
 }
-- 
1.9.3


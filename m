Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaIXPBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:01:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaIXPBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:01:11 -0400
Date: Wed, 24 Sep 2014 08:00:37 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-7e96ae1a8915e7064091ab75857f8c63334ea28d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1409872109-31645-4-git-send-email-andi@firstfloor.org>
References: <1409872109-31645-4-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/uncore:
  Add missing cbox filter flags on IvyBridge-EP uncore driver
Git-Commit-ID: 7e96ae1a8915e7064091ab75857f8c63334ea28d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e96ae1a8915e7064091ab75857f8c63334ea28d
Gitweb:     http://git.kernel.org/tip/7e96ae1a8915e7064091ab75857f8c63334ea28d
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 4 Sep 2014 16:08:28 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:48:23 +0200

perf/x86/intel/uncore: Add missing cbox filter flags on IvyBridge-EP uncore driver

The IvyBridge-EP uncore driver was missing three filter flags:
NC, ISOC, C6 which are useful in some cases. Support them in the same way
as the Haswell EP driver, by allowing to set them and exposing
them in the sysfs formats.

Also fix a typo in a define.

Relies on the Haswell EP driver to be applied earlier.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1409872109-31645-4-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index a4fe9fa..b237abc 100644
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

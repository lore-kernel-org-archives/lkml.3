Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaACUfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:35:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:17760 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbaACUfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:35:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,599,1384329600"; 
   d="scan'208";a="459776431"
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: Add Cache QoS Monitoring support to x86 perf uncore
Date: Fri,  3 Jan 2014 12:34:43 -0800
Message-Id: <1388781285-18067-3-git-send-email-peter.p.waskiewicz.jr@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the MSRs and masks for CQM to the x86 uncore.

The actual schedling functions using the MSRs will be included
in the next patch when the new cgroup subsystem is added, as there
are dependencies on structs from the cgroup.

Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index a80ab71..f788145 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -412,6 +412,19 @@
 
 #define NHMEX_W_PMON_GLOBAL_FIXED_EN		(1ULL << 31)
 
+#ifdef CONFIG_CGROUP_CACHEQOS
+/* Intel Cache QoS Monitoring uncore support */
+#define IA32_QM_EVTSEL				0xc8d
+#define IA32_QM_CTR				0xc8e
+#define IA32_PQR_ASSOC				0xc8f
+
+#define IA32_QM_EVTSEL_EVTID_READ_OCC		0x01
+#define IA32_QM_CTR_ERR				(0x03llu << 62)
+#define IA32_RMID_PQR_MASK			0x3ff
+#define IA32_QM_EVTSEL_RMID_POSITION		32
+
+#endif /* CONFIG_CGROUP_CACHEQOS */
+
 struct intel_uncore_ops;
 struct intel_uncore_pmu;
 struct intel_uncore_box;
-- 
1.8.3.1


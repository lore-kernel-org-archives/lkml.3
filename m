Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3LZVfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 16:35:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:4162 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab3LZVfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 16:35:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,557,1384329600"; 
   d="scan'208";a="456166495"
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: cgroups@vger.kernel.org, x86@kernel.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, peter.p.waskiewicz.jr@intel.com
Subject: [RFC PATCH 2/3] x86: Add Cache QoS Monitoring support to x86 perf uncore
Date: Thu, 26 Dec 2013 13:34:38 -0800
Message-Id: <1388093679-26952-3-git-send-email-peter.p.waskiewicz.jr@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388093679-26952-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
References: <1388093679-26952-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the MSRs and masks for CQM to the x86 uncore.

The actual scheduling functions using the MSRs will be included
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


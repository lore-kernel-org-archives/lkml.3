Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaHVJ6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:58:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:6258 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaHVJ6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:58:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,379,1406617200"; 
   d="scan'208";a="591818549"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Kumar Mahesh <mahesh.kumar.p@intel.com>, Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] intel_idle: add idle values for Cherrytrail/Braswell
Date: Fri, 22 Aug 2014 12:58:28 +0300
Message-Id: <1408701508-13636-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Mahesh <mahesh.kumar.p@intel.com>

Braswell is a successor of Intel Baytrail but has slighly different CPU
idle values and latencies.

Signed-off-by: Kumar Mahesh <mahesh.kumar.p@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/idle/intel_idle.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 9b7ee7e427df..ae6f9f1cb700 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -536,6 +536,59 @@ static struct cpuidle_state atom_cstates[] = {
 	{
 		.enter = NULL }
 };
+
+static struct cpuidle_state chv_cstates[CPUIDLE_STATE_MAX] = {
+	{ /* MWAIT C1 */
+		.name = "C1-ATM",
+		.desc = "MWAIT 0x00",
+		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 1,
+		.target_residency = 4,
+		.enter = &intel_idle },
+	{ /* MWAIT C4 */
+		.name = "C4-ATM",
+		.desc = "MWAIT 0x30",
+		.flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TIME_VALID
+						| CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 100,
+		.target_residency = 400,
+		.enter = &intel_idle },
+	{ /* MWAIT C6 */
+		.name = "C6-ATM",
+		.desc = "MWAIT 0x52",
+		.flags = MWAIT2flg(0x52) | CPUIDLE_FLAG_TIME_VALID
+						| CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 140,
+		.target_residency = 560,
+		.enter = &intel_idle },
+	{ /* MWAIT C7-S0i1 */
+		.name = "S0i1-ATM",
+		.desc = "MWAIT 0x60",
+		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TIME_VALID
+						| CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 1200,
+		.target_residency = 4000,
+		.enter = &intel_idle },
+	{ /* MWAIT C8-S0i2 */
+		.name = "S0i2-ATM",
+		.desc = "MWAIT 0x62",
+		.flags = MWAIT2flg(0x62) | CPUIDLE_FLAG_TIME_VALID
+						| CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 2000,
+		.target_residency = 8000,
+		.enter = &intel_idle },
+	{ /* MWAIT C9-S0i3 */
+		.name = "S0i3-ATM",
+		.desc = "MWAIT 0x64",
+		.flags = MWAIT2flg(0x64) | CPUIDLE_FLAG_TIME_VALID
+						| CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 10000,
+		.target_residency = 20000,
+		.enter = &intel_idle },
+	{
+		.enter = NULL }
+};
+
 static struct cpuidle_state avn_cstates[] = {
 	{
 		.name = "C1-AVN",
@@ -702,6 +755,10 @@ static const struct idle_cpu idle_cpu_avn = {
 	.disable_promotion_to_c1e = true,
 };
 
+static const struct idle_cpu idle_cpu_chv = {
+	.state_table = chv_cstates,
+};
+
 #define ICPU(model, cpu) \
 	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_MWAIT, (unsigned long)&cpu }
 
@@ -725,6 +782,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
 	ICPU(0x3f, idle_cpu_hsw),
 	ICPU(0x45, idle_cpu_hsw),
 	ICPU(0x46, idle_cpu_hsw),
+	ICPU(0x4c, idle_cpu_chv),
 	ICPU(0x4d, idle_cpu_avn),
 	ICPU(0x3d, idle_cpu_bdw),
 	ICPU(0x4f, idle_cpu_bdw),
-- 
2.1.0


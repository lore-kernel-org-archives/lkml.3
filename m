Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3BAEL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:11:56 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:35136 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3BAELv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:11:51 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 4/4] intel_idle: initial HSW support
Date: Thu, 31 Jan 2013 23:11:36 -0500
Message-Id: <ea7c468dd73f98795811d3d038ccc2ca3e04a5ca.1359691799.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.2.422.g08c0e7f
In-Reply-To: <1359691896-23567-1-git-send-email-lenb@kernel.org>
References: <1359691896-23567-1-git-send-email-lenb@kernel.org>
In-Reply-To: <9a38405338d7464c852c4524465f84f8a2ac22fb.1359691799.git.len.brown@intel.com>
References: <9a38405338d7464c852c4524465f84f8a2ac22fb.1359691799.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

This patch enables intel_idle to run on the
next-generation Intel(R) Microarchitecture code named Haswell.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 8331753..85d50a1 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -212,6 +212,38 @@ static struct cpuidle_state ivb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 };
 
+static struct cpuidle_state hsw_cstates[MWAIT_MAX_NUM_CSTATES] = {
+	{ /* MWAIT C0 */ },
+	{ /* MWAIT C1 */
+		.name = "C1-HSW",
+		.desc = "MWAIT 0x00",
+		.flags = MWAIT_EAX_2_flags(0x00) | CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 2,
+		.target_residency = 2,
+		.enter = &intel_idle },
+	{ /* MWAIT C2 */
+		.name = "C3-HSW",
+		.desc = "MWAIT 0x10",
+		.flags = MWAIT_EAX_2_flags(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 39,
+		.target_residency = 117,
+		.enter = &intel_idle },
+	{ /* MWAIT C3 */
+		.name = "C6-HSW",
+		.desc = "MWAIT 0x20",
+		.flags = MWAIT_EAX_2_flags(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 55,
+		.target_residency = 165,
+		.enter = &intel_idle },
+	{ /* MWAIT C4 */
+		.name = "C7-HSW",
+		.desc = "MWAIT 0x30",
+		.flags = MWAIT_EAX_2_flags(0x32) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 79,
+		.target_residency = 237,
+		.enter = &intel_idle },
+};
+
 static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
@@ -365,6 +397,10 @@ static const struct idle_cpu idle_cpu_ivb = {
 	.state_table = ivb_cstates,
 };
 
+static const struct idle_cpu idle_cpu_hsw = {
+	.state_table = hsw_cstates,
+};
+
 #define ICPU(model, cpu) \
 	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_MWAIT, (unsigned long)&cpu }
 
@@ -382,6 +418,9 @@ static const struct x86_cpu_id intel_idle_ids[] = {
 	ICPU(0x2d, idle_cpu_snb),
 	ICPU(0x3a, idle_cpu_ivb),
 	ICPU(0x3e, idle_cpu_ivb),
+	ICPU(0x3c, idle_cpu_hsw),
+	ICPU(0x3f, idle_cpu_hsw),
+	ICPU(0x45, idle_cpu_hsw),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
-- 
1.8.1.2.422.g08c0e7f


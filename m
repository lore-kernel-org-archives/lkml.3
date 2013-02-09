Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab3BIBKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:10:15 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:56734 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947650Ab3BIBIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:47 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 11/16] intel_idle: support Haswell
Date: Fri,  8 Feb 2013 20:08:15 -0500
Message-Id: <85a4d2d41dc6d1c0296326204a857a9fab864a31.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

This patch enables intel_idle to run on the
next-generation Intel(R) Microarchitecture code named "Haswell".

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index b2cf489..fa71477 100644
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
+		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 2,
+		.target_residency = 2,
+		.enter = &intel_idle },
+	{ /* MWAIT C2 */
+		.name = "C3-HSW",
+		.desc = "MWAIT 0x10",
+		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 33,
+		.target_residency = 100,
+		.enter = &intel_idle },
+	{ /* MWAIT C3 */
+		.name = "C6-HSW",
+		.desc = "MWAIT 0x20",
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 133,
+		.target_residency = 400,
+		.enter = &intel_idle },
+	{ /* MWAIT C4 */
+		.name = "C7s-HSW",
+		.desc = "MWAIT 0x32",
+		.flags = MWAIT2flg(0x32) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 166,
+		.target_residency = 500,
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
1.8.1.3.535.ga923c31


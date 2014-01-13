Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaAMO0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:26:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51199 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaAMOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Len Brown <len.brown@intel.com>, Vinson Lee <vlee@twopensource.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 11/96] intel_idle: initial IVB support
Date: Mon, 13 Jan 2014 14:23:34 +0000
Message-Id: <1389623099-18783-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

commit 6edab08c24f9141d69cfa4683a0a027d86ab303e upstream.

>From an OS point of view, IVB looks like SNB, but quicker.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Vinson Lee <vlee@twopensource.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/idle/intel_idle.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 04eced7..377ec9a 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -169,6 +169,38 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 };
 
+static struct cpuidle_state ivb_cstates[MWAIT_MAX_NUM_CSTATES] = {
+	{ /* MWAIT C0 */ },
+	{ /* MWAIT C1 */
+		.name = "C1-IVB",
+		.desc = "MWAIT 0x00",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &intel_idle },
+	{ /* MWAIT C2 */
+		.name = "C3-IVB",
+		.desc = "MWAIT 0x10",
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 59,
+		.target_residency = 156,
+		.enter = &intel_idle },
+	{ /* MWAIT C3 */
+		.name = "C6-IVB",
+		.desc = "MWAIT 0x20",
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 80,
+		.target_residency = 300,
+		.enter = &intel_idle },
+	{ /* MWAIT C4 */
+		.name = "C7-IVB",
+		.desc = "MWAIT 0x30",
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 87,
+		.target_residency = 300,
+		.enter = &intel_idle },
+};
+
 static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
@@ -347,6 +379,10 @@ static const struct idle_cpu idle_cpu_snb = {
 	.state_table = snb_cstates,
 };
 
+static const struct idle_cpu idle_cpu_ivb = {
+	.state_table = ivb_cstates,
+};
+
 #define ICPU(model, cpu) \
 	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_MWAIT, (unsigned long)&cpu }
 
@@ -362,6 +398,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
 	ICPU(0x2f, idle_cpu_nehalem),
 	ICPU(0x2a, idle_cpu_snb),
 	ICPU(0x2d, idle_cpu_snb),
+	ICPU(0x3a, idle_cpu_ivb),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
-- 
1.8.3.2


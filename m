Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370AbaAFWmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:42:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbaAFWmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Vinson Lee <vlee@twopensource.com>
Subject: [PATCH 3.4 12/43] intel_idle: initial IVB support
Date: Mon,  6 Jan 2014 14:39:29 -0800
Message-Id: <20140106223942.603446266@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223942.259651490@linuxfoundation.org>
References: <20140106223942.259651490@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

commit 6edab08c24f9141d69cfa4683a0a027d86ab303e upstream.

>From an OS point of view, IVB looks like SNB, but quicker.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Vinson Lee <vlee@twopensource.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/idle/intel_idle.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -169,6 +169,38 @@ static struct cpuidle_state snb_cstates[
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
@@ -347,6 +379,10 @@ static const struct idle_cpu idle_cpu_sn
 	.state_table = snb_cstates,
 };
 
+static const struct idle_cpu idle_cpu_ivb = {
+	.state_table = ivb_cstates,
+};
+
 #define ICPU(model, cpu) \
 	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_MWAIT, (unsigned long)&cpu }
 
@@ -362,6 +398,7 @@ static const struct x86_cpu_id intel_idl
 	ICPU(0x2f, idle_cpu_nehalem),
 	ICPU(0x2a, idle_cpu_snb),
 	ICPU(0x2d, idle_cpu_snb),
+	ICPU(0x3a, idle_cpu_ivb),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3CTOVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:21:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30821 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3CTOVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:21:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, rafael.j.wysocki@intel.com,
        dirk.j.brandewie@intel.com
Subject: [PATCH] intel-pstate: Use #defines instead of hard-coded values.
Date: Wed, 20 Mar 2013 10:21:10 -0400
Message-Id: <1363789270-29579-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are defined in coreboot (MSR_PLATFORM) and the other
one is already defined in msr-index.h.

Lets use those.

CC: rafael.j.wysocki@intel.com
CC: dirk.j.brandewie@intel.com
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/uapi/asm/msr-index.h | 1 +
 drivers/cpufreq/intel_pstate.c        | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 892ce40..7a060f4 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -44,6 +44,7 @@
 #define SNB_C1_AUTO_UNDEMOTE		(1UL << 27)
 #define SNB_C3_AUTO_UNDEMOTE		(1UL << 28)
 
+#define MSR_PLATFORM_INFO		0x000000ce
 #define MSR_MTRRcap			0x000000fe
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index f6dd1e7..dadc27d 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -358,14 +358,14 @@ static void intel_pstate_sysfs_expose_params(void)
 static int intel_pstate_min_pstate(void)
 {
 	u64 value;
-	rdmsrl(0xCE, value);
+	rdmsrl(MSR_PLATFORM_INFO, value);
 	return (value >> 40) & 0xFF;
 }
 
 static int intel_pstate_max_pstate(void)
 {
 	u64 value;
-	rdmsrl(0xCE, value);
+	rdmsrl(MSR_PLATFORM_INFO, value);
 	return (value >> 8) & 0xFF;
 }
 
@@ -373,7 +373,7 @@ static int intel_pstate_turbo_pstate(void)
 {
 	u64 value;
 	int nont, ret;
-	rdmsrl(0x1AD, value);
+	rdmsrl(MSR_NHM_TURBO_RATIO_LIMIT, value);
 	nont = intel_pstate_max_pstate();
 	ret = ((value) & 255);
 	if (ret <= nont)
-- 
1.8.0.2


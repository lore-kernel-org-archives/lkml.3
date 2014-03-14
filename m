Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbaCNGlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:41:06 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:60374 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaCNGlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:41:03 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xin.wang@arm.com, arvind.chauhan@arm.com, Sudeep.Holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: arm_big_little: make vexpress driver dependent on bL core driver
Date: Fri, 14 Mar 2014 12:10:54 +0530
Message-Id: <4689064c920e08d5667b38d7117620ab98150273.1394779110.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vexpress big LITTLE driver selects ARM_BIG_LITTLE_CPUFREQ and so if
CONFIG_BIG_LITTLE isn't enabled and CONFIG_ARM_VEXPRESS_SPC_CPUFREQ is enabled
we get below warnings while compiling:

warning: (ARM_VEXPRESS_SPC_CPUFREQ) selects ARM_BIG_LITTLE_CPUFREQ which has
unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && (ARM || ARM64) && ARM
&& BIG_LITTLE && ARM_CPU_TOPOLOGY && HAVE_CLK)

To fix this make ARM_VEXPRESS_SPC_CPUFREQ dependent on ARM_BIG_LITTLE_CPUFREQ
instead of selecting it.

This also moves entry for ARM_VEXPRESS_SPC_CPUFREQ along with other big LITTLE
config entries.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Rafael,

Both of these are fixes, please see if they can make it to 3.14 only.

Thanks.

 drivers/cpufreq/Kconfig.arm | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 3129749..9fb6270 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -2,6 +2,7 @@
 # ARM CPU Frequency scaling drivers
 #
 
+# big LITTLE core layer and glue drivers
 config ARM_BIG_LITTLE_CPUFREQ
 	tristate "Generic ARM big LITTLE CPUfreq driver"
 	depends on ARM && BIG_LITTLE && ARM_CPU_TOPOLOGY && HAVE_CLK
@@ -16,6 +17,14 @@ config ARM_DT_BL_CPUFREQ
 	  This enables probing via DT for Generic CPUfreq driver for ARM
 	  big.LITTLE platform. This gets frequency tables from DT.
 
+config ARM_VEXPRESS_SPC_CPUFREQ
+        tristate "Versatile Express SPC based CPUfreq driver"
+	depends on ARM_BIG_LITTLE_CPUFREQ && ARCH_VEXPRESS_SPC
+        help
+          This add the CPUfreq driver support for Versatile Express
+	  big.LITTLE platforms using SPC for power management.
+
+
 config ARM_EXYNOS_CPUFREQ
 	bool
 
@@ -241,11 +250,3 @@ config ARM_TEGRA_CPUFREQ
 	default y
 	help
 	  This adds the CPUFreq driver support for TEGRA SOCs.
-
-config ARM_VEXPRESS_SPC_CPUFREQ
-        tristate "Versatile Express SPC based CPUfreq driver"
-        select ARM_BIG_LITTLE_CPUFREQ
-        depends on ARCH_VEXPRESS_SPC
-        help
-          This add the CPUfreq driver support for Versatile Express
-	  big.LITTLE platforms using SPC for power management.
-- 
1.7.12.rc2.18.g61b472e


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3C2O1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:27:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:9010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab3C2O1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:27:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,373,1363158000"; 
   d="scan'208";a="309147572"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: amit.daniel@samsung.com, durgadoss.r@intel.com, andi@lisas.de,
        eduardo.valentin@ti.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V2 3/3] Thermal: build cpu_cooling code into thermal_sys module
Date: Fri, 29 Mar 2013 22:26:36 +0800
Message-Id: <1364567196-3560-4-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364567196-3560-1-git-send-email-rui.zhang@intel.com>
References: <1364567196-3560-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/Kconfig     |    2 +-
 drivers/thermal/Makefile    |    2 +-
 include/linux/cpu_cooling.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index a764f16..10014de 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -67,7 +67,7 @@ config THERMAL_GOV_USER_SPACE
 	  Enable this to let the user space manage the platform thermals.
 
 config CPU_THERMAL
-	tristate "generic cpu cooling support"
+	bool "generic cpu cooling support"
 	depends on CPU_FREQ
 	select CPU_FREQ_TABLE
 	help
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index b7fffc7..cae124f 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -11,7 +11,7 @@ thermal_sys-$(CONFIG_THERMAL_GOV_STEP_WISE)	+= step_wise.o
 thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)	+= user_space.o
 
 # cpufreq cooling
-obj-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
+thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
 
 # platform thermal drivers
 obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index 40b4ef5..b30cc79c 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -29,7 +29,7 @@
 #define CPUFREQ_COOLING_START		0
 #define CPUFREQ_COOLING_STOP		1
 
-#if defined(CONFIG_CPU_THERMAL) || defined(CONFIG_CPU_THERMAL_MODULE)
+#ifdef CONFIG_CPU_THERMAL
 /**
  * cpufreq_cooling_register - function to create cpufreq cooling device.
  * @clip_cpus: cpumask of cpus where the frequency constraints will happen
-- 
1.7.9.5


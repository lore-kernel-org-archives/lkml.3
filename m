Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbaGAQfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:35:39 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44422 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589AbaGAQff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:35:35 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 13/14] cpufreq: cpu0: rename driver and internals to 'cpufreq_generic'
Date: Tue,  1 Jul 2014 22:02:42 +0530
Message-Id: <17e1db05f7884b059a64ad7896be6a9ab4bc7fc8.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a cpu0 driver anymore as it supports any number of clusters with
separate clock/voltage lines.

Lets rename it to 'cpufreq_generic' from 'cpufreq_cpu0'.

'.name' field of platform driver/devices isn't renamed yet, would be done
separately.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 .../{cpufreq-cpu0.txt => cpufreq-generic.txt}      |  0
 drivers/cpufreq/Kconfig                            | 10 +++---
 drivers/cpufreq/Kconfig.arm                        |  2 +-
 drivers/cpufreq/Makefile                           |  2 +-
 .../cpufreq/{cpufreq-cpu0.c => cpufreq-generic.c}  | 36 +++++++++++-----------
 5 files changed, 25 insertions(+), 25 deletions(-)
 rename Documentation/devicetree/bindings/cpufreq/{cpufreq-cpu0.txt => cpufreq-generic.txt} (100%)
 rename drivers/cpufreq/{cpufreq-cpu0.c => cpufreq-generic.c} (91%)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-generic.txt
similarity index 100%
rename from Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
rename to Documentation/devicetree/bindings/cpufreq/cpufreq-generic.txt
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index ffe350f..22b42d5 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -183,16 +183,16 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
 	  If in doubt, say N.
 
-config GENERIC_CPUFREQ_CPU0
-	tristate "Generic CPU0 cpufreq driver"
+config CPUFREQ_GENERIC
+	tristate "Generic cpufreq driver"
 	depends on HAVE_CLK && OF
-	# if CPU_THERMAL is on and THERMAL=m, CPU0 cannot be =y:
+	# if CPU_THERMAL is on and THERMAL=m, GENERIC cannot be =y:
 	depends on !CPU_THERMAL || THERMAL
 	select PM_OPP
 	help
-	  This adds a generic cpufreq driver for CPU0 frequency management.
+	  This adds a generic cpufreq driver for frequency management.
 	  It supports both uniprocessor (UP) and symmetric multiprocessor (SMP)
-	  systems which share clock and voltage across all CPUs.
+	  systems which may or maynot share clock and voltage across all CPUs.
 
 	  If in doubt, say N.
 
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index ebac671..16bdd31 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -92,7 +92,7 @@ config ARM_EXYNOS_CPU_FREQ_BOOST_SW
 
 config ARM_HIGHBANK_CPUFREQ
 	tristate "Calxeda Highbank-based"
-	depends on ARCH_HIGHBANK && GENERIC_CPUFREQ_CPU0 && REGULATOR
+	depends on ARCH_HIGHBANK && CPUFREQ_GENERIC && REGULATOR
 	default m
 	help
 	  This adds the CPUFreq driver for Calxeda Highbank SoC
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 738c8b7..0d0cddc 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o
 obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
 obj-$(CONFIG_CPU_FREQ_GOV_COMMON)		+= cpufreq_governor.o
 
-obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)	+= cpufreq-cpu0.o
+obj-$(CONFIG_CPUFREQ_GENERIC)		+= cpufreq-generic.o
 
 ##################################################################################
 # x86 drivers.
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-generic.c
similarity index 91%
rename from drivers/cpufreq/cpufreq-cpu0.c
rename to drivers/cpufreq/cpufreq-generic.c
index b3f2bf0..ac8fd9f 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-generic.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2014 Linaro.
  * Viresh Kumar <viresh.kumar@linaro.org>
  *
- * The OPP code in function cpu0_set_target() is reused from
+ * The OPP code in function set_target() is reused from
  * drivers/cpufreq/omap-cpufreq.c
  *
  * This program is free software; you can redistribute it and/or modify
@@ -35,7 +35,7 @@ struct private_data {
 	unsigned int voltage_tolerance; /* in percentage */
 };
 
-static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
+static int set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct dev_pm_opp *opp;
 	struct cpufreq_frequency_table *freq_table = policy->freq_table;
@@ -201,7 +201,7 @@ static void find_siblings(struct cpufreq_policy *policy)
 	}
 }
 
-static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
+static int cpufreq_init(struct cpufreq_policy *policy)
 {
 	struct cpufreq_frequency_table *freq_table;
 	struct thermal_cooling_device *cdev;
@@ -318,7 +318,7 @@ out_put_reg_clk:
 	return ret;
 }
 
-static int cpu0_cpufreq_exit(struct cpufreq_policy *policy)
+static int cpufreq_exit(struct cpufreq_policy *policy)
 {
 	struct private_data *priv = policy->driver_data;
 
@@ -332,18 +332,18 @@ static int cpu0_cpufreq_exit(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static struct cpufreq_driver cpu0_cpufreq_driver = {
+static struct cpufreq_driver generic_cpufreq_driver = {
 	.flags = CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target_index = cpu0_set_target,
+	.target_index = set_target,
 	.get = cpufreq_generic_get,
-	.init = cpu0_cpufreq_init,
-	.exit = cpu0_cpufreq_exit,
-	.name = "generic_cpu0",
+	.init = cpufreq_init,
+	.exit = cpufreq_exit,
+	.name = "cpufreq-generic",
 	.attr = cpufreq_generic_attr,
 };
 
-static int cpu0_cpufreq_probe(struct platform_device *pdev)
+static int generic_cpufreq_probe(struct platform_device *pdev)
 {
 	struct device *cpu_dev;
 	struct regulator *cpu_reg;
@@ -365,30 +365,30 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	if (!IS_ERR(cpu_reg))
 		regulator_put(cpu_reg);
 
-	ret = cpufreq_register_driver(&cpu0_cpufreq_driver);
+	ret = cpufreq_register_driver(&generic_cpufreq_driver);
 	if (ret)
 		dev_err(cpu_dev, "failed register driver: %d\n", ret);
 
 	return ret;
 }
 
-static int cpu0_cpufreq_remove(struct platform_device *pdev)
+static int generic_cpufreq_remove(struct platform_device *pdev)
 {
-	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
+	cpufreq_unregister_driver(&generic_cpufreq_driver);
 	return 0;
 }
 
-static struct platform_driver cpu0_cpufreq_platdrv = {
+static struct platform_driver generic_cpufreq_platdrv = {
 	.driver = {
 		.name	= "cpufreq-cpu0",
 		.owner	= THIS_MODULE,
 	},
-	.probe		= cpu0_cpufreq_probe,
-	.remove		= cpu0_cpufreq_remove,
+	.probe		= generic_cpufreq_probe,
+	.remove		= generic_cpufreq_remove,
 };
-module_platform_driver(cpu0_cpufreq_platdrv);
+module_platform_driver(generic_cpufreq_platdrv);
 
 MODULE_AUTHOR("Viresh Kumar <viresh.kumar@linaro.org>");
 MODULE_AUTHOR("Shawn Guo <shawn.guo@linaro.org>");
-MODULE_DESCRIPTION("Generic CPU0 cpufreq driver");
+MODULE_DESCRIPTION("Generic cpufreq driver");
 MODULE_LICENSE("GPL");
-- 
2.0.0.rc2


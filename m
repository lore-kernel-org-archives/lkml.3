Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaGAQfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:35:51 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54479 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589AbaGAQfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:35:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Simon Horman <horms@verge.net.au>,
        Michal Simek <michal.simek@xilinx.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <rob.herring@linaro.org>
Subject: [PATCH 14/14] cpufreq: generic: set platform_{driver|device} '.name' to 'cpufreq-generic'
Date: Tue,  1 Jul 2014 22:02:43 +0530
Message-Id: <36c77764336c7986dc4fb7534852166028154019.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have already renamed cpufreq-cpu0 to cpufreq-generic at most of the places,
the only one left is in the '.name' field of platform driver and devices.

Lets do it now for all users.

Updates cpufreq-cpu0 from comments as well.

Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Rob Herring <rob.herring@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
@Santosh: Probably you can drop omap's cpufreq driver now?

 arch/arm/mach-imx/imx27-dt.c                     | 2 +-
 arch/arm/mach-imx/imx51-dt.c                     | 2 +-
 arch/arm/mach-omap2/pm.c                         | 2 +-
 arch/arm/mach-shmobile/board-ape6evm-reference.c | 2 +-
 arch/arm/mach-shmobile/setup-sh73a0.c            | 4 ++--
 arch/arm/mach-zynq/common.c                      | 2 +-
 drivers/cpufreq/cpufreq-generic.c                | 2 +-
 drivers/cpufreq/exynos4x12-cpufreq.c             | 2 +-
 drivers/cpufreq/highbank-cpufreq.c               | 6 +++---
 9 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-imx/imx27-dt.c b/arch/arm/mach-imx/imx27-dt.c
index 17bd405..02376e1 100644
--- a/arch/arm/mach-imx/imx27-dt.c
+++ b/arch/arm/mach-imx/imx27-dt.c
@@ -20,7 +20,7 @@
 
 static void __init imx27_dt_init(void)
 {
-	struct platform_device_info devinfo = { .name = "cpufreq-cpu0", };
+	struct platform_device_info devinfo = { .name = "cpufreq-generic", };
 
 	mxc_arch_reset_init_dt();
 
diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
index b8cd968..66d415a 100644
--- a/arch/arm/mach-imx/imx51-dt.c
+++ b/arch/arm/mach-imx/imx51-dt.c
@@ -21,7 +21,7 @@
 
 static void __init imx51_dt_init(void)
 {
-	struct platform_device_info devinfo = { .name = "cpufreq-cpu0", };
+	struct platform_device_info devinfo = { .name = "cpufreq-generic", };
 
 	mxc_arch_reset_init_dt();
 
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 828aee9..7ec2fbb 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -282,7 +282,7 @@ static inline void omap_init_cpufreq(void)
 	if (!of_have_populated_dt())
 		devinfo.name = "omap-cpufreq";
 	else
-		devinfo.name = "cpufreq-cpu0";
+		devinfo.name = "cpufreq-generic";
 	platform_device_register_full(&devinfo);
 }
 
diff --git a/arch/arm/mach-shmobile/board-ape6evm-reference.c b/arch/arm/mach-shmobile/board-ape6evm-reference.c
index 3276afc..94eb59d 100644
--- a/arch/arm/mach-shmobile/board-ape6evm-reference.c
+++ b/arch/arm/mach-shmobile/board-ape6evm-reference.c
@@ -48,7 +48,7 @@ static void __init ape6evm_add_standard_devices(void)
 
 	r8a73a4_add_dt_devices();
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-	platform_device_register_simple("cpufreq-cpu0", -1, NULL, 0);
+	platform_device_register_simple("cpufreq-generic", -1, NULL, 0);
 }
 
 static const char *ape6evm_boards_compat_dt[] __initdata = {
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index ad00724..360eace 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -774,7 +774,7 @@ void __init sh73a0_add_early_devices(void)
 
 void __init sh73a0_add_standard_devices_dt(void)
 {
-	struct platform_device_info devinfo = { .name = "cpufreq-cpu0", .id = -1, };
+	struct platform_device_info devinfo = { .name = "cpufreq-generic", .id = -1, };
 
 	/* clocks are setup late during boot in the case of DT */
 	sh73a0_clock_init();
@@ -783,7 +783,7 @@ void __init sh73a0_add_standard_devices_dt(void)
 			     ARRAY_SIZE(sh73a0_devices_dt));
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
-	/* Instantiate cpufreq-cpu0 */
+	/* Instantiate cpufreq-generic */
 	platform_device_register_full(&devinfo);
 }
 
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 31a6fa4..79f3c61 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -104,7 +104,7 @@ static int __init zynq_get_revision(void)
  */
 static void __init zynq_init_machine(void)
 {
-	struct platform_device_info devinfo = { .name = "cpufreq-cpu0", };
+	struct platform_device_info devinfo = { .name = "cpufreq-generic", };
 	struct soc_device_attribute *soc_dev_attr;
 	struct soc_device *soc_dev;
 	struct device *parent = NULL;
diff --git a/drivers/cpufreq/cpufreq-generic.c b/drivers/cpufreq/cpufreq-generic.c
index ac8fd9f..d47b4a3 100644
--- a/drivers/cpufreq/cpufreq-generic.c
+++ b/drivers/cpufreq/cpufreq-generic.c
@@ -380,7 +380,7 @@ static int generic_cpufreq_remove(struct platform_device *pdev)
 
 static struct platform_driver generic_cpufreq_platdrv = {
 	.driver = {
-		.name	= "cpufreq-cpu0",
+		.name	= "cpufreq-generic",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= generic_cpufreq_probe,
diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
index 351a207..7bbe5ef 100644
--- a/drivers/cpufreq/exynos4x12-cpufreq.c
+++ b/drivers/cpufreq/exynos4x12-cpufreq.c
@@ -174,7 +174,7 @@ int exynos4x12_cpufreq_init(struct exynos_dvfs_info *info)
 	 * dependencies on platform headers. It is necessary to enable
 	 * Exynos multi-platform support and will be removed together with
 	 * this whole driver as soon as Exynos gets migrated to use
-	 * cpufreq-cpu0 driver.
+	 * cpufreq-generic driver.
 	 */
 	np = of_find_compatible_node(NULL, NULL, "samsung,exynos4412-clock");
 	if (!np) {
diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index bf8902a..dc7a9ab 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -6,7 +6,7 @@
  * published by the Free Software Foundation.
  *
  * This driver provides the clk notifier callbacks that are used when
- * the cpufreq-cpu0 driver changes to frequency to alert the highbank
+ * the cpufreq-generic driver changes to frequency to alert the highbank
  * EnergyCore Management Engine (ECME) about the need to change
  * voltage. The ECME interfaces with the actual voltage regulators.
  */
@@ -60,7 +60,7 @@ static struct notifier_block hb_cpufreq_clk_nb = {
 
 static int hb_cpufreq_driver_init(void)
 {
-	struct platform_device_info devinfo = { .name = "cpufreq-cpu0", };
+	struct platform_device_info devinfo = { .name = "cpufreq-generic", };
 	struct device *cpu_dev;
 	struct clk *cpu_clk;
 	struct device_node *np;
@@ -95,7 +95,7 @@ static int hb_cpufreq_driver_init(void)
 		goto out_put_node;
 	}
 
-	/* Instantiate cpufreq-cpu0 */
+	/* Instantiate cpufreq-generic */
 	platform_device_register_full(&devinfo);
 
 out_put_node:
-- 
2.0.0.rc2


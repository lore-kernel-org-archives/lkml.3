Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3E0HpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 03:45:25 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9573 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3E0HpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 03:45:21 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2013 03:45:21 EDT
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 27 May 2013 00:40:16 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH v2] clk: tegra: Use common of_clk_init function
Date: Mon, 27 May 2013 13:10:09 +0530
Message-ID: <1369640409-1981-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common of_clk_init() function for clocks initialization.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---

Included initialization for T114 in V2.

---
 arch/arm/mach-tegra/common.c     |    4 ++--
 drivers/clk/tegra/clk-tegra114.c |    3 ++-
 drivers/clk/tegra/clk-tegra20.c  |    3 ++-
 drivers/clk/tegra/clk-tegra30.c  |    3 ++-
 drivers/clk/tegra/clk.c          |   12 ------------
 drivers/clk/tegra/clk.h          |   18 ------------------
 include/linux/clk/tegra.h        |    1 -
 7 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 9f852c6..95ce2a0 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -23,7 +23,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/irqchip.h>
-#include <linux/clk/tegra.h>
+#include <linux/clk-provider.h>
 
 #include <asm/hardware/cache-l2x0.h>
 
@@ -59,7 +59,7 @@ u32 tegra_uart_config[4] = {
 #ifdef CONFIG_OF
 void __init tegra_dt_init_irq(void)
 {
-	tegra_clocks_init();
+	of_clk_init(NULL);
 	tegra_pmc_init();
 	tegra_init_irq();
 	irqchip_init();
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index d78e16e..e0ee077 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -2030,7 +2030,7 @@ static void __init tegra114_clock_apply_init_table(void)
 	tegra_init_from_table(init_table, clks, clk_max);
 }
 
-void __init tegra114_clock_init(struct device_node *np)
+static void __init tegra114_clock_init(struct device_node *np)
 {
 	struct device_node *node;
 	int i;
@@ -2083,3 +2083,4 @@ void __init tegra114_clock_init(struct device_node *np)
 
 	tegra_cpu_car_ops = &tegra114_cpu_car_ops;
 }
+CLK_OF_DECLARE(tegra114, "nvidia,tegra114-car", tegra114_clock_init);
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 8292a00..a25e07c 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1282,7 +1282,7 @@ static const struct of_device_id pmc_match[] __initconst = {
 	{},
 };
 
-void __init tegra20_clock_init(struct device_node *np)
+static void __init tegra20_clock_init(struct device_node *np)
 {
 	int i;
 	struct device_node *node;
@@ -1334,3 +1334,4 @@ void __init tegra20_clock_init(struct device_node *np)
 
 	tegra_cpu_car_ops = &tegra20_cpu_car_ops;
 }
+CLK_OF_DECLARE(tegra20, "nvidia,tegra20-car", tegra20_clock_init);
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index c6921f5..985ad69 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1953,7 +1953,7 @@ static const struct of_device_id pmc_match[] __initconst = {
 	{},
 };
 
-void __init tegra30_clock_init(struct device_node *np)
+static void __init tegra30_clock_init(struct device_node *np)
 {
 	struct device_node *node;
 	int i;
@@ -2004,3 +2004,4 @@ void __init tegra30_clock_init(struct device_node *np)
 
 	tegra_cpu_car_ops = &tegra30_cpu_car_ops;
 }
+CLK_OF_DECLARE(tegra30, "nvidia,tegra30-car", tegra30_clock_init);
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 923ca7e..86581ac 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -74,18 +74,6 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
 	}
 }
 
-static const struct of_device_id tegra_dt_clk_match[] = {
-	{ .compatible = "nvidia,tegra20-car", .data = tegra20_clock_init },
-	{ .compatible = "nvidia,tegra30-car", .data = tegra30_clock_init },
-	{ .compatible = "nvidia,tegra114-car", .data = tegra114_clock_init },
-	{ }
-};
-
-void __init tegra_clocks_init(void)
-{
-	of_clk_init(tegra_dt_clk_match);
-}
-
 tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
 
 void __init tegra_clocks_apply_init_table(void)
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index e056562..11278a8 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -571,24 +571,6 @@ void tegra_init_from_table(struct tegra_clk_init_table *tbl,
 void tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 		struct clk *clks[], int clk_max);
 
-#ifdef CONFIG_ARCH_TEGRA_2x_SOC
-void tegra20_clock_init(struct device_node *np);
-#else
-static inline void tegra20_clock_init(struct device_node *np) {}
-#endif /* CONFIG_ARCH_TEGRA_2x_SOC */
-
-#ifdef CONFIG_ARCH_TEGRA_3x_SOC
-void tegra30_clock_init(struct device_node *np);
-#else
-static inline void tegra30_clock_init(struct device_node *np) {}
-#endif /* CONFIG_ARCH_TEGRA_3x_SOC */
-
-#ifdef CONFIG_ARCH_TEGRA_114_SOC
-void tegra114_clock_init(struct device_node *np);
-#else
-static inline void tegra114_clock_init(struct device_node *np) {}
-#endif /* CONFIG_ARCH_TEGRA114_SOC */
-
 typedef void (*tegra_clk_apply_init_table_func)(void);
 extern tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
 
diff --git a/include/linux/clk/tegra.h b/include/linux/clk/tegra.h
index 642789b..3670a4f 100644
--- a/include/linux/clk/tegra.h
+++ b/include/linux/clk/tegra.h
@@ -122,7 +122,6 @@ static inline void tegra_cpu_clock_resume(void)
 
 void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
-void tegra_clocks_init(void);
 void tegra_clocks_apply_init_table(void);
 
 #endif /* __LINUX_CLK_TEGRA_H_ */
-- 
1.7.4.1


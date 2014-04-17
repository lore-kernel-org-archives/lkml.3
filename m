Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaDQIxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:53:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54394 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751520AbaDQIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:50:10 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v6 3/8] ARM: sunxi: Move the clock protection to machine hooks
Date: Thu, 17 Apr 2014 10:46:14 +0200
Message-Id: <1397724379-15398-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we start to have a lot of clocks to protect, some of them in a few boards
only, it becomes difficult to handle the clock protection without having to add
per machine exceptions.

Move these where they belong, in the machine definition code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/sun4i.c   |  9 +++++++++
 arch/arm/mach-sunxi/sun5i.c   | 14 ++++++++++++++
 arch/arm/mach-sunxi/sun7i.c   | 14 ++++++++++++++
 drivers/clk/sunxi/clk-sunxi.c | 24 ------------------------
 4 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-sunxi/sun4i.c b/arch/arm/mach-sunxi/sun4i.c
index fc28b89b3378..3276e63587fb 100644
--- a/arch/arm/mach-sunxi/sun4i.c
+++ b/arch/arm/mach-sunxi/sun4i.c
@@ -10,6 +10,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/of_platform.h>
 
@@ -19,9 +20,17 @@
 
 static void __init sun4i_dt_init(void)
 {
+	struct clk *clk;
+
 	sunxi_setup_restart();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	/* Make sure the clocks we absolutely need are enabled */
+	/* DDR clock */
+	clk = clk_get(NULL, "pll5_ddr");
+	if (!IS_ERR(clk))
+		clk_prepare_enable(clk);
 }
 
 static const char * const sun4i_board_dt_compat[] = {
diff --git a/arch/arm/mach-sunxi/sun5i.c b/arch/arm/mach-sunxi/sun5i.c
index 623a95ad93b7..990dcfd42681 100644
--- a/arch/arm/mach-sunxi/sun5i.c
+++ b/arch/arm/mach-sunxi/sun5i.c
@@ -10,6 +10,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/of_platform.h>
 
@@ -19,9 +20,22 @@
 
 static void __init sun5i_dt_init(void)
 {
+	struct clk *clk;
+
 	sunxi_setup_restart();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	/* Make sure the clocks we absolutely need are enabled */
+	/* Memory bus clock */
+	clk = clk_get(NULL, "mbus");
+	if (!IS_ERR(clk))
+		clk_prepare_enable(clk);
+
+	/* DDR clock */
+	clk = clk_get(NULL, "pll5_ddr");
+	if (!IS_ERR(clk))
+		clk_prepare_enable(clk);
 }
 
 static const char * const sun5i_board_dt_compat[] = {
diff --git a/arch/arm/mach-sunxi/sun7i.c b/arch/arm/mach-sunxi/sun7i.c
index 2e6a8ee1966b..48a090b91a90 100644
--- a/arch/arm/mach-sunxi/sun7i.c
+++ b/arch/arm/mach-sunxi/sun7i.c
@@ -10,6 +10,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/of_platform.h>
 
@@ -19,9 +20,22 @@
 
 static void __init sun7i_dt_init(void)
 {
+	struct clk *clk;
+
 	sunxi_setup_restart();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	/* Make sure the clocks we absolutely need are enabled */
+	/* Memory bus clock */
+	clk = clk_get(NULL, "mbus");
+	if (!IS_ERR(clk))
+		clk_prepare_enable(clk);
+
+	/* DDR clock */
+	clk = clk_get(NULL, "pll5_ddr");
+	if (!IS_ERR(clk))
+		clk_prepare_enable(clk);
 }
 
 static const char * const sun7i_board_dt_compat[] = {
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index b1fde0f89bc1..b06200079f06 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -1285,27 +1285,6 @@ static void __init of_sunxi_table_clock_setup(const struct of_device_id *clk_mat
 	}
 }
 
-/**
- * System clock protection
- *
- * By enabling these critical clocks, we prevent their accidental gating
- * by the framework
- */
-static void __init sunxi_clock_protect(void)
-{
-	struct clk *clk;
-
-	/* memory bus clock - sun5i+ */
-	clk = clk_get(NULL, "mbus");
-	if (!IS_ERR(clk))
-		clk_prepare_enable(clk);
-
-	/* DDR clock - sun4i+ */
-	clk = clk_get(NULL, "pll5_ddr");
-	if (!IS_ERR(clk))
-		clk_prepare_enable(clk);
-}
-
 static void __init sunxi_init_clocks(void)
 {
 	/* Register factor clocks */
@@ -1322,9 +1301,6 @@ static void __init sunxi_init_clocks(void)
 
 	/* Register gate clocks */
 	of_sunxi_table_clock_setup(clk_gates_match, sunxi_gates_clk_setup);
-
-	/* Enable core system clocks */
-	sunxi_clock_protect();
 }
 CLK_OF_DECLARE(sun4i_a10_clk_init, "allwinner,sun4i-a10", sunxi_init_clocks);
 CLK_OF_DECLARE(sun5i_a10s_clk_init, "allwinner,sun5i-a10s", sunxi_init_clocks);
-- 
1.9.1


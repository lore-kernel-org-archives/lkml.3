Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3KRNef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:34:35 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:39716 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3KRNd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:33:57 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -v2 10/10] mfd: Constify struct mfd_cell where possible
Date: Mon, 18 Nov 2013 14:33:06 +0100
Message-Id: <1384781586-4798-10-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
References: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 03e361b25ee8dfb1fd9b890072c23c4aae01c6c7 ("mfd: Stop setting
refcounting pointers in original mfd_cell arrays"), the "cell" parameter of
mfd_add_devices() is "const" again. Hence make all cell data passed to
mfd_add_devices() const where possible.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2: Split in groups

 drivers/mfd/ab8500-core.c         |   14 +++++++-------
 drivers/mfd/arizona-core.c        |    8 ++++----
 drivers/mfd/as3722.c              |    2 +-
 drivers/mfd/asic3.c               |    4 ++--
 drivers/mfd/cros_ec.c             |    2 +-
 drivers/mfd/db8500-prcmu.c        |    4 ++--
 drivers/mfd/htc-pasic3.c          |    2 +-
 drivers/mfd/jz4740-adc.c          |    2 +-
 drivers/mfd/lp8788.c              |    2 +-
 drivers/mfd/rc5t583.c             |    2 +-
 drivers/mfd/rdc321x-southbridge.c |    2 +-
 drivers/mfd/retu-mfd.c            |    6 +++---
 drivers/mfd/sec-core.c            |    8 ++++----
 drivers/mfd/timberdale.c          |   12 ++++++------
 drivers/mfd/viperboard.c          |    2 +-
 drivers/mfd/vx855.c               |    2 +-
 16 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index b6c2cdc76091..6788064ed899 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1017,7 +1017,7 @@ static struct resource ab8500_temp_resources[] = {
 	},
 };
 
-static struct mfd_cell ab8500_bm_devs[] = {
+static const struct mfd_cell ab8500_bm_devs[] = {
 	{
 		.name = "ab8500-charger",
 		.of_compatible = "stericsson,ab8500-charger",
@@ -1052,7 +1052,7 @@ static struct mfd_cell ab8500_bm_devs[] = {
 	},
 };
 
-static struct mfd_cell ab8500_devs[] = {
+static const struct mfd_cell ab8500_devs[] = {
 #ifdef CONFIG_DEBUG_FS
 	{
 		.name = "ab8500-debug",
@@ -1143,7 +1143,7 @@ static struct mfd_cell ab8500_devs[] = {
 	},
 };
 
-static struct mfd_cell ab9540_devs[] = {
+static const struct mfd_cell ab9540_devs[] = {
 #ifdef CONFIG_DEBUG_FS
 	{
 		.name = "ab8500-debug",
@@ -1214,7 +1214,7 @@ static struct mfd_cell ab9540_devs[] = {
 };
 
 /* Device list for ab8505  */
-static struct mfd_cell ab8505_devs[] = {
+static const struct mfd_cell ab8505_devs[] = {
 #ifdef CONFIG_DEBUG_FS
 	{
 		.name = "ab8500-debug",
@@ -1275,7 +1275,7 @@ static struct mfd_cell ab8505_devs[] = {
 	},
 };
 
-static struct mfd_cell ab8540_devs[] = {
+static const struct mfd_cell ab8540_devs[] = {
 #ifdef CONFIG_DEBUG_FS
 	{
 		.name = "ab8500-debug",
@@ -1339,7 +1339,7 @@ static struct mfd_cell ab8540_devs[] = {
 	},
 };
 
-static struct mfd_cell ab8540_cut1_devs[] = {
+static const struct mfd_cell ab8540_cut1_devs[] = {
 	{
 		.name = "ab8500-rtc",
 		.of_compatible = "stericsson,ab8500-rtc",
@@ -1348,7 +1348,7 @@ static struct mfd_cell ab8540_cut1_devs[] = {
 	},
 };
 
-static struct mfd_cell ab8540_cut2_devs[] = {
+static const struct mfd_cell ab8540_cut2_devs[] = {
 	{
 		.name = "ab8540-rtc",
 		.of_compatible = "stericsson,ab8540-rtc",
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 75e180ceecf3..a45aab9f6bb1 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -565,7 +565,7 @@ static inline int arizona_of_get_core_pdata(struct arizona *arizona)
 }
 #endif
 
-static struct mfd_cell early_devs[] = {
+static const struct mfd_cell early_devs[] = {
 	{ .name = "arizona-ldo1" },
 };
 
@@ -577,7 +577,7 @@ static const char *wm5102_supplies[] = {
 	"SPKVDDR",
 };
 
-static struct mfd_cell wm5102_devs[] = {
+static const struct mfd_cell wm5102_devs[] = {
 	{ .name = "arizona-micsupp" },
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
@@ -590,7 +590,7 @@ static struct mfd_cell wm5102_devs[] = {
 	},
 };
 
-static struct mfd_cell wm5110_devs[] = {
+static const struct mfd_cell wm5110_devs[] = {
 	{ .name = "arizona-micsupp" },
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
@@ -609,7 +609,7 @@ static const char *wm8997_supplies[] = {
 	"SPKVDD",
 };
 
-static struct mfd_cell wm8997_devs[] = {
+static const struct mfd_cell wm8997_devs[] = {
 	{ .name = "arizona-micsupp" },
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
diff --git a/drivers/mfd/as3722.c b/drivers/mfd/as3722.c
index f161f2e00df7..2d9b728a19f8 100644
--- a/drivers/mfd/as3722.c
+++ b/drivers/mfd/as3722.c
@@ -54,7 +54,7 @@ static const struct resource as3722_adc_resource[] = {
 	},
 };
 
-static struct mfd_cell as3722_devs[] = {
+static const struct mfd_cell as3722_devs[] = {
 	{
 		.name = "as3722-pinctrl",
 	},
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index fa22154c84e4..9f6294f2a070 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -695,7 +695,7 @@ static int ds1wm_disable(struct platform_device *pdev)
 	return 0;
 }
 
-static struct mfd_cell asic3_cell_ds1wm = {
+static const struct mfd_cell asic3_cell_ds1wm = {
 	.name          = "ds1wm",
 	.enable        = ds1wm_enable,
 	.disable       = ds1wm_disable,
@@ -797,7 +797,7 @@ static int asic3_mmc_disable(struct platform_device *pdev)
 	return 0;
 }
 
-static struct mfd_cell asic3_cell_mmc = {
+static const struct mfd_cell asic3_cell_mmc = {
 	.name          = "tmio-mmc",
 	.enable        = asic3_mmc_enable,
 	.disable       = asic3_mmc_disable,
diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
index 1f36885d674b..783fe2e73e1e 100644
--- a/drivers/mfd/cros_ec.c
+++ b/drivers/mfd/cros_ec.c
@@ -84,7 +84,7 @@ static irqreturn_t ec_irq_thread(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static struct mfd_cell cros_devs[] = {
+static const struct mfd_cell cros_devs[] = {
 	{
 		.name = "cros-ec-keyb",
 		.id = 1,
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index b9ce60c301de..e43e6e821117 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3070,7 +3070,7 @@ static struct db8500_thsens_platform_data db8500_thsens_data = {
 	.num_trips = 4,
 };
 
-static struct mfd_cell common_prcmu_devs[] = {
+static const struct mfd_cell common_prcmu_devs[] = {
 	{
 		.name = "ux500_wdt",
 		.platform_data = &db8500_wdt_pdata,
@@ -3079,7 +3079,7 @@ static struct mfd_cell common_prcmu_devs[] = {
 	},
 };
 
-static struct mfd_cell db8500_prcmu_devs[] = {
+static const struct mfd_cell db8500_prcmu_devs[] = {
 	{
 		.name = "db8500-prcmu-regulators",
 		.of_compatible = "stericsson,db8500-prcmu-regulator",
diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 6bf92a507b95..e88d4f6fef4c 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -114,7 +114,7 @@ static struct resource ds1wm_resources[] __initdata = {
 	},
 };
 
-static struct mfd_cell ds1wm_cell __initdata = {
+static const struct mfd_cell ds1wm_cell __initconst = {
 	.name          = "ds1wm",
 	.enable        = ds1wm_enable,
 	.disable       = ds1wm_disable,
diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 3c0e8cf6916b..7a51c0d0d4f1 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -181,7 +181,7 @@ static struct resource jz4740_battery_resources[] = {
 	},
 };
 
-static struct mfd_cell jz4740_adc_cells[] = {
+static const struct mfd_cell jz4740_adc_cells[] = {
 	{
 		.id = 0,
 		.name = "jz4740-hwmon",
diff --git a/drivers/mfd/lp8788.c b/drivers/mfd/lp8788.c
index 0f1221911018..a30bc15fe5ba 100644
--- a/drivers/mfd/lp8788.c
+++ b/drivers/mfd/lp8788.c
@@ -71,7 +71,7 @@ static struct resource rtc_irqs[] = {
 	},
 };
 
-static struct mfd_cell lp8788_devs[] = {
+static const struct mfd_cell lp8788_devs[] = {
 	/* 4 bucks */
 	MFD_DEV_WITH_ID(BUCK, 1),
 	MFD_DEV_WITH_ID(BUCK, 2),
diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index 346330176afc..df276ad9f40b 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -74,7 +74,7 @@ static struct deepsleep_control_data deepsleep_data[] = {
 #define EXT_PWR_REQ		\
 	(RC5T583_EXT_PWRREQ1_CONTROL | RC5T583_EXT_PWRREQ2_CONTROL)
 
-static struct mfd_cell rc5t583_subdevs[] = {
+static const struct mfd_cell rc5t583_subdevs[] = {
 	{.name = "rc5t583-gpio",},
 	{.name = "rc5t583-regulator",},
 	{.name = "rc5t583-rtc",      },
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index 21b7bef73507..aab63ee043e3 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -56,7 +56,7 @@ static struct resource rdc321x_gpio_resources[] = {
 	}
 };
 
-static struct mfd_cell rdc321x_sb_cells[] = {
+static const struct mfd_cell rdc321x_sb_cells[] = {
 	{
 		.name		= "rdc321x-wdt",
 		.resources	= rdc321x_wdt_resource,
diff --git a/drivers/mfd/retu-mfd.c b/drivers/mfd/retu-mfd.c
index a1830986eeb7..c8f345f7e9a2 100644
--- a/drivers/mfd/retu-mfd.c
+++ b/drivers/mfd/retu-mfd.c
@@ -55,7 +55,7 @@ static struct resource retu_pwrbutton_res[] = {
 	},
 };
 
-static struct mfd_cell retu_devs[] = {
+static const struct mfd_cell retu_devs[] = {
 	{
 		.name		= "retu-wdt"
 	},
@@ -94,7 +94,7 @@ static struct resource tahvo_usb_res[] = {
 	},
 };
 
-static struct mfd_cell tahvo_devs[] = {
+static const struct mfd_cell tahvo_devs[] = {
 	{
 		.name		= "tahvo-usb",
 		.resources	= tahvo_usb_res,
@@ -122,7 +122,7 @@ static const struct retu_data {
 	char			*chip_name;
 	char			*companion_name;
 	struct regmap_irq_chip	*irq_chip;
-	struct mfd_cell		*children;
+	const struct mfd_cell	*children;
 	int			nchildren;
 } retu_data[] = {
 	[0] = {
diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 34c18fb8c089..f9c6a7d3b6a8 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -31,7 +31,7 @@
 #include <linux/mfd/samsung/s5m8767.h>
 #include <linux/regmap.h>
 
-static struct mfd_cell s5m8751_devs[] = {
+static const struct mfd_cell s5m8751_devs[] = {
 	{
 		.name = "s5m8751-pmic",
 	}, {
@@ -41,7 +41,7 @@ static struct mfd_cell s5m8751_devs[] = {
 	},
 };
 
-static struct mfd_cell s5m8763_devs[] = {
+static const struct mfd_cell s5m8763_devs[] = {
 	{
 		.name = "s5m8763-pmic",
 	}, {
@@ -51,7 +51,7 @@ static struct mfd_cell s5m8763_devs[] = {
 	},
 };
 
-static struct mfd_cell s5m8767_devs[] = {
+static const struct mfd_cell s5m8767_devs[] = {
 	{
 		.name = "s5m8767-pmic",
 	}, {
@@ -59,7 +59,7 @@ static struct mfd_cell s5m8767_devs[] = {
 	},
 };
 
-static struct mfd_cell s2mps11_devs[] = {
+static const struct mfd_cell s2mps11_devs[] = {
 	{
 		.name = "s2mps11-pmic",
 	}, {
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index dbb34f94e5e3..c6668ac70af3 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -374,7 +374,7 @@ static const struct resource timberdale_dma_resources[] = {
 	},
 };
 
-static struct mfd_cell timberdale_cells_bar0_cfg0[] = {
+static const struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 	{
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
@@ -431,7 +431,7 @@ static struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 	},
 };
 
-static struct mfd_cell timberdale_cells_bar0_cfg1[] = {
+static const struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 	{
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
@@ -498,7 +498,7 @@ static struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 	},
 };
 
-static struct mfd_cell timberdale_cells_bar0_cfg2[] = {
+static const struct mfd_cell timberdale_cells_bar0_cfg2[] = {
 	{
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
@@ -548,7 +548,7 @@ static struct mfd_cell timberdale_cells_bar0_cfg2[] = {
 	},
 };
 
-static struct mfd_cell timberdale_cells_bar0_cfg3[] = {
+static const struct mfd_cell timberdale_cells_bar0_cfg3[] = {
 	{
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
@@ -619,7 +619,7 @@ static const struct resource timberdale_sdhc_resources[] = {
 	},
 };
 
-static struct mfd_cell timberdale_cells_bar1[] = {
+static const struct mfd_cell timberdale_cells_bar1[] = {
 	{
 		.name = "sdhci",
 		.num_resources = ARRAY_SIZE(timberdale_sdhc_resources),
@@ -627,7 +627,7 @@ static struct mfd_cell timberdale_cells_bar1[] = {
 	},
 };
 
-static struct mfd_cell timberdale_cells_bar2[] = {
+static const struct mfd_cell timberdale_cells_bar2[] = {
 	{
 		.name = "sdhci",
 		.num_resources = ARRAY_SIZE(timberdale_sdhc_resources),
diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index af2a6703f34f..e00f5340ed87 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -37,7 +37,7 @@ static const struct usb_device_id vprbrd_table[] = {
 
 MODULE_DEVICE_TABLE(usb, vprbrd_table);
 
-static struct mfd_cell vprbrd_devs[] = {
+static const struct mfd_cell vprbrd_devs[] = {
 	{
 		.name = "viperboard-gpio",
 	},
diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
index 757ecc63338c..5cd5661158bc 100644
--- a/drivers/mfd/vx855.c
+++ b/drivers/mfd/vx855.c
@@ -60,7 +60,7 @@ static struct resource vx855_gpio_resources[] = {
 	},
 };
 
-static struct mfd_cell vx855_cells[] = {
+static const struct mfd_cell vx855_cells[] = {
 	{
 		.name = "vx855_gpio",
 		.num_resources = ARRAY_SIZE(vx855_gpio_resources),
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3KRM5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 07:57:39 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:40390 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3KRM5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 07:57:32 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mfd: Constify struct mfd_cell where possible
Date: Mon, 18 Nov 2013 13:57:29 +0100
Message-Id: <1384779449-1888-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 03e361b25ee8dfb1fd9b890072c23c4aae01c6c7 ("mfd: Stop setting
refcounting pointers in original mfd_cell arrays"), the "cell" parameter of
mfd_add_devices() is "const" again. Hence make all cell data passed to
mfd_add_devices() const where possible.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Compile tested:
  - cs5535-mfd, intel_msic, and sta2x11-mfd for x86,
  - all other drivers for arm.

 drivers/mfd/88pm800.c             |    4 ++--
 drivers/mfd/88pm805.c             |    2 +-
 drivers/mfd/ab8500-core.c         |   14 +++++++-------
 drivers/mfd/arizona-core.c        |    8 ++++----
 drivers/mfd/as3722.c              |    2 +-
 drivers/mfd/asic3.c               |    4 ++--
 drivers/mfd/cros_ec.c             |    2 +-
 drivers/mfd/da9052-core.c         |    2 +-
 drivers/mfd/da9055-core.c         |    2 +-
 drivers/mfd/da9063-core.c         |    2 +-
 drivers/mfd/db8500-prcmu.c        |    4 ++--
 drivers/mfd/htc-pasic3.c          |    2 +-
 drivers/mfd/intel_msic.c          |    2 +-
 drivers/mfd/jz4740-adc.c          |    2 +-
 drivers/mfd/lp8788.c              |    2 +-
 drivers/mfd/max77686.c            |    2 +-
 drivers/mfd/max77693.c            |    2 +-
 drivers/mfd/max8907.c             |    2 +-
 drivers/mfd/max8925-core.c        |    8 ++++----
 drivers/mfd/max8997.c             |    2 +-
 drivers/mfd/max8998.c             |    4 ++--
 drivers/mfd/rc5t583.c             |    2 +-
 drivers/mfd/rdc321x-southbridge.c |    2 +-
 drivers/mfd/retu-mfd.c            |    6 +++---
 drivers/mfd/sec-core.c            |    8 ++++----
 drivers/mfd/stmpe.c               |   10 +++++-----
 drivers/mfd/stmpe.h               |    2 +-
 drivers/mfd/tc3589x.c             |    4 ++--
 drivers/mfd/tc6387xb.c            |    2 +-
 drivers/mfd/timberdale.c          |   12 ++++++------
 drivers/mfd/tps6507x.c            |    2 +-
 drivers/mfd/tps65090.c            |    2 +-
 drivers/mfd/tps65217.c            |    2 +-
 drivers/mfd/tps6586x.c            |    2 +-
 drivers/mfd/tps65910.c            |    2 +-
 drivers/mfd/tps65912-core.c       |    2 +-
 drivers/mfd/tps80031.c            |    2 +-
 drivers/mfd/viperboard.c          |    2 +-
 drivers/mfd/vx855.c               |    2 +-
 drivers/mfd/wm831x-core.c         |   14 +++++++-------
 drivers/mfd/wm8994-core.c         |    4 ++--
 drivers/staging/nvec/nvec.c       |    2 +-
 42 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index a65447d65605..7dca1e640970 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -148,7 +148,7 @@ static struct resource onkey_resources[] = {
 	 },
 };
 
-static struct mfd_cell onkey_devs[] = {
+static const struct mfd_cell onkey_devs[] = {
 	{
 	 .name = "88pm80x-onkey",
 	 .num_resources = 1,
@@ -157,7 +157,7 @@ static struct mfd_cell onkey_devs[] = {
 	 },
 };
 
-static struct mfd_cell regulator_devs[] = {
+static const struct mfd_cell regulator_devs[] = {
 	{
 	 .name = "88pm80x-regulator",
 	 .id = -1,
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 8a5b6ffb5afb..64751c2a1ace 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -77,7 +77,7 @@ static struct resource codec_resources[] = {
 	 },
 };
 
-static struct mfd_cell codec_devs[] = {
+static const struct mfd_cell codec_devs[] = {
 	{
 	 .name = "88pm80x-codec",
 	 .num_resources = ARRAY_SIZE(codec_resources),
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
diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index ea28a33576e4..25838f10b35b 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -427,7 +427,7 @@ int da9052_adc_read_temp(struct da9052 *da9052)
 }
 EXPORT_SYMBOL_GPL(da9052_adc_read_temp);
 
-static struct mfd_cell da9052_subdev_info[] = {
+static const struct mfd_cell da9052_subdev_info[] = {
 	{
 		.name = "da9052-regulator",
 		.id = 1,
diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index d3670cd3c3c6..caf8dcffd0ad 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -294,7 +294,7 @@ static struct resource da9055_ld05_6_resource = {
 	.flags = IORESOURCE_IRQ,
 };
 
-static struct mfd_cell da9055_devs[] = {
+static const struct mfd_cell da9055_devs[] = {
 	{
 		.of_compatible = "dialog,da9055-gpio",
 		.name = "da9055-gpio",
diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index c9cf8d988406..26937cd01071 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -75,7 +75,7 @@ static struct resource da9063_hwmon_resources[] = {
 };
 
 
-static struct mfd_cell da9063_devs[] = {
+static const struct mfd_cell da9063_devs[] = {
 	{
 		.name		= DA9063_DRVNAME_REGULATORS,
 		.num_resources	= ARRAY_SIZE(da9063_regulators_resources),
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
diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index 9203d47cdbb1..049fd23af54a 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -178,7 +178,7 @@ static struct mfd_cell msic_devs[] = {
  * These devices appear only after the MSIC driver itself is initialized so
  * we can guarantee that the SCU IPC interface is ready.
  */
-static struct mfd_cell msic_other_devs[] = {
+static const struct mfd_cell msic_other_devs[] = {
 	/* Audio codec in the MSIC */
 	{
 		.id			= -1,
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
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 34520cbe8afb..fb0848544b76 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -35,7 +35,7 @@
 
 #define I2C_ADDR_RTC	(0x0C >> 1)
 
-static struct mfd_cell max77686_devs[] = {
+static const struct mfd_cell max77686_devs[] = {
 	{ .name = "max77686-pmic", },
 	{ .name = "max77686-rtc", },
 	{ .name = "max77686-clk", },
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 9f92463f4f7e..a0093a839d4b 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -41,7 +41,7 @@
 #define I2C_ADDR_MUIC	(0x4A >> 1)
 #define I2C_ADDR_HAPTIC	(0x90 >> 1)
 
-static struct mfd_cell max77693_devs[] = {
+static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-pmic", },
 	{ .name = "max77693-charger", },
 	{ .name = "max77693-flash", },
diff --git a/drivers/mfd/max8907.c b/drivers/mfd/max8907.c
index 3bbfedc07f41..07740314b29d 100644
--- a/drivers/mfd/max8907.c
+++ b/drivers/mfd/max8907.c
@@ -22,7 +22,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
-static struct mfd_cell max8907_cells[] = {
+static const struct mfd_cell max8907_cells[] = {
 	{ .name = "max8907-regulator", },
 	{ .name = "max8907-rtc", },
 };
diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index f0cc40296d8c..f3faf0c45ddd 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -45,7 +45,7 @@ static struct resource touch_resources[] = {
 	},
 };
 
-static struct mfd_cell touch_devs[] = {
+static const struct mfd_cell touch_devs[] = {
 	{
 		.name		= "max8925-touch",
 		.num_resources	= 1,
@@ -63,7 +63,7 @@ static struct resource power_supply_resources[] = {
 	},
 };
 
-static struct mfd_cell power_devs[] = {
+static const struct mfd_cell power_devs[] = {
 	{
 		.name		= "max8925-power",
 		.num_resources	= 1,
@@ -81,7 +81,7 @@ static struct resource rtc_resources[] = {
 	},
 };
 
-static struct mfd_cell rtc_devs[] = {
+static const struct mfd_cell rtc_devs[] = {
 	{
 		.name		= "max8925-rtc",
 		.num_resources	= 1,
@@ -104,7 +104,7 @@ static struct resource onkey_resources[] = {
 	},
 };
 
-static struct mfd_cell onkey_devs[] = {
+static const struct mfd_cell onkey_devs[] = {
 	{
 		.name		= "max8925-onkey",
 		.num_resources	= 2,
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 791aea3e96ce..1b80e51c2e73 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -40,7 +40,7 @@
 #define I2C_ADDR_RTC	(0x0C >> 1)
 #define I2C_ADDR_HAPTIC	(0x90 >> 1)
 
-static struct mfd_cell max8997_devs[] = {
+static const struct mfd_cell max8997_devs[] = {
 	{ .name = "max8997-pmic", },
 	{ .name = "max8997-rtc", },
 	{ .name = "max8997-battery", },
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index fe6332dcabee..f47eaa70eae0 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -37,7 +37,7 @@
 
 #define RTC_I2C_ADDR		(0x0c >> 1)
 
-static struct mfd_cell max8998_devs[] = {
+static const struct mfd_cell max8998_devs[] = {
 	{
 		.name = "max8998-pmic",
 	}, {
@@ -47,7 +47,7 @@ static struct mfd_cell max8998_devs[] = {
 	},
 };
 
-static struct mfd_cell lp3974_devs[] = {
+static const struct mfd_cell lp3974_devs[] = {
 	{
 		.name = "lp3974-pmic",
 	}, {
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
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index fff63a41862c..42ccd0544513 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -297,14 +297,14 @@ static struct resource stmpe_gpio_resources[] = {
 	},
 };
 
-static struct mfd_cell stmpe_gpio_cell = {
+static const struct mfd_cell stmpe_gpio_cell = {
 	.name		= "stmpe-gpio",
 	.of_compatible	= "st,stmpe-gpio",
 	.resources	= stmpe_gpio_resources,
 	.num_resources	= ARRAY_SIZE(stmpe_gpio_resources),
 };
 
-static struct mfd_cell stmpe_gpio_cell_noirq = {
+static const struct mfd_cell stmpe_gpio_cell_noirq = {
 	.name		= "stmpe-gpio",
 	.of_compatible	= "st,stmpe-gpio",
 	/* gpio cell resources consist of an irq only so no resources here */
@@ -325,7 +325,7 @@ static struct resource stmpe_keypad_resources[] = {
 	},
 };
 
-static struct mfd_cell stmpe_keypad_cell = {
+static const struct mfd_cell stmpe_keypad_cell = {
 	.name		= "stmpe-keypad",
 	.of_compatible  = "st,stmpe-keypad",
 	.resources	= stmpe_keypad_resources,
@@ -409,7 +409,7 @@ static struct resource stmpe_ts_resources[] = {
 	},
 };
 
-static struct mfd_cell stmpe_ts_cell = {
+static const struct mfd_cell stmpe_ts_cell = {
 	.name		= "stmpe-ts",
 	.of_compatible	= "st,stmpe-ts",
 	.resources	= stmpe_ts_resources,
@@ -1064,7 +1064,7 @@ static int stmpe_chip_init(struct stmpe *stmpe)
 	return stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_ICR_LSB], icr);
 }
 
-static int stmpe_add_device(struct stmpe *stmpe, struct mfd_cell *cell)
+static int stmpe_add_device(struct stmpe *stmpe, const struct mfd_cell *cell)
 {
 	return mfd_add_devices(stmpe->dev, stmpe->pdata->id, cell, 1,
 			       NULL, stmpe->irq_base, stmpe->domain);
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index ff2b09ba8797..6639f1b0fef5 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -38,7 +38,7 @@ static inline void stmpe_dump_bytes(const char *str, const void *buf,
  *		enable and altfunc callbacks
  */
 struct stmpe_variant_block {
-	struct mfd_cell		*cell;
+	const struct mfd_cell	*cell;
 	int			irq;
 	enum stmpe_block	block;
 };
diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 87ea51dc6234..2cf636c267d9 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -155,7 +155,7 @@ static struct resource keypad_resources[] = {
 	},
 };
 
-static struct mfd_cell tc3589x_dev_gpio[] = {
+static const struct mfd_cell tc3589x_dev_gpio[] = {
 	{
 		.name		= "tc3589x-gpio",
 		.num_resources	= ARRAY_SIZE(gpio_resources),
@@ -164,7 +164,7 @@ static struct mfd_cell tc3589x_dev_gpio[] = {
 	},
 };
 
-static struct mfd_cell tc3589x_dev_keypad[] = {
+static const struct mfd_cell tc3589x_dev_keypad[] = {
 	{
 		.name           = "tc3589x-keypad",
 		.num_resources  = ARRAY_SIZE(keypad_resources),
diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index acd0f3a41044..591a331d8d83 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -126,7 +126,7 @@ static struct tmio_mmc_data tc6387xb_mmc_data = {
 
 /*--------------------------------------------------------------------------*/
 
-static struct mfd_cell tc6387xb_cells[] = {
+static const struct mfd_cell tc6387xb_cells[] = {
 	[TC6387XB_CELL_MMC] = {
 		.name = "tmio-mmc",
 		.enable = tc6387xb_mmc_enable,
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
diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index a081b925d10b..3b27482a174f 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -24,7 +24,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6507x.h>
 
-static struct mfd_cell tps6507x_devs[] = {
+static const struct mfd_cell tps6507x_devs[] = {
 	{
 		.name = "tps6507x-pmic",
 	},
diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index e6f03a733879..ba1a25d758c1 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -64,7 +64,7 @@ static struct resource charger_resources[] = {
 	}
 };
 
-static struct mfd_cell tps65090s[] = {
+static const struct mfd_cell tps65090s[] = {
 	{
 		.name = "tps65090-pmic",
 	},
diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index b7be0b295575..6939ae56c2e1 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -30,7 +30,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps65217.h>
 
-static struct mfd_cell tps65217s[] = {
+static const struct mfd_cell tps65217s[] = {
 	{
 		.name = "tps65217-pmic",
 	},
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index ee61fd7c198d..d0e57934370f 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -103,7 +103,7 @@ static struct resource tps6586x_rtc_resources[] = {
 	},
 };
 
-static struct mfd_cell tps6586x_cell[] = {
+static const struct mfd_cell tps6586x_cell[] = {
 	{
 		.name = "tps6586x-gpio",
 	},
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index c0f608e3ca9e..1f142d76cbbc 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -36,7 +36,7 @@ static struct resource rtc_resources[] = {
 	}
 };
 
-static struct mfd_cell tps65910s[] = {
+static const struct mfd_cell tps65910s[] = {
 	{
 		.name = "tps65910-gpio",
 	},
diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
index 925a044cbdf6..27a518e0eec6 100644
--- a/drivers/mfd/tps65912-core.c
+++ b/drivers/mfd/tps65912-core.c
@@ -21,7 +21,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps65912.h>
 
-static struct mfd_cell tps65912s[] = {
+static const struct mfd_cell tps65912s[] = {
 	{
 		.name = "tps65912-pmic",
 	},
diff --git a/drivers/mfd/tps80031.c b/drivers/mfd/tps80031.c
index f15ee6d5cfbf..ed6c5b0956e2 100644
--- a/drivers/mfd/tps80031.c
+++ b/drivers/mfd/tps80031.c
@@ -44,7 +44,7 @@ static struct resource tps80031_rtc_resources[] = {
 };
 
 /* TPS80031 sub mfd devices */
-static struct mfd_cell tps80031_cell[] = {
+static const struct mfd_cell tps80031_cell[] = {
 	{
 		.name = "tps80031-pmic",
 	},
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
diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 5c459f469224..28366a90e1ad 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1011,7 +1011,7 @@ static struct resource wm831x_wdt_resources[] = {
 	},
 };
 
-static struct mfd_cell wm8310_devs[] = {
+static const struct mfd_cell wm8310_devs[] = {
 	{
 		.name = "wm831x-backup",
 	},
@@ -1165,7 +1165,7 @@ static struct mfd_cell wm8310_devs[] = {
 	},
 };
 
-static struct mfd_cell wm8311_devs[] = {
+static const struct mfd_cell wm8311_devs[] = {
 	{
 		.name = "wm831x-backup",
 	},
@@ -1295,7 +1295,7 @@ static struct mfd_cell wm8311_devs[] = {
 	},
 };
 
-static struct mfd_cell wm8312_devs[] = {
+static const struct mfd_cell wm8312_devs[] = {
 	{
 		.name = "wm831x-backup",
 	},
@@ -1449,7 +1449,7 @@ static struct mfd_cell wm8312_devs[] = {
 	},
 };
 
-static struct mfd_cell wm8320_devs[] = {
+static const struct mfd_cell wm8320_devs[] = {
 	{
 		.name = "wm831x-backup",
 	},
@@ -1578,7 +1578,7 @@ static struct mfd_cell wm8320_devs[] = {
 	},
 };
 
-static struct mfd_cell touch_devs[] = {
+static const struct mfd_cell touch_devs[] = {
 	{
 		.name = "wm831x-touch",
 		.num_resources = ARRAY_SIZE(wm831x_touch_resources),
@@ -1586,7 +1586,7 @@ static struct mfd_cell touch_devs[] = {
 	},
 };
 
-static struct mfd_cell rtc_devs[] = {
+static const struct mfd_cell rtc_devs[] = {
 	{
 		.name = "wm831x-rtc",
 		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
@@ -1594,7 +1594,7 @@ static struct mfd_cell rtc_devs[] = {
 	},
 };
 
-static struct mfd_cell backlight_devs[] = {
+static const struct mfd_cell backlight_devs[] = {
 	{
 		.name = "wm831x-backlight",
 	},
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 030827511667..ba04f1bc70eb 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -33,7 +33,7 @@
 
 #include "wm8994.h"
 
-static struct mfd_cell wm8994_regulator_devs[] = {
+static const struct mfd_cell wm8994_regulator_devs[] = {
 	{
 		.name = "wm8994-ldo",
 		.id = 1,
@@ -62,7 +62,7 @@ static struct resource wm8994_gpio_resources[] = {
 	},
 };
 
-static struct mfd_cell wm8994_devs[] = {
+static const struct mfd_cell wm8994_devs[] = {
 	{
 		.name = "wm8994-codec",
 		.num_resources = ARRAY_SIZE(wm8994_codec_resources),
diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 3066ee2e753b..27d74134f187 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -83,7 +83,7 @@ enum nvec_sleep_subcmds {
 
 static struct nvec_chip *nvec_power_handle;
 
-static struct mfd_cell nvec_devices[] = {
+static const struct mfd_cell nvec_devices[] = {
 	{
 		.name = "nvec-kbd",
 		.id = 1,
-- 
1.7.9.5


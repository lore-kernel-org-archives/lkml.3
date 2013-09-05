Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3IEEQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:16:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22053 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab3IEEQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:16:06 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-56-52280582e729
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701cea9ee$609bfff0$21d3ffd0$%han@samsung.com>
In-reply-to: <000701cea9ee$609bfff0$21d3ffd0$%han@samsung.com>
Subject: [PATCH V2 1/6] backlight: lp855x_bl: support new LP8555 device
Date: Thu, 05 Sep 2013 13:16:02 +0900
Message-id: <000e01cea9ee$a1fa5050$e5eef0f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p7mBpdyq9ywYnR82rhDmFCL2hBAAAB3sw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zA90mVo0gg9XfjSzmrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	WxSXTUpqTmZZapG+XQJXxuLfr1gLfppVrHv6mb2B8aBOFyMnh4SAicStv92MELaYxIV769m6
	GLk4hASWMUpcf/SXEaZo54PbLBCJRYwSH/ZPZYZwfjFKvHg8nRWkik1ATeLLl8PsXYwcHCIC
	+hJtLRogNcwCWxklNn/czQoSFxKwlXi8kReknFPATmLp8ztMILawgLtE4/mLzCA2i4CqxJ1p
	X8HG8AKV96wTAQnzCghK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQcgkBdYlHf3VBwiICRhJn
	752FKheR2PfiHSPINRICH9kleqacZYdYJSDxbfIhFoheWYlNB5gh3pWUOLjiBssERolZSDbP
	QrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjJHYn7GC8d8D6EGMy0PqJ
	zFKiyfnA2M8riTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUA2ME46qTN+5MmH3zfL3F0TlH1T7z9G3xqngUy+dtcoN11/wbdY6mapp3rBNrzol8NDQP
	4Tz8euOB4CVutb/eTmOeeS7oWdMMnpeJZ6x6Z+mt6t6w5dbh5MPzA13N6xvSlr18Zl4rpJNy
	Mzmx5HPEaob+GyZlCivfXz8mW7XtmZbiyml/rk9wzJFRYinOSDTUYi4qTgQAt9FBI/MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAd0mVo0gg7uftS3mrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	W1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0B1K
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xozFv1+xFvw0q1j39DN7A+NB
	nS5GTg4JAROJnQ9us0DYYhIX7q1n62Lk4hASWMQo8WH/VGYI5xejxIvH01lBqtgE1CS+fDnM
	3sXIwSEioC/R1qIBUsMssJVRYvPH3awgcSEBW4nHG3lByjkF7CSWPr/DBGILC7hLNJ6/yAxi
	swioStyZ9hVsDC9Qec86EZAwr4CgxI/J98DuYRbQkli/8zgThC0vsXnNW2aQcgkBdYlHf3VB
	wiICRhJn752FKheR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtc
	mpeul5yfu4kRnBieSe1gXNlgcYhRgINRiYe3wVg9SIg1say4MvcQowQHs5IIr8VKoBBvSmJl
	VWpRfnxRaU5q8SHGZKA/JzJLiSbnA5NWXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNL
	UrNTUwtSi2C2MHFwSjUwyvHffNL1q7Su5vlFMx3BZyeUNnAaBJx8nO+hdqdTTk7xd/LuUrY6
	9r8XHW4JdZv96/p5QEzH2a71h7vpolmqq+emmL6x9JHWWx2b1GKWr82afi734rG10/e4b2l+
	WCS1dIn2jR4Wl9YV+8pVDmeKWVfOutS7df/r2+oP5ijLXz3A79PN8t9biaU4I9FQi7moOBEA
	/12slVADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milo Kim <milo.kim@ti.com>

LP8555 is one of LP855x family device.
This device needs pre_init_device() and post_init_device() driver structure.
It's same as LP8557, so the device configuration code is shared with LP8557.
Backlight outputs are generated from dual DC-DC boost converters.
It's configurable EPROM settings which are defined in the platform data.

Driver documentation and device tree bindings are updated.

Signed-off-by: Milo Kim <milo.kim@ti.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 Documentation/backlight/lp855x-driver.txt          |    5 ++--
 .../devicetree/bindings/video/backlight/lp855x.txt |   29 +++++++++++++++++++-
 drivers/video/backlight/Kconfig                    |    4 +--
 drivers/video/backlight/lp855x_bl.c                |   17 ++++++++++--
 include/linux/platform_data/lp855x.h               |   19 +++++++++++++
 5 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/Documentation/backlight/lp855x-driver.txt b/Documentation/backlight/lp855x-driver.txt
index 1c732f0..01bce24 100644
--- a/Documentation/backlight/lp855x-driver.txt
+++ b/Documentation/backlight/lp855x-driver.txt
@@ -4,7 +4,8 @@ Kernel driver lp855x
 Backlight driver for LP855x ICs
 
 Supported chips:
-	Texas Instruments LP8550, LP8551, LP8552, LP8553, LP8556 and LP8557
+	Texas Instruments LP8550, LP8551, LP8552, LP8553, LP8555, LP8556 and
+	LP8557
 
 Author: Milo(Woogyom) Kim <milo.kim@ti.com>
 
@@ -24,7 +25,7 @@ Value : pwm based or register based
 
 2) chip_id
 The lp855x chip id.
-Value : lp8550/lp8551/lp8552/lp8553/lp8556/lp8557
+Value : lp8550/lp8551/lp8552/lp8553/lp8555/lp8556/lp8557
 
 Platform data for lp855x
 ------------------------
diff --git a/Documentation/devicetree/bindings/video/backlight/lp855x.txt
b/Documentation/devicetree/bindings/video/backlight/lp855x.txt
index 1482103..96e83a5 100644
--- a/Documentation/devicetree/bindings/video/backlight/lp855x.txt
+++ b/Documentation/devicetree/bindings/video/backlight/lp855x.txt
@@ -2,7 +2,7 @@ lp855x bindings
 
 Required properties:
   - compatible: "ti,lp8550", "ti,lp8551", "ti,lp8552", "ti,lp8553",
-                "ti,lp8556", "ti,lp8557"
+                "ti,lp8555", "ti,lp8556", "ti,lp8557"
   - reg: I2C slave address (u8)
   - dev-ctrl: Value of DEVICE CONTROL register (u8). It depends on the device.
 
@@ -15,6 +15,33 @@ Optional properties:
 
 Example:
 
+	/* LP8555 */
+	backlight@2c {
+		compatible = "ti,lp8555";
+		reg = <0x2c>;
+
+		dev-ctrl = /bits/ 8 <0x00>;
+		pwm-period = <10000>;
+
+		/* 4V OV, 4 output LED0 string enabled */
+		rom_14h {
+			rom-addr = /bits/ 8 <0x14>;
+			rom-val = /bits/ 8 <0xcf>;
+		};
+
+		/* Heavy smoothing, 24ms ramp time step */
+		rom_15h {
+			rom-addr = /bits/ 8 <0x15>;
+			rom-val = /bits/ 8 <0xc7>;
+		};
+
+		/* 4 output LED1 string enabled */
+		rom_19h {
+			rom-addr = /bits/ 8 <0x19>;
+			rom-val = /bits/ 8 <0x0f>;
+		};
+	};
+
 	/* LP8556 */
 	backlight@2c {
 		compatible = "ti,lp8556";
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index d4a7a35..a65dd06 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -388,8 +388,8 @@ config BACKLIGHT_LP855X
 	tristate "Backlight driver for TI LP855X"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	help
-	  This supports TI LP8550, LP8551, LP8552, LP8553, LP8556 and LP8557
-	  backlight driver.
+	  This supports TI LP8550, LP8551, LP8552, LP8553, LP8555, LP8556 and
+	  LP8557 backlight driver.
 
 config BACKLIGHT_LP8788
 	tristate "Backlight driver for TI LP8788 MFD"
diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index c0b41f1..c952175 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -26,13 +26,15 @@
 #define LP8556_EPROM_START		0xA0
 #define LP8556_EPROM_END		0xAF
 
-/* LP8557 Registers */
+/* LP8555/7 Registers */
 #define LP8557_BL_CMD			0x00
 #define LP8557_BL_MASK			0x01
 #define LP8557_BL_ON			0x01
 #define LP8557_BL_OFF			0x00
 #define LP8557_BRIGHTNESS_CTRL		0x04
 #define LP8557_CONFIG			0x10
+#define LP8555_EPROM_START		0x10
+#define LP8555_EPROM_END		0x7A
 #define LP8557_EPROM_START		0x10
 #define LP8557_EPROM_END		0x1E
 
@@ -111,6 +113,10 @@ static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
 		start = LP8556_EPROM_START;
 		end = LP8556_EPROM_END;
 		break;
+	case LP8555:
+		start = LP8555_EPROM_START;
+		end = LP8555_EPROM_END;
+		break;
 	case LP8557:
 		start = LP8557_EPROM_START;
 		end = LP8557_EPROM_END;
@@ -165,9 +171,14 @@ static int lp855x_configure(struct lp855x *lp)
 	struct lp855x_platform_data *pd = lp->pdata;
 
 	switch (lp->chip_id) {
-	case LP8550 ... LP8556:
+	case LP8550:
+	case LP8551:
+	case LP8552:
+	case LP8553:
+	case LP8556:
 		lp->cfg = &lp855x_dev_cfg;
 		break;
+	case LP8555:
 	case LP8557:
 		lp->cfg = &lp8557_dev_cfg;
 		break;
@@ -470,6 +481,7 @@ static const struct of_device_id lp855x_dt_ids[] = {
 	{ .compatible = "ti,lp8551", },
 	{ .compatible = "ti,lp8552", },
 	{ .compatible = "ti,lp8553", },
+	{ .compatible = "ti,lp8555", },
 	{ .compatible = "ti,lp8556", },
 	{ .compatible = "ti,lp8557", },
 	{ }
@@ -481,6 +493,7 @@ static const struct i2c_device_id lp855x_ids[] = {
 	{"lp8551", LP8551},
 	{"lp8552", LP8552},
 	{"lp8553", LP8553},
+	{"lp8555", LP8555},
 	{"lp8556", LP8556},
 	{"lp8557", LP8557},
 	{ }
diff --git a/include/linux/platform_data/lp855x.h b/include/linux/platform_data/lp855x.h
index ea32005..1b2ba24 100644
--- a/include/linux/platform_data/lp855x.h
+++ b/include/linux/platform_data/lp855x.h
@@ -40,6 +40,17 @@
 #define LP8553_PWM_CONFIG	LP8550_PWM_CONFIG
 #define LP8553_I2C_CONFIG	LP8550_I2C_CONFIG
 
+/* CONFIG register - LP8555 */
+#define LP8555_PWM_STANDBY	BIT(7)
+#define LP8555_PWM_FILTER	BIT(6)
+#define LP8555_RELOAD_EPROM	BIT(3)	/* use it if EPROMs should be reset
+					   when the backlight turns on */
+#define LP8555_OFF_OPENLEDS	BIT(2)
+#define LP8555_PWM_CONFIG	LP8555_PWM_ONLY
+#define LP8555_I2C_CONFIG	LP8555_I2C_ONLY
+#define LP8555_COMB1_CONFIG	LP8555_COMBINED1
+#define LP8555_COMB2_CONFIG	LP8555_COMBINED2
+
 /* DEVICE CONTROL register - LP8556 */
 #define LP8556_PWM_CONFIG	(LP8556_PWM_ONLY << BRT_MODE_SHFT)
 #define LP8556_COMB1_CONFIG	(LP8556_COMBINED1 << BRT_MODE_SHFT)
@@ -65,6 +76,7 @@ enum lp855x_chip_id {
 	LP8551,
 	LP8552,
 	LP8553,
+	LP8555,
 	LP8556,
 	LP8557,
 };
@@ -89,6 +101,13 @@ enum lp8553_brighntess_source {
 	LP8553_I2C_ONLY = LP8550_I2C_ONLY,
 };
 
+enum lp8555_brightness_source {
+	LP8555_PWM_ONLY,
+	LP8555_I2C_ONLY,
+	LP8555_COMBINED1,	/* Brightness register with shaped PWM */
+	LP8555_COMBINED2,	/* PWM with shaped brightness register */
+};
+
 enum lp8556_brightness_source {
 	LP8556_PWM_ONLY,
 	LP8556_COMBINED1,	/* pwm + i2c before the shaper block */
-- 
1.7.10.4



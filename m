Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820Ab3IEClL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:41:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19262 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761477Ab3IEClI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:41:08 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-3f-5227ef42d06b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
In-reply-to: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
Subject: [PATCH 1/6] backlight: lp855x_bl: support new LP8555 device
Date: Thu, 05 Sep 2013 11:41:05 +0900
Message-id: <002201cea9e1$5e99da40$1bcd8ec0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p4TRpKe++09SiQwq9N1m2ivIIowAABbpg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zQ12n9+pBBlc3C1jMWb+GzWLy7i5W
	i8sLLwGJXXPYLJb/WsdisXvXU1YHNo+ds+6ye5yY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA
	tigum5TUnMyy1CJ9uwSujM+fowqWmFU0nC9uYPyh3cXIySEhYCJxa+ZBFghbTOLCvfVsXYxc
	HEICyxgldi39zQhT9OjoVUaIxCJGiduzHoF1CAn8YpQ431gEYrMJqEl8+XKYvYuRg0NEQF+i
	rUUDpJ5ZYCujxOaPu1kh6m0lzi+ZzQZicwrYSXz6sRdsgbCAi8SzhjdMIDaLgKrE/U/tYDW8
	QPUHNs9ngrAFJX5Mvge2l1lAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYRMJLYPfsXK0SJ
	iMS+F+/A7pcQeMsu8ef7IWaIXQIS3yYfYoHolZXYdIAZ4l9JiYMrbrBMYJSYhWTzLCSbZyHZ
	PAvJigWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQiK3dwfj7QPWhxiTgdZPZJYSTc4H
	Rn5eSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiP
	/VK31J1e3//0bczMvw1bC0smL0640n/frEv5cNgXwbArH/xfSL6fbHC0pbSgPKH/Ru0an/Nr
	y655TWhjq/t2a13xqaMV9+25qxgP68T9MmfNXcm++fFrNqPVO9fNWdz9f6HLn38HSvYLHxTU
	LVhc3sq+/qHezmbdT9WhIa9TudkC9Wo1mIOUWIozEg21mIuKEwG/Wgyc8gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAV2n9+pBBjuXc1vMWb+GzWLy7i5W
	i8sLLwGJXXPYLJb/WsdisXvXU1YHNo+ds+6ye5yY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA
	tqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDuU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmfP0cVLDGraDhf3MD4Q7uL
	kZNDQsBE4tHRq4wQtpjEhXvr2boYuTiEBBYxStye9YgFJCEk8ItR4nxjEYjNJqAm8eXLYfYu
	Rg4OEQF9ibYWDZB6ZoGtjBKbP+5mhai3lTi/ZDYbiM0pYCfx6cdesAXCAi4SzxreMIHYLAKq
	Evc/tYPV8ALVH9g8nwnCFpT4Mfke2F5mAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBI
	YvfsX6wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGC08IzqR2MKxssDjEKcDAq8fA2GKsHCbEmlhVX5h5ilOBgVhLhtVgJFOJNSaysSi3K
	jy8qzUktPsSYDPToRGYp0eR8YMrKK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZq
	akFqEcwWJg5OqQbG2le3Jyzi0roXGu3y3lH+lGp45zubKbv38B1aMy9wO/fiuWUMJqfmXFEs
	ffj7QHpi5c7k6IvSFtaeD53WqLA5M7ls1Jkc8c5u4tmjugd5a7nYeVa2MoSsTP/g9pOl5enf
	XW6Kdjn3jvpNs5xqNFMjaPGtCD+nC8c8f6ut3bMzY67xgQnXLJfnKrEUZyQaajEXFScCAL8U
	t29PAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP8555 is one of LP855x family device.
This device needs pre_init_device() and post_init_device() driver structure.
It's same as LP8557, so the device configuration code is shared with LP8557.
Backlight outputs are generated from dual DC-DC boost converters.
It's configurable EPROM settings which are defined in the platform data.

Driver documentation and device tree bindings are updated.

Signed-off-by: Milo Kim <milo.kim@ti.com>
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



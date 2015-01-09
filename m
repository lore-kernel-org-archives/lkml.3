Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbbAIPYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:24:20 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55063 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbbAIPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:24:11 -0500
X-AuditID: cbfee61a-f79c06d000004e71-bd-54aff2981c21
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH/RFC v10 08/19] leds: Add support for max77693 mfd flash cell
Date: Fri, 09 Jan 2015 16:22:58 +0100
Message-id: <1420816989-1808-9-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t9jQd0Zn9aHGKxrN7a4te4cq8XGGetZ
	LY7unMhkcf3Lc1aL+UeAYr1XnzNanG16w25x/+tRRovLu+awWWx9s47RomfDVlaLu6eOslns
	3vWU1eLwm3ZWizP7V7I58HvsnHWX3ePw14UsHneu7WHz2DP/B6tH35ZVjB4rVn9n9/i8SS6A
	PYrLJiU1J7MstUjfLoErY86Db0wFXT8YK+4/WMLawPjkJGMXIyeHhICJxJuOYywQtpjEhXvr
	2boYuTiEBKYzSvx8MJkZwmlnkvi/djkrSBWbgKHEzxevmboYOThEBKIlLh2rB6lhFrjJJDHp
	xHYmkBphAR+J7SuWsYHYLAKqEmtnL2MHsXkF3CVen1wL1ishoCAxZ5INiMkp4CHR8tsJxBQC
	qnhz1XACI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGB+0xqB+PKBotDjAIcjEo8
	vBvk1ocIsSaWFVfmHmKU4GBWEuFt2AwU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzqtk3xYiJJCe
	WJKanZpakFoEk2Xi4JRqYHQ4268cemzuZF1mFQcX+YV/P33jmqOdd2GDlbyscMTTbZ3tR5eo
	fTvMfoR124FHLOyauY9/HLggfUfC89gftSnOyu8d9Thm8eevnj//30wbc7F8kRfHYxfPc1l5
	w0rsT12Ugvu+EsdH7lHWT/u36vFKCpV7Pwvp+By957Tv57DvoYG/ZSdysCmxFGckGmoxFxUn
	AgD3UhOKWAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds led-flash support to Maxim max77693 chipset.
A device can be exposed to user space through LED subsystem
sysfs interface. Device supports up to two leds which can
work in flash and torch mode. The leds can be triggered
externally or by software.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/leds/Kconfig         |   10 +
 drivers/leds/Makefile        |    1 +
 drivers/leds/leds-max77693.c | 1045 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1056 insertions(+)
 create mode 100644 drivers/leds/leds-max77693.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 95029df..ff9c21b 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -464,6 +464,16 @@ config LEDS_TCA6507
 	  LED driver chips accessed via the I2C bus.
 	  Driver support brightness control and hardware-assisted blinking.
 
+config LEDS_MAX77693
+	tristate "LED support for MAX77693 Flash"
+	depends on LEDS_CLASS_FLASH
+	depends on MFD_MAX77693
+	depends on OF
+	help
+	  This option enables support for the flash part of the MAX77693
+	  multifunction device. It has build in control for two leds in flash
+	  and torch mode.
+
 config LEDS_MAX8997
 	tristate "LED support for MAX8997 PMIC"
 	depends on LEDS_CLASS && MFD_MAX8997
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index cbba921..57ca62b 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
 obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
+obj-$(CONFIG_LEDS_MAX77693)		+= leds-max77693.o
 obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
 obj-$(CONFIG_LEDS_LM355x)		+= leds-lm355x.o
 obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
new file mode 100644
index 0000000..3ba07c4
--- /dev/null
+++ b/drivers/leds/leds-max77693.c
@@ -0,0 +1,1045 @@
+/*
+ * LED Flash class driver for the flash cell of max77693 mfd.
+ *
+ *	Copyright (C) 2015, Samsung Electronics Co., Ltd.
+ *
+ *	Authors: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *		 Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#include <asm/div64.h>
+#include <linux/led-class-flash.h>
+#include <linux/mfd/max77693.h>
+#include <linux/mfd/max77693-private.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#define MODE_OFF		0
+#define MODE_FLASH(a)		(1 << (a))
+#define MODE_TORCH(a)		(1 << (2 + (a)))
+#define MODE_FLASH_EXTERNAL(a)	(1 << (4 + (a)))
+
+#define MODE_FLASH_MASK		(MODE_FLASH(FLED1) | MODE_FLASH(FLED2) | \
+				 MODE_FLASH_EXTERNAL(FLED1) | \
+				 MODE_FLASH_EXTERNAL(FLED2))
+#define MODE_TORCH_MASK		(MODE_TORCH(FLED1) | MODE_TORCH(FLED2))
+
+#define FLED1_IOUT		(1 << 0)
+#define FLED2_IOUT		(1 << 1)
+
+enum max77693_fled {
+	FLED1,
+	FLED2,
+};
+
+enum max77693_led_mode {
+	FLASH,
+	TORCH,
+};
+
+struct max77693_sub_led {
+	/* related FLED output identifier */
+	int fled_id;
+	/* related LED Flash class device */
+	struct led_classdev_flash fled_cdev;
+	/* assures led-triggers compatibility */
+	struct work_struct work_brightness_set;
+
+	/* brightness cache */
+	unsigned int torch_brightness;
+	/* flash timeout cache */
+	unsigned int flash_timeout;
+};
+
+struct max77693_led_device {
+	/* parent mfd regmap */
+	struct regmap *regmap;
+	/* platform device data */
+	struct platform_device *pdev;
+	/* configuration data for the device */
+	struct max77693_led_config_data *cfg_data;
+	/* secures access to the device */
+	struct mutex lock;
+
+	/* sub led data */
+	struct max77693_sub_led sub_leds[2];
+
+	/* current flash timeout cache */
+	unsigned int current_flash_timeout;
+	/* ITORCH register cache */
+	u8 torch_iout_reg;
+	/* mode of fled outputs */
+	unsigned int mode_flags;
+	/* recently strobed fled */
+	int strobing_sub_led_id;
+	/* bitmask of fled outputs use state (bit 0. - FLED1, bit 1. - FLED2) */
+	u8 fled_mask;
+	/* fled modes that can be set */
+	u8 allowed_modes;
+
+	/* arrangement of current outputs */
+	bool iout_joint;
+};
+
+struct max77693_led_settings {
+	struct led_flash_setting torch_brightness;
+	struct led_flash_setting flash_brightness;
+	struct led_flash_setting flash_timeout;
+};
+
+static u8 max77693_led_iout_to_reg(u32 ua)
+{
+	if (ua < FLASH_IOUT_MIN)
+		ua = FLASH_IOUT_MIN;
+	return (ua - FLASH_IOUT_MIN) / FLASH_IOUT_STEP;
+}
+
+static u8 max77693_flash_timeout_to_reg(u32 us)
+{
+	return (us - FLASH_TIMEOUT_MIN) / FLASH_TIMEOUT_STEP;
+}
+
+static inline struct max77693_sub_led *flcdev_to_sub_led(
+					struct led_classdev_flash *fled_cdev)
+{
+	return container_of(fled_cdev, struct max77693_sub_led, fled_cdev);
+}
+
+static inline struct max77693_led_device *sub_led_to_led(
+					struct max77693_sub_led *sub_led)
+{
+	return container_of(sub_led, struct max77693_led_device,
+				sub_leds[sub_led->fled_id]);
+}
+
+static inline u8 max77693_led_vsys_to_reg(u32 mv)
+{
+	return ((mv - MAX_FLASH1_VSYS_MIN) / MAX_FLASH1_VSYS_STEP) << 2;
+}
+
+static inline u8 max77693_led_vout_to_reg(u32 mv)
+{
+	return (mv - FLASH_VOUT_MIN) / FLASH_VOUT_STEP + FLASH_VOUT_RMIN;
+}
+
+static inline bool max77693_fled_used(struct max77693_led_device *led,
+					 int fled_id)
+{
+	u8 fled_bit = (fled_id == FLED1) ? FLED1_IOUT : FLED2_IOUT;
+
+	return led->fled_mask & fled_bit;
+}
+
+/* split composite current @i into two @iout according to @imax weights */
+static void __max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
+{
+	u64 t = i;
+
+	t *= imax[1];
+	do_div(t, imax[0] + imax[1]);
+
+	iout[1] = (u32)t / FLASH_IOUT_STEP * FLASH_IOUT_STEP;
+	iout[0] = i - iout[1];
+}
+
+static int max77693_set_mode(struct max77693_led_device *led, u8 mode)
+{
+	struct regmap *rmap = led->regmap;
+	int ret, v = 0, i;
+
+	for (i = FLED1; i <= FLED2; ++i) {
+		if (mode & MODE_TORCH(i))
+			v |= FLASH_EN_ON << TORCH_EN_SHIFT(i);
+
+		if (mode & MODE_FLASH(i)) {
+			v |= FLASH_EN_ON << FLASH_EN_SHIFT(i);
+		} else if (mode & MODE_FLASH_EXTERNAL(i)) {
+			v |= FLASH_EN_FLASH << FLASH_EN_SHIFT(i);
+			/*
+			 * Enable hw triggering also for torch mode, as some
+			 * camera sensors use torch led to fathom ambient light
+			 * conditions before strobing the flash.
+			 */
+			v |= FLASH_EN_TORCH << TORCH_EN_SHIFT(i);
+		}
+	}
+
+	/* Reset the register only prior setting flash modes */
+	if (mode & ~(MODE_TORCH(FLED1) | MODE_TORCH(FLED2))) {
+		ret = regmap_write(rmap, MAX77693_LED_REG_FLASH_EN, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return regmap_write(rmap, MAX77693_LED_REG_FLASH_EN, v);
+}
+
+static void max77693_set_sync_strobe(struct max77693_led_device *led,
+					u8 *mode)
+{
+	struct max77693_sub_led *sub_leds = led->sub_leds;
+	struct led_classdev_flash *fled_cdev;
+	u8 m = *mode;
+
+	if (led->iout_joint)
+		return;
+
+	/* Check if the other sub-led wants to be strobed simultaneously. */
+	if (m & (MODE_FLASH(FLED1) | MODE_FLASH_EXTERNAL(FLED1))) {
+		fled_cdev = &sub_leds[FLED2].fled_cdev;
+		if (fled_cdev->sync_led_id)
+			m |= m << 1;
+	} else if (m & (MODE_FLASH(FLED2) | MODE_FLASH_EXTERNAL(FLED2))) {
+		fled_cdev = &sub_leds[FLED1].fled_cdev;
+		if (fled_cdev->sync_led_id)
+			m |= m >> 1;
+	}
+
+	*mode = m;
+}
+
+static int max77693_add_mode(struct max77693_led_device *led, u8 mode)
+{
+	int i, ret;
+
+	mode &= led->allowed_modes;
+
+	/*
+	 * Torch mode once enabled remains active until turned off. If the FLED2
+	 * output isn't to be disabled check if the torch mode to be set isn't
+	 * already activated and avoid re-setting it.
+	 */
+	if ((!(mode ^ led->mode_flags)) & MODE_TORCH(FLED2)) {
+		for (i = FLED1; i <= FLED2; ++i)
+			if ((mode & MODE_TORCH(i)) &&
+			    (led->mode_flags & MODE_TORCH(i)))
+				return 0;
+	}
+
+	/* Span the mode on FLED2 for joint iouts case */
+	if (led->iout_joint)
+		mode |= (mode << 1);
+
+	/* Span the flash mode on the other led if it is to be synchronized */
+	max77693_set_sync_strobe(led, &mode);
+
+	/*
+	 * FLASH_EXTERNAL mode activates FLASHEN and TORCHEN pins in the device.
+	 * The related register bits fields interfere with SW triggerred modes,
+	 * thus clear them to ensure proper device configuration.
+	 */
+	for (i = FLED1; i <= FLED2; ++i)
+		if (mode & MODE_FLASH_EXTERNAL(i))
+			led->mode_flags &= (~MODE_TORCH(i) & ~MODE_FLASH(i));
+
+	led->mode_flags |= mode;
+	led->mode_flags &= led->allowed_modes;
+
+	ret = max77693_set_mode(led, led->mode_flags);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Clear flash mode flag after setting the mode to avoid spurious flash
+	 * strobing on each subsequent torch mode setting.
+	 */
+	if (mode & MODE_FLASH_MASK)
+		led->mode_flags &= ~mode;
+
+	return ret;
+}
+
+static int max77693_clear_mode(struct max77693_led_device *led,
+				u8 mode)
+{
+	int ret;
+
+	if (led->iout_joint)
+		/* Clear mode also on FLED2 for joint iouts case */
+		mode |= (mode << 1);
+	else
+		/*
+		 * Clear a flash mode on the other led
+		 * if it is to be synchronized.
+		 */
+		max77693_set_sync_strobe(led, &mode);
+
+	led->mode_flags &= ~mode;
+
+	ret = max77693_set_mode(led, led->mode_flags);
+
+	return ret;
+}
+
+static void max77693_calc_iout(struct max77693_led_device *led, int fled_id,
+				u32 iout[2], u32 micro_amp, u32 iout_max[2],
+				enum max77693_led_mode mode)
+{
+	u8 blocked_modes;
+
+	if (fled_id == FLED1) {
+		if (led->iout_joint) {
+			/*
+			 * FLED2 must not be turned on to get
+			 * 15625 uA of total current.
+			 */
+			if (micro_amp == FLASH_IOUT_MIN) {
+				if (mode == FLASH)
+					blocked_modes =
+						MODE_FLASH(FLED2) |
+						MODE_FLASH_EXTERNAL(FLED2);
+				else
+					blocked_modes = MODE_TORCH(FLED2);
+
+				led->allowed_modes &= ~blocked_modes;
+			}
+		} else {
+			/*
+			 * Preclude splitting current to FLED2 if we
+			 * are driving two separate leds.
+			 */
+			iout_max[FLED2] = 0;
+		}
+		__max77693_calc_iout(iout, micro_amp, iout_max);
+	} else if (fled_id == FLED2) {
+		/*
+		 * Preclude splitting current to FLED1 if we
+		 * are driving two separate leds.
+		 */
+		iout_max[FLED1] = 0;
+		__max77693_calc_iout(iout, micro_amp, iout_max);
+	}
+}
+
+static int max77693_set_torch_current(struct max77693_led_device *led,
+				int fled_id, u32 micro_amp)
+{
+	struct max77693_led_config_data *cfg = led->cfg_data;
+	struct regmap *rmap = led->regmap;
+	u32 iout[2], iout_max[2];
+	u8 iout1_reg = 0, iout2_reg = 0;
+
+	iout_max[FLED1] = cfg->iout_torch[FLED1];
+	iout_max[FLED2] = cfg->iout_torch[FLED2];
+
+	led->allowed_modes |= MODE_TORCH_MASK;
+
+	max77693_calc_iout(led, fled_id, iout, micro_amp, iout_max,
+				TORCH);
+
+	if (fled_id == FLED1 || led->iout_joint) {
+		iout1_reg = max77693_led_iout_to_reg(iout[FLED1]);
+		led->torch_iout_reg &= 0xf0;
+	}
+	if (fled_id == FLED2 || led->iout_joint) {
+		iout2_reg = max77693_led_iout_to_reg(iout[FLED2]);
+		led->torch_iout_reg &= 0x0f;
+	}
+
+	led->torch_iout_reg |= ((iout1_reg << TORCH_IOUT1_SHIFT) |
+				(iout2_reg << TORCH_IOUT2_SHIFT));
+
+	return regmap_write(rmap, MAX77693_LED_REG_ITORCH,
+						led->torch_iout_reg);
+}
+
+static int max77693_set_flash_current(struct max77693_led_device *led,
+					int fled_id,
+					u32 micro_amp)
+{
+	struct max77693_led_config_data *cfg = led->cfg_data;
+	struct regmap *rmap = led->regmap;
+	u32 iout[2], iout_max[2];
+	u8 iout1_reg, iout2_reg;
+	int ret = -EINVAL;
+
+	iout_max[FLED1] = cfg->iout_flash[FLED1];
+	iout_max[FLED2] = cfg->iout_flash[FLED2];
+
+	led->allowed_modes |= MODE_FLASH_MASK;
+
+	max77693_calc_iout(led, fled_id, iout, micro_amp, iout_max,
+				FLASH);
+
+	if (fled_id == FLED1 || led->iout_joint) {
+		iout1_reg = max77693_led_iout_to_reg(iout[FLED1]);
+		ret = regmap_write(rmap, MAX77693_LED_REG_IFLASH1,
+							iout1_reg);
+		if (ret < 0)
+			return ret;
+	}
+	if (fled_id == FLED2 || led->iout_joint) {
+		iout2_reg = max77693_led_iout_to_reg(iout[FLED2]);
+		ret = regmap_write(rmap, MAX77693_LED_REG_IFLASH2,
+							iout2_reg);
+	}
+
+	return ret;
+}
+
+static int max77693_set_timeout(struct max77693_led_device *led, u32 microsec)
+{
+	struct max77693_led_config_data *cfg = led->cfg_data;
+	struct regmap *rmap = led->regmap;
+	u8 v;
+	int ret;
+
+	v = max77693_flash_timeout_to_reg(microsec);
+
+	if (cfg->trigger_type == MAX77693_LED_TRIG_TYPE_LEVEL)
+		v |= FLASH_TMR_LEVEL;
+
+	ret = regmap_write(rmap, MAX77693_LED_REG_FLASH_TIMER, v);
+	if (ret < 0)
+		return ret;
+
+	led->current_flash_timeout = microsec;
+
+	return 0;
+}
+
+static int max77693_strobe_status_get(struct max77693_led_device *led,
+					bool *state)
+{
+	struct regmap *rmap = led->regmap;
+	unsigned int v;
+	int ret;
+
+	ret = regmap_read(rmap, MAX77693_LED_REG_FLASH_STATUS, &v);
+	if (ret < 0)
+		return ret;
+
+	*state = v & FLASH_STATUS_FLASH_ON;
+
+	return ret;
+}
+
+static int max77693_int_flag_get(struct max77693_led_device *led,
+					unsigned int *v)
+{
+	struct regmap *rmap = led->regmap;
+
+	return regmap_read(rmap, MAX77693_LED_REG_FLASH_INT, v);
+}
+
+static int max77693_setup(struct max77693_led_device *led)
+{
+	struct max77693_led_config_data *cfg = led->cfg_data;
+	struct regmap *rmap = led->regmap;
+	int i, first_led, last_led, ret;
+	u32 max_flash_curr[2];
+	u8 v;
+
+	/*
+	 * Initialize only flash current. Torch current doesn't
+	 * require initialization as ITORCH register is written with
+	 * new value each time brightness_set op is called.
+	 */
+	if (led->iout_joint) {
+		first_led = FLED1;
+		last_led = FLED1;
+		max_flash_curr[FLED1] = cfg->iout_flash[FLED1] +
+					cfg->iout_flash[FLED2];
+	} else {
+		first_led = max77693_fled_used(led, FLED1) ? FLED1 : FLED2;
+		last_led = led->cfg_data->num_leds == 2 ? FLED2 : first_led;
+		max_flash_curr[FLED1] = cfg->iout_flash[FLED1];
+		max_flash_curr[FLED2] = cfg->iout_flash[FLED2];
+	}
+
+	for (i = first_led; i <= last_led; ++i) {
+		ret = max77693_set_flash_current(led, i,
+					max_flash_curr[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	v = TORCH_TMR_NO_TIMER | MAX77693_LED_TRIG_TYPE_LEVEL;
+	ret = regmap_write(rmap, MAX77693_LED_REG_ITORCHTIMER, v);
+	if (ret < 0)
+		return ret;
+
+	/* initially set FLED1 timeout */
+	ret = max77693_set_timeout(led, cfg->flash_timeout[FLED1]);
+	if (ret < 0)
+		return ret;
+
+	if (cfg->low_vsys > 0)
+		v = max77693_led_vsys_to_reg(cfg->low_vsys) |
+						MAX_FLASH1_MAX_FL_EN;
+	else
+		v = 0;
+
+	ret = regmap_write(rmap, MAX77693_LED_REG_MAX_FLASH1, v);
+	if (ret < 0)
+		return ret;
+	ret = regmap_write(rmap, MAX77693_LED_REG_MAX_FLASH2, 0);
+	if (ret < 0)
+		return ret;
+
+	if (cfg->boost_mode == MAX77693_LED_BOOST_FIXED)
+		v = FLASH_BOOST_FIXED;
+	else
+		v = cfg->boost_mode | cfg->boost_mode << 1;
+
+	if (max77693_fled_used(led, FLED1) && max77693_fled_used(led, FLED2))
+		v |= FLASH_BOOST_LEDNUM_2;
+
+	ret = regmap_write(rmap, MAX77693_LED_REG_VOUT_CNTL, v);
+	if (ret < 0)
+		return ret;
+
+	v = max77693_led_vout_to_reg(cfg->boost_vout);
+	ret = regmap_write(rmap, MAX77693_LED_REG_VOUT_FLASH1, v);
+	if (ret < 0)
+		return ret;
+
+	/* Allow all modes on both fled outputs */
+	led->allowed_modes = MODE_FLASH_MASK | MODE_TORCH_MASK;
+
+	return max77693_set_mode(led, MODE_OFF);
+}
+
+static int __max77693_led_brightness_set(struct max77693_led_device *led,
+					int fled_id, enum led_brightness value)
+{
+	int ret;
+
+	mutex_lock(&led->lock);
+
+	if (value == 0) {
+		ret = max77693_clear_mode(led, MODE_TORCH(fled_id));
+		if (ret < 0)
+			dev_dbg(&led->pdev->dev,
+				"Failed to clear torch mode (%d)\n",
+				ret);
+		goto unlock;
+	}
+
+	ret = max77693_set_torch_current(led, fled_id, value * TORCH_IOUT_STEP);
+	if (ret < 0) {
+		dev_dbg(&led->pdev->dev,
+			"Failed to set torch current (%d)\n",
+			ret);
+		goto unlock;
+	}
+
+	ret = max77693_add_mode(led, MODE_TORCH(fled_id));
+	if (ret < 0)
+		dev_dbg(&led->pdev->dev,
+			"Failed to set torch mode (%d)\n",
+			ret);
+unlock:
+	mutex_unlock(&led->lock);
+	return ret;
+}
+
+static void max77693_led_brightness_set_work(
+					struct work_struct *work)
+{
+	struct max77693_sub_led *sub_led =
+			container_of(work, struct max77693_sub_led,
+					work_brightness_set);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+
+	__max77693_led_brightness_set(led, sub_led->fled_id,
+				sub_led->torch_brightness);
+}
+
+/* LED subsystem callbacks */
+
+static int max77693_led_brightness_set_sync(
+				struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+
+	return __max77693_led_brightness_set(led, sub_led->fled_id, value);
+}
+
+static void max77693_led_brightness_set(
+				struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+
+	sub_led->torch_brightness = value;
+	schedule_work(&sub_led->work_brightness_set);
+}
+
+static int max77693_led_flash_brightness_set(
+				struct led_classdev_flash *fled_cdev,
+				u32 brightness)
+{
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	int ret;
+
+	mutex_lock(&led->lock);
+	ret = max77693_set_flash_current(led, sub_led->fled_id, brightness);
+	mutex_unlock(&led->lock);
+
+	return ret;
+}
+
+static int max77693_led_flash_strobe_set(
+				struct led_classdev_flash *fled_cdev,
+				bool state)
+{
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	int fled_id = sub_led->fled_id;
+	int ret;
+
+	mutex_lock(&led->lock);
+
+	if (!state) {
+		ret = max77693_clear_mode(led, MODE_FLASH(fled_id));
+		goto unlock;
+	}
+
+	if (sub_led->flash_timeout != led->current_flash_timeout) {
+		ret = max77693_set_timeout(led, sub_led->flash_timeout);
+		if (ret < 0)
+			goto unlock;
+	}
+
+	led->strobing_sub_led_id = fled_id;
+
+	ret = max77693_add_mode(led, MODE_FLASH(fled_id));
+
+unlock:
+	mutex_unlock(&led->lock);
+	return ret;
+}
+
+static int max77693_led_flash_fault_get(
+				struct led_classdev_flash *fled_cdev,
+				u32 *fault)
+{
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	unsigned int v;
+	int ret;
+
+	ret = max77693_int_flag_get(led, &v);
+	if (ret < 0)
+		return ret;
+
+	*fault = 0;
+
+	if (v & ((sub_led->fled_id == FLED1) ? FLASH_INT_FLED1_OPEN :
+					       FLASH_INT_FLED2_OPEN))
+		*fault |= LED_FAULT_OVER_VOLTAGE;
+	if (v & ((sub_led->fled_id == FLED1) ? FLASH_INT_FLED1_SHORT :
+					       FLASH_INT_FLED2_SHORT))
+		*fault |= LED_FAULT_SHORT_CIRCUIT;
+	if (v & FLASH_INT_OVER_CURRENT)
+		*fault |= LED_FAULT_OVER_CURRENT;
+
+	return 0;
+}
+
+static int max77693_led_flash_strobe_get(
+				struct led_classdev_flash *fled_cdev,
+				bool *state)
+{
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	int ret;
+
+	if (!state)
+		return -EINVAL;
+
+	mutex_lock(&led->lock);
+
+	ret = max77693_strobe_status_get(led, state);
+
+	*state = !!(*state && (led->strobing_sub_led_id == sub_led->fled_id));
+
+
+	mutex_unlock(&led->lock);
+
+	return ret;
+}
+
+static int max77693_led_flash_timeout_set(
+				struct led_classdev_flash *fled_cdev,
+				u32 timeout)
+{
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+
+	mutex_lock(&led->lock);
+	sub_led->flash_timeout = timeout;
+	mutex_unlock(&led->lock);
+
+	return 0;
+}
+
+static int max77693_led_parse_dt(struct max77693_led_device *led,
+				 struct device_node *node)
+{
+	struct max77693_led_config_data *cfg = led->cfg_data;
+	struct max77693_sub_led *sub_leds = led->sub_leds;
+	struct device *dev = &led->pdev->dev;
+	struct device_node *child_node;
+	u32 led_sources[2];
+	int fled_id, ret;
+
+	of_property_read_u32(node, "maxim,trigger-type", &cfg->trigger_type);
+	of_property_read_u32(node, "maxim,boost-mode", &cfg->boost_mode);
+	of_property_read_u32(node, "maxim,boost-vout", &cfg->boost_vout);
+	of_property_read_u32(node, "maxim,vsys-min", &cfg->low_vsys);
+
+	for_each_available_child_of_node(node, child_node) {
+		ret = of_property_read_u32_array(child_node, "led-sources",
+							led_sources, 2);
+		if (ret < 0) {
+			dev_err(dev,
+				"Error reading \"led-sources\" DT property\n");
+			return ret;
+		}
+
+		if (led_sources[0] && led_sources[1]) {
+			fled_id = FLED1;
+			led->fled_mask = FLED1_IOUT | FLED2_IOUT;
+		} else if (led_sources[0] && !led_sources[1]) {
+			fled_id = FLED1;
+			led->fled_mask |= FLED1_IOUT;
+		} else if (!led_sources[0] && led_sources[1]) {
+			fled_id = FLED2;
+			led->fled_mask |= FLED2_IOUT;
+		} else {
+			dev_err(dev,
+				"Wrong \"led-sources\" DT property value\n");
+			return -EINVAL;
+		}
+
+		sub_leds[fled_id].fled_id = fled_id;
+
+		ret = of_property_read_string(child_node, "label",
+					(const char **) &cfg->label[fled_id]);
+		if (ret < 0) {
+			dev_err(dev, "Error reading \"label\" DT property\n");
+			return ret;
+		}
+
+		of_property_read_u32(child_node, "max-microamp",
+						&cfg->iout_torch[fled_id]);
+		of_property_read_u32(child_node, "flash-max-microamp",
+						&cfg->iout_flash[fled_id]);
+		of_property_read_u32(child_node, "flash-timeout-us",
+						&cfg->flash_timeout[fled_id]);
+
+		if (++led->cfg_data->num_leds == 2 ||
+		    (max77693_fled_used(led, FLED1) &&
+		     max77693_fled_used(led, FLED2)))
+			break;
+	}
+
+	return 0;
+}
+
+static void clamp_align(u32 *v, u32 min, u32 max, u32 step)
+{
+	*v = clamp_val(*v, min, max);
+	if (step > 1)
+		*v = (*v - min) / step * step + min;
+}
+
+static void max77693_led_validate_configuration(struct max77693_led_device *led)
+{
+	struct max77693_led_config_data *cfg = led->cfg_data;
+	int i;
+
+	if (led->cfg_data->num_leds == 1 &&
+	    max77693_fled_used(led, FLED1) && max77693_fled_used(led, FLED2))
+		led->iout_joint = true;
+
+	cfg->boost_mode = clamp_val(cfg->boost_mode, MAX77693_LED_BOOST_NONE,
+			    MAX77693_LED_BOOST_FIXED);
+
+	/* Boost must be enabled if both current outputs are used */
+	if ((cfg->boost_mode == MAX77693_LED_BOOST_NONE) && led->iout_joint)
+		cfg->boost_mode = MAX77693_LED_BOOST_FIXED;
+
+	/* Split max current settings to both outputs in case of joint leds */
+	if (led->iout_joint) {
+		cfg->iout_torch[FLED1] /= 2;
+		cfg->iout_torch[FLED2] = cfg->iout_torch[FLED1];
+		cfg->iout_flash[FLED1] /= 2;
+		cfg->iout_flash[FLED2] = cfg->iout_flash[FLED1];
+	}
+
+	for (i = FLED1; i <= FLED2; ++i) {
+		if (max77693_fled_used(led, i)) {
+			clamp_align(&cfg->iout_torch[i], TORCH_IOUT_MIN,
+					TORCH_IOUT_MAX, TORCH_IOUT_STEP);
+			clamp_align(&cfg->iout_flash[i], FLASH_IOUT_MIN,
+					cfg->boost_mode ? FLASH_IOUT_MAX_2LEDS :
+							FLASH_IOUT_MAX_1LED,
+					FLASH_IOUT_STEP);
+		} else {
+			cfg->iout_torch[i] = cfg->iout_flash[i] = 0;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cfg->flash_timeout); ++i)
+		clamp_align(&cfg->flash_timeout[i], FLASH_TIMEOUT_MIN,
+				FLASH_TIMEOUT_MAX, FLASH_TIMEOUT_STEP);
+
+	cfg->trigger_type = clamp_val(cfg->trigger_type,
+					MAX77693_LED_TRIG_TYPE_EDGE,
+					MAX77693_LED_TRIG_TYPE_LEVEL);
+
+	clamp_align(&cfg->boost_vout, FLASH_VOUT_MIN, FLASH_VOUT_MAX,
+							FLASH_VOUT_STEP);
+
+	if (cfg->low_vsys)
+		clamp_align(&cfg->low_vsys, MAX_FLASH1_VSYS_MIN,
+				MAX_FLASH1_VSYS_MAX, MAX_FLASH1_VSYS_STEP);
+}
+
+static int max77693_led_get_configuration(struct max77693_led_device *led)
+{
+	struct device *dev = &led->pdev->dev;
+	int ret;
+
+	if (!dev->of_node)
+		return -EINVAL;
+
+	led->cfg_data = devm_kzalloc(dev, sizeof(*led->cfg_data), GFP_KERNEL);
+	if (!led->cfg_data)
+		return -ENOMEM;
+
+	ret = max77693_led_parse_dt(led, dev->of_node);
+	if (ret < 0)
+		return ret;
+
+	max77693_led_validate_configuration(led);
+
+	return 0;
+}
+
+static const struct led_flash_ops flash_ops = {
+	.flash_brightness_set	= max77693_led_flash_brightness_set,
+	.strobe_set		= max77693_led_flash_strobe_set,
+	.strobe_get		= max77693_led_flash_strobe_get,
+	.timeout_set		= max77693_led_flash_timeout_set,
+	.fault_get		= max77693_led_flash_fault_get,
+};
+
+static void max77693_init_flash_settings(struct max77693_led_device *led,
+					 struct max77693_led_settings *s,
+					 int fled_id)
+{
+	struct max77693_led_config_data *cfg = led->cfg_data;
+	struct led_flash_setting *setting;
+
+	/* Init torch intensity setting */
+	setting = &s->torch_brightness;
+	setting->min = TORCH_IOUT_MIN;
+	setting->max = cfg->iout_torch[fled_id];
+	setting->max = led->iout_joint ?
+			cfg->iout_torch[FLED1] + cfg->iout_torch[FLED2] :
+			cfg->iout_torch[fled_id];
+	setting->step = TORCH_IOUT_STEP;
+	setting->val = setting->max;
+
+	/* Init flash intensity setting */
+	setting = &s->flash_brightness;
+	setting->min = FLASH_IOUT_MIN;
+	setting->max = led->iout_joint ?
+			cfg->iout_flash[FLED1] + cfg->iout_flash[FLED2] :
+			cfg->iout_flash[fled_id];
+	setting->step = FLASH_IOUT_STEP;
+	setting->val = setting->max;
+
+	/* Init flash timeout setting */
+	setting = &s->flash_timeout;
+	setting->min = FLASH_TIMEOUT_MIN;
+	setting->max = cfg->flash_timeout[fled_id];
+	setting->step = FLASH_TIMEOUT_STEP;
+	setting->val = setting->max;
+}
+
+static int max77693_set_available_sync_led(struct max77693_led_device *led,
+						int fled_id)
+{
+	struct max77693_sub_led *sub_led = &led->sub_leds[fled_id];
+	struct led_classdev_flash *fled_cdev = &sub_led->fled_cdev;
+
+	fled_cdev->sync_leds = devm_kzalloc(&led->pdev->dev, sizeof(fled_cdev),
+					GFP_KERNEL);
+	if (!fled_cdev->sync_leds)
+		return -ENOMEM;
+
+	fled_cdev->sync_leds[0] = &led->sub_leds[!fled_id].fled_cdev;
+	fled_cdev->num_sync_leds = 1;
+
+	return 0;
+}
+
+static void max77693_init_fled_cdev(struct max77693_led_device *led,
+					int fled_id)
+{
+	struct led_classdev_flash *fled_cdev;
+	struct led_classdev *led_cdev;
+	struct max77693_sub_led *sub_led = &led->sub_leds[fled_id];
+	struct max77693_led_settings settings;
+
+	/* Initialize flash settings */
+	max77693_init_flash_settings(led, &settings, fled_id);
+
+	/* Initialize LED Flash class device */
+	fled_cdev = &sub_led->fled_cdev;
+	fled_cdev->ops = &flash_ops;
+	led_cdev = &fled_cdev->led_cdev;
+	led_cdev->name = led->cfg_data->label[fled_id];
+	led_cdev->brightness_set = max77693_led_brightness_set;
+	led_cdev->brightness_set_sync = max77693_led_brightness_set_sync;
+	INIT_WORK(&sub_led->work_brightness_set,
+			max77693_led_brightness_set_work);
+
+	led_cdev->max_brightness = settings.torch_brightness.val /
+					TORCH_IOUT_STEP;
+	led_cdev->flags |= LED_DEV_CAP_FLASH;
+	if (led->cfg_data->num_leds == 2)
+		led_cdev->flags |= LED_DEV_CAP_SYNC_STROBE;
+
+	fled_cdev->brightness = settings.flash_brightness;
+	fled_cdev->timeout = settings.flash_timeout;
+	sub_led->flash_timeout = fled_cdev->timeout.val;
+}
+
+static int max77693_led_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
+	struct max77693_led_device *led;
+	struct max77693_sub_led *sub_leds;
+	int init_fled_cdev[2], i, ret;
+
+	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->pdev = pdev;
+	led->regmap = iodev->regmap;
+	sub_leds = led->sub_leds;
+
+	platform_set_drvdata(pdev, led);
+	ret = max77693_led_get_configuration(led);
+	if (ret < 0)
+		return ret;
+
+	ret = max77693_setup(led);
+	if (ret < 0)
+		return ret;
+
+	init_fled_cdev[FLED1] =
+			led->iout_joint || max77693_fled_used(led, FLED1);
+	init_fled_cdev[FLED2] =
+			!led->iout_joint && max77693_fled_used(led, FLED2);
+
+	/* Initialize LED Flash class device(s) */
+	for (i = FLED1; i <= FLED2; ++i)
+		if (init_fled_cdev[i])
+			max77693_init_fled_cdev(led, i);
+
+	/* Setup sub-leds available for flash strobe synchronization */
+	if (led->cfg_data->num_leds == 2) {
+		for (i = FLED1; i <= FLED2; ++i) {
+			ret = max77693_set_available_sync_led(led, i);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	mutex_init(&led->lock);
+
+	/* Register LED Flash class device(s) */
+	for (i = FLED1; i <= FLED2; ++i) {
+		if (init_fled_cdev[i]) {
+			ret = led_classdev_flash_register(dev,
+							&sub_leds[i].fled_cdev);
+			if (ret < 0) {
+				/*
+				 * At this moment FLED1 might have been already
+				 * registered and it needs to be released.
+				 */
+				if (i == FLED2)
+					goto err_register_led2;
+				else
+					goto err_register_led1;
+			}
+		}
+	}
+
+
+	return 0;
+
+err_register_led2:
+	/* It is possible than only FLED2 was to be registered */
+	if (!init_fled_cdev[FLED1])
+		goto err_register_led1;
+	led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
+err_register_led1:
+	mutex_destroy(&led->lock);
+
+	return ret;
+}
+
+static int max77693_led_remove(struct platform_device *pdev)
+{
+	struct max77693_led_device *led = platform_get_drvdata(pdev);
+	struct max77693_sub_led *sub_leds = led->sub_leds;
+
+	if (led->iout_joint || max77693_fled_used(led, FLED1)) {
+		led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
+		cancel_work_sync(&sub_leds[FLED1].work_brightness_set);
+	}
+
+	if (!led->iout_joint && max77693_fled_used(led, FLED2)) {
+		led_classdev_flash_unregister(&sub_leds[FLED2].fled_cdev);
+		cancel_work_sync(&sub_leds[FLED2].work_brightness_set);
+	}
+
+	mutex_destroy(&led->lock);
+
+	return 0;
+}
+
+static struct of_device_id max77693_led_dt_match[] = {
+	{.compatible = "maxim,max77693-led"},
+	{},
+};
+
+static struct platform_driver max77693_led_driver = {
+	.probe		= max77693_led_probe,
+	.remove		= max77693_led_remove,
+	.driver		= {
+		.name	= "max77693-led",
+		.owner	= THIS_MODULE,
+		.of_match_table = max77693_led_dt_match,
+	},
+};
+
+module_platform_driver(max77693_led_driver);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_AUTHOR("Andrzej Hajda <a.hajda@samsung.com>");
+MODULE_DESCRIPTION("Maxim MAX77693 led flash driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5


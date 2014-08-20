Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaHTNoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:44:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25607 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaHTNoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:07 -0400
X-AuditID: cbfee61b-f79f86d00000144c-75-53f4a6254c90
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH/RFC v5 2/3] leds: Add support for max77693 mfd flash cell
Date: Wed, 20 Aug 2014 15:43:40 +0200
Message-id: <1408542221-375-3-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t9jQV3VZV+CDT7cV7S4te4cq8XGGetZ
	LY7unMhkMf8IkPvx3j9Wi96rzxktzja9Ybe4//Uoo8XlXXPYLLa+Wcdo0bNhK6vF7l1PWS1O
	d7M68HrsnHWX3ePOtT1sHvNOBnrsmf+D1aNvyypGj2cf3zF7fN4kF8AexWWTkpqTWZZapG+X
	wJXx9EQ3Y8H8hUwVh/88Z29gPPiSsYuRk0NCwETi1sN7zBC2mMSFe+vZQGwhgemMEo/2ckPY
	7UwS5zp5QWw2AUOJny9eM4HYIgLlEj3vnwHVc3EwCxxmkvi69whYQljAU2LaqtlgC1gEVCV+
	L/4ANpRXwE1iyt67QMs4gJYpSMyZZAMS5hRwlzjbcZQZYpebxP3mTUwTGHkXMDKsYhRNLUgu
	KE5KzzXSK07MLS7NS9dLzs/dxAgO0WfSOxhXNVgcYhTgYFTi4b2x6EuwEGtiWXFl7iFGCQ5m
	JRHe9k6gEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBkaX
	zSfeO/+efXWKYHNDT1NbYfkXufgNc1W/vnVrCblcv8zve6SF3fGaVYwXzb4GC952mK/aZ6LW
	UFzj/1f4/PSSoK43Kts/7tm0Umaqfr+mpNfk6FebN91M9zrk1llwOHJ6w8doloQd2545mfX8
	NXJKk1y5b//cpb5rl198eFO992jVf+YjzbOVWIozEg21mIuKEwEDN3bPTQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds led-flash support to Maxim max77693 chipset.
A device can be exposed to user space through LED subsystem
sysfs interface or through V4L2 subdevice when the support
for V4L2 Flash sub-devices is enabled. Device supports up to
two leds which can work in flash and torch mode. Leds can
be triggered externally or by software.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: SangYoung Son <hello.son@smasung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/leds/Kconfig                 |    9 +
 drivers/leds/Makefile                |    1 +
 drivers/leds/leds-max77693.c         | 1048 ++++++++++++++++++++++++++++++++++
 drivers/mfd/max77693.c               |    5 +-
 include/linux/mfd/max77693-private.h |   59 ++
 include/linux/mfd/max77693.h         |   40 ++
 6 files changed, 1161 insertions(+), 1 deletion(-)
 create mode 100644 drivers/leds/leds-max77693.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index f8a26ec..27031ab 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -465,6 +465,15 @@ config LEDS_TCA6507
 	  LED driver chips accessed via the I2C bus.
 	  Driver support brightness control and hardware-assisted blinking.
 
+config LEDS_MAX77693
+	tristate "LED support for MAX77693 Flash"
+	depends on LEDS_CLASS_FLASH
+	depends on MFD_MAX77693
+	help
+	  This option enables support for the flash part of the MAX77693
+	  multifunction device. It has build in control for two leds in flash
+	  and torch mode.
+
 config LEDS_MAX8997
 	tristate "LED support for MAX8997 PMIC"
 	depends on LEDS_CLASS && MFD_MAX8997
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index d063364..8d7acec 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
 obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
+obj-$(CONFIG_LEDS_MAX77693)		+= leds-max77693.o
 obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
 obj-$(CONFIG_LEDS_LM355x)		+= leds-lm355x.o
 obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
new file mode 100644
index 0000000..e1386d3
--- /dev/null
+++ b/drivers/leds/leds-max77693.c
@@ -0,0 +1,1048 @@
+/*
+ * LED Flash Class driver for the flash cell of max77693 mfd.
+ *
+ *	Copyright (C) 2014, Samsung Electronics Co., Ltd.
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
+#include <linux/led-flash-manager.h>
+#include <linux/mfd/max77693.h>
+#include <linux/mfd/max77693-private.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <media/v4l2-flash.h>
+
+#define MAX77693_LED_NAME_1		"max77693-flash_1"
+#define MAX77693_LED_NAME_2		"max77693-flash_2"
+
+#define MODE_OFF		0
+#define MODE_FLASH1		(1 << 0)
+#define MODE_FLASH2		(1 << 1)
+#define MODE_TORCH1		(1 << 2)
+#define MODE_TORCH2		(1 << 3)
+#define MODE_FLASH_EXTERNAL1	(1 << 4)
+#define MODE_FLASH_EXTERNAL2	(1 << 5)
+
+enum {
+	FLED1,
+	FLED2
+};
+
+enum {
+	FLASH,
+	TORCH
+};
+
+struct max77693_sub_led {
+	struct led_classdev_flash ldev;
+	struct work_struct work_brightness_set;
+	struct v4l2_flash *v4l2_flash;
+
+	unsigned int torch_brightness;
+	unsigned int flash_timeout;
+};
+
+struct max77693_led {
+	struct regmap *regmap;
+	struct platform_device *pdev;
+	struct max77693_led_platform_data *pdata;
+	struct mutex lock;
+
+	struct max77693_sub_led sub_leds[2];
+
+	unsigned int current_flash_timeout;
+	unsigned int mode_flags;
+	u8 torch_iout_reg;
+	bool iout_joint;
+	int strobing_sub_led_id;
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
+static inline struct max77693_led *ldev1_to_led(
+					struct led_classdev_flash *ldev)
+{
+	struct max77693_sub_led *sub_led = container_of(ldev,
+						struct max77693_sub_led,
+						ldev);
+	return container_of(sub_led, struct max77693_led, sub_leds[0]);
+}
+
+static inline struct max77693_led *ldev2_to_led(
+					struct led_classdev_flash *ldev)
+{
+	struct max77693_sub_led *sub_led = container_of(ldev,
+						struct max77693_sub_led,
+						ldev);
+	return container_of(sub_led, struct max77693_led, sub_leds[1]);
+}
+
+static u8 max77693_led_vsys_to_reg(u32 mv)
+{
+	return ((mv - MAX_FLASH1_VSYS_MIN) / MAX_FLASH1_VSYS_STEP) << 2;
+}
+
+static u8 max77693_led_vout_to_reg(u32 mv)
+{
+	return (mv - FLASH_VOUT_MIN) / FLASH_VOUT_STEP + FLASH_VOUT_RMIN;
+}
+
+/* split composite current @i into two @iout according to @imax weights */
+static void max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
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
+static int max77693_set_mode(struct max77693_led *led, unsigned int mode)
+{
+	struct max77693_led_platform_data *p = led->pdata;
+	struct regmap *rmap = led->regmap;
+	int ret, v = 0;
+
+	if (mode & MODE_TORCH1) {
+		if (p->trigger[FLED1] & MAX77693_LED_TRIG_SOFT)
+			v |= FLASH_EN_ON << TORCH_EN_SHIFT(1);
+	}
+
+	if (mode & MODE_TORCH2) {
+		if (p->trigger[FLED2] & MAX77693_LED_TRIG_SOFT)
+			v |= FLASH_EN_ON << TORCH_EN_SHIFT(2);
+	}
+
+	if (mode & MODE_FLASH1) {
+		if (p->trigger[FLED1] & MAX77693_LED_TRIG_SOFT)
+			v |= FLASH_EN_ON << FLASH_EN_SHIFT(1);
+	} else if (mode & MODE_FLASH_EXTERNAL1) {
+		if (p->trigger[FLED1] & MAX77693_LED_TRIG_EXT)
+			v |= FLASH_EN_FLASH << FLASH_EN_SHIFT(2);
+		/*
+		 * Enable hw triggering also for torch mode, as some camera
+		 * sensors use torch led to fathom ambient light conditions
+		 * before strobing the flash.
+		 */
+		if (p->trigger[FLED1] & MAX77693_LED_TRIG_EXT)
+			v |= FLASH_EN_TORCH << TORCH_EN_SHIFT(1);
+	}
+
+	if (mode & MODE_FLASH2) {
+		if (p->trigger[FLED2] & MAX77693_LED_TRIG_SOFT)
+			v |= FLASH_EN_ON << FLASH_EN_SHIFT(2);
+	} else if (mode & MODE_FLASH_EXTERNAL2) {
+		if (p->trigger[FLED2] & MAX77693_LED_TRIG_EXT)
+			v |= FLASH_EN_FLASH << FLASH_EN_SHIFT(2);
+		/*
+		 * Enable hw triggering also for torch mode, as some camera
+		 * sensors use torch led to fathom ambient light conditions
+		 * before strobing the flash.
+		 */
+		if (p->trigger[FLED2] & MAX77693_LED_TRIG_EXT)
+			v |= FLASH_EN_TORCH << TORCH_EN_SHIFT(2);
+	}
+
+	/* Reset the register only prior setting flash modes */
+	if (mode & ~(MODE_TORCH1 | MODE_TORCH2)) {
+		ret = regmap_write(rmap, MAX77693_LED_REG_FLASH_EN, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return regmap_write(rmap, MAX77693_LED_REG_FLASH_EN, v);
+}
+
+static int max77693_add_mode(struct max77693_led *led, unsigned int mode)
+{
+	int ret;
+
+	/* Span mode on FLED2 for joint iouts case */
+	if (led->iout_joint)
+		mode |= (mode << 1);
+
+	/*
+	 * Torch mode once enabled remains active until turned off,
+	 * and thus no action is required in this case.
+	 */
+	if ((mode & MODE_TORCH1) &&
+	    (led->mode_flags & MODE_TORCH1))
+		return 0;
+	if ((mode & MODE_TORCH2) &&
+	    (led->mode_flags & MODE_TORCH2))
+		return 0;
+	/*
+	 * FLASH_EXTERNAL mode activates HW triggered flash and torch
+	 * modes in the device. The related register settings interfere
+	 * with SW triggerred modes, thus clear them to ensure proper
+	 * device configuration.
+	 */
+	if (mode & MODE_FLASH_EXTERNAL1)
+		led->mode_flags &= (~MODE_TORCH1 & ~MODE_FLASH1);
+	if (mode & MODE_FLASH_EXTERNAL2)
+		led->mode_flags &= (~MODE_TORCH2 & ~MODE_FLASH2);
+
+	led->mode_flags |= mode;
+
+	ret = max77693_set_mode(led, led->mode_flags);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Clear flash mode flag after setting the mode to avoid
+	 * spurous flash strobing on every subsequent torch mode
+	 * setting.
+	 */
+	if (mode & MODE_FLASH1 || mode & MODE_FLASH_EXTERNAL1 ||
+	    mode & MODE_FLASH2 || mode & MODE_FLASH_EXTERNAL2)
+		led->mode_flags &= ~mode;
+
+	return ret;
+}
+
+static int max77693_clear_mode(struct max77693_led *led, unsigned int mode)
+{
+	int ret;
+
+	/* Span mode on FLED2 for joint iouts case */
+	if (led->iout_joint)
+		mode |= (mode << 1);
+
+	led->mode_flags &= ~mode;
+
+	ret = max77693_set_mode(led, led->mode_flags);
+
+	return ret;
+}
+
+static int max77693_set_torch_current(struct max77693_led *led,
+					int led_id,
+					u32 micro_amp)
+{
+	struct max77693_led_platform_data *p = led->pdata;
+	struct regmap *rmap = led->regmap;
+	u32 iout[2], iout_max[2];
+	u8 iout1_reg = 0, iout2_reg = 0;
+
+	iout_max[FLED1] = p->iout_torch[FLED1];
+	iout_max[FLED2] = p->iout_torch[FLED2];
+
+	if (led_id == FLED1) {
+		/*
+		 * Preclude splitting current to FLED2 if we
+		 * are driving two separate leds.
+		 */
+		if (!led->iout_joint)
+			iout_max[FLED2] = 0;
+		max77693_calc_iout(iout, micro_amp, iout_max);
+	} else if (led_id == FLED2) {
+		iout_max[FLED1] = 0;
+		max77693_calc_iout(iout, micro_amp, iout_max);
+	}
+
+	if (led_id == FLED1 || led->iout_joint) {
+		iout1_reg = max77693_led_iout_to_reg(iout[FLED1]);
+		led->torch_iout_reg &= 0xf0;
+	}
+	if (led_id == FLED2 || led->iout_joint) {
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
+static int max77693_set_flash_current(struct max77693_led *led,
+					int led_id,
+					u32 micro_amp)
+{
+	struct max77693_led_platform_data *p = led->pdata;
+	struct regmap *rmap = led->regmap;
+	u32 iout[2], iout_max[2];
+	u8 iout1_reg, iout2_reg;
+	int ret = -EINVAL;
+
+	iout_max[FLED1] = p->iout_flash[FLED1];
+	iout_max[FLED2] = p->iout_flash[FLED2];
+
+	if (led_id == FLED1) {
+		/*
+		 * Preclude splitting current to FLED2 if we
+		 * are driving two separate leds.
+		 */
+		if (!led->iout_joint)
+			iout_max[FLED2] = 0;
+		max77693_calc_iout(iout, micro_amp, iout_max);
+	} else if (led_id == FLED2) {
+		iout_max[FLED1] = 0;
+		max77693_calc_iout(iout, micro_amp, iout_max);
+	}
+
+	if (led_id == FLED1 || led->iout_joint) {
+		iout1_reg = max77693_led_iout_to_reg(iout[FLED1]);
+		ret = regmap_write(rmap, MAX77693_LED_REG_IFLASH1,
+							iout1_reg);
+		if (ret < 0)
+			return ret;
+	}
+	if (led_id == FLED2 || led->iout_joint) {
+		iout2_reg = max77693_led_iout_to_reg(iout[FLED2]);
+		ret = regmap_write(rmap, MAX77693_LED_REG_IFLASH2,
+							iout2_reg);
+	}
+
+	return ret;
+}
+
+static int max77693_set_timeout(struct max77693_led *led, u32 timeout)
+{
+	struct max77693_led_platform_data *p = led->pdata;
+	struct regmap *rmap = led->regmap;
+	u8 v;
+	int ret;
+
+	v = max77693_flash_timeout_to_reg(timeout);
+
+	if (p->trigger_type[FLASH] == MAX77693_LED_TRIG_TYPE_LEVEL)
+		v |= FLASH_TMR_LEVEL;
+
+	ret = regmap_write(rmap, MAX77693_LED_REG_FLASH_TIMER, v);
+	if (ret < 0)
+		return ret;
+
+	led->current_flash_timeout = timeout;
+
+	return 0;
+}
+
+static int max77693_strobe_status_get(struct max77693_led *led, bool *state)
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
+static int max77693_int_flag_get(struct max77693_led *led, unsigned int *v)
+{
+	struct regmap *rmap = led->regmap;
+
+	return regmap_read(rmap, MAX77693_LED_REG_FLASH_INT, v);
+}
+
+static int max77693_setup(struct max77693_led *led)
+{
+	struct max77693_led_platform_data *p = led->pdata;
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
+		max_flash_curr[FLED1] = p->iout_flash[FLED1] +
+					p->iout_flash[FLED2];
+	} else {
+		first_led = p->fleds[FLED1] ? FLED1 : FLED2;
+		last_led = p->num_leds == 2 ? FLED2 : first_led;
+		max_flash_curr[FLED1] = p->iout_flash[FLED1];
+		max_flash_curr[FLED2] = p->iout_flash[FLED2];
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
+	ret = max77693_set_timeout(led,	p->flash_timeout);
+	if (ret < 0)
+		return ret;
+
+	if (p->low_vsys > 0)
+		v = max77693_led_vsys_to_reg(p->low_vsys) |
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
+	if (p->boost_mode == MAX77693_LED_BOOST_FIXED)
+		v = FLASH_BOOST_FIXED;
+	else
+		v = p->boost_mode | p->boost_mode << 1;
+	if (p->fleds[FLED1] && p->fleds[FLED2])
+		v |= FLASH_BOOST_LEDNUM_2;
+	ret = regmap_write(rmap, MAX77693_LED_REG_VOUT_CNTL, v);
+	if (ret < 0)
+		return ret;
+
+	v = max77693_led_vout_to_reg(p->boost_vout);
+	ret = regmap_write(rmap, MAX77693_LED_REG_VOUT_FLASH1, v);
+	if (ret < 0)
+		return ret;
+
+	return max77693_set_mode(led, MODE_OFF);
+}
+
+static int max77693_led_brightness_set(struct max77693_led *led,
+					int led_id, enum led_brightness value)
+{
+	int ret;
+
+	mutex_lock(&led->lock);
+
+	if (value == 0) {
+		ret = max77693_clear_mode(led, MODE_TORCH1 << led_id);
+		if (ret < 0)
+			dev_dbg(&led->pdev->dev,
+				"Failed to clear torch mode (%d)\n",
+				ret);
+		goto unlock;
+	}
+
+	ret = max77693_set_torch_current(led, led_id, value * TORCH_IOUT_STEP);
+	if (ret < 0) {
+		dev_dbg(&led->pdev->dev,
+			"Failed to set torch current (%d)\n",
+			ret);
+		goto unlock;
+	}
+
+	ret = max77693_add_mode(led, MODE_TORCH1 << led_id);
+	if (ret < 0)
+		dev_dbg(&led->pdev->dev,
+			"Failed to set torch mode (%d)\n",
+			ret);
+unlock:
+	mutex_unlock(&led->lock);
+	return ret;
+}
+
+#define MAX77693_LED_BRIGHTNESS_SET_WORK(ID)				\
+static void max77693_led##ID##_brightness_set_work(			\
+					struct work_struct *work)	\
+{									\
+	struct max77693_sub_led *sub_led =				\
+			container_of(work, struct max77693_sub_led,	\
+					work_brightness_set);		\
+	struct max77693_led *led = container_of(sub_led,		\
+					struct max77693_led,		\
+					sub_leds[FLED##ID]);		\
+	struct max77693_sub_led *sub_leds = led->sub_leds;		\
+									\
+	max77693_led_brightness_set(led, FLED##ID,			\
+				sub_leds[FLED##ID].torch_brightness);	\
+}
+
+/* LED subsystem callbacks */
+
+#define MAX77693_LED_TORCH_BRIGHTNESS_SET(ID)				\
+static int max77693_led##ID##_torch_brightness_set(			\
+				struct led_classdev *led_cdev,		\
+				enum led_brightness value)		\
+{									\
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);	\
+	struct max77693_led *led = ldev##ID##_to_led(flash);		\
+									\
+	return max77693_led_brightness_set(led, FLED##ID, value);	\
+}
+
+#define MAX77693_LED_BRIGHTNESS_SET(ID)					\
+static void max77693_led##ID##_brightness_set(				\
+				struct led_classdev *led_cdev,		\
+				enum led_brightness value)		\
+{									\
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);	\
+	struct max77693_led *led = ldev##ID##_to_led(flash);		\
+	struct max77693_sub_led *sub_leds = led->sub_leds;		\
+									\
+	sub_leds[FLED##ID].torch_brightness = value;			\
+	schedule_work(&sub_leds[FLED##ID].work_brightness_set);		\
+}
+
+#define MAX77693_LED_FLASH_BRIGHTNESS_SET(ID)				\
+static int max77693_led##ID##_flash_brightness_set(			\
+				struct led_classdev_flash *flash,	\
+				u32 brightness)				\
+{									\
+	struct max77693_led *led = ldev##ID##_to_led(flash);		\
+	int ret;							\
+									\
+	mutex_lock(&led->lock);						\
+	ret = max77693_set_flash_current(led, FLED##ID, brightness);	\
+	mutex_unlock(&led->lock);					\
+									\
+	return ret;							\
+}
+
+#define MAX77693_LED_FLASH_STROBE_SET(ID)				\
+static int max77693_led##ID##_flash_strobe_set(				\
+				struct led_classdev_flash *flash,	\
+				bool state)				\
+{									\
+	struct max77693_led *led = ldev##ID##_to_led(flash);		\
+	struct max77693_sub_led *sub_leds = led->sub_leds;		\
+	int ret;							\
+									\
+	mutex_lock(&led->lock);						\
+									\
+	if (!state) {							\
+		ret = max77693_clear_mode(led, MODE_FLASH##ID);		\
+		goto unlock;						\
+	}								\
+									\
+	if (sub_leds[FLED##ID].flash_timeout !=				\
+				led->current_flash_timeout) {		\
+		ret = max77693_set_timeout(led,				\
+				sub_leds[FLED##ID].flash_timeout);	\
+		if (ret < 0)						\
+			goto unlock;					\
+	}								\
+									\
+	led->strobing_sub_led_id = ID;					\
+									\
+	ret = max77693_add_mode(led, MODE_FLASH##ID);			\
+									\
+unlock:									\
+	mutex_unlock(&led->lock);					\
+	return ret;							\
+}
+
+#define MAX77693_LED_FLASH_EXTERNAL_STROBE_SET(ID)			\
+static int max77693_led##ID##_external_strobe_set(			\
+				struct led_classdev_flash *flash,	\
+				bool enable)				\
+{									\
+	struct max77693_led *led = ldev##ID##_to_led(flash);		\
+	int ret;							\
+									\
+	mutex_lock(&led->lock);						\
+									\
+	if (enable)							\
+		ret = max77693_add_mode(led, MODE_FLASH_EXTERNAL##ID);	\
+	else								\
+		ret = max77693_clear_mode(led,				\
+					MODE_FLASH_EXTERNAL##ID);	\
+									\
+	mutex_unlock(&led->lock);					\
+									\
+	return ret;							\
+}
+
+#define MAX77693_LED_FLASH_FAULT_GET(ID)				\
+static int max77693_led##ID##_flash_fault_get(				\
+				struct led_classdev_flash *flash,	\
+				u32 *fault)				\
+{									\
+	struct max77693_led *led = ldev##ID##_to_led(flash);		\
+	unsigned int v;							\
+	int ret;							\
+									\
+	ret = max77693_int_flag_get(led, &v);				\
+	if (ret < 0)							\
+		return ret;						\
+									\
+	*fault = 0;							\
+									\
+	if (v & FLASH_INT_FLED##ID##_OPEN)				\
+		*fault |= LED_FAULT_OVER_VOLTAGE;			\
+	if (v & FLASH_INT_FLED##ID##_SHORT)				\
+		*fault |= LED_FAULT_SHORT_CIRCUIT;			\
+	if (v & FLASH_INT_OVER_CURRENT)					\
+		*fault |= LED_FAULT_OVER_CURRENT;			\
+									\
+	return 0;							\
+}
+
+#define MAX77693_LED_FLASH_STROBE_GET(ID)				\
+static int max77693_led##ID##_flash_strobe_get(				\
+				struct led_classdev_flash *flash,	\
+				bool *state)				\
+{									\
+	struct max77693_led *led = ldev##ID##_to_led(flash);		\
+	int ret;							\
+									\
+	if (!state)							\
+		return -EINVAL;						\
+									\
+	mutex_lock(&led->lock);						\
+									\
+	ret = max77693_strobe_status_get(led, state);			\
+									\
+	*state = !!(*state && led->strobing_sub_led_id == ID);		\
+									\
+	mutex_unlock(&led->lock);					\
+									\
+	return ret;							\
+}
+
+#define MAX77693_LED_FLASH_TIMEOUT_SET(ID)				\
+static int max77693_led##ID##_flash_timeout_set(			\
+				struct led_classdev_flash *flash,	\
+				u32 timeout)				\
+{									\
+	struct max77693_led *led = ldev##ID##_to_led(flash);		\
+	struct max77693_sub_led *sub_leds = led->sub_leds;		\
+									\
+	mutex_lock(&led->lock);						\
+	sub_leds[FLED##ID].flash_timeout = timeout;			\
+	mutex_unlock(&led->lock);					\
+									\
+	return 0;							\
+}
+
+MAX77693_LED_BRIGHTNESS_SET(1)
+MAX77693_LED_BRIGHTNESS_SET_WORK(1)
+MAX77693_LED_TORCH_BRIGHTNESS_SET(1)
+MAX77693_LED_FLASH_BRIGHTNESS_SET(1)
+MAX77693_LED_FLASH_STROBE_SET(1)
+MAX77693_LED_FLASH_STROBE_GET(1)
+MAX77693_LED_FLASH_EXTERNAL_STROBE_SET(1)
+MAX77693_LED_FLASH_TIMEOUT_SET(1)
+MAX77693_LED_FLASH_FAULT_GET(1)
+
+MAX77693_LED_BRIGHTNESS_SET(2)
+MAX77693_LED_BRIGHTNESS_SET_WORK(2)
+MAX77693_LED_TORCH_BRIGHTNESS_SET(2)
+MAX77693_LED_FLASH_BRIGHTNESS_SET(2)
+MAX77693_LED_FLASH_STROBE_SET(2)
+MAX77693_LED_FLASH_STROBE_GET(2)
+MAX77693_LED_FLASH_EXTERNAL_STROBE_SET(2)
+MAX77693_LED_FLASH_TIMEOUT_SET(2)
+MAX77693_LED_FLASH_FAULT_GET(2)
+
+static void max77693_led_parse_dt(struct max77693_led_platform_data *p,
+			    struct device_node *node)
+{
+	of_property_read_u32_array(node, "iout-torch", p->iout_torch, 2);
+	of_property_read_u32_array(node, "iout-flash", p->iout_flash, 2);
+	of_property_read_u32_array(node, "maxim,fleds", p->fleds, 2);
+	of_property_read_u32_array(node, "maxim,trigger", p->trigger, 2);
+	of_property_read_u32_array(node, "maxim,trigger-type", p->trigger_type,
+									2);
+	of_property_read_u32(node, "flash-timeout", &p->flash_timeout);
+	of_property_read_u32(node, "maxim,boost-mode", &p->boost_mode);
+	of_property_read_u32(node, "maxim,boost-vout", &p->boost_vout);
+	of_property_read_u32(node, "maxim,num-leds", &p->num_leds);
+	of_property_read_u32(node, "maxim,vsys-min", &p->low_vsys);
+}
+
+static void clamp_align(u32 *v, u32 min, u32 max, u32 step)
+{
+	*v = clamp_val(*v, min, max);
+	if (step > 1)
+		*v = (*v - min) / step * step + min;
+}
+
+static void max77693_led_validate_platform_data(
+					struct max77693_led_platform_data *p)
+{
+	u32 max;
+	int i;
+
+	p->boost_mode = clamp_val(p->boost_mode, MAX77693_LED_BOOST_NONE,
+			    MAX77693_LED_BOOST_FIXED);
+	p->num_leds = clamp_val(p->num_leds, 1, 2);
+
+	for (i = 0; i < ARRAY_SIZE(p->fleds); ++i)
+		p->fleds[i] = clamp_val(p->fleds[i], 0, 1);
+
+	/* Ensure fleds configuration is sane */
+	if (!p->fleds[FLED1] && !p->fleds[FLED2]) {
+		p->fleds[FLED1] = p->fleds[FLED2] = 1;
+		p->num_leds = 1;
+	}
+
+	/* Ensure num_leds is consistent with fleds configuration */
+	if ((!p->fleds[FLED1] || !p->fleds[FLED2]) && p->num_leds == 2)
+		p->num_leds = 1;
+
+	/*
+	 * boost must be enabled if current outputs
+	 * are connected to separate leds.
+	 */
+	if ((p->num_leds == 2 || (p->fleds[FLED1] && p->fleds[FLED2])) &&
+	    p->boost_mode == MAX77693_LED_BOOST_NONE)
+		p->boost_mode = MAX77693_LED_BOOST_FIXED;
+
+	max = p->boost_mode ? FLASH_IOUT_MAX_2LEDS : FLASH_IOUT_MAX_1LED;
+
+	if (p->fleds[FLED1]) {
+		clamp_align(&p->iout_torch[FLED1], TORCH_IOUT_MIN,
+					TORCH_IOUT_MAX, TORCH_IOUT_STEP);
+		clamp_align(&p->iout_flash[FLED1], FLASH_IOUT_MIN, max,
+							FLASH_IOUT_STEP);
+	} else {
+		p->iout_torch[FLED1] = p->iout_flash[FLED1] = 0;
+	}
+	if (p->fleds[FLED2]) {
+		clamp_align(&p->iout_torch[FLED2], TORCH_IOUT_MIN,
+					TORCH_IOUT_MAX, TORCH_IOUT_STEP);
+		clamp_align(&p->iout_flash[FLED2], FLASH_IOUT_MIN, max,
+							FLASH_IOUT_STEP);
+	} else {
+		p->iout_torch[FLED2] = p->iout_flash[FLED2] = 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(p->trigger); ++i)
+		p->trigger[i] = clamp_val(p->trigger[i], 0, 7);
+	for (i = 0; i < ARRAY_SIZE(p->trigger_type); ++i)
+		p->trigger_type[i] = clamp_val(p->trigger_type[i],
+					MAX77693_LED_TRIG_TYPE_EDGE,
+					MAX77693_LED_TRIG_TYPE_LEVEL);
+
+	clamp_align(&p->flash_timeout, FLASH_TIMEOUT_MIN, FLASH_TIMEOUT_MAX,
+						FLASH_TIMEOUT_STEP);
+
+	clamp_align(&p->boost_vout, FLASH_VOUT_MIN, FLASH_VOUT_MAX,
+							FLASH_VOUT_STEP);
+
+	if (p->low_vsys)
+		clamp_align(&p->low_vsys, MAX_FLASH1_VSYS_MIN,
+				MAX_FLASH1_VSYS_MAX, MAX_FLASH1_VSYS_STEP);
+}
+
+static int max77693_led_get_platform_data(struct max77693_led *led)
+{
+	struct max77693_led_platform_data *p;
+	struct device *dev = &led->pdev->dev;
+
+	if (dev->of_node) {
+		p = devm_kzalloc(dev, sizeof(*led->pdata), GFP_KERNEL);
+		if (!p)
+			return -ENOMEM;
+		max77693_led_parse_dt(p, dev->of_node);
+	} else {
+		p = dev_get_platdata(dev);
+		if (!p)
+			return -ENODEV;
+	}
+	led->pdata = p;
+
+	max77693_led_validate_platform_data(p);
+
+	return 0;
+}
+
+#define MAX77693_LED_INIT_FLASH_OPS(ID)						\
+const struct led_flash_ops flash_ops##ID = {					\
+										\
+	.flash_brightness_set	= max77693_led##ID##_flash_brightness_set,	\
+	.strobe_set 		= max77693_led##ID##_flash_strobe_set,		\
+	.strobe_get		= max77693_led##ID##_flash_strobe_get,		\
+	.timeout_set		= max77693_led##ID##_flash_timeout_set,		\
+	.external_strobe_set	= max77693_led##ID##_external_strobe_set,	\
+	.fault_get		= max77693_led##ID##_flash_fault_get,		\
+}
+
+MAX77693_LED_INIT_FLASH_OPS(1);
+MAX77693_LED_INIT_FLASH_OPS(2);
+
+static void max77693_init_flash_settings(struct max77693_led *led,
+					 struct max77693_led_settings *s,
+					 int led_id)
+{
+	struct max77693_led_platform_data *p = led->pdata;
+	struct led_flash_setting *setting;
+
+	/* Init torch intensity setting */
+	setting = &s->torch_brightness;
+	setting->min = led->iout_joint ? TORCH_IOUT_MIN * 2 :
+					 TORCH_IOUT_MIN;
+	setting->max = led->iout_joint ?
+			p->iout_torch[FLED1] + p->iout_torch[FLED2] :
+			p->iout_torch[led_id];
+	setting->step = TORCH_IOUT_STEP;
+	setting->val = setting->max;
+
+	/* Init flash intensity setting */
+	setting = &s->flash_brightness;
+	setting->min = led->iout_joint ? FLASH_IOUT_MIN * 2 :
+					 FLASH_IOUT_MIN;
+	setting->max = led->iout_joint ?
+			p->iout_flash[FLED1] + p->iout_flash[FLED2] :
+			p->iout_flash[led_id];
+	setting->step = FLASH_IOUT_STEP;
+	setting->val = setting->max;
+
+	/* Init flash timeout setting */
+	setting = &s->flash_timeout;
+	setting->min = FLASH_TIMEOUT_MIN;
+	setting->max = FLASH_TIMEOUT_MAX;
+	setting->step = FLASH_TIMEOUT_STEP;
+	setting->val = p->flash_timeout;
+}
+
+#ifdef CONFIG_V4L2_FLASH_LED_CLASS
+static void max77693_init_v4l2_ctrl_config(struct max77693_led_settings *s,
+					struct v4l2_flash_ctrl_config *config)
+{
+	struct led_flash_setting *setting;
+	struct v4l2_ctrl_config *c;
+
+	c = &config->torch_intensity;
+	setting = &s->torch_brightness;
+	c->min = setting->min;
+	c->max = setting->max;
+	c->step = setting->step;
+	c->def = setting->val;
+
+	c = &config->flash_intensity;
+	setting = &s->flash_brightness;
+	c->min = setting->min;
+	c->max = setting->max;
+	c->step = setting->step;
+	c->def = setting->val;
+
+	c = &config->flash_timeout;
+	setting = &s->flash_timeout;
+	c->min = setting->min;
+	c->max = setting->max;
+	c->step = setting->step;
+	c->def = setting->val;
+
+	/* Init flash faults config */
+	config->flash_faults =	V4L2_FLASH_FAULT_OVER_VOLTAGE |
+				V4L2_FLASH_FAULT_SHORT_CIRCUIT |
+				V4L2_FLASH_FAULT_OVER_CURRENT;
+}
+#else
+#define max77693_init_v4l2_ctrl_config(s, config)
+#endif
+
+static int max77693_register_led(struct max77693_led *led, int id)
+{
+	struct platform_device *pdev = led->pdev;
+	struct device *dev = &pdev->dev;
+	struct led_classdev_flash *flash;
+	struct led_classdev *led_cdev;
+	struct max77693_led_platform_data *p = led->pdata;
+	struct max77693_sub_led *sub_leds = led->sub_leds;
+#ifdef CONFIG_V4L2_FLASH_LED_CLASS
+	struct v4l2_flash_ctrl_config v4l2_flash_config;
+#endif
+	struct max77693_led_settings settings;
+	int ret;
+
+	flash = &sub_leds[id].ldev;
+
+	/* Init flash settings */
+	max77693_init_flash_settings(led, &settings, id);
+	/* Init V4L2 Flash controls basing on initialized settings */
+	max77693_init_v4l2_ctrl_config(&settings, &v4l2_flash_config);
+
+	/* Init led class */
+	led_cdev = &flash->led_cdev;
+
+	if (id == FLED1) {
+		led_cdev->name = MAX77693_LED_NAME_1;
+		led_cdev->brightness_set = max77693_led1_brightness_set;
+		led_cdev->torch_brightness_set =
+				max77693_led1_torch_brightness_set;
+		INIT_WORK(&sub_leds[id].work_brightness_set,
+				max77693_led1_brightness_set_work);
+		flash->ops = &flash_ops1;
+	} else {
+		led_cdev->name = MAX77693_LED_NAME_2;
+		led_cdev->brightness_set = max77693_led2_brightness_set;
+		led_cdev->torch_brightness_set =
+				max77693_led2_torch_brightness_set;
+		INIT_WORK(&sub_leds[id].work_brightness_set,
+				max77693_led2_brightness_set_work);
+		flash->ops = &flash_ops2;
+	}
+
+	led_cdev->max_brightness = settings.torch_brightness.val /
+					TORCH_IOUT_STEP;
+	led_cdev->flags |= LED_DEV_CAP_FLASH;
+
+	flash->brightness = settings.flash_brightness;
+	flash->timeout = settings.flash_timeout;
+	sub_leds[id].flash_timeout = flash->timeout.val;
+
+	if (p->trigger[id] & MAX77693_LED_TRIG_FLASH)
+		flash->has_external_strobe = true;
+
+	/* Register in the LED subsystem. */
+	ret = led_classdev_flash_register(&pdev->dev, flash,
+						dev->of_node);
+	if (ret < 0)
+		return ret;
+
+	sub_leds[id].v4l2_flash =
+			v4l2_flash_init(flash,
+					&v4l2_flash_config,
+					led_get_v4l2_flash_ops());
+
+	if (IS_ERR(sub_leds[id].v4l2_flash)) {
+		ret = PTR_ERR(sub_leds[id].v4l2_flash);
+		goto err_v4l2_flash_init;
+	}
+
+	return 0;
+
+err_v4l2_flash_init:
+	led_classdev_flash_unregister(flash);
+
+	return ret;
+}
+
+static int max77693_led_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
+	struct max77693_led *led;
+	struct max77693_led_platform_data *p;
+	struct max77693_sub_led *sub_leds;
+	int ret;
+
+	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->pdev = pdev;
+	led->regmap = iodev->regmap;
+	sub_leds = led->sub_leds;
+	platform_set_drvdata(pdev, led);
+	ret = max77693_led_get_platform_data(led);
+	if (ret < 0)
+		return -EINVAL;
+
+	p = led->pdata;
+	mutex_init(&led->lock);
+
+	if (p->num_leds == 1 && p->fleds[FLED1] && p->fleds[FLED2])
+		led->iout_joint = true;
+
+	ret = max77693_setup(led);
+	if (ret < 0)
+		goto unlock;
+
+	if (led->iout_joint || p->fleds[FLED1]) {
+		ret = max77693_register_led(led, FLED1);
+		if (ret < 0)
+			goto unlock;
+	}
+
+	if (!led->iout_joint && p->fleds[FLED2]) {
+		ret = max77693_register_led(led, FLED2);
+		if (ret < 0)
+			goto err_register_led2;
+	}
+
+	return 0;
+
+err_register_led2:
+	if (!p->fleds[FLED1])
+		goto unlock;
+	v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
+	led_classdev_flash_unregister(&sub_leds[FLED1].ldev);
+unlock:
+	mutex_destroy(&led->lock);
+
+	return ret;
+}
+
+static int max77693_led_remove(struct platform_device *pdev)
+{
+	struct max77693_led *led = platform_get_drvdata(pdev);
+	struct max77693_led_platform_data *p = led->pdata;
+	struct max77693_sub_led *sub_leds = led->sub_leds;
+
+	if (led->iout_joint || p->fleds[FLED1]) {
+		v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
+		led_classdev_flash_unregister(&sub_leds[FLED1].ldev);
+		cancel_work_sync(&sub_leds[FLED1].work_brightness_set);
+	}
+
+	if (!led->iout_joint && p->fleds[FLED2]) {
+		v4l2_flash_release(sub_leds[FLED2].v4l2_flash);
+		led_classdev_flash_unregister(&sub_leds[FLED2].ldev);
+		cancel_work_sync(&sub_leds[FLED2].work_brightness_set);
+	}
+
+	mutex_destroy(&led->lock);
+
+	return 0;
+}
+
+static struct of_device_id max77693_led_dt_match[] = {
+	{.compatible = "maxim,max77693-flash"},
+	{},
+};
+
+static struct platform_driver max77693_led_driver = {
+	.probe		= max77693_led_probe,
+	.remove		= max77693_led_remove,
+	.driver		= {
+		.name	= "max77693-flash",
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
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 249c139..cf008f4 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -44,9 +44,12 @@
 static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-pmic", },
 	{ .name = "max77693-charger", },
-	{ .name = "max77693-flash", },
 	{ .name = "max77693-muic", },
 	{ .name = "max77693-haptic", },
+	{
+		.name = "max77693-flash",
+		.of_compatible = "maxim,max77693-flash",
+	},
 };
 
 static const struct regmap_config max77693_regmap_config = {
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 615f121..de06377 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -85,6 +85,65 @@ enum max77693_pmic_reg {
 	MAX77693_PMIC_REG_END,
 };
 
+/* MAX77693 ITORCH register */
+#define TORCH_IOUT1_SHIFT	0
+#define TORCH_IOUT2_SHIFT	4
+#define TORCH_IOUT_MIN		15625
+#define TORCH_IOUT_MAX		250000
+#define TORCH_IOUT_STEP		15625
+
+/* MAX77693 IFLASH1 and IFLASH2 registers */
+#define FLASH_IOUT_MIN		15625
+#define FLASH_IOUT_MAX_1LED	1000000
+#define FLASH_IOUT_MAX_2LEDS	625000
+#define FLASH_IOUT_STEP		15625
+
+/* MAX77693 TORCH_TIMER register */
+#define TORCH_TMR_NO_TIMER	0x40
+#define TORCH_TIMEOUT_MIN	262000
+#define TORCH_TIMEOUT_MAX	15728000
+
+/* MAX77693 FLASH_TIMER register */
+#define FLASH_TMR_LEVEL		0x80
+#define FLASH_TIMEOUT_MIN	62500
+#define FLASH_TIMEOUT_MAX	1000000
+#define FLASH_TIMEOUT_STEP	62500
+
+/* MAX77693 FLASH_EN register */
+#define FLASH_EN_OFF		0x0
+#define FLASH_EN_FLASH		0x1
+#define FLASH_EN_TORCH		0x2
+#define FLASH_EN_ON		0x3
+#define FLASH_EN_SHIFT(x)	(6 - ((x) - 1) * 2)
+#define TORCH_EN_SHIFT(x)	(2 - ((x) - 1) * 2)
+
+/* MAX77693 MAX_FLASH1 register */
+#define MAX_FLASH1_MAX_FL_EN	0x80
+#define MAX_FLASH1_VSYS_MIN	2400
+#define MAX_FLASH1_VSYS_MAX	3400
+#define MAX_FLASH1_VSYS_STEP	33
+
+/* MAX77693 VOUT_CNTL register */
+#define FLASH_BOOST_FIXED	0x04
+#define FLASH_BOOST_LEDNUM_2	0x80
+
+/* MAX77693 VOUT_FLASH1 register */
+#define FLASH_VOUT_MIN		3300
+#define FLASH_VOUT_MAX		5500
+#define FLASH_VOUT_STEP		25
+#define FLASH_VOUT_RMIN		0x0c
+
+/* MAX77693 FLASH_STATUS register */
+#define FLASH_STATUS_FLASH_ON	BIT(3)
+#define FLASH_STATUS_TORCH_ON	BIT(2)
+
+/* MAX77693 FLASH_INT register */
+#define FLASH_INT_FLED2_OPEN	BIT(0)
+#define FLASH_INT_FLED2_SHORT	BIT(1)
+#define FLASH_INT_FLED1_OPEN	BIT(2)
+#define FLASH_INT_FLED1_SHORT	BIT(3)
+#define FLASH_INT_OVER_CURRENT	BIT(4)
+
 /* MAX77693 CHG_CNFG_00 register */
 #define CHG_CNFG_00_CHG_MASK		0x1
 #define CHG_CNFG_00_BUCK_MASK		0x4
diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index 3f3dc45..f0b6585 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -63,6 +63,45 @@ struct max77693_muic_platform_data {
 	int path_uart;
 };
 
+/* MAX77693 led flash */
+
+/* triggers */
+enum max77693_led_trigger {
+	MAX77693_LED_TRIG_OFF,
+	MAX77693_LED_TRIG_FLASH,
+	MAX77693_LED_TRIG_TORCH,
+	MAX77693_LED_TRIG_EXT,
+	MAX77693_LED_TRIG_SOFT,
+};
+
+/* trigger types */
+enum max77693_led_trigger_type {
+	MAX77693_LED_TRIG_TYPE_EDGE,
+	MAX77693_LED_TRIG_TYPE_LEVEL,
+};
+
+/* boost modes */
+enum max77693_led_boost_mode {
+	MAX77693_LED_BOOST_NONE,
+	MAX77693_LED_BOOST_ADAPTIVE,
+	MAX77693_LED_BOOST_FIXED,
+};
+
+struct max77693_led_platform_data {
+	u32 fleds[2];
+	u32 iout_torch[2];
+	u32 iout_flash[2];
+	u32 trigger[2];
+	u32 trigger_type[2];
+	u32 num_leds;
+	u32 boost_mode;
+	u32 flash_timeout;
+	u32 boost_vout;
+	u32 low_vsys;
+};
+
+/* MAX77693 */
+
 struct max77693_platform_data {
 	/* regulator data */
 	struct max77693_regulator_data *regulators;
@@ -70,5 +109,6 @@ struct max77693_platform_data {
 
 	/* muic data */
 	struct max77693_muic_platform_data *muic_data;
+	struct max77693_led_platform_data *led_data;
 };
 #endif	/* __LINUX_MFD_MAX77693_H */
-- 
1.7.9.5


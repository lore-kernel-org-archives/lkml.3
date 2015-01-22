Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbbAVAiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:38:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49290 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbbAVAiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:38:17 -0500
X-AuditID: cbfee68e-f79b46d000002b74-f4-54c04676d8d0
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org, robh+dt@kernel.org
Cc: lee.jone@linaro.org, broonie@kernel.org, dbaryshkov@gmail.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v3 1/2] power: rt5033_charger: Add RT5033 charger device driver
Date: Thu, 22 Jan 2015 09:38:11 +0900
Message-id: <1421887092-4070-2-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1421887092-4070-1-git-send-email-beomho.seo@samsung.com>
References: <1421887092-4070-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkRLfM7UCIwZNnwhanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchqce7VSkaLSfcnsFi833OG0eLyrjlsFp97jzBa
	LL1+kcliwvS1LBate4+wW5zeXWIxY/JLNgdBjzXz1jB6XO7rZfLYOesuu8fK5V/YPDav0PLY
	tKqTzePOtT1sHn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJVx+eRptoIT1RWPNu9kb2BsSu9i
	5OSQEDCR2HfzKQuELSZx4d56ti5GLg4hgaWMEnO3rGeGKfr9ZisrRGIRo8TZ5t9QVW1MEvvb
	WsCq2AQ0Jd5PuQI2SkSgRmLSmfdgRcwCO5kkds38wQqSEBbwl9i/eR8jiM0ioCoxdeJ7sAZe
	AVeJ2b1H2LsYOYDWKUjMmWQDEuYUcJPYfH0qG4gtBFSy9/d0qFMbOSSmTreDGCMg8W3yIRaI
	VlmJTQegjpaUOLjiBssERuEFjAyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQLj7fS/Z307
	GG8esD7EKMDBqMTD+0Jxf4gQa2JZcWXuIUZToA0TmaVEk/OBUZ1XEm9obGZkYWpiamxkbmmm
	JM6bIPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjkoydzzZKtZ6f8JevI++8xYIm49MK
	D2Z1uiYcyyx8dJxzzrMtc7+W/uc/uLWmdAID+/9dvtsTu0UPiz0s+bSMmXeaY6C2Z8czLYlL
	6yYJcKz3Nvj6SGyd/e2U05M3XPO6+C/NcOe/WsWVnPO/ppSmutq691eKzDn95knsWmmW5Qkq
	nA+ub5U6pcRSnJFoqMVcVJwIADUwGBiyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd0ytwMhBscPs1mc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC0mrpzMbNH/ZiGrxblXKxktJt2fwGLxfs8ZRovLu+awWXzuPcJo
	sfT6RSaLCdPXsli07j3CbnF6d4nFjMkv2RwEPdbMW8Pocbmvl8lj56y77B4rl39h89i8Qstj
	06pONo871/awefRtWcXo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGl
	hbmSQl5ibqqtkotPgK5bZg7QL0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBA
	whrGjMsnT7MVnKiueLR5J3sDY1N6FyMnh4SAicTvN1tZIWwxiQv31rN1MXJxCAksYpQ42/wb
	ymljktjf1sIMUsUmoCnxfsoVFhBbRKBGYtKZ92BFzAI7mSR2zfwBNkpYwF9i/+Z9jCA2i4Cq
	xNSJ78EaeAVcJWb3HmHvYuQAWqcgMWeSDUiYU8BNYvP1qWwgthBQyd7f01kmMPIuYGRYxSia
	WpBcUJyUnmuoV5yYW1yal66XnJ+7iREcz8+kdjCubLA4xCjAwajEw/tCcX+IEGtiWXFl7iFG
	CQ5mJRFeD40DIUK8KYmVValF+fFFpTmpxYcYTYGOmsgsJZqcD0w1eSXxhsYmZkaWRuaGFkbG
	5krivEr2bSFCAumJJanZqakFqUUwfUwcnFINjMk/36Y1xUo/ed+6ff4FHffFzfllMxpa7u66
	VKTV/fd7mZTK3CsbBc9eaun5dqvoiu/1W31B3jEHn4qIh8vGNydHf9c8evDtGuOP8d/UH3nE
	Lr37X0esT0jbKKBp3qzjIkqzxZgmve3gLmJ/sqq0S/RImMfrH3E/oyIslv1pC8kMkmLyebVb
	VImlOCPRUIu5qDgRAB1WTjz9AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add device driver of Richtek RT5033 PMIC. The driver support
switching charger. rt5033 charger provide three charging mode.
Three charging mode are pre charge mode, fast cahrge mode and constant voltage
mode. They are have vary charge rate, charge parameters. The charge parameters
can be controlled by i2c interface.

Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
Changes in v3
Changes in v2
- none
---
 drivers/power/Kconfig          |    8 +
 drivers/power/Makefile         |    1 +
 drivers/power/rt5033_charger.c |  485 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 494 insertions(+)
 create mode 100644 drivers/power/rt5033_charger.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index da6981f..629b101 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -405,6 +405,14 @@ config BATTERY_RT5033
 	  The fuelgauge calculates and determines the battery state of charge
 	  according to battery open circuit voltage.
 
+config CHARGER_RT5033
+	tristate "RT5033 battery charger support"
+	depends on MFD_RT5033
+	help
+	  This adds support for battery charger in Richtek RT5033 PMIC.
+	  The device supports pre-charge mode, fast charge mode and
+	  constant voltage mode.
+
 source "drivers/power/reset/Kconfig"
 
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b83a0c7..bb8cce3 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
 obj-$(CONFIG_CHARGER_BQ24190)	+= bq24190_charger.o
 obj-$(CONFIG_CHARGER_BQ24735)	+= bq24735-charger.o
 obj-$(CONFIG_POWER_AVS)		+= avs/
+obj-$(CONFIG_POWER_RT5033)	+= rt5033_charger.o
 obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
 obj-$(CONFIG_CHARGER_TPS65090)	+= tps65090-charger.o
 obj-$(CONFIG_POWER_RESET)	+= reset/
diff --git a/drivers/power/rt5033_charger.c b/drivers/power/rt5033_charger.c
new file mode 100644
index 0000000..9dcaef4
--- /dev/null
+++ b/drivers/power/rt5033_charger.c
@@ -0,0 +1,485 @@
+/*
+ * Battery charger driver for RT5033
+ *
+ * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
+ * Author: Beomho Seo <beomho.seo@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published bythe Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/mfd/rt5033-private.h>
+#include <linux/mfd/rt5033.h>
+
+static int rt5033_get_charger_state(struct rt5033_charger *charger)
+{
+	struct regmap *regmap = charger->rt5033->regmap;
+	int state = POWER_SUPPLY_STATUS_UNKNOWN;
+	u32 reg_data;
+
+	if (!regmap)
+		return state;
+
+	regmap_read(regmap, RT5033_REG_CHG_STAT, &reg_data);
+
+	switch (reg_data & RT5033_CHG_STAT_MASK) {
+	case RT5033_CHG_STAT_DISCHARGING:
+		state = POWER_SUPPLY_STATUS_DISCHARGING;
+		break;
+	case RT5033_CHG_STAT_CHARGING:
+		state = POWER_SUPPLY_STATUS_CHARGING;
+		break;
+	case RT5033_CHG_STAT_FULL:
+		state = POWER_SUPPLY_STATUS_FULL;
+		break;
+	case RT5033_CHG_STAT_NOT_CHARGING:
+		state = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		break;
+	}
+
+	return state;
+}
+
+static int rt5033_get_charger_type(struct rt5033_charger *charger)
+{
+	struct regmap *regmap = charger->rt5033->regmap;
+	int state = POWER_SUPPLY_CHARGE_TYPE_UNKNOWN;
+	u32 reg_data;
+
+	regmap_read(regmap, RT5033_REG_CHG_STAT, &reg_data);
+
+	switch (reg_data & RT5033_CHG_STAT_TYPE_MASK) {
+	case RT5033_CHG_STAT_TYPE_FAST:
+		state = POWER_SUPPLY_CHARGE_TYPE_FAST;
+		break;
+	case RT5033_CHG_STAT_TYPE_PRE:
+		state = POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
+		break;
+	}
+
+	return state;
+}
+
+static int rt5033_get_charger_current(struct rt5033_charger *charger,
+		enum power_supply_property psp)
+{
+	struct regmap *regmap = charger->rt5033->regmap;
+	unsigned int state, reg_data, data;
+
+	if (psp == POWER_SUPPLY_PROP_CURRENT_MAX)
+		return RT5033_CHG_MAX_CURRENT;
+
+	regmap_read(regmap, RT5033_REG_CHG_CTRL5, &reg_data);
+
+	state = (reg_data >> RT5033_CHGCTRL5_ICHG_SHIFT) & 0xf;
+
+	if (state > RT5033_CHG_MAX_CURRENT)
+		state = RT5033_CHG_MAX_CURRENT;
+
+	data = state * 100 + 700;
+
+	return data;
+}
+
+static int rt5033_get_charge_voltage(struct rt5033_charger *charger,
+		enum power_supply_property psp)
+{
+	struct regmap *regmap = charger->rt5033->regmap;
+	unsigned int state, reg_data, data;
+
+	if (psp == POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX)
+		return RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MAX;
+
+	regmap_read(regmap, RT5033_REG_CHG_CTRL2, &reg_data);
+
+	state = reg_data >> 2;
+
+	data = RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MIN +
+		RT5033_CHARGER_CONST_VOLTAGE_STEP_NUM * state;
+
+	if (data > RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MAX)
+		data = RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MAX;
+
+	return data;
+}
+
+static inline int rt5033_init_const_charge(struct rt5033_charger *psy)
+{
+	struct rt5033_charger_data *chg = psy->chg;
+	unsigned val;
+	int ret;
+	u8 reg_data;
+
+	/* Set Constant voltage mode */
+	if (chg->const_uvolt < RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MIN ||
+		chg->const_uvolt > RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MAX)
+		return -EINVAL;
+
+	if (chg->const_uvolt == RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MIN)
+		reg_data = 0x0;
+	else if (chg->const_uvolt == RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MAX)
+		reg_data = 0xfc;
+	else {
+		val = chg->const_uvolt;
+		val -= RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MIN;
+		val /= RT5033_CHARGER_CONST_VOLTAGE_STEP_NUM;
+		reg_data = val;
+	}
+
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_CHG_CTRL2,
+			RT5033_CHGCTRL2_CV_MASK, reg_data << 2);
+	if (ret) {
+		dev_err(psy->dev, "Failed regmap update\n");
+		return -EINVAL;
+	}
+
+	/* Set end of charge current */
+	if (chg->eoc_uamp < RT5033_CHARGER_EOC_MIN ||
+		chg->eoc_uamp > RT5033_CHARGER_EOC_MAX)
+		return -EINVAL;
+
+	if (chg->eoc_uamp == RT5033_CHARGER_EOC_MIN)
+		reg_data = 0x1;
+	else if (chg->eoc_uamp == RT5033_CHARGER_EOC_MAX)
+		reg_data = 0x7;
+	else {
+		val = chg->eoc_uamp;
+		if (val < RT5033_CHARGER_EOC_REF) {
+			val -= RT5033_CHARGER_EOC_MIN;
+			val /= RT5033_CHARGER_EOC_STEP_NUM1;
+			reg_data = 0x01 + val;
+		} else if (val > RT5033_CHARGER_EOC_REF) {
+			val -= RT5033_CHARGER_EOC_REF;
+			val /= RT5033_CHARGER_EOC_STEP_NUM2;
+			reg_data = 0x04 + val;
+		} else {
+			reg_data = 0x04;
+		}
+	}
+
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_CHG_CTRL4,
+			RT5033_CHGCTRL4_EOC_MASK, reg_data);
+	if (ret) {
+		dev_err(psy->dev, "Failed regmap update\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static inline int rt5033_init_fast_charge(struct rt5033_charger *psy)
+{
+	struct rt5033_charger_data *chg = psy->chg;
+	int ret;
+	u8 reg_data;
+
+	/* Set limit input current */
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_CHG_CTRL1,
+			RT5033_AICR_MODE_MASK, RT5033_AICR_2000_MODE);
+	if (ret) {
+		dev_err(psy->dev, "Failed regmap update\n");
+		return -EINVAL;
+	}
+
+	/* Set internal timer */
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_CHG_CTRL3,
+		RT5033_CHGCTRL3_TIMER_MASK | RT5033_CHGCTRL3_TIMER_EN_MASK,
+		RT5033_FAST_CHARGE_TIMER4 | RT5033_INT_TIMER_ENABLE);
+	if (ret) {
+		dev_err(psy->dev, "Failed regmap update\n");
+		return -EINVAL;
+	}
+
+	/* Set fast-charge mode Carging current */
+	if (chg->fast_uamp < RT5033_CHARGER_FAST_CURRENT_MIN ||
+			chg->fast_uamp > RT5033_CHARGER_FAST_CURRENT_MAX)
+		return -EINVAL;
+
+	if (chg->fast_uamp == RT5033_CHARGER_FAST_CURRENT_MIN)
+		reg_data = 0x0;
+	else if (chg->fast_uamp == RT5033_CHARGER_FAST_CURRENT_MAX)
+		reg_data = 0xd0;
+	else {
+		unsigned int val = chg->fast_uamp;
+
+		val -= RT5033_CHARGER_FAST_CURRENT_MIN;
+		val /= RT5033_CHARGER_FAST_CURRENT_STEP_NUM;
+		reg_data = 0x10 + val;
+	}
+
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_CHG_CTRL5,
+			RT5033_CHGCTRL5_ICHG_MASK, reg_data);
+	if (ret) {
+		dev_err(psy->dev, "Failed regmap update\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static inline int rt5033_init_pre_charge(struct rt5033_charger *psy)
+{
+	struct rt5033_charger_data *chg = psy->chg;
+	int ret;
+	u8 reg_data;
+
+	/* Set pre-charge threshold voltage */
+	if (chg->pre_uvolt < RT5033_CHARGER_PRE_THRESHOLD_LIMIT_MIN ||
+		chg->pre_uvolt > RT5033_CHARGER_PRE_THRESHOLD_LIMIT_MAX)
+		return -EINVAL;
+
+	if (chg->pre_uvolt == RT5033_CHARGER_PRE_THRESHOLD_LIMIT_MIN)
+		reg_data = 0x00;
+	else if (chg->pre_uvolt == RT5033_CHARGER_PRE_THRESHOLD_LIMIT_MAX)
+		reg_data = 0x0f;
+	else {
+		unsigned int val = chg->pre_uvolt;
+
+		val -= RT5033_CHARGER_PRE_THRESHOLD_LIMIT_MIN;
+		val /= RT5033_CHARGER_PRE_THRESHOLD_STEP_NUM;
+		reg_data = 0x00 + val;
+	}
+
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_CHG_CTRL5,
+			RT5033_CHGCTRL5_VPREC_MASK, reg_data);
+	if (ret) {
+		dev_err(psy->dev, "Failed regmap update\n");
+		return -EINVAL;
+	}
+
+	/* Set pre-charge mode charging current */
+	if (chg->pre_uamp < RT5033_CHARGER_PRE_CURRENT_LIMIT_MIN ||
+		chg->pre_uamp > RT5033_CHARGER_PRE_CURRENT_LIMIT_MAX)
+		return -EINVAL;
+
+	if (chg->pre_uamp == RT5033_CHARGER_PRE_CURRENT_LIMIT_MIN)
+		reg_data = 0x00;
+	else if (chg->pre_uamp == RT5033_CHARGER_PRE_CURRENT_LIMIT_MAX)
+		reg_data = 0x18;
+	else {
+		unsigned int val = chg->pre_uamp;
+
+		val -= RT5033_CHARGER_PRE_CURRENT_LIMIT_MIN;
+		val /= RT5033_CHARGER_PRE_CURRENT_STEP_NUM;
+		reg_data = 0x08 + val;
+	}
+
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_CHG_CTRL4,
+			RT5033_CHGCTRL4_IPREC_MASK, reg_data);
+	if (ret) {
+		dev_err(psy->dev, "Failed regmap update\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int rt5033_charger_reg_init(struct rt5033_charger *psy)
+{
+	int ret = 0;
+
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_CHG_CTRL1,
+			RT5033_CHGCTRL1_MODE_MASK, RT5033_CHARGER_MODE);
+	if (ret) {
+		dev_err(psy->dev, "Failed to update charger mode.\n");
+		return -EINVAL;
+	}
+
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_RT_CTRL1,
+			RT5033_RT_CTRL1_UUG_MASK, RT5033_CHARGER_UUG_ENABLE);
+	if (ret) {
+		dev_err(psy->dev, "Failed to update rt ctrl register.\n");
+		return -EINVAL;
+	}
+
+	ret = rt5033_init_pre_charge(psy);
+	if (ret)
+		return ret;
+
+	ret = rt5033_init_fast_charge(psy);
+	if (ret)
+		return ret;
+
+	ret = rt5033_init_const_charge(psy);
+	if (ret)
+		return ret;
+
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_CHG_CTRL3,
+			RT5033_CHGCTRL3_CFO_EN_MASK, RT5033_CFO_ENABLE);
+	if (ret) {
+		dev_err(psy->dev, "Failed to set enable.\n");
+		return -EINVAL;
+	}
+
+	ret = regmap_update_bits(psy->rt5033->regmap, RT5033_REG_CHG_CTRL1,
+			RT5033_RT_HZ_MASK, RT5033_CHARGER_HZ_DISABLE);
+	if (ret) {
+		dev_err(psy->dev, "Failed to set high impedance mode.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static enum power_supply_property rt5033_charger_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CURRENT_MAX,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+};
+
+static int rt5033_charger_get_property(struct power_supply *psy,
+			enum power_supply_property psp,
+			union power_supply_propval *val)
+{
+	struct rt5033_charger *charger = container_of(psy,
+			struct rt5033_charger, psy);
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = rt5033_get_charger_state(charger);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		val->intval = rt5033_get_charger_type(charger);
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+	case POWER_SUPPLY_PROP_CURRENT_MAX:
+		val->intval = rt5033_get_charger_current(charger, psp);
+		break;
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX:
+		val->intval = rt5033_get_charge_voltage(charger, psp);
+		break;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = RT5033_CHARGER_MODEL;
+		break;
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		val->strval = RT5033_MANUFACTURER;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static struct rt5033_charger_data *rt5033_charger_dt_init(
+						struct platform_device *pdev)
+{
+	struct rt5033_charger_data *chg;
+	struct device_node *np = pdev->dev.of_node;
+	int ret;
+
+	if (!np) {
+		dev_err(&pdev->dev, "No charger of_node\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	chg = devm_kzalloc(&pdev->dev, sizeof(*chg), GFP_KERNEL);
+	if (!chg)
+		return ERR_PTR(-ENOMEM);
+
+	ret = of_property_read_u32(np, "richtek,pre-uamp", &chg->pre_uamp);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_property_read_u32(np, "richtek,pre-threshold-uvolt",
+			&chg->pre_uvolt);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/*
+	 * Charging current is decided by external sensing register and
+	 * regulated voltage. In this driver, external sensing regster value
+	 * is 10 mili ohm
+	 */
+	ret = of_property_read_u32(np, "richtek,fast-uamp", &chg->fast_uamp);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_property_read_u32(np, "richtek,const-uvolt",
+			&chg->const_uvolt);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_property_read_u32(np, "richtek,eoc-uamp", &chg->eoc_uamp);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return chg;
+}
+
+static int rt5033_charger_probe(struct platform_device *pdev)
+{
+	struct rt5033_charger *charger;
+	struct rt5033_dev *rt5033 = dev_get_drvdata(pdev->dev.parent);
+	int ret;
+
+	charger = devm_kzalloc(&pdev->dev, sizeof(*charger), GFP_KERNEL);
+	if (!charger)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, charger);
+	charger->dev = &pdev->dev;
+	charger->rt5033 = rt5033;
+
+	charger->chg = rt5033_charger_dt_init(pdev);
+	if (IS_ERR_OR_NULL(charger->chg))
+		return -ENODEV;
+
+	ret = rt5033_charger_reg_init(charger);
+	if (ret)
+		return ret;
+
+	charger->psy.name = "rt5033-charger",
+	charger->psy.type = POWER_SUPPLY_TYPE_BATTERY,
+	charger->psy.properties = rt5033_charger_props,
+	charger->psy.num_properties = ARRAY_SIZE(rt5033_charger_props),
+	charger->psy.get_property = rt5033_charger_get_property,
+
+	ret = power_supply_register(&pdev->dev, &charger->psy);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register power supply\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int rt5033_charger_remove(struct platform_device *pdev)
+{
+	struct rt5033_charger *charger = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&charger->psy);
+
+	return 0;
+}
+
+static const struct platform_device_id rt5033_charger_id[] = {
+	{ "rt5033-charger", },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, rt5033_charger_id);
+
+static struct platform_driver rt5033_charger_driver = {
+	.driver = {
+		.name = "rt5033-charger",
+	},
+	.probe = rt5033_charger_probe,
+	.remove = rt5033_charger_remove,
+	.id_table = rt5033_charger_id,
+};
+module_platform_driver(rt5033_charger_driver);
+
+MODULE_DESCRIPTION("Richtek RT5033 charger driver");
+MODULE_AUTHOR("Beomho Seo <beomho.seo@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5


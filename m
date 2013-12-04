Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3LDKkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:40:36 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29763 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab3LDKkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:40:32 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-2c-529f069d178f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 1/3] charger: max14577: Add charger support for Maxim 14577
Date: Wed, 04 Dec 2013 11:40:13 +0100
Message-id: <1386153615-25456-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386153615-25456-1-git-send-email-k.kozlowski@samsung.com>
References: <1386153615-25456-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xy7pz2eYHGaw7oGRxcKumxcYZ61kt
	pj58wmZx/ctzVov5R86xWkxcOZnZ4tyrlYwWr18YWpxtesNucf/rUUaLb1c6mCw2Pb7GarGw
	bQmLxeVdc9gs1h65y26x9PpFJosJ09eyWBxecYDJYt3L6SwWrw62sTiIeKyZt4bRY8HnK+we
	E/o/MXrsnHWX3WPl8i9sHptXaHlsWtXJ5vFq9UxWjzvX9gCFltR79G1ZxejxeZOcx8a5oQG8
	UVw2Kak5mWWpRfp2CVwZUxefYy24H10x/a1RA+NWny5GTg4JAROJK92PmCBsMYkL99azdTFy
	cQgJLGWU2PujkwXC6WOSaD/8BayKTcBYYvPyJWBVIgK3WCQmvFzHDuIwC2xklHh/dCNYlbCA
	n8SvX8fZQGwWAVWJV//Xg8V5Bdwlptz6AtTAAbRPQWLOJBuQMKeAh8ThB7OYQWwhoJK1a7ay
	TWDkXcDIsIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJD6+7mBceszqEKMAB6MSD28C57wg
	IdbEsuLK3EOMEhzMSiK8h1jnBwnxpiRWVqUW5ccXleakFh9iZOLglGpgVFC+ffLrrTVHDn2M
	92o/OUfvLEP8yXu9AoYrpK+66N/y47/r/cnmxiY7kb1Xruy1WahiGHP6ZL6Z34S8ktjHny4z
	2qxbuC//QrKco5zJlLAjBpOX3dKfUb4wYIPOqe9zp3Z4m12UKpfRz15//c60vgOfGh6zsNxc
	17Yu6cBr8b2u2oUPzolUVCixFGckGmoxFxUnAgDGTuf+bQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX14577 chip is a multi-function device which includes MUIC, charger
and voltage regulator. The driver is located in drivers/mfd.

This patch supports battery charging control of MAX14577 chip and
provides power supply class information to userspace.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/Kconfig            |    7 +
 drivers/power/Makefile           |    1 +
 drivers/power/max14577_charger.c |  311 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 319 insertions(+)
 create mode 100644 drivers/power/max14577_charger.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 5e2054afe840..9b6d4666d61e 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -316,6 +316,13 @@ config CHARGER_MANAGER
           runtime and in suspend-to-RAM by waking up the system periodically
           with help of suspend_again support.
 
+config CHARGER_MAX14577
+	tristate "Maxim MAX14577 MUIC battery charger driver"
+	depends on MFD_MAX14577
+	help
+	  Say Y to enable support for the battery charger control sysfs and
+	  platform data of MAX14577 MUICs.
+
 config CHARGER_MAX8997
 	tristate "Maxim MAX8997/MAX8966 PMIC battery charger driver"
 	depends on MFD_MAX8997 && REGULATOR_MAX8997
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 372b4e8ab598..ee54a3e4c90a 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_CHARGER_LP8727)	+= lp8727_charger.o
 obj-$(CONFIG_CHARGER_LP8788)	+= lp8788-charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
 obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
+obj-$(CONFIG_CHARGER_MAX14577)	+= max14577_charger.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
 obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
new file mode 100644
index 000000000000..e0faf57283a8
--- /dev/null
+++ b/drivers/power/max14577_charger.c
@@ -0,0 +1,311 @@
+/*
+ * max14577_charger.c - Battery charger driver for the Maxim 14577
+ *
+ * Copyright (C) 2013 Samsung Electronics
+ * Krzysztof Kozlowski <k.kozlowski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/mfd/max14577-private.h>
+
+struct max14577_charger {
+	struct device *dev;
+	struct max14577	*max14577;
+	struct power_supply	charger;
+
+	unsigned int	charging_state;
+	unsigned int	battery_state;
+};
+
+static int max14577_get_charger_state(struct max14577_charger *chg)
+{
+	struct regmap *rmap = chg->max14577->regmap;
+	int state = POWER_SUPPLY_STATUS_DISCHARGING;
+	u8 reg_data;
+
+	/*
+	 * Charging occurs only if:
+	 *  - CHGCTRL2/MBCHOSTEN == 1
+	 *  - STATUS2/CGMBC == 1
+	 *
+	 * TODO:
+	 *  - handle FULL after Top-off timer (EOC register may be off
+	 *    and the charger won't be charging although MBCHOSTEN is on)
+	 *  - handle properly dead-battery charging (respect timer)
+	 *  - handle timers (fast-charge and prequal) /MBCCHGERR/
+	 */
+	max14577_read_reg(rmap, MAX14577_CHG_REG_CHG_CTRL2, &reg_data);
+	if ((reg_data & CHGCTRL2_MBCHOSTEN_MASK) == 0)
+		goto state_set;
+
+	max14577_read_reg(rmap, MAX14577_CHG_REG_STATUS3, &reg_data);
+	if (reg_data & STATUS3_CGMBC_MASK) {
+		/* Charger or USB-cable is connected */
+		if (reg_data & STATUS3_EOC_MASK)
+			state = POWER_SUPPLY_STATUS_FULL;
+		else
+			state = POWER_SUPPLY_STATUS_CHARGING;
+		goto state_set;
+	}
+
+state_set:
+	chg->charging_state = state;
+	return state;
+}
+
+/*
+ * Supported charge types:
+ *  - POWER_SUPPLY_CHARGE_TYPE_NONE
+ *  - POWER_SUPPLY_CHARGE_TYPE_FAST
+ */
+static int max14577_get_charge_type(struct max14577_charger *chg)
+{
+	/*
+	 * TODO: CHARGE_TYPE_TRICKLE (VCHGR_RC or EOC)?
+	 * As spec says:
+	 * [after reaching EOC interrupt]
+	 * "When the battery is fully charged, the 30-minute (typ)
+	 *  top-off timer starts. The device continues to trickle
+	 *  charge the battery until the top-off timer runs out."
+	 */
+	if (max14577_get_charger_state(chg) == POWER_SUPPLY_STATUS_CHARGING)
+		return POWER_SUPPLY_CHARGE_TYPE_FAST;
+	return POWER_SUPPLY_CHARGE_TYPE_NONE;
+}
+
+static int max14577_get_online(struct max14577_charger *chg)
+{
+	struct regmap *rmap = chg->max14577->regmap;
+	u8 reg_data;
+
+	max14577_read_reg(rmap, MAX14577_MUIC_REG_STATUS2, &reg_data);
+	reg_data = ((reg_data & STATUS2_CHGTYP_MASK) >> STATUS2_CHGTYP_SHIFT);
+	switch (reg_data) {
+	case MAX14577_CHARGER_TYPE_USB:
+	case MAX14577_CHARGER_TYPE_DEDICATED_CHG:
+	case MAX14577_CHARGER_TYPE_SPECIAL_500MA:
+	case MAX14577_CHARGER_TYPE_SPECIAL_1A:
+	case MAX14577_CHARGER_TYPE_DEAD_BATTERY:
+		return 1;
+	case MAX14577_CHARGER_TYPE_NONE:
+	case MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT:
+	case MAX14577_CHARGER_TYPE_RESERVED:
+	default:
+		return 0;
+	}
+}
+
+/*
+ * Supported health statuses:
+ *  - POWER_SUPPLY_HEALTH_DEAD
+ *  - POWER_SUPPLY_HEALTH_OVERVOLTAGE
+ *  - POWER_SUPPLY_HEALTH_GOOD
+ */
+static int max14577_get_battery_health(struct max14577_charger *chg)
+{
+	struct regmap *rmap = chg->max14577->regmap;
+	int state = POWER_SUPPLY_HEALTH_GOOD;
+	u8 reg_data;
+
+	max14577_read_reg(rmap, MAX14577_MUIC_REG_STATUS2, &reg_data);
+	reg_data = ((reg_data & STATUS2_CHGTYP_MASK) >> STATUS2_CHGTYP_SHIFT);
+	if (reg_data == MAX14577_CHARGER_TYPE_DEAD_BATTERY) {
+		state = POWER_SUPPLY_HEALTH_DEAD;
+		goto state_set;
+	}
+
+	max14577_read_reg(rmap, MAX14577_CHG_REG_STATUS3, &reg_data);
+	if (reg_data & STATUS3_OVP_MASK) {
+		state = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
+		goto state_set;
+	}
+
+state_set:
+	chg->battery_state = state;
+	return state;
+}
+
+/*
+ * Always returns 1.
+ * The max14577 chip doesn't report any status of battery presence.
+ * Lets assume that it will always be used with some battery.
+ */
+static int max14577_get_present(struct max14577_charger *chg)
+{
+	return 1;
+}
+
+/*
+ * Sets charger registers to proper and safe default values.
+ * Some of these values are equal to defaults in MAX14577E
+ * data sheet but there are minor differences.
+ */
+static void max14577_charger_reg_init(struct max14577_charger *chg)
+{
+	struct regmap *rmap = chg->max14577->regmap;
+	u8 reg_data;
+
+	/*
+	 * Charger-Type Manual Detection, default off (set CHGTYPMAN to 0)
+	 * Charger-Detection Enable, default on (set CHGDETEN to 1)
+	 * Combined mask of CHGDETEN and CHGTYPMAN will zero the CHGTYPMAN bit
+	 */
+	reg_data = 0x1 << CDETCTRL1_CHGDETEN_SHIFT;
+	max14577_update_reg(rmap, MAX14577_REG_CDETCTRL1,
+			CDETCTRL1_CHGDETEN_MASK | CDETCTRL1_CHGTYPMAN_MASK,
+			reg_data);
+
+	/* Battery Fast-Charge Timer, from SM-V700: 6hrs */
+	reg_data = 0x3 << CHGCTRL1_TCHW_SHIFT;
+	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL1, reg_data);
+
+	/*
+	 * Wall-Adapter Rapid Charge, default on
+	 * Battery-Charger, default on
+	 */
+	reg_data = 0x1 << CHGCTRL2_VCHGR_RC_SHIFT;
+	reg_data |= 0x1 << CHGCTRL2_MBCHOSTEN_SHIFT;
+	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL2, reg_data);
+
+	/* Battery-Charger Constant Voltage (CV) Mode, from SM-V700: 4.35V */
+	reg_data = 0xf << CHGCTRL3_MBCCVWRC_SHIFT;
+	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL3, reg_data);
+
+	/*
+	 * Fast Battery-Charge Current Low, default 200-950mA
+	 * Fast Battery-Charge Current High, from SM-V700: 450mA
+	 */
+	reg_data = 0x1 << CHGCTRL4_MBCICHWRCL_SHIFT;
+	reg_data |= 0x5 << CHGCTRL4_MBCICHWRCH_SHIFT;
+	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL4, reg_data);
+
+	/* End-of-Charge Current, from SM-V700: 50mA */
+	reg_data = 0x0 << CHGCTRL5_EOCS_SHIFT;
+	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL5, reg_data);
+
+	/* Auto Charging Stop, default off */
+	reg_data = 0x0 << CHGCTRL6_AUTOSTOP_SHIFT;
+	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL6, reg_data);
+
+	/* Overvoltage-Protection Threshold, from SM-V700: 6.5V */
+	reg_data = 0x2 << CHGCTRL7_OTPCGHCVS_SHIFT;
+	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL7, reg_data);
+}
+
+/* Support property from charger */
+static enum power_supply_property max14577_charger_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+};
+
+static const char *model_name = "MAX14577";
+static const char *manufacturer = "Maxim Integrated";
+static int max14577_charger_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	struct max14577_charger *chg = container_of(psy,
+						  struct max14577_charger,
+						  charger);
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = max14577_get_charger_state(chg);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		val->intval = max14577_get_charge_type(chg);
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		val->intval = max14577_get_battery_health(chg);
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = max14577_get_present(chg);
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = max14577_get_online(chg);
+		break;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = model_name;
+		break;
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		val->strval = manufacturer;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static int max14577_charger_probe(struct platform_device *pdev)
+{
+	struct max14577_charger *chg;
+	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
+	int ret;
+
+	chg = devm_kzalloc(&pdev->dev, sizeof(*chg), GFP_KERNEL);
+	if (!chg)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, chg);
+	chg->dev = &pdev->dev;
+	chg->max14577 = max14577;
+
+	max14577_charger_reg_init(chg);
+
+	chg->charger.name = "max14577-charger",
+	chg->charger.type = POWER_SUPPLY_TYPE_BATTERY,
+	chg->charger.properties = max14577_charger_props,
+	chg->charger.num_properties = ARRAY_SIZE(max14577_charger_props),
+	chg->charger.get_property = max14577_charger_get_property,
+
+	ret = power_supply_register(&pdev->dev, &chg->charger);
+	if (ret) {
+		dev_err(&pdev->dev, "failed: power supply register\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int max14577_charger_remove(struct platform_device *pdev)
+{
+	struct max14577_charger *chg = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&chg->charger);
+
+	return 0;
+}
+
+static struct platform_driver max14577_charger_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "max14577-charger",
+	},
+	.probe		= max14577_charger_probe,
+	.remove		= max14577_charger_remove,
+};
+
+module_platform_driver(max14577_charger_driver);
+
+MODULE_AUTHOR("Krzysztof Kozlowski <k.kozlowski@samsung.com>");
+MODULE_DESCRIPTION("MAXIM 14577 charger driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5


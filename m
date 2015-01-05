Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbbAEKRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:17:21 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44520 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbbAEKRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:17:17 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-66-54aa64aa51ff
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 2/4] mfd: max77693: Add defines for MAX77693 charger driver
Date: Mon, 05 Jan 2015 11:16:57 +0100
Message-id: <1420453019-28614-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
References: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Vd1VKatCDLZ/NrOY9OQ9s8X8I+dY
	LSaunMxs8fqFocX9r0cZLTZ/72CzuLxrDpvF594jjBanu1ktTu8uceDy2DnrLrvH5hVaHptW
	dbJ53Lm2h81j3slAj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4Mo43HKHsaBPveLtwz6mBsZD
	Sl2MnBwSAiYSv/v2MkHYYhIX7q1n62Lk4hASWMooMWXzYnYIp49JYs/FY+wgVWwCxhKbly8B
	qxIR2MMk8enFClaQBLOAocTPd3/AioQF/CTer5sBFmcRUJX4/W4iI4jNK+Au0X2hnwVinZzE
	yWOTwWo4BTwk5r/8zgxiCwHVHNj3mHkCI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GCEB+GUH4+JjVocYBTgYlXh4PU6sDBFiTSwrrsw9xCjBwawkwrvuFlCINyWxsiq1KD++qDQn
	tfgQIxMHp1QD4wQj2Z+55ZdaHy2RmBRRmFDpx6Wy+esLo2CnrOo679P3IhdlNG9XqW36pHu2
	8JGAd3RYyPxtB96Z8jdEMzakHvKvnVHLrfKywrPxEtN65yUSG3cZbpvOKse7yfPzu4e8Qv+K
	zf7OumRnUD7F+Gn09D6/XS0smowcS9vkXy0vWOl7KO33J86nSizFGYmGWsxFxYkAZXTVJx4C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for adding support for Maxim 77693 charger by adding necessary
new defines.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/max77693-private.h | 108 +++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 08dae01258b9..955dd990beaf 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -143,10 +143,118 @@ enum max77693_pmic_reg {
 #define FLASH_INT_FLED1_SHORT	BIT(3)
 #define FLASH_INT_OVER_CURRENT	BIT(4)
 
+/* Fast charge timer in in hours */
+#define DEFAULT_FAST_CHARGE_TIMER		4
+/* microamps */
+#define DEFAULT_TOP_OFF_THRESHOLD_CURRENT	150000
+/* minutes */
+#define DEFAULT_TOP_OFF_TIMER			30
+/* microvolts */
+#define DEFAULT_CONSTANT_VOLT			4200000
+/* microvolts */
+#define DEFAULT_MIN_SYSTEM_VOLT			3600000
+/* celsius */
+#define DEFAULT_THERMAL_REGULATION_TEMP		100
+/* microamps */
+#define DEFAULT_BATTERY_OVERCURRENT		3500000
+/* microvolts */
+#define DEFAULT_CHARGER_INPUT_THRESHOLD_VOLT	4300000
+
+/* MAX77693_CHG_REG_CHG_INT_OK register */
+#define CHG_INT_OK_BYP_SHIFT		0
+#define CHG_INT_OK_BAT_SHIFT		3
+#define CHG_INT_OK_CHG_SHIFT		4
+#define CHG_INT_OK_CHGIN_SHIFT		6
+#define CHG_INT_OK_DETBAT_SHIFT		7
+#define CHG_INT_OK_BYP_MASK		BIT(CHG_INT_OK_BYP_SHIFT)
+#define CHG_INT_OK_BAT_MASK		BIT(CHG_INT_OK_BAT_SHIFT)
+#define CHG_INT_OK_CHG_MASK		BIT(CHG_INT_OK_CHG_SHIFT)
+#define CHG_INT_OK_CHGIN_MASK		BIT(CHG_INT_OK_CHGIN_SHIFT)
+#define CHG_INT_OK_DETBAT_MASK		BIT(CHG_INT_OK_DETBAT_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_DETAILS_00 register */
+#define CHG_DETAILS_00_CHGIN_SHIFT	5
+#define CHG_DETAILS_00_CHGIN_MASK	(0x3 << CHG_DETAILS_00_CHGIN_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_DETAILS_01 register */
+#define CHG_DETAILS_01_CHG_SHIFT	0
+#define CHG_DETAILS_01_BAT_SHIFT	4
+#define CHG_DETAILS_01_TREG_SHIFT	7
+#define CHG_DETAILS_01_CHG_MASK		(0xf << CHG_DETAILS_01_CHG_SHIFT)
+#define CHG_DETAILS_01_BAT_MASK		(0x7 << CHG_DETAILS_01_BAT_SHIFT)
+#define CHG_DETAILS_01_TREG_MASK	BIT(7)
+
+/* MAX77693_CHG_REG_CHG_DETAILS_01/CHG field */
+enum max77693_charger_charging_state {
+	MAX77693_CHARGING_PREQUALIFICATION	= 0x0,
+	MAX77693_CHARGING_FAST_CONST_CURRENT,
+	MAX77693_CHARGING_FAST_CONST_VOLTAGE,
+	MAX77693_CHARGING_TOP_OFF,
+	MAX77693_CHARGING_DONE,
+	MAX77693_CHARGING_HIGH_TEMP,
+	MAX77693_CHARGING_TIMER_EXPIRED,
+	MAX77693_CHARGING_THERMISTOR_SUSPEND,
+	MAX77693_CHARGING_OFF,
+	MAX77693_CHARGING_RESERVED,
+	MAX77693_CHARGING_OVER_TEMP,
+	MAX77693_CHARGING_WATCHDOG_EXPIRED,
+};
+
+/* MAX77693_CHG_REG_CHG_DETAILS_01/BAT field */
+enum max77693_charger_battery_state {
+	MAX77693_BATTERY_NOBAT			= 0x0,
+	/* Dead-battery or low-battery prequalification */
+	MAX77693_BATTERY_PREQUALIFICATION,
+	MAX77693_BATTERY_TIMER_EXPIRED,
+	MAX77693_BATTERY_GOOD,
+	MAX77693_BATTERY_LOWVOLTAGE,
+	MAX77693_BATTERY_OVERVOLTAGE,
+	MAX77693_BATTERY_OVERCURRENT,
+	MAX77693_BATTERY_RESERVED,
+};
+
+/* MAX77693_CHG_REG_CHG_DETAILS_02 register */
+#define CHG_DETAILS_02_BYP_SHIFT	0
+#define CHG_DETAILS_02_BYP_MASK		(0xf << CHG_DETAILS_02_BYP_SHIFT)
+
 /* MAX77693 CHG_CNFG_00 register */
 #define CHG_CNFG_00_CHG_MASK		0x1
 #define CHG_CNFG_00_BUCK_MASK		0x4
 
+/* MAX77693_CHG_REG_CHG_CNFG_01 register */
+#define CHG_CNFG_01_FCHGTIME_SHIFT	0
+#define CHG_CNFG_01_CHGRSTRT_SHIFT	4
+#define CHG_CNFG_01_PQEN_SHIFT		7
+#define CHG_CNFG_01_FCHGTIME_MASK	(0x7 << CHG_CNFG_01_FCHGTIME_SHIFT)
+#define CHG_CNFG_01_CHGRSTRT_MASK	(0x3 << CHG_CNFG_01_CHGRSTRT_SHIFT)
+#define CHG_CNFG_01_PQEN_MAKS		BIT(CHG_CNFG_01_PQEN_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_CNFG_03 register */
+#define CHG_CNFG_03_TOITH_SHIFT		0
+#define CHG_CNFG_03_TOTIME_SHIFT	3
+#define CHG_CNFG_03_TOITH_MASK		(0x7 << CHG_CNFG_03_TOITH_SHIFT)
+#define CHG_CNFG_03_TOTIME_MASK		(0x7 << CHG_CNFG_03_TOTIME_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_CNFG_04 register */
+#define CHG_CNFG_04_CHGCVPRM_SHIFT	0
+#define CHG_CNFG_04_MINVSYS_SHIFT	5
+#define CHG_CNFG_04_CHGCVPRM_MASK	(0x1f << CHG_CNFG_04_CHGCVPRM_SHIFT)
+#define CHG_CNFG_04_MINVSYS_MASK	(0x7 << CHG_CNFG_04_MINVSYS_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_CNFG_06 register */
+#define CHG_CNFG_06_CHGPROT_SHIFT	2
+#define CHG_CNFG_06_CHGPROT_MASK	(0x3 << CHG_CNFG_06_CHGPROT_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_CNFG_07 register */
+#define CHG_CNFG_07_REGTEMP_SHIFT	5
+#define CHG_CNFG_07_REGTEMP_MASK	(0x3 << CHG_CNFG_07_REGTEMP_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_CNFG_12 register */
+#define CHG_CNFG_12_B2SOVRC_SHIFT	0
+#define CHG_CNFG_12_VCHGINREG_SHIFT	3
+#define CHG_CNFG_12_B2SOVRC_MASK	(0x7 << CHG_CNFG_12_B2SOVRC_SHIFT)
+#define CHG_CNFG_12_VCHGINREG_MASK	(0x3 << CHG_CNFG_12_VCHGINREG_SHIFT)
+
 /* MAX77693 CHG_CNFG_09 Register */
 #define CHG_CNFG_09_CHGIN_ILIM_MASK	0x7F
 
-- 
1.9.1


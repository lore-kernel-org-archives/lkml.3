Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaJBMW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:22:28 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15441 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaJBMWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:22:24 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-45-542d4379abcc
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/7] mfd: max77693: Add defines for MAX77693 charger driver
Date: Thu, 02 Oct 2014 14:22:02 +0200
Message-id: <1412252528-30148-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
References: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t/xq7qVzrohBl175Cw2zljPajFp3QEm
	i0lP3jNbzD9yjtVi4srJzBb9bxayWpx7tZLR4ujvAovXLwwtehdcZbM42/SG3eL+16OMFpu/
	d7BZbHp8jdXi8q45bBafe48wWsw4v4/J4vZlXou1R+6yWyy9fpHJYsL0tSwWrXuPsFuc7ma1
	OL27xGLVrj+MDpIea+atYfRoae5h87jc18vk8ff5dRaPv6teMHvsnHWX3WPl8i9sHptXaHls
	WtXJ5nHn2h42j3knAz02L6n36NuyitHj8ya5AL4oLpuU1JzMstQifbsErox1E9ezFuzRrljV
	toulgXGiWhcjJ4eEgInEuS0f2CFsMYkL99azdTFycQgJLGWUuPvqDzNIQkigj0nixGFDEJtN
	wFhi8/IlYEUiAn+ZJSZ8f8UE4jALPGWWOLdhC2sXIweHsIC3xLpvGSANLAKqEr9XfmMDsXkF
	3CUurZrODLFNTuLkscmsIDangIfE3LcT2SGWuUu0Na1im8DIu4CRYRWjaGppckFxUnquoV5x
	Ym5xaV66XnJ+7iZGSFR92cG4+JjVIUYBDkYlHt6MBp0QIdbEsuLK3EOMEhzMSiK8T+x1Q4R4
	UxIrq1KL8uOLSnNSiw8xMnFwSjUw+u+8ZL/+QUWuZ70rr96sY6EPJh7Xulx5dXuWjeOOdRYt
	W2vnHHZ7dlQh88Uhsbjz++KmCfCKb8u5b+Vvlr10yf8dvN/1GYy5xXavrJ6ppLSyI2P63e5p
	B6bl7TZyPnT6nMrEtxfZLAI+5eXk7mWdIpk/1fc1I5f0maeCvsm7SjYdlnMKj0l4ocRSnJFo
	qMVcVJwIAOPCqv2IAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for adding support for Maxim 77693 charger by adding necessary
new defines and structure for device tree parsed data.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/mfd/max77693-private.h | 108 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max77693.h         |   8 +++
 2 files changed, 116 insertions(+)

diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index fc17d56581b2..e1b2b61285b9 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -144,10 +144,118 @@ enum max77693_pmic_reg {
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
 
diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index f0b6585cd874..88ef24b28294 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -63,6 +63,14 @@ struct max77693_muic_platform_data {
 	int path_uart;
 };
 
+struct max77693_charger_platform_data {
+	u32 constant_volt;
+	u32 min_system_volt;
+	u32 thermal_regulation_temp;
+	u32 batttery_overcurrent;
+	u32 charge_input_threshold_volt;
+};
+
 /* MAX77693 led flash */
 
 /* triggers */
-- 
1.9.1


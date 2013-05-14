Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3ENKBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:01:16 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41440 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab3ENKBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:01:12 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 24/30] thermal: exynos: Add thermal configuration data for exynos5440 TMU sensor
Date: Tue, 14 May 2013 15:28:54 +0530
Message-Id: <1368525540-15034-25-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds configuration data for exynos5440 soc. Also register
definations for the controller are added.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |    4 ++
 drivers/thermal/samsung/exynos_tmu_data.c |   61 +++++++++++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.h |   42 ++++++++++++++++++++
 3 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 28804a5..671061b 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -423,6 +423,10 @@ static const struct of_device_id exynos_tmu_match[] = {
 		.compatible = "samsung,exynos5250-tmu",
 		.data = (void *)EXYNOS5250_TMU_DRV_DATA,
 	},
+	{
+		.compatible = "samsung,exynos5440-tmu",
+		.data = (void *)EXYNOS5440_TMU_DRV_DATA,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_tmu_match);
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index b4bfa61..d622cb4 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -160,3 +160,64 @@ struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
 			TMU_SUPPORT_EMUL_TIME),
 };
 #endif
+
+#if defined(CONFIG_SOC_EXYNOS5440)
+static const struct exynos_tmu_registers exynos5440_tmu_registers = {
+	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
+	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
+	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
+	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
+	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
+	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
+	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
+	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
+	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
+	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
+	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
+	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
+	.tmu_status = EXYNOS5440_TMU_S0_7_STATUS,
+	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
+	.threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
+	.threshold_th1 = EXYNOS5440_TMU_S0_7_TH1,
+	.threshold_th2 = EXYNOS5440_TMU_S0_7_TH2,
+	.threshold_th3_l0_shift = EXYNOS5440_TMU_TH_RISE4_SHIFT,
+	.tmu_inten = EXYNOS5440_TMU_S0_7_IRQEN,
+	.inten_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
+	.inten_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
+	.inten_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
+	.inten_fall_shift = EXYNOS5440_TMU_FALL_INT_SHIFT,
+	.inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
+	.inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
+	.inten_rise2_shift = EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
+	.inten_rise3_shift = EXYNOS5440_TMU_INTEN_RISE3_SHIFT,
+	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
+	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
+	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
+	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
+	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
+	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
+	.tmu_pmin = EXYNOS5440_TMU_PMIN,
+};
+struct exynos_tmu_platform_data const exynos5440_default_tmu_data = {
+	.trigger_levels[0] = 100,
+	.trigger_levels[4] = 105,
+	.trigger_enable[0] = 1,
+	.trigger_type[0] = 1,
+	.trigger_type[4] = 2,
+	.gain = 5,
+	.reference_voltage = 16,
+	.noise_cancel_mode = 4,
+	.cal_type = TYPE_TWO_POINT_TRIMMING,
+	.cal_mode = 0,
+	.efuse_value = 0x5b2d,
+	.min_efuse_value = 16,
+	.max_efuse_value = 76,
+	.first_point_trim = 25,
+	.second_point_trim = 70,
+	.default_temp_offset = 25,
+	.type = SOC_ARCH_EXYNOS5440,
+	.registers = &exynos5440_tmu_registers,
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP |
+			TMU_SUPPORT_MULTI_INST),
+};
+#endif
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index 4acf070..eb7250d 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -93,6 +93,41 @@
 
 #define EXYNOS_MAX_TRIGGER_PER_REG	4
 
+/*exynos5440 specific registers*/
+#define EXYNOS5440_TMU_S0_7_TRIM		0x000
+#define EXYNOS5440_TMU_S0_7_CTRL		0x020
+#define EXYNOS5440_TMU_S0_7_DEBUG		0x040
+#define EXYNOS5440_TMU_S0_7_STATUS		0x060
+#define EXYNOS5440_TMU_S0_7_TEMP		0x0f0
+#define EXYNOS5440_TMU_S0_7_TH0			0x110
+#define EXYNOS5440_TMU_S0_7_TH1			0x130
+#define EXYNOS5440_TMU_S0_7_TH2			0x150
+#define EXYNOS5440_TMU_S0_7_EVTEN		0x1F0
+#define EXYNOS5440_TMU_S0_7_IRQEN		0x210
+#define EXYNOS5440_TMU_S0_7_IRQ			0x230
+/* exynos5440 common registers */
+#define EXYNOS5440_TMU_IRQ_STATUS		0x000
+#define EXYNOS5440_TMU_PMIN			0x004
+#define EXYNOS5440_TMU_TEMP			0x008
+
+#define EXYNOS5440_TMU_RISE_INT_MASK		0xf
+#define EXYNOS5440_TMU_RISE_INT_SHIFT		0
+#define EXYNOS5440_TMU_FALL_INT_MASK		0xf
+#define EXYNOS5440_TMU_FALL_INT_SHIFT		4
+#define EXYNOS5440_TMU_INTEN_RISE0_SHIFT	0
+#define EXYNOS5440_TMU_INTEN_RISE1_SHIFT	1
+#define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2
+#define EXYNOS5440_TMU_INTEN_RISE3_SHIFT	3
+#define EXYNOS5440_TMU_INTEN_FALL0_SHIFT	4
+#define EXYNOS5440_TMU_INTEN_FALL1_SHIFT	5
+#define EXYNOS5440_TMU_INTEN_FALL2_SHIFT	6
+#define EXYNOS5440_TMU_INTEN_FALL3_SHIFT	7
+#define EXYNOS5440_TMU_TH_RISE0_SHIFT		0
+#define EXYNOS5440_TMU_TH_RISE1_SHIFT		8
+#define EXYNOS5440_TMU_TH_RISE2_SHIFT		16
+#define EXYNOS5440_TMU_TH_RISE3_SHIFT		24
+#define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
+
 #if defined(CONFIG_CPU_EXYNOS4210)
 extern struct exynos_tmu_platform_data const exynos4210_default_tmu_data;
 #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
@@ -107,4 +142,11 @@ extern struct exynos_tmu_platform_data const exynos5250_default_tmu_data;
 #define EXYNOS5250_TMU_DRV_DATA (NULL)
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS5440)
+extern struct exynos_tmu_platform_data const exynos5440_default_tmu_data;
+#define EXYNOS5440_TMU_DRV_DATA (&exynos5440_default_tmu_data)
+#else
+#define EXYNOS5440_TMU_DRV_DATA (NULL)
+#endif
+
 #endif /*_EXYNOS_TMU_DATA_H*/
-- 
1.7.1


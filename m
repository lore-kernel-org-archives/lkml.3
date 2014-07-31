Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaGaRMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:12:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41829 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaGaRL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:11:58 -0400
X-AuditID: cbfee61b-f79f86d00000144c-37-53da78dcef42
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v3 8/8] thermal: exynos: remove identical values from
 exynos*_tmu_registers structures
Date: Thu, 31 Jul 2014 19:11:06 +0200
Message-id: <1406826667-2289-9-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
References: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jAd07FbeCDU6uM7JouBpisXHGelaL
	Nft/MlmcbXrDbnF51xw2i8+9RxgtZpzfx2Rx5vQlVosnD/vYLNbPeM3iwOWxeM9LJo8tV9tZ
	PPq2rGL0OH5jO5PH501yAaxRXDYpqTmZZalF+nYJXBlT/6sUvAutmH1XoYFxjlcXIyeHhICJ
	xKLWt4wQtpjEhXvr2boYuTiEBBYxSpx5tI4Rwulikmhe94MFpIpNwEpiYvsqsA4RAT2JGy+e
	MIEUMQscZ5L4+fs8G0hCWCBDonXtPGYQm0VAVeLYq8dgDbwC7hJPf91ihlinKNH9bAJYPaeA
	h8SB9hlgthBQzd9NJ1knMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREccM+kdzCu
	arA4xCjAwajEw+sQeitYiDWxrLgy9xCjBAezkgivSzlQiDclsbIqtSg/vqg0J7X4EKM0B4uS
	OO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA6PwOgO9tV/WH19W80Jv7dzdv2UcttpP5tz9I3JR
	eK3zUoetdsr2O2MdY+b8b49IvKvcW6vhrN4p1Darym9hxIR1bg8bvivfnbi/7sP8BeXKM2ZH
	a6yWbFmnwX9v26Ob55/whPUwnXnC0q+xhfn7dkvXJkWT4/clVlS5XprzTqP+O/fBbde2alcp
	sRRnJBpqMRcVJwIA9N3TDDQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for abstracting configuration for registers that
are identical on all SoC types.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 16 ++++++------
 drivers/thermal/samsung/exynos_tmu.h      | 15 -----------
 drivers/thermal/samsung/exynos_tmu_data.c | 42 -------------------------------
 3 files changed, 8 insertions(+), 65 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 122ae66..35437df 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -174,7 +174,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 			trim_info = readl(data->base + reg->triminfo_data);
 	}
 	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
-	data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
+	data->temp_error2 = ((trim_info >> EXYNOS_TRIMINFO_85_SHIFT) &
 				EXYNOS_TMU_TEMP_MASK);
 
 	if (!data->temp_error1 ||
@@ -184,7 +184,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 
 	if (!data->temp_error2)
 		data->temp_error2 =
-			(pdata->efuse_value >> reg->triminfo_85_shift) &
+			(pdata->efuse_value >> EXYNOS_TRIMINFO_85_SHIFT) &
 			EXYNOS_TMU_TEMP_MASK;
 
 	rising_threshold = readl(data->base + reg->threshold_th0);
@@ -274,11 +274,11 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	if (pdata->test_mux)
 		con |= (pdata->test_mux << reg->test_mux_addr_shift);
 
-	con &= ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
-	con |= pdata->reference_voltage << reg->buf_vref_sel_shift;
+	con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK << EXYNOS_TMU_REF_VOLTAGE_SHIFT);
+	con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT;
 
-	con &= ~(reg->buf_slope_sel_mask << reg->buf_slope_sel_shift);
-	con |= (pdata->gain << reg->buf_slope_sel_shift);
+	con &= ~(EXYNOS_TMU_BUF_SLOPE_SEL_MASK << EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT);
+	con |= (pdata->gain << EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT);
 
 	if (pdata->noise_cancel_mode) {
 		con &= ~(reg->therm_trip_mode_mask <<
@@ -287,7 +287,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	}
 
 	if (on) {
-		con |= (1 << reg->core_en_shift);
+		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
 		interrupt_en =
 			pdata->trigger_enable[3] << reg->inten_rise3_shift |
 			pdata->trigger_enable[2] << reg->inten_rise2_shift |
@@ -297,7 +297,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 			interrupt_en |=
 				interrupt_en << reg->inten_fall0_shift;
 	} else {
-		con &= ~(1 << reg->core_en_shift);
+		con &= ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
 		interrupt_en = 0; /* Disable all interrupts */
 	}
 	writel(interrupt_en, data->base + reg->tmu_inten);
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 327c64f..d503f35 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -77,20 +77,12 @@ enum soc_type {
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
  * @triminfo_data: register containing 2 pont trimming data
- * @triminfo_25_shift: shift bit of the 25 C trim value in triminfo_data reg.
- * @triminfo_85_shift: shift bit of the 85 C trim value in triminfo_data reg.
  * @triminfo_ctrl: trim info controller register.
  * @tmu_ctrl: TMU main controller register.
  * @test_mux_addr_shift: shift bits of test mux address.
- * @buf_vref_sel_shift: shift bits of reference voltage in tmu_ctrl register.
- * @buf_vref_sel_mask: mask bits of reference voltage in tmu_ctrl register.
  * @therm_trip_mode_shift: shift bits of tripping mode in tmu_ctrl register.
  * @therm_trip_mode_mask: mask bits of tripping mode in tmu_ctrl register.
  * @therm_trip_en_shift: shift bits of tripping enable in tmu_ctrl register.
- * @buf_slope_sel_shift: shift bits of amplifier gain value in tmu_ctrl
-	register.
- * @buf_slope_sel_mask: mask bits of amplifier gain value in tmu_ctrl register.
- * @core_en_shift: shift bits of TMU core enable bit in tmu_ctrl register.
  * @tmu_status: register drescribing the TMU status.
  * @tmu_cur_temp: register containing the current temperature of the TMU.
  * @threshold_temp: register containing the base threshold level.
@@ -119,22 +111,15 @@ enum soc_type {
  */
 struct exynos_tmu_registers {
 	u32	triminfo_data;
-	u32	triminfo_25_shift;
-	u32	triminfo_85_shift;
 
 	u32	triminfo_ctrl;
 	u32	triminfo_ctrl1;
 
 	u32	tmu_ctrl;
 	u32     test_mux_addr_shift;
-	u32	buf_vref_sel_shift;
-	u32	buf_vref_sel_mask;
 	u32	therm_trip_mode_shift;
 	u32	therm_trip_mode_mask;
 	u32	therm_trip_en_shift;
-	u32	buf_slope_sel_shift;
-	u32	buf_slope_sel_mask;
-	u32	core_en_shift;
 
 	u32	tmu_status;
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 9c81515..82e0732 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -27,14 +27,7 @@
 #if defined(CONFIG_CPU_EXYNOS4210)
 static const struct exynos_tmu_registers exynos4210_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
-	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
-	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
-	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
-	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
 	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_temp = EXYNOS4210_TMU_REG_THRESHOLD_TEMP,
@@ -94,18 +87,11 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS3250)
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
-	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
-	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
-	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
-	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
 	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
@@ -183,19 +169,12 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
-	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
-	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
-	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
-	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
 	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
@@ -286,18 +265,11 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5260)
 static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL1,
-	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
-	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
-	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
-	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
 	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
@@ -378,17 +350,10 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5420)
 static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
-	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
-	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
-	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
 	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
@@ -477,17 +442,10 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5440)
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
-	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
-	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
-	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
-	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
 	.tmu_status = EXYNOS5440_TMU_S0_7_STATUS,
 	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
 	.threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
-- 
1.8.2.3


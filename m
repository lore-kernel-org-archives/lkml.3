Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbaEELUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:20:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37913 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbaEELUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:20:38 -0400
X-AuditID: cbfee61b-b7f766d00000646c-bc-536774047059
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 10/10] thermal: exynos: remove identical values from
 exynos*_tmu_registers structures
Date: Mon, 05 May 2014 13:15:39 +0200
Message-id: <1399288539-1793-11-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jAV2WkvRggx3H5S0aroZYbJyxntVi
	zf6fTBZnm96wW1zeNYfN4nPvEUaLGef3MVmcOX2J1eLJwz42i/UzXrM4cHks3vOSyWPL1XYW
	j74tqxg9jt/YzuTxeZNcAGsUl01Kak5mWWqRvl0CV8ba5fwF2w0qep5sZWtgPKvZxcjJISFg
	IvFvbiczhC0mceHeejYQW0hgEaNEb69oFyMXkN3FJHHm7m8mkASbgJXExPZVjCC2iICexI0X
	T5hAipgFjjNJ/Px9HqxbWCBd4vXrM2BFLAKqErt2t4HFeQU8JPp+fWaH2KYo0f1sAlicEyi+
	/+VjZojN7hIHH09mnsDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcMA9k97BuKrB
	4hCjAAejEg9vAnN6sBBrYllxZe4hRgkOZiUR3uxEoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe
	g63WgUIC6YklqdmpqQWpRTBZJg5OqQbGoj+PD0edbrnyS9No4cr//57FGfNr+2WGixb9FC2X
	Pt99wJff8mvri89XXyqK2T5oyjlpJrJDNPl8jdCfV0F7nsz8ZMPgc27KXFHrXm7Dc8w3Dy9I
	PSd+Xlu4RGMbK1/I/Y1bu66FmPvrxp3/4jOnUf/f7wlHIwpWLNY74Vc6PelYAddJ3jwvJZbi
	jERDLeai4kQAaa1kgjQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for abstracting configuration for registers that
are identical on all SoC types.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 12 ++++++------
 drivers/thermal/samsung/exynos_tmu.h      | 11 -----------
 drivers/thermal/samsung/exynos_tmu_data.c | 15 ---------------
 3 files changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 45d7c6f..d37e755 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -215,11 +215,11 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
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
@@ -228,7 +228,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	}
 
 	if (on) {
-		con |= (1 << reg->core_en_shift);
+		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
 		interrupt_en =
 			pdata->trigger_enable[3] << reg->inten_rise3_shift |
 			pdata->trigger_enable[2] << reg->inten_rise2_shift |
@@ -238,7 +238,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 			interrupt_en |=
 				interrupt_en << reg->inten_fall0_shift;
 	} else {
-		con &= ~(1 << reg->core_en_shift);
+		con &= ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
 		interrupt_en = 0; /* Disable all interrupts */
 	}
 	writel(interrupt_en, data->base + reg->tmu_inten);
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 4845171..5c25a4b 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -69,15 +69,9 @@ enum soc_type {
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
@@ -111,14 +105,9 @@ struct exynos_tmu_registers {
 
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
index ef7f186..32530dc 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -28,11 +28,6 @@
 static const struct exynos_tmu_registers exynos4210_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
-	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
-	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
-	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
-	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
 	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_temp = EXYNOS4210_TMU_REG_THRESHOLD_TEMP,
@@ -92,14 +87,9 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
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
@@ -188,14 +178,9 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
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


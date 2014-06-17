Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131AbaFQRba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:31:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25891 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965038AbaFQRb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:31:26 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-7d-53a07b6c7896
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 9/9] thermal: exynos: remove identical values from
 exynos*_tmu_registers structures
Date: Tue, 17 Jun 2014 19:27:25 +0200
Message-id: <1403026045-16024-10-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQd2c6gXBBjtn61o0XA2x2DhjPavF
	mv0/mSzONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PJYvOclk8eWq+0s
	Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsEroz+mxOZCl7aVqx9sIipgXGvaRcjJ4eE
	gInEnSd7mCBsMYkL99azdTFycQgJTGeU2L33NpTTxSRx/v8aFpAqNgEriYntqxhBbBEBPYkb
	L54wgRQxCxxnkvj5+zwbSEJYIEPi6O8f7CA2i4CqxNYVH5hBbF4BT4kfzzdBrVOU6H42Aaye
	Eyh+414LmC0k4CEx/2In0wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgoPumfQO
	xlUNFocYBTgYlXh4OXIXBAuxJpYVV+YeYpTgYFYS4T2XBRTiTUmsrEotyo8vKs1JLT7EKM3B
	oiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXA6CJaUL36RPOOq1Llmn/mN9T+ss9aceigJWfg
	kbe8n9t8PvNHiSrMvPDJ5yLjl/D2y2Fe10K3/7v5bYvq7p3/FC9rPQq9KXly5/Wr9U2d5beZ
	43b3fIppjZ56deU3nWWpHudL87e/uiccfU2quGZ7h+8nUWvfi3d4WOLzE/j3zFb+5/vtENfy
	IiWW4oxEQy3mouJEAJtOtZI2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for abstracting configuration for registers that
are identical on all SoC types.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 12 ++++++------
 drivers/thermal/samsung/exynos_tmu.h      | 11 -----------
 drivers/thermal/samsung/exynos_tmu_data.c | 25 -------------------------
 3 files changed, 6 insertions(+), 42 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index b22f358..c47d2e2 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -229,11 +229,11 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
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
@@ -242,7 +242,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	}
 
 	if (on) {
-		con |= (1 << reg->core_en_shift);
+		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
 		interrupt_en =
 			pdata->trigger_enable[3] << reg->inten_rise3_shift |
 			pdata->trigger_enable[2] << reg->inten_rise2_shift |
@@ -252,7 +252,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 			interrupt_en |=
 				interrupt_en << reg->inten_fall0_shift;
 	} else {
-		con &= ~(1 << reg->core_en_shift);
+		con &= ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
 		interrupt_en = 0; /* Disable all interrupts */
 	}
 	writel(interrupt_en, data->base + reg->tmu_inten);
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 5d36708..4f6f1b4 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -71,15 +71,9 @@ enum soc_type {
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
@@ -114,14 +108,9 @@ struct exynos_tmu_registers {
 
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
index 4bc6b06..9dcf913 100644
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
@@ -189,14 +179,9 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
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
@@ -275,14 +260,9 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
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
@@ -369,14 +349,9 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
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


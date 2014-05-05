Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbaEELSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:18:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37780 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbaEELSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:18:04 -0400
X-AuditID: cbfee61b-b7f766d00000646c-fe-5367736a7c83
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 03/10] thermal: exynos: remove dead code for HW_MODE calibration
Date: Mon, 05 May 2014 13:15:32 +0200
Message-id: <1399288539-1793-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jAd2s4vRgg+a1NhYNV0MsNs5Yz2qx
	Zv9PJouzTW/YLS7vmsNm8bn3CKPFjPP7mCzOnL7EavHkYR+bxfoZr1kcuDwW73nJ5LHlajuL
	R9+WVYwex29sZ/L4vEkugDWKyyYlNSezLLVI3y6BK+P5m80sBUtMKpp3nmFsYDym3cXIySEh
	YCLx8MI2VghbTOLCvfVsXYxcHEICixglrh59xQrhdDFJvP7SwQ5SxSZgJTGxfRUjiC0ioCdx
	48UTJpAiZoHjTBI/f59nA0kICwRI3F04C6yIRUBVYvXf40wgNq+Au8SR5p0sEOsUJbqfTQCr
	5xTwkNj/8jEziC0EVHPw8WTmCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB90z
	6R2MqxosDjEKcDAq8fAmMKcHC7EmlhVX5h5ilOBgVhLhzU4ECvGmJFZWpRblxxeV5qQWH2KU
	5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamBk7jF5ZX33JeOrdpV1J+csmr7r/yVj1fVN
	B5ZEb2mviItpEIrUbt0ZbHFAy72xXXbnRoV/HiVX4t9IrJH0MBWcZdG9d6fubZUrfmVvJG+5
	W8Qa7dpV8GzBp0m3/rrdFL+fseGF7vrdrRks6/3aCt30jt09MCukl03hYA3fLVWJ16z2JR/D
	FscpsRRnJBpqMRcVJwIAI9idvDYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 33 +------------------------------
 drivers/thermal/samsung/exynos_tmu.h      | 13 ------------
 drivers/thermal/samsung/exynos_tmu_data.c |  3 ---
 drivers/thermal/samsung/exynos_tmu_data.h |  2 --
 4 files changed, 1 insertion(+), 50 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 0d96a51..9f2a5ee 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -76,9 +76,6 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp_code;
 
-	if (pdata->cal_mode == HW_MODE)
-		return temp;
-
 	if (data->soc == SOC_ARCH_EXYNOS4210)
 		/* temp should range between 25 and 125 */
 		if (temp < 25 || temp > 125) {
@@ -113,9 +110,6 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp;
 
-	if (pdata->cal_mode == HW_MODE)
-		return temp_code;
-
 	if (data->soc == SOC_ARCH_EXYNOS4210)
 		/* temp_code should range between 75 and 175 */
 		if (temp_code < 75 || temp_code > 175) {
@@ -164,9 +158,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
 		__raw_writel(1, data->base + reg->triminfo_ctrl);
 
-	if (pdata->cal_mode == HW_MODE)
-		goto skip_calib_data;
-
 	/* Save trimming info in order to perform calibration */
 	if (data->soc == SOC_ARCH_EXYNOS5440) {
 		/*
@@ -202,7 +193,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 			(pdata->efuse_value >> reg->triminfo_85_shift) &
 			EXYNOS_TMU_TEMP_MASK;
 
-skip_calib_data:
 	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
 		dev_err(&pdev->dev, "Invalid max trigger level\n");
 		ret = -EINVAL;
@@ -311,7 +301,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	const struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int con, interrupt_en, cal_val;
+	unsigned int con, interrupt_en;
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
@@ -337,27 +327,6 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 		con |= (pdata->noise_cancel_mode << reg->therm_trip_mode_shift);
 	}
 
-	if (pdata->cal_mode == HW_MODE) {
-		con &= ~(reg->calib_mode_mask << reg->calib_mode_shift);
-		cal_val = 0;
-		switch (pdata->cal_type) {
-		case TYPE_TWO_POINT_TRIMMING:
-			cal_val = 3;
-			break;
-		case TYPE_ONE_POINT_TRIMMING_85:
-			cal_val = 2;
-			break;
-		case TYPE_ONE_POINT_TRIMMING_25:
-			cal_val = 1;
-			break;
-		case TYPE_NONE:
-			break;
-		default:
-			dev_err(&pdev->dev, "Invalid calibration type, using none\n");
-		}
-		con |= cal_val << reg->calib_mode_shift;
-	}
-
 	if (on) {
 		con |= (1 << reg->core_en_shift);
 		interrupt_en =
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 80dc899..e417af8 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -34,11 +34,6 @@ enum calibration_type {
 	TYPE_NONE,
 };
 
-enum calibration_mode {
-	SW_MODE,
-	HW_MODE,
-};
-
 enum soc_type {
 	SOC_ARCH_EXYNOS4210 = 1,
 	SOC_ARCH_EXYNOS4412,
@@ -92,10 +87,6 @@ enum soc_type {
  * @buf_slope_sel_shift: shift bits of amplifier gain value in tmu_ctrl
 	register.
  * @buf_slope_sel_mask: mask bits of amplifier gain value in tmu_ctrl register.
- * @calib_mode_shift: shift bits of calibration mode value in tmu_ctrl
-	register.
- * @calib_mode_mask: mask bits of calibration mode value in tmu_ctrl
-	register.
  * @core_en_shift: shift bits of TMU core enable bit in tmu_ctrl register.
  * @tmu_status: register drescribing the TMU status.
  * @tmu_cur_temp: register containing the current temperature of the TMU.
@@ -139,8 +130,6 @@ struct exynos_tmu_registers {
 	u32	therm_trip_en_shift;
 	u32	buf_slope_sel_shift;
 	u32	buf_slope_sel_mask;
-	u32	calib_mode_shift;
-	u32	calib_mode_mask;
 	u32	core_en_shift;
 
 	u32	tmu_status;
@@ -222,7 +211,6 @@ struct exynos_tmu_registers {
  * @default_temp_offset: default temperature offset in case of no trimming
  * @test_mux; information if SoC supports test MUX
  * @cal_type: calibration type for temperature
- * @cal_mode: calibration mode for temperature
  * @freq_clip_table: Table representing frequency reduction percentage.
  * @freq_tab_count: Count of the above table as frequency reduction may
  *	applicable to only some of the trigger levels.
@@ -253,7 +241,6 @@ struct exynos_tmu_platform_data {
 	u8 test_mux;
 
 	enum calibration_type cal_type;
-	enum calibration_mode cal_mode;
 	enum soc_type type;
 	struct freq_clip_table freq_tab[4];
 	unsigned int freq_tab_count;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 36d64d6..4b992d9 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -205,8 +205,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
 	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
-	.calib_mode_shift = EXYNOS_TMU_CALIB_MODE_SHIFT,
-	.calib_mode_mask = EXYNOS_TMU_CALIB_MODE_MASK,
 	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
 	.tmu_status = EXYNOS5440_TMU_S0_7_STATUS,
 	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
@@ -243,7 +241,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
 	.cal_type = TYPE_ONE_POINT_TRIMMING, \
-	.cal_mode = 0, \
 	.efuse_value = 0x5b2d, \
 	.min_efuse_value = 16, \
 	.max_efuse_value = 76, \
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index d4eeddb..1fed00d 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -60,8 +60,6 @@
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
 #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
-#define EXYNOS_TMU_CALIB_MODE_SHIFT	4
-#define EXYNOS_TMU_CALIB_MODE_MASK	0x3
 
 #define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
 #define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
-- 
1.8.2.3


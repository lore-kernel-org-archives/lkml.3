Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3H1FpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:45:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8909 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3H1FpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:45:14 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-b2-521d8e6536f2
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH 2/3] thermal: samsung: Add TMU support for Exynos5420 SoCs
Date: Wed, 28 Aug 2013 11:15:18 +0530
Message-id: <1377668719-8602-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
 <1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkWje1TzbI4OxdG4uGqyEW84+cY7VY
	s/8nk0XvgqtsFpd3zWGz+Nx7hNFixvl9TBaLtv1ntnjysI/NgdNj56y77B6L97xk8ujbsorR
	4/iN7UwenzfJBbBGcdmkpOZklqUW6dslcGU8vaJXsF+34s0ytwbGv2pdjJwcEgImEutXdLFB
	2GISF+6tB7K5OIQEljJKTFpyjAmmaOO7HywQiUWMEmfvr4dyepgkbm95xgJSxSZgJnFw0Wp2
	EFtEwEti1sOrTCBFzALrGSUObV/LDJIQBkqs+7QIyObgYBFQlXh+MwQkzCvgIvHs8RIWkLCE
	gILEnEk2IGFOAVeJ6UteMkLsamCUWPDzMpgjIbCKXeJUbysjSBWLgIDEt8mHoJplJTYdYIa4
	WlLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECAz70/+e9e9gvHvA+hBj
	MtC4icxSosn5wLjJK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1
	+BAjEwenVAOjW9ODtDTpRb4f9j41uX7rFO/1Pxo6z953LDOKrxBZZGGjXRXh425QH/d5ntV6
	mUMRwjYx8S1FVbISUVv97Hgryvi2RlzjKWEq7T0rbcl8OGzdyl7NBXYHVQxvcifsCZJQEyr6
	yb38WHh7dUlensmViu4Uu9P360Vr47x3uP4PObPokKzADSWW4oxEQy3mouJEAK+NfPyRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd3UPtkgg+OLjC0aroZYzD9yjtVi
	zf6fTBa9C66yWVzeNYfN4nPvEUaLGef3MVks2vaf2eLJwz42B06PnbPusnss3vOSyaNvyypG
	j+M3tjN5fN4kF8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4+kVvYL9
	uhVvlrk1MP5V62Lk5JAQMJHY+O4HC4QtJnHh3nq2LkYuDiGBRYwSZ++vZ4Fwepgkbm95BlbF
	JmAmcXDRanYQW0TAS2LWw6tMIEXMAusZJQ5tX8sMkhAGSqz7tAjI5uBgEVCVeH4zBCTMK+Ai
	8ezxEhaQsISAgsScSTYgYU4BV4npS14yQuxqYJRY8PMy4wRG3gWMDKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxgqPqmdQOxpUNFocYBTgYlXh4LTbLBAmxJpYVV+YeYpTgYFYS4S35DxTi
	TUmsrEotyo8vKs1JLT7EmAx01ERmKdHkfGDE55XEGxqbmJsam1qaWJiYWZImrCTOe6DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QDY4DP4j+8c7y0jiwzyeXIXpbq7vIt0Vo/c8LSg/PiEtTcphWt
	mrZ+fmHTe4YlMmt1RUqevXi30LZbL39y6pwEznmJ+h0LxR+uPrZey0eUtZJN+GeQ7L7LBwpm
	XHlx5dUT9oiQb8Gz+ELvyky/8PbGXc6X7npWasEq2zyNdQR5oy6qCLx96xzPpMRSnJFoqMVc
	VJwIAJ3Yb6juAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the neccessary register changes and arch information
to support Exynos5420 SoCs
Exynos5420 has 5 TMU channels one for each CPU 0, 1, 2 and 3 and GPU

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |    4 ++
 drivers/thermal/samsung/exynos_tmu.h      |    1 +
 drivers/thermal/samsung/exynos_tmu_data.c |   90 +++++++++++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.h |    7 +++
 4 files changed, 102 insertions(+)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index d201ed8..bfdfbd6 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -499,6 +499,10 @@ static const struct of_device_id exynos_tmu_match[] = {
 		.compatible = "samsung,exynos5440-tmu",
 		.data = (void *)EXYNOS5440_TMU_DRV_DATA,
 	},
+	{
+		.compatible = "samsung,exynos5420-tmu",
+		.data = (void *)EXYNOS5420_TMU_DRV_DATA,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_tmu_match);
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 7c6c34a..d88a536 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -43,6 +43,7 @@ enum soc_type {
 	SOC_ARCH_EXYNOS4210 = 1,
 	SOC_ARCH_EXYNOS,
 	SOC_ARCH_EXYNOS5440,
+	SOC_ARCH_EXYNOS5420,
 };
 
 /**
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 23fea23..5adbb36 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -177,6 +177,96 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 };
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS5420)
+static const struct exynos_tmu_registers exynos5420_tmu_registers = {
+	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
+	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
+	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
+	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
+	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
+	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
+	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
+	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
+	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
+	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
+	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
+	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
+	.tmu_status = EXYNOS_TMU_REG_STATUS,
+	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
+	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
+	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
+	.tmu_inten = EXYNOS_TMU_REG_INTEN,
+	.inten_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
+	.inten_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
+	.inten_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
+	.inten_fall_shift = EXYNOS_TMU_FALL_INT_SHIFT,
+	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
+	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
+	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
+	/* INTEN_RISE3 Not availble in exynos5420 */
+	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
+	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
+	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
+	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_fall_shift = EXYNOS_TMU_FALL_INT_SHIFT,
+	.emul_con = EXYNOS_EMUL_CON,
+	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
+	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
+	.emul_time_mask = EXYNOS_EMUL_TIME_MASK,
+};
+
+#define EXYNOS5420_TMU_DATA \
+	.threshold_falling = 10, \
+	.trigger_levels[0] = 85, \
+	.trigger_levels[1] = 103, \
+	.trigger_levels[2] = 110, \
+	.trigger_levels[3] = 120, \
+	.trigger_enable[0] = true, \
+	.trigger_enable[1] = true, \
+	.trigger_enable[2] = true, \
+	.trigger_enable[3] = false, \
+	.trigger_type[0] = THROTTLE_ACTIVE, \
+	.trigger_type[1] = THROTTLE_ACTIVE, \
+	.trigger_type[2] = SW_TRIP, \
+	.trigger_type[3] = HW_TRIP, \
+	.max_trigger_level = 4, \
+	.gain = 8, \
+	.reference_voltage = 16, \
+	.noise_cancel_mode = 4, \
+	.cal_type = TYPE_ONE_POINT_TRIMMING, \
+	.efuse_value = 55, \
+	.min_efuse_value = 40, \
+	.max_efuse_value = 100, \
+	.first_point_trim = 25, \
+	.second_point_trim = 85, \
+	.default_temp_offset = 50, \
+	.freq_tab[0] = { \
+		.freq_clip_max = 800 * 1000, \
+		.temp_level = 85, \
+	}, \
+	.freq_tab[1] = { \
+		.freq_clip_max = 200 * 1000, \
+		.temp_level = 103, \
+	}, \
+	.freq_tab_count = 2, \
+	.type = SOC_ARCH_EXYNOS5420, \
+	.registers = &exynos5420_tmu_registers, \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
+			TMU_SUPPORT_EMUL_TIME)
+
+struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
+	.tmu_data = {
+		{ EXYNOS5420_TMU_DATA },
+		{ EXYNOS5420_TMU_DATA },
+		{ EXYNOS5420_TMU_DATA },
+		{ EXYNOS5420_TMU_DATA },
+		{ EXYNOS5420_TMU_DATA },
+	},
+	.tmu_count = 5,
+};
+#endif
+
 #if defined(CONFIG_SOC_EXYNOS5440)
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index 8788a87..3ce94cd 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -153,4 +153,11 @@ extern struct exynos_tmu_init_data const exynos5440_default_tmu_data;
 #define EXYNOS5440_TMU_DRV_DATA (NULL)
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS5420)
+extern struct exynos_tmu_init_data const exynos5420_default_tmu_data;
+#define EXYNOS5420_TMU_DRV_DATA (&exynos5420_default_tmu_data)
+#else
+#define EXYNOS5420_TMU_DRV_DATA (NULL)
+#endif
+
 #endif /*_EXYNOS_TMU_DATA_H*/
-- 
1.7.9.5


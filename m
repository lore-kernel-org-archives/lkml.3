Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3H1JRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:17:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62325 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3H1JQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:16:48 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-07-521dbfffdf11
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH v2: 3/3] thermal: samsung: Add TMU support for Exynos5420 SoCs
Date: Wed, 28 Aug 2013 14:46:49 +0530
Message-id: <1377681409-18166-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377681409-18166-1-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
 <1377681409-18166-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkSvf/ftkgg5l/RS0aroZYzD9yjtVi
	zf6fTBa9C66yWVzeNYfN4nPvEUaLGef3MVks2vaf2eLJwz42B06PnbPusnss3vOSyaNvyypG
	j+M3tjN5fN4kF8AaxWWTkpqTWZZapG+XwJXRdkihYIZTxZuj3ewNjHfMuxg5OSQETCQav81m
	g7DFJC7cWw9kc3EICSxllNi15i0jTNHlt9dYIRLTGSWe3L/GBOH0MEnsfd/KAlLFJmAmcXDR
	anYQW0TAS2LWw6tgRcwC6xklDm1fy9zFyMEhLOAncXw32FQWAVWJBYsug/XyCrhK/F/eygRS
	IiGgIDFnkg1ImFPATeL2m+OMELsaGSWmf1gONlNCYBO7xJfrO5ghBglIfJt8iAWiWVZi0wFm
	iKslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYzAwD/971n/Dsa7B6wP
	MSYDjZvILCWanA+MnLySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pz
	UosPMTJxcEo1MLaaMWgGSqYH+iUu+uD28LbHKcm5Di0KLEtqa4J6vPi+bRHSzbQ+OZ0l2PH8
	xd4nkzf1fJ84OUvaUDT1erPEg4s6aoeUzQ9/+Do38MNiLsEXXmc3r7Po8Nm+/JHJsVlptt+C
	XHjOWIQdMT5eKSwz+WGa+sqWAt3s+ZN515kY7+MRNhR65HmwSomlOCPRUIu5qDgRADt1GluS	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd3/+2WDDI6d4bZouBpiMf/IOVaL
	Nft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PY7f2M7k8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjLZDCgUz
	nCreHO1mb2C8Y97FyMkhIWAicfntNVYIW0ziwr31bF2MXBxCAtMZJZ7cv8YE4fQwSex938oC
	UsUmYCZxcNFqdhBbRMBLYtbDq2BFzALrGSUObV/L3MXIwSEs4CdxfDcjSA2LgKrEgkWXwXp5
	BVwl/i9vZQIpkRBQkJgzyQYkzCngJnH7zXFGiF2NjBLTPyxnmsDIu4CRYRWjaGpBckFxUnqu
	oV5xYm5xaV66XnJ+7iZGcFw9k9rBuLLB4hCjAAejEg+vxWaZICHWxLLiytxDjBIczEoivPzb
	ZYOEeFMSK6tSi/Lji0pzUosPMSYDXTWRWUo0OR8Y83kl8YbGJuamxqaWJhYmZpakCSuJ8x5o
	tQ4UEkhPLEnNTk0tSC2C2cLEwSnVwGhd3SCzaVL7cnnN3TsEipfPDF0ZLP7G4Maj7MXP18v/
	CPnPnH23Jb9F8P38v2daU778Nf7GWap/5tHqztIqq02aG2fyii7pnFY1a+ftACnRCzab/cJX
	vflxXJXnxiKnJmOWt02+QnumxC7naFPkm6o/w4bXR71vktdvoS6lnbs8e0TbNBKOnlNiKc5I
	NNRiLipOBADiGSOd7wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the neccessary register changes and arch information
to support Exynos5420 SoCs
Exynos5420 has 5 TMU channels one for each CPU 0, 1, 2 and 3 and GPU

Note: The platform data structure will be handled properly once the driver
 moves to complete device driver solution.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
1. modified the platform data structure in order to pass SHARED flag
   for channels that need sharing of address space.
2. https://lkml.org/lkml/2013/8/1/38 is merged into this patch.
   As the changes are minimum and can be added here.

 drivers/thermal/samsung/exynos_tmu.c      |   14 +++-
 drivers/thermal/samsung/exynos_tmu.h      |    1 +
 drivers/thermal/samsung/exynos_tmu_data.c |  130 +++++++++++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.h |    7 ++
 4 files changed, 150 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index c56f7e5..d57a4e2 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -186,7 +186,12 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
 		}
 	} else {
-		trim_info = readl(data->base + reg->triminfo_data);
+		/* On exynos5420 the triminfo register is in the shared space */
+		if (data->base_second && (data->soc == SOC_ARCH_EXYNOS5420))
+			trim_info = readl(data->base_second +
+							reg->triminfo_data);
+		else
+			trim_info = readl(data->base + reg->triminfo_data);
 	}
 	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
 	data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
@@ -499,6 +504,10 @@ static const struct of_device_id exynos_tmu_match[] = {
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
@@ -637,7 +646,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 
 	if (pdata->type == SOC_ARCH_EXYNOS ||
 		pdata->type == SOC_ARCH_EXYNOS4210 ||
-				pdata->type == SOC_ARCH_EXYNOS5440)
+				pdata->type == SOC_ARCH_EXYNOS5440 ||
+				pdata->type == SOC_ARCH_EXYNOS5420)
 		data->soc = pdata->type;
 	else {
 		ret = -EINVAL;
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
index 23fea23..c3cdfbb 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -177,6 +177,136 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
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
+#define EXYNOS5420_TMU_DATA_SHARED \
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
+			TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_SHARED_MEMORY)
+
+struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
+	.tmu_data = {
+		{ EXYNOS5420_TMU_DATA },
+		{ EXYNOS5420_TMU_DATA },
+		{ EXYNOS5420_TMU_DATA_SHARED },
+		{ EXYNOS5420_TMU_DATA_SHARED },
+		{ EXYNOS5420_TMU_DATA_SHARED },
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


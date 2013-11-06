Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab3KFN1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:27:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36405 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab3KFN1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:27:09 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-7c-527a43aa90ad
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: [PATCH 3/3 v7] thermal: samsung: Add TMU support for Exynos5420 SoCs
Date: Wed, 06 Nov 2013 18:58:45 +0530
Message-id: <1383744525-22858-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSq7vKuSrIYGmjukXD1RCLjTPWs1q8
	PKRpMf/IOVaLNft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYHLg9ds66y+6x
	eM9LJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGup7DrAWXgyq+rX/K2sD4y6WL
	kYNDQsBEovmOfBcjJ5ApJnHh3nq2LkYuDiGBpYwSL/9NZIepObzOBKRGSGARo8SBD+kQNT1M
	EsfbrzKDJNgEzCQOLlrNDmKLCMhITL2ynxWkiFmgm0li/opzLCAJYQFfid6zl5hAbBYBVYmt
	67rAbF4BV4kzqyYyQVyhKNH9bAIbiM0JFJ96q5cZYrOLxPL3r8GukxDYxS5x7swvRohBAhLf
	Jh9igbhUVmLTAWaIOZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRmAk
	nP73rG8H480D1ocYk4HGTWSWEk3OB0ZSXkm8obGZkYWpiamxkbmlGWnCSuK8ix4mBQkJpCeW
	pGanphakFsUXleakFh9iZOLglGpgFGiUkG1L3aUa7OD527OHc2/n292nVwrY3pWc0K2r2SJW
	siH8iCdTnkpAyyOWWWwt34Q4zZVrfvCfEhNV6roQsVY+ZXVj7SSGTxdXrEyJuVOiG71x6fkF
	ts5b+WTd/k4+3+y19iLX8k3LN3w5rfB0pnZyfUD4pLZNz3uXphtlNHE9kf+hartQiaU4I9FQ
	i7moOBEAndXwEZoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd1VzlVBBs+WSls0XA2x2DhjPavF
	y0OaFvOPnGO1WLP/J5NF74KrbBaXd81hs/jce4TRYsb5fUwWi7b9Z7Z48rCPzYHbY+esu+we
	i/e8ZPLo27KK0eP4je1MHp83yQWwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxhzFjXc5i14HJQxbf1T1kbGH+5dDFycEgImEgcXmfSxcgJZIpJXLi3ng3EFhJYxChx4EN6
	FyMXkN3DJHG8/SozSIJNwEzi4KLV7CC2iICMxNQr+1lBipgFupkk5q84xwKSEBbwleg9e4kJ
	xGYRUJXYuq4LzOYVcJU4s2oiE8Q2RYnuZxPAtnECxafe6mWG2Owisfz9a7YJjLwLGBlWMYqm
	FiQXFCel5xrpFSfmFpfmpesl5+duYgRH2jPpHYyrGiwOMQpwMCrx8CbIVwYJsSaWFVfmHmKU
	4GBWEuG1MqgKEuJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YBLIK4k3NDYxNzU2tTSxMDGz
	JE1YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZG0SMnZlQ3p4ftqX3GYv/80drcL7mf95Uv
	CQoznK4pr8JxKa7tal/PjI/3fvgmH71suT+F701+vuJ+J02rqW4lTpmOsSukVvO2CDyVZ6+u
	/fe1W3iN+d/ZaT+558Yd32rhrPvt99+5S1ck5uYd2yHyNuvyzm9za8IXzFY6++Cz/cdFM+MP
	rzjJosRSnJFoqMVcVJwIAB7PTGX4AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the neccessary register changes and arch information
to support Exynos5420 SoCs
Exynos5420 has 5 TMU channels one for each CPU 0, 1, 2 and 3 and GPU

Also updated the Documentation at
Documentation/devicetree/bindings/thermal/exynos-thermal.txt

Note: The platform data structure will be handled properly once the driver
 moves to complete device driver solution.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
1. modified the platform data structure in order to pass SHARED flag
   for channels that need sharing of address space.
2. https://lkml.org/lkml/2013/8/1/38 is merged into this patch.
   As the changes are minimum and can be added here.
Changes since v3:
   a. Rearraged the code alphabetically, make exynso5420 come before exynso5440
   b. Reduce code duplication in passing platform data by introducing a common macro
      Bartlomiej Zolnierkiewicz Thanks for review and suggestions
Changes since v4:
 None
Changes since v5:
 None
Changes since v6:
 - removed the unsued field "inten_fall_shift"
 - defined EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT instead of using EXYNOS_TMU_FALL_INT_SHIFT
 
 .../devicetree/bindings/thermal/exynos-thermal.txt |   39 ++++++++
 drivers/thermal/samsung/exynos_tmu.c               |   12 ++-
 drivers/thermal/samsung/exynos_tmu.h               |    1 +
 drivers/thermal/samsung/exynos_tmu_data.c          |   99 ++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.h          |    7 ++
 5 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index 116cca0..c5f9a74 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -6,6 +6,7 @@
 	       "samsung,exynos4412-tmu"
 	       "samsung,exynos4210-tmu"
 	       "samsung,exynos5250-tmu"
+	       "samsung,exynos5420-tmu"
 	       "samsung,exynos5440-tmu"
 - interrupt-parent : The phandle for the interrupt controller
 - reg : Address range of the thermal registers. For soc's which has multiple
@@ -13,6 +14,16 @@
 	interrupt related then 2 set of register has to supplied. First set
 	belongs	to each instance of TMU and second set belongs to second set
 	of common TMU registers.
+  NOTE: On Exynos5420, the TRIMINFO register is misplaced for TMU
+	channels 2, 3 and 4
+
+	TRIMINFO at 0x1006c000 contains data for TMU channel 3
+	TRIMINFO at 0x100a0000 contains data for TMU channel 4
+	TRIMINFO at 0x10068000 contains data for TMU channel 2
+
+	The misplaced register address is passed through devicetree as the
+	second base
+
 - interrupts : Should contain interrupt for thermal system
 - clocks : The main clock for TMU device
 - clock-names : Thermal system clock name
@@ -43,6 +54,34 @@ Example 2):
 		clock-names = "tmu_apbif";
 	};
 
+Example 3): (In case of Exynos5420)
+	/* tmu for CPU2 */
+	tmu@10068000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x10068000 0x100>, <0x1006c000 0x4>;
+		interrupts = <0 184 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	/* tmu for CPU3 */
+	tmu@1006c000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
+		interrupts = <0 185 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	/* tmu for GPU */
+	tmu@100a0000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x100a0000 0x100>, <0x10068000 0x4>;
+		interrupts = <0 215 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
 Note: For multi-instance tmu each instance should have an alias correctly
 numbered in "aliases" node.
 
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index ae80a87..b54825a 100644
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
@@ -498,6 +503,10 @@ static const struct of_device_id exynos_tmu_match[] = {
 		.data = (void *)EXYNOS5250_TMU_DRV_DATA,
 	},
 	{
+		.compatible = "samsung,exynos5420-tmu",
+		.data = (void *)EXYNOS5420_TMU_DRV_DATA,
+	},
+	{
 		.compatible = "samsung,exynos5440-tmu",
 		.data = (void *)EXYNOS5440_TMU_DRV_DATA,
 	},
@@ -635,6 +644,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
 	    pdata->type == SOC_ARCH_EXYNOS4412 ||
 	    pdata->type == SOC_ARCH_EXYNOS5250 ||
+	    pdata->type == SOC_ARCH_EXYNOS5420 ||
 	    pdata->type == SOC_ARCH_EXYNOS5440)
 		data->soc = pdata->type;
 	else {
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index d79264f..4b9be23 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -43,6 +43,7 @@ enum soc_type {
 	SOC_ARCH_EXYNOS4210 = 1,
 	SOC_ARCH_EXYNOS4412,
 	SOC_ARCH_EXYNOS5250,
+	SOC_ARCH_EXYNOS5420,
 	SOC_ARCH_EXYNOS5440,
 };
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index ad424ad..c876b1e 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -195,6 +195,105 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
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
+#define __EXYNOS5420_TMU_DATA	\
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
+
+#define EXYNOS5420_TMU_DATA \
+	__EXYNOS5420_TMU_DATA \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
+			TMU_SUPPORT_EMUL_TIME)
+
+#define EXYNOS5420_TMU_DATA_SHARED \
+	__EXYNOS5420_TMU_DATA \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
+			TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_ADDRESS_MULTIPLE)
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
index bb412bb..eb2cb92 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -158,6 +158,13 @@ extern struct exynos_tmu_init_data const exynos5250_default_tmu_data;
 #define EXYNOS5250_TMU_DRV_DATA (NULL)
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS5420)
+extern struct exynos_tmu_init_data const exynos5420_default_tmu_data;
+#define EXYNOS5420_TMU_DRV_DATA (&exynos5420_default_tmu_data)
+#else
+#define EXYNOS5420_TMU_DRV_DATA (NULL)
+#endif
+
 #if defined(CONFIG_SOC_EXYNOS5440)
 extern struct exynos_tmu_init_data const exynos5440_default_tmu_data;
 #define EXYNOS5440_TMU_DRV_DATA (&exynos5440_default_tmu_data)
-- 
1.7.10.4


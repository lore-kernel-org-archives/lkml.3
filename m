Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3KSNEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:04:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:49809 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3KSNEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:04:02 -0500
X-AuditID: cbfee68d-b7fa16d0000029b0-e7-528b61c0711c
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH 3/4 v10] thermal: samsung: Add TMU support for Exynos5420 SoCs
Date: Tue, 19 Nov 2013 18:35:25 +0530
Message-id: <1384866325-16110-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSrXsgsTvIoP2AgkXD1RCLjTPWs1q8
	PKRpMf/IOVaLNft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYLNbPeM3iwOOx
	c9Zddo/Fe14yefRtWcXocfzGdiaPz5vkAlijuGxSUnMyy1KL9O0SuDL+TrrBVLCitOLWv9lM
	DYxvErsYOTkkBEwkPnxfwAphi0lcuLeerYuRi0NIYCmjxLGed4wwRZ/mXmaCSCxilGht2Q/l
	9DBJ/LvxFqyKTcBM4uCi1ewgtoiAjMTUK/tZQYqYBeYzSRz6sxYsISzgJ9Gy5xjYPhYBVYnJ
	07uBJnFw8Aq4SjQ/UYHYpijR/WwCG4jNCRSeequXGcQWEnCRWP7+Ndh5EgKH2CUOXb7NDjFH
	QOLb5EMsIHMkBGQlNh1ghpgjKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefn
	bmIExsXpf896dzDePmB9iDEZaNxEZinR5HxgXOWVxBsamxlZmJqYGhuZW5qRJqwkzpv0MClI
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+Nhl0k2606rJsTzz5rVctvOln/zlKRZe9vCdh4K
	L/pae843/A7fUZnvHT3bu7e1TmdpDAifkn6VhTlYP858Csud3TGryrtmTgtV3Xrj6p2iA3ap
	B4v2VWzWer/uzL9zsScmHP4qquI86/qPRctOzdWITdVKmTz5sIqx+jXOzv7r6mG3T99Uu3pH
	iaU4I9FQi7moOBEAaPjuvqECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd0Did1BBnu+ilg0XA2x2DhjPavF
	y0OaFvOPnGO1WLP/J5NF74KrbBaXd81hs/jce4TRYsb5fUwWi7b9Z7Z48rCPzWL9jNcsDjwe
	O2fdZfdYvOclk0ffllWMHsdvbGfy+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jxt9JN5gKVpRW3Po3m6mB8U1iFyMnh4SAicSnuZeZIGwxiQv31rN1MXJxCAks
	YpRobdnPBOH0MEn8u/GWEaSKTcBM4uCi1ewgtoiAjMTUK/tZQYqYBeYzSRz6sxYsISzgJ9Gy
	5xgriM0ioCoxeXo30CQODl4BV4nmJyoQ2xQlup9NYAOxOYHCU2/1MoPYQgIuEsvfv2abwMi7
	gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw1D2T2sG4ssHiEKMAB6MSD+8E964gIdbE
	suLK3EOMEhzMSiK8xkHdQUK8KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD0wIeSXxhsYm5qbG
	ppYmFiZmlqQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAmCx27cv9xfGRE57vvSkyI+qN
	mrmKsJLa1RuNhW+z1uuaKBw7W/xm/fnIf39khI0FOd482GHxWijNpbfg7YcVXzMXxq97+Jm/
	7POyMA/Orul91bkHHzI5Xcp2ZBMu3X3fa6+B40oB9UlavYqu6ue8+ZZ2fuZJqNfk/Sqzx2iK
	2Tu1e+LpO17mK7EUZyQaajEXFScCAGOH8H/+AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5420 has 5 TMU channels, the TRIMINFO register is
misplaced for TMU channels 2, 3 and 4
TRIMINFO at 0x1006c000 contains data for TMU channel 3
TRIMINFO at 0x100a0000 contains data for TMU channel 4
TRIMINFO at 0x10068000 contains data for TMU channel 2

This patch
1 Adds the neccessary register changes and arch information
   to support Exynos5420 SoCs.
2. Handles the gate clock for misplaced TRIMINFO register
3. Updates the Documentation at
   Documentation/devicetree/bindings/thermal/exynos-thermal.txt

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Changes since v9:
Just respinning

Changes since v8:
1. rewrote the Documentation for device tree bindings
2. Merged the https://lkml.org/lkml/2013/11/7/262 (as this is a fix)
3. introduces "samsung,exynos5420-tmu-triminfo" and 
   "samsung,exynos5420-tmu-triminfo-clk" to handle the TMU channels on
   Exynos5420 more appropriately

 .../devicetree/bindings/thermal/exynos-thermal.txt |   45 +++++++++
 drivers/thermal/samsung/exynos_tmu.c               |   58 ++++++++++-
 drivers/thermal/samsung/exynos_tmu.h               |    2 +
 drivers/thermal/samsung/exynos_tmu_data.c          |  106 ++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.h          |    8 ++
 5 files changed, 215 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index 116cca0..5055b31 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -6,6 +6,11 @@
 	       "samsung,exynos4412-tmu"
 	       "samsung,exynos4210-tmu"
 	       "samsung,exynos5250-tmu"
+	       "samsung,exynos5420-tmu" for TMU channel 0, 1 on Exynos5420
+	       "samsung,exynos5420-tmu-triminfo" for TMU channel 2 Exynos5420
+			(Must pass triminfo base)
+	       "samsung,exynos5420-tmu-triminfo-clk" for TMU channel 3 and 4
+			Exynos5420 (Must pass triminfo base and triminfo clock)
 	       "samsung,exynos5440-tmu"
 - interrupt-parent : The phandle for the interrupt controller
 - reg : Address range of the thermal registers. For soc's which has multiple
@@ -13,6 +18,18 @@
 	interrupt related then 2 set of register has to supplied. First set
 	belongs	to each instance of TMU and second set belongs to second set
 	of common TMU registers.
+
+  NOTE: On Exynos5420, the TRIMINFO register is misplaced for TMU
+	channels 2, 3 and 4
+	Use "samsung,exynos5420-tmu-triminfo" in cases, there is a misplaced
+	register but no need of another clock to access that base.
+	Use "samsung,exynos5420-tmu-triminfo-clk" in cases where there is a misplaced
+	register and we need another clock to access that base.
+
+	TRIMINFO at 0x1006c000 contains data for TMU channel 3
+	TRIMINFO at 0x100a0000 contains data for TMU channel 4
+	TRIMINFO at 0x10068000 contains data for TMU channel 2
+
 - interrupts : Should contain interrupt for thermal system
 - clocks : The main clock for TMU device
 - clock-names : Thermal system clock name
@@ -43,6 +60,34 @@ Example 2):
 		clock-names = "tmu_apbif";
 	};
 
+Example 3): (In case of Exynos5420 "with misplaced TRIMINFO register")
+	/* tmu for CPU2 */
+	tmu@10068000 {
+		compatible = "samsung,exynos5420-tmu-triminfo";
+		reg = <0x10068000 0x100>, <0x1006c000 0x4>;
+		interrupts = <0 184 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	/* tmu for CPU3 */
+	tmu@1006c000 {
+		compatible = "samsung,exynos5420-tmu-triminfo-clk";
+		reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
+		interrupts = <0 185 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
+	};
+
+	/* tmu for GPU */
+	tmu@100a0000 {
+		compatible = "samsung,exynos5420-tmu-triminfo-clk";
+		reg = <0x100a0000 0x100>, <0x10068000 0x4>;
+		interrupts = <0 215 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
+	};
+
 Note: For multi-instance tmu each instance should have an alias correctly
 numbered in "aliases" node.
 
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index bbd0fc3..826647c 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -47,6 +47,7 @@
  * @irq_work: pointer to the irq work structure.
  * @lock: lock to implement synchronization.
  * @clk: pointer to the clock structure.
+ * @clk_sec: pointer to the clock structure for accessing the base_second.
  * @temp_error1: fused value of the first point trim.
  * @temp_error2: fused value of the second point trim.
  * @regulator: pointer to the TMU regulator structure.
@@ -61,7 +62,7 @@ struct exynos_tmu_data {
 	enum soc_type soc;
 	struct work_struct irq_work;
 	struct mutex lock;
-	struct clk *clk;
+	struct clk *clk, *clk_sec;
 	u8 temp_error1, temp_error2;
 	struct regulator *regulator;
 	struct thermal_sensor_conf *reg_conf;
@@ -152,6 +153,8 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
+	if (!IS_ERR(data->clk_sec))
+		clk_enable(data->clk_sec);
 
 	if (TMU_SUPPORTS(pdata, READY_STATUS)) {
 		status = readb(data->base + reg->tmu_status);
@@ -186,7 +189,13 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
 		}
 	} else {
-		trim_info = readl(data->base + reg->triminfo_data);
+		/* On exynos5420 the triminfo register is in the shared space */
+		if (data->soc == SOC_ARCH_EXYNOS5420_TRIMINFO ||
+			data->soc == SOC_ARCH_EXYNOS5420_TRIMINFO_CLK)
+			trim_info = readl(data->base_second +
+							reg->triminfo_data);
+		else
+			trim_info = readl(data->base + reg->triminfo_data);
 	}
 	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
 	data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
@@ -301,6 +310,8 @@ skip_calib_data:
 out:
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
+	if (!IS_ERR(data->clk_sec))
+		clk_disable(data->clk_sec);
 
 	return ret;
 }
@@ -452,12 +463,16 @@ static void exynos_tmu_work(struct work_struct *work)
 	const struct exynos_tmu_registers *reg = pdata->registers;
 	unsigned int val_irq, val_type;
 
+	if (!IS_ERR(data->clk_sec))
+		clk_enable(data->clk_sec);
 	/* Find which sensor generated this interrupt */
 	if (reg->tmu_irqstatus) {
 		val_type = readl(data->base_second + reg->tmu_irqstatus);
 		if (!((val_type >> data->id) & 0x1))
 			goto out;
 	}
+	if (!IS_ERR(data->clk_sec))
+		clk_disable(data->clk_sec);
 
 	exynos_report_trigger(data->reg_conf);
 	mutex_lock(&data->lock);
@@ -498,6 +513,18 @@ static const struct of_device_id exynos_tmu_match[] = {
 		.data = (void *)EXYNOS5250_TMU_DRV_DATA,
 	},
 	{
+		.compatible = "samsung,exynos5420-tmu",
+		.data = (void *)EXYNOS5420_TMU_DRV_DATA,
+	},
+	{
+		.compatible = "samsung,exynos5420-tmu-triminfo",
+		.data = (void *)EXYNOS5420_TMU_DRV_DATA,
+	},
+	{
+		.compatible = "samsung,exynos5420-tmu-triminfo-clk",
+		.data = (void *)EXYNOS5420_TMU_DRV_DATA,
+	},
+	{
 		.compatible = "samsung,exynos5440-tmu",
 		.data = (void *)EXYNOS5440_TMU_DRV_DATA,
 	},
@@ -628,13 +655,31 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		return  PTR_ERR(data->clk);
 	}
 
+	data->clk_sec = devm_clk_get(&pdev->dev, "tmu_apbif_triminfo");
+	if (IS_ERR(data->clk_sec)) {
+		if (data->soc == SOC_ARCH_EXYNOS5420_TRIMINFO_CLK) {
+			dev_err(&pdev->dev, "Failed to get triminfo clock\n");
+			return PTR_ERR(data->clk_sec);
+		}
+	} else {
+		ret = clk_prepare(data->clk_sec);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to get clock\n");
+			return ret;
+		}
+	}
+
 	ret = clk_prepare(data->clk);
-	if (ret)
-		return ret;
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to get clock\n");
+		goto err_clk_sec;
+	}
 
 	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
 	    pdata->type == SOC_ARCH_EXYNOS4412 ||
 	    pdata->type == SOC_ARCH_EXYNOS5250 ||
+	    pdata->type == SOC_ARCH_EXYNOS5420_TRIMINFO ||
+	    pdata->type == SOC_ARCH_EXYNOS5420_TRIMINFO_CLK ||
 	    pdata->type == SOC_ARCH_EXYNOS5440)
 		data->soc = pdata->type;
 	else {
@@ -703,6 +748,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	return 0;
 err_clk:
 	clk_unprepare(data->clk);
+err_clk_sec:
+	if (!IS_ERR(data->clk_sec))
+		clk_unprepare(data->clk_sec);
 	return ret;
 }
 
@@ -715,6 +763,8 @@ static int exynos_tmu_remove(struct platform_device *pdev)
 	exynos_unregister_thermal(data->reg_conf);
 
 	clk_unprepare(data->clk);
+	if (!IS_ERR(data->clk_sec))
+		clk_unprepare(data->clk_sec);
 
 	if (!IS_ERR(data->regulator))
 		regulator_disable(data->regulator);
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 0d6b32f..f2eb3ac 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -43,6 +43,8 @@ enum soc_type {
 	SOC_ARCH_EXYNOS4210 = 1,
 	SOC_ARCH_EXYNOS4412,
 	SOC_ARCH_EXYNOS5250,
+	SOC_ARCH_EXYNOS5420_TRIMINFO,
+	SOC_ARCH_EXYNOS5420_TRIMINFO_CLK,
 	SOC_ARCH_EXYNOS5440,
 };
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 1d27069..ff79c9a 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -194,6 +194,112 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
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
+	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
+	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
+	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
+	/* INTEN_RISE3 Not availble in exynos5420 */
+	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
+	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
+	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
+	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_fall_shift = EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT,
+	.intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
+	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
+	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
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
+	.registers = &exynos5420_tmu_registers, \
+
+#define EXYNOS5420_TMU_DATA \
+	__EXYNOS5420_TMU_DATA \
+	.type = SOC_ARCH_EXYNOS5250, \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
+			TMU_SUPPORT_EMUL_TIME)
+
+#define EXYNOS5420_TMU_DATA_SHARED \
+	__EXYNOS5420_TMU_DATA \
+	.type = SOC_ARCH_EXYNOS5420_TRIMINFO, \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
+			TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_ADDRESS_MULTIPLE)
+
+#define EXYNOS5420_TMU_DATA_SHARED_CLK \
+	__EXYNOS5420_TMU_DATA \
+	.type = SOC_ARCH_EXYNOS5420_TRIMINFO_CLK, \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
+			TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_ADDRESS_MULTIPLE)
+
+struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
+	.tmu_data = {
+		{ EXYNOS5420_TMU_DATA },
+		{ EXYNOS5420_TMU_DATA },
+		{ EXYNOS5420_TMU_DATA_SHARED },
+		{ EXYNOS5420_TMU_DATA_SHARED_CLK },
+		{ EXYNOS5420_TMU_DATA_SHARED_CLK },
+	},
+	.tmu_count = 5,
+};
+#endif
+
 #if defined(CONFIG_SOC_EXYNOS5440)
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index d9495a4..41f06dc 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -72,6 +72,7 @@
 #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
 #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
 #define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
+#define EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT	16
 #define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT	4
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
@@ -156,6 +157,13 @@ extern struct exynos_tmu_init_data const exynos5250_default_tmu_data;
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


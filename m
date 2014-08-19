Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaHSMIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:08:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49333 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaHSMID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:08:03 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-ca-53f33e20ce70
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: kgene.kim@samsung.com, b.zolnierkie@samsung.com, amit.daniel@samsung.com,
        t.figa@samsung.com, l.majewski@samsung.com, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv2] thermal: exynos: Add support for TRIM_RELOAD feature at
 Exynos3250
Date: Tue, 19 Aug 2014 21:07:58 +0900
Message-id: <1408450078-6296-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408449463-3987-1-git-send-email-cw00.choi@samsung.com>
References: <1408449463-3987-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWyRsSkQFfB7nOwwdX/nBYNV0MsNs5Yz2px
	9/lhRovrX56zWsw/co7VYs3+n0wW869cY7XoXXCVzeJs0xt2izcPNzNabHoMFLu8aw6bxefe
	I4wWM87vY7J48rCPzWL9jNcsDgIeO2fdZfdYvOclk8fmJfUefVtWMXocv7GdyePzJrkAtigu
	m5TUnMyy1CJ9uwSujF3ztzEV3Fat6DnSwdTAuFihi5GTQ0LARGLzmotMELaYxIV769m6GLk4
	hASWMkosnN3ABFN0a2UzVGI6o8TzOeuZIJwmJolrf7ewgVSxCWhJ7H9xA8wWETCQ6LgygxnE
	ZhaYzyzxutUDxBYWCJdY/WAnI4jNIqAq8WTzNbB6XgEXicdLDjFDbJOT+LDnETuIzSngKrHu
	7DoWEFsIqGbZ+V2sIIslBG6xS1x6OpEFYpCAxLfJh4BsDqCErMSmA1BzJCUOrrjBMoFReAEj
	wypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwEg6/e9Z3w7GmwesDzEmA42byCwlmpwPjMS8
	knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAo5Ldo
	Wc3aXu6T5rP+bD6itmT/6y6LfN0N2679T2H9V3X2iRC/1gyFlYfuPTjdeGy1c/Anl906Cb1L
	zRVC193MW3E506/eTPTonGjzwK1z77ofNI5parm9uPric8WN2vcUPTezr2qZHFAbkvrn5pef
	mtw8h033VEpuXB2d+CBr6q+/03VXhX89psRSnJFoqMVcVJwIAFInZrK6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQV15u8/BBkuabSwaroZYbJyxntXi
	7vPDjBbXvzxntZh/5ByrxZr9P5ks5l+5xmrRu+Aqm8XZpjfsFm8ebma02PQYKHZ51xw2i8+9
	RxgtZpzfx2Tx5GEfm8X6Ga9ZHAQ8ds66y+6xeM9LJo/NS+o9+rasYvQ4fmM7k8fnTXIBbFEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QHcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDN2zd/GVHBbtaLnSAdTA+NihS5G
	Tg4JAROJWyub2SBsMYkL99YD2VwcQgLTGSWez1nPBOE0MUlc+7sFrIpNQEti/4sbYLaIgIFE
	x5UZzCA2s8B8ZonXrR4gtrBAuMTqBzsZQWwWAVWJJ5uvgdXzCrhIPF5yiBlim5zEhz2P2EFs
	TgFXiXVn17GA2EJANcvO72KdwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwnD6T
	2sG4ssHiEKMAB6MSD6/Cl4/BQqyJZcWVuYcYJTiYlUR4O6Q/BwvxpiRWVqUW5ccXleakFh9i
	NAW6aiKzlGhyPjCF5JXEGxqbmBlZGpkbWhgZmyuJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRq
	YCzwWrRmq5pQXeKDh0m6jgW+jMbfdMNfuzydneUf/EzQeVXj34TyrIPLWtXLrVQjLrunm4nt
	P//o5cYVF9672Vzy71SIZ5/TVxywX/SqXegzZ6tWjgUu33Qu39+uE5A9JdGkNCddvPb8gtZL
	vvfyBIJctq+e/ieu4rr43qJTK173/WvOnS0bpMRSnJFoqMVcVJwIAD5Nr4DpAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for TRIM_RELOAD feature at Exynos3250. The TMU of
Exynos3250 has two TRIMINFO_CON register.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
---
Changes from v1:
- Add missing 'TMU_SUPPORT_TRIM_RELOAD' features

 drivers/thermal/samsung/exynos_tmu.c      |  7 +++++--
 drivers/thermal/samsung/exynos_tmu.h      |  5 +++--
 drivers/thermal/samsung/exynos_tmu_data.c | 11 +++++++++--
 drivers/thermal/samsung/exynos_tmu_data.h |  7 +++++--
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index acbff14..ed01606 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -164,8 +164,11 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		}
 	}
 
-	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
-		__raw_writel(1, data->base + reg->triminfo_ctrl);
+	if (TMU_SUPPORTS(pdata, TRIM_RELOAD)) {
+		for (i = 0; i < pdata->triminfo_reload_count; i++)
+			__raw_writel(pdata->triminfo_reload[i],
+					data->base + reg->triminfo_ctrl[i]);
+	}
 
 	if (pdata->cal_mode == HW_MODE)
 		goto skip_calib_data;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 1b4a644..72cb54e 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -151,8 +151,7 @@ struct exynos_tmu_registers {
 	u32	triminfo_25_shift;
 	u32	triminfo_85_shift;
 
-	u32	triminfo_ctrl;
-	u32	triminfo_ctrl1;
+	u32	triminfo_ctrl[2];
 	u32	triminfo_reload_shift;
 
 	u32	tmu_ctrl;
@@ -295,6 +294,8 @@ struct exynos_tmu_platform_data {
 	u8 second_point_trim;
 	u8 default_temp_offset;
 	u8 test_mux;
+	u8 triminfo_reload[2];
+	u8 triminfo_reload_count;
 
 	enum calibration_type cal_type;
 	enum calibration_mode cal_mode;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index aa8e0de..b45aa90 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -95,6 +95,8 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON1,
+	.triminfo_ctrl[1] = EXYNOS_TMU_TRIMINFO_CON2,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
@@ -160,8 +162,11 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
+	.triminfo_reload[0] = 0x1, \
+	.triminfo_reload[1] = 0x11, \
+	.triminfo_reload_count = 2, \
 	.registers = &exynos3250_tmu_registers, \
-	.features = (TMU_SUPPORT_EMULATION | \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD\
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
 			TMU_SUPPORT_EMUL_TIME)
 #endif
@@ -184,7 +189,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
-	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON2,
 	.triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
@@ -252,6 +257,8 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
+	.triminfo_reload[0] = 0x1, \
+	.triminfo_reload_count = 1, \
 	.registers = &exynos4412_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index f0979e5..e0536c3 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -57,8 +57,11 @@
 #define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
 #define EXYNOS4210_TMU_INTCLEAR_VAL	0x1111
 
-/* Exynos5250 and Exynos4412 specific registers */
-#define EXYNOS_TMU_TRIMINFO_CON	0x14
+/* Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON1	0x10
+
+/* Exynos5250, Exynos4412 and Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON2	0x14
 #define EXYNOS_THD_TEMP_RISE		0x50
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
-- 
1.8.0


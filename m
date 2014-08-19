Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaHSXwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 19:52:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34414 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaHSXwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 19:52:47 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-65-53f3e34da4aa
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, amit.daniel@samsung.com
Cc: kgene.kim@samsung.com, b.zolnierkie@samsung.com, t.figa@samsung.com,
        l.majewski@samsung.com, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv3] thermal: exynos: Add support for TRIM_RELOAD feature at
 Exynos3250
Date: Wed, 20 Aug 2014 08:52:44 +0900
Message-id: <1408492364-8012-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408450078-6296-1-git-send-email-cw00.choi@samsung.com>
References: <1408450078-6296-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkWNf38edggzOTuCwaroZYbJyxntXi
	7vPDjBbXvzxntZh/5ByrxZr9P5ks5l+5xmrRu+Aqm8XZpjfsFm8ebma02PQYKHZ51xw2i8+9
	RxgtZpzfx2Tx5GEfm8X6Ga9ZHAQ8ds66y+6xeM9LJo/NS+o9+rasYvQ4fmM7k8fnTXIBbFFc
	NimpOZllqUX6dglcGafPLWEquKFW8bhrKnMDY5diFyMHh4SAicStBz5djJxAppjEhXvr2boY
	uTiEBJYySmw/dI8JImEicXPFViaIxCJGie5nJ6GcJiaJxZsOsoNUsQloSex/cYMNxBYR8JSY
	M/0EC4jNLNDGLDFpZgKILSwQLvF7UgsriM0ioCrx5NQ1sBpeAReJS8d+MUJsk5P4sOcR2ExO
	AVeJ9m8HwWYKAdV8vrSYHWSxhMA9dolN948xQgwSkPg2+RALxDuyEpsOMEPMkZQ4uOIGywRG
	4QWMDKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAuPo9L9nfTsYbx6wPsSYDDRuIrOUaHI+
	MA7zSuINjc2MLExNTI2NzC3NSBNWEudd9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj
	cn6J6LcjD86r8P9ysXvd//OAj0jzQhHRW3mbg799KU0wNlZ4+Pu5zYqXXdqTYmrPMTq9a3UJ
	/jqnY4lTP8usq0/709/u8OIUOLnNZ8bCnwyH+3hnv/4eWDTr3euN9XrKO4p9i+RM2k7krSqb
	N1kyyPVvY16/sZ1s4sygTwlMzZPVVRzvr/BUYinOSDTUYi4qTgQA4w7OBbkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jAV3fx5+DDfZ1Mlk0XA2x2DhjPavF
	3eeHGS2uf3nOajH/yDlWizX7fzJZzL9yjdWid8FVNouzTW/YLd483MxosekxUOzyrjlsFp97
	jzBazDi/j8niycM+Nov1M16zOAh47Jx1l91j8Z6XTB6bl9R79G1Zxehx/MZ2Jo/Pm+QC2KIa
	GG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgO5WUihL
	zCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGacPreEqeCGWsXjrqnMDYxdil2M
	nBwSAiYSN1dsZYKwxSQu3FvP1sXIxSEksIhRovvZSSYIp4lJYvGmg+wgVWwCWhL7X9xgA7FF
	BDwl5kw/wQJiMwu0MUtMmpkAYgsLhEv8ntTCCmKzCKhKPDl1DayGV8BF4tKxX4wQ2+QkPux5
	BDaTU8BVov3bQbCZQkA1ny8tZp/AyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnCc
	PpPawbiyweIQowAHoxIPr0L252Ah1sSy4srcQ4wSHMxKIrysHUAh3pTEyqrUovz4otKc1OJD
	jKZAV01klhJNzgemkLySeENjEzMjSyNzQwsjY3Mlcd4DrdaBQgLpiSWp2ampBalFMH1MHJxS
	DYzHQwqVgi6v+FAxkcVZ17vhj3fDgj1h2z51VOsJcJWX652TzQzmnx48V9NhZlWIbfv5g8+f
	5XFamTgIMLE5yb1foCxYmSCk4HHozard0xh/n4x8H/Z3V8Yyw/prJ6YLqUwSZ5U6cqda68zv
	FdvPr9xw2jXocMzJ9z6Lvkku3Liee+/LF5p/XyxQYinOSDTUYi4qTgQAUgs8kukCAAA=
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
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
Changes from v2:
- Fix build break because of missing 'or' operation.
Changes from v1:
- Add missing 'TMU_SUPPORT_TRIM_RELOAD' feature

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
index aa8e0de..8cd609c 100644
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
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
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


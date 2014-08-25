Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaHYHak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:30:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42444 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbaHYHah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:30:37 -0400
X-AuditID: cbfee68d-f79c46d000000b84-1e-53fae61bb8bd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, galak@codeaurora.org, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv4 3/4] thermal: exynos: Add support for TRIM_RELOAD feature at
 Exynos3250
Date: Mon, 25 Aug 2014 16:30:24 +0900
Message-id: <1408951825-2639-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408951825-2639-1-git-send-email-cw00.choi@samsung.com>
References: <1408951825-2639-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkSFf62a9gg4WdXBYNV0Ms7j4/zGhx
	/ctzVov5R86xWqzZ/5PJYv6Va6wW/W8Wslr0LrjKZnG26Q27xabHQLHLu+awWXzuPcJoMeP8
	PiaLpdcvMllMmL6WxaJ17xF2iycP+9gcBD3WzFvD6HG5r5fJY+esu+wei/e8ZPLYtKqTzWPz
	knqPvi2rGD2O39jO5PF5k1wAZxSXTUpqTmZZapG+XQJXxrHlS5gKZktW3Ln8kamBsUGsi5GT
	Q0LARGLGpPusELaYxIV769m6GLk4hASWMkqceXGMvYuRA6zo8kpBiPh0Ronjxy6wQjhNTBKn
	pr9gB+lmE9CS2P/iBhuILSLgKTF3YQsTSBGzwBRmiVMdR8FWCAtES7w40ckIYrMIqEp8vbAS
	LM4r4CKx+c4CZogz5CQ+7HkEtplTwFXi7CI7kLAQUMnfaWuYQWZKCDRySDSsXMMGMUdA4tvk
	QywQl8pKbDoANUZS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiMt9P/
	nvXuYLx9wPoQowAHoxIP7wrOX8FCrIllxZW5hxhNgTZMZJYSTc4HRnVeSbyhsZmRhamJqbGR
	uaWZkjivotTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MKl99Xop+3OVcuf9F+uspUq9f
	+S+ck9d5eP+RaS2rfqoLW39p6xabyLzzxv3pvpM/u2p9M0v+qy4Qen+jXdmBy5biIldvWeZl
	T2kwYDj7QZ9TycB1wyerqTevba12dbf2uTRrysRlfjnv8yZeUfi8+JrcMt6f3I3ummX8YeYr
	rKqzzL6c6q5vVGIpzkg01GIuKk4EAJFk53iyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQV3pZ7+CDeavY7JouBpicff5YUaL
	61+es1rMP3KO1WLN/p9MFvOvXGO16H+zkNWid8FVNouzTW/YLTY9Bopd3jWHzeJz7xFGixnn
	9zFZLL1+kcliwvS1LBate4+wWzx52MfmIOixZt4aRo/Lfb1MHjtn3WX3WLznJZPHplWdbB6b
	l9R79G1Zxehx/MZ2Jo/Pm+QCOKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgH5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MGYcW76EqWC2ZMWdyx+ZGhgbxLoYOTgkBEwkLq8U7GLkBDLFJC7cW8/WxcjFISQwnVHi+LEL
	rBBOE5PEqekv2EGq2AS0JPa/uMEGYosIeErMXdjCBFLELDCFWeJUx1FWkISwQLTEixOdjCA2
	i4CqxNcLK8HivAIuEpvvLGCGWCcn8WHPI3aQKzgFXCXOLrIDCQsBlfydtoZ5AiPvAkaGVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjB0fxMagfjygaLQ4wCHIxKPLwrOX8FC7EmlhVX5h5i
	lOBgVhLhnXIcKMSbklhZlVqUH19UmpNafIjRFOioicxSosn5wESTVxJvaGxiZmRpZG5oYWRs
	riTOe6DVOlBIID2xJDU7NbUgtQimj4mDU6qBsWkeMIxXRBXHz7tyYa8x35SNy51E3NNzZdfr
	Vc57P8Nmbm+7X6oSs6Os2NzLax2Y+d6ZZOqWZsxTD7t9f7v/5HeOXGf3Nm2uXNh/6Oq9hPjM
	W20b7BPyeQIVnv087DTL5LXVlusX5nuJ/BRgmXakWeLpxpNPVr5n0+99z/dwlqD0fS5/da55
	SizFGYmGWsxFxYkAz7GGpfwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for TRIM_RELOAD feature at Exynos3250. The TMu of
Exynos3250 has two TRIMINFO_CON register and must need to set RELOAD bit
before reading TRIMINFO register.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu_data.c | 11 +++++++++--
 drivers/thermal/samsung/exynos_tmu_data.h |  7 +++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 754c638..4006eb4 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -95,6 +95,11 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON1,
+	.triminfo_ctrl[1] = EXYNOS_TMU_TRIMINFO_CON2,
+	.triminfo_ctrl_count = 2,
+	.triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
+	.triminfo_reload_mask = EXYNOS_TRIMINFO_RELOAD_MASK,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
@@ -161,7 +166,9 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	}, \
 	.freq_tab_count = 2, \
 	.registers = &exynos3250_tmu_registers, \
-	.features = (TMU_SUPPORT_EMULATION | \
+	.triminfo_reload[0] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
+	.triminfo_reload[1] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
 			TMU_SUPPORT_EMUL_TIME)
 #endif
@@ -184,7 +191,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
-	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON2,
 	.triminfo_ctrl_count = 1,
 	.triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
 	.triminfo_reload_mask = EXYNOS_TRIMINFO_RELOAD_MASK,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index 87454f63..f62fdde 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -57,8 +57,11 @@
 #define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
 #define EXYNOS4210_TMU_INTCLEAR_VAL	0x1111
 
-/* Exynos5250 and Exynos4412 specific registers */
-#define EXYNOS_TMU_TRIMINFO_CON	0x14
+/*  Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON1	0x10
+
+/* Exynos5250 ,Exynos4412 and Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON2	0x14
 #define EXYNOS_THD_TEMP_RISE		0x50
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
-- 
1.8.0


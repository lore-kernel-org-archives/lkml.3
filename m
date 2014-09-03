Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaICDJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:09:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39035 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaICDJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:09:10 -0400
X-AuditID: cbfee691-f79546d0000011a1-b8-5406865214bf
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, ch.naveen@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv6 2/2] thermal: exynos: Add support for TRIM_RELOAD feature at
 Exynos3250
Date: Wed, 03 Sep 2014 12:09:03 +0900
Message-id: <1409713743-6124-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409713743-6124-1-git-send-email-cw00.choi@samsung.com>
References: <1409713743-6124-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkUDeojS3E4Ol0dYuGqyEWG2esZ7W4
	+/wwo8X1L89ZLdbs/8lkMf/KNVaL3gVX2SzONr1ht9j0GMi9vGsOm8Xn3iOMFjPO72OyePKw
	j82B12PnrLvsHov3vGTy2Lyk3qNvyypGj+M3tjN5fN4kF8AWxWWTkpqTWZZapG+XwJXx9fEa
	1oJ/khXHH39hb2A8JdbFyMEhIWAi0XAzu4uRE8gUk7hwbz1bFyMXh5DAUkaJd38/skIkTCS+
	THsOlZjOKDHrdAMjhNPEJHH7ewcjSBWbgJbE/hc32EBsEQFPibkLW5hAipgF9jBJvOt+ygyS
	EBaIlnjx+xcLiM0ioCpxesILJhCbV8BF4tCPTiaIdXISH/Y8YgexOQVcJa4s+AJWLwRU82X3
	NFaQoRICp9gldq6axAYxSEDi2+RDLBD/yEpsOsAMMUdS4uCKGywTGIUXMDKsYhRNLUguKE5K
	LzLVK07MLS7NS9dLzs/dxAiMldP/nk3cwXj/gPUhRgEORiUe3gUBbCFCrIllxZW5hxhNgTZM
	ZJYSTc4HRmReSbyhsZmRhamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILUovii0pzU4kOMTByc
	Ug2MpTVPPK5Frt4qeeXkqZsZZh9575ruEyi6F/BicmMAp6Lh1En9TplbOM2mtbbHRVbM+fQv
	cY29rd2WlRWNdjdEvEtqjq3+ry5dYCFp6jw5/6D0rdzsD4Uuy1RkOOaWTQx+enB5zPKDLJ7L
	0/a9i9mxeOGk3P+Cx23/9Sn/vMDy7XXUvGCZvwuYlViKMxINtZiLihMBLpi9R5ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQd2gNrYQg54uOYuGqyEWG2esZ7W4
	+/wwo8X1L89ZLdbs/8lkMf/KNVaL3gVX2SzONr1ht9j0GMi9vGsOm8Xn3iOMFjPO72OyePKw
	j82B12PnrLvsHov3vGTy2Lyk3qNvyypGj+M3tjN5fN4kF8AW1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qJJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYx4+vjNawF/yQrjj/+wt7AeEqsi5GTQ0LAROLLtOdsELaYxIV7
	64FsLg4hgemMErNONzBCOE1MEre/dzCCVLEJaEnsf3EDrENEwFNi7sIWJpAiZoE9TBLvup8y
	gySEBaIlXvz+xQJiswioSpye8IIJxOYVcJE49KOTCWKdnMSHPY/YQWxOAVeJKwu+gNULAdV8
	2T2NdQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwbH4THoH46oGi0OMAhyMSjy8
	CwLYQoRYE8uKK3MPMUpwMCuJ8PomAoV4UxIrq1KL8uOLSnNSiw8xmgJdNZFZSjQ5H5gm8kri
	DY1NzIwsjcwNLYyMzZXEeQ+2WgcKCaQnlqRmp6YWpBbB9DFxcEo1MPYFv/wje0kplV9i68Qz
	Nm+9p1+ezLXEf9KGRtebPqqbKi5+SnQ68S1Dp3q7xfGrSwT+aDFNj0zuPHRv67pHsx2EkosZ
	Ow1TF/1ZczZI8dfdrju/1KeoJz549Doi806wnYLJDeZXr38E87yf9lWysEL84eq8ztIK61vO
	IX+v3App6rtp/qhqxlclluKMREMt5qLiRACqgyvu2wIAAA==
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
 drivers/thermal/samsung/exynos_tmu_data.c | 9 +++++++--
 drivers/thermal/samsung/exynos_tmu_data.h | 7 +++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 362a1e1..8bae170 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -87,6 +87,9 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS3250)
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON1,
+	.triminfo_ctrl[1] = EXYNOS_TMU_TRIMINFO_CON2,
+	.triminfo_ctrl_count = 2,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
@@ -147,8 +150,10 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
+	.triminfo_reload[0] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
+	.triminfo_reload[1] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
 	.registers = &exynos3250_tmu_registers, \
-	.features = (TMU_SUPPORT_EMULATION | \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
 			TMU_SUPPORT_EMUL_TIME)
 #endif
@@ -169,7 +174,7 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON2,
 	.triminfo_ctrl_count = 1,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index 6b47a17..4b8f33c 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -39,14 +39,17 @@
 #define EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT	8
 #define EXYNOS_TMU_CORE_EN_SHIFT	0
 
+/* Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON1	0x10
+
 /* Exynos4210 specific registers */
 #define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
 #define EXYNOS4210_TMU_REG_TRIG_LEVEL0	0x50
 
 #define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
 
-/* Exynos5250 and Exynos4412 specific registers */
-#define EXYNOS_TMU_TRIMINFO_CON	0x14
+/* Exynos5250, Exynos4412, Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON2	0x14
 #define EXYNOS_THD_TEMP_RISE		0x50
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
-- 
1.8.0


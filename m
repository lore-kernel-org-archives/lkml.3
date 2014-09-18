Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaIRP2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:28:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14534 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbaIRP2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:28:16 -0400
X-AuditID: cbfee61b-f79f86d00000144c-60-541afa0ea887
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 01/33] thermal: exynos: remove needless triminfo_data
 abstraction
Date: Thu, 18 Sep 2014 17:27:18 +0200
Message-id: <1411054070-25757-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAV2+X1IhBg9W8Vs0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugStj0oGrTAVvtCvWLutmb2Bcq9rFyMkhIWAicbjr
	ACOELSZx4d56NhBbSGARo8SEJQVdjFxAdheTxLK959hBEmwCVhIT21eBNYgIaEmcuLSdCaSI
	WeAWk8TrG5PBEsICwRKtpyaCNbAIqEoc3nmIBcTmFfCQWHTpAxvENkWJ7mcTwGxOAU+Jhlub
	2CE2e0i0bbnLPIGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4EB7Jr2DcVWDxSFG
	AQ5GJR7eA7xSIUKsiWXFlbmHGCU4mJVEeP98BArxpiRWVqUW5ccXleakFh9ilOZgURLnPdhq
	HSgkkJ5YkpqdmlqQWgSTZeLglGpg1DhnsOgA9xnpAK1gBW3375+dD0l4H3juYqH/5V2tfYCk
	0Gf/fO3TAaL9+7asigw1PpE7kcfs27zKo9Havspi5Xk22QVOxe+ufTM8aqDG/MTg/FrbXd+y
	aszu5spnfpg7/Zid1vUZ84rkGXL2lvL1hZ+V3RnDE/x3/9vrBueZcxP3mWkUHWJQYinOSDTU
	Yi4qTgQAiJAXLjACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->triminfo_data is used only in exynos_tmu_initialize() and
the code has already different paths for Exynos5440 and other
SoC types (on which TRIMINFO_DATA register offset is identical)
so the register abstraction is not needed and can be removed.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 10 +++++-----
 drivers/thermal/samsung/exynos_tmu.h      |  3 ---
 drivers/thermal/samsung/exynos_tmu_data.c |  6 ------
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 092ab69..e0e1151 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -165,22 +165,22 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		switch (data->id) {
 		case 0:
 			trim_info = readl(data->base +
-			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
+			EXYNOS5440_EFUSE_SWAP_OFFSET + EXYNOS5440_TMU_S0_7_TRIM);
 			break;
 		case 1:
-			trim_info = readl(data->base + reg->triminfo_data);
+			trim_info = readl(data->base + EXYNOS5440_TMU_S0_7_TRIM);
 			break;
 		case 2:
 			trim_info = readl(data->base -
-			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
+			EXYNOS5440_EFUSE_SWAP_OFFSET + EXYNOS5440_TMU_S0_7_TRIM);
 		}
 	} else {
 		/* On exynos5420 the triminfo register is in the shared space */
 		if (data->soc == SOC_ARCH_EXYNOS5420_TRIMINFO)
 			trim_info = readl(data->base_second +
-							reg->triminfo_data);
+						EXYNOS_TMU_REG_TRIMINFO);
 		else
-			trim_info = readl(data->base + reg->triminfo_data);
+			trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
 	}
 	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
 	data->temp_error2 = ((trim_info >> EXYNOS_TRIMINFO_85_SHIFT) &
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index f67203b..de20dcc 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -76,7 +76,6 @@ enum soc_type {
  * struct exynos_tmu_register - register descriptors to access registers and
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
- * @triminfo_data: register containing 2 pont trimming data
  * @triminfo_ctrl: trim info controller register.
  * @triminfo_ctrl_count: the number of trim info controller register.
  * @tmu_ctrl: TMU main controller register.
@@ -111,8 +110,6 @@ enum soc_type {
  * @tmu_pmin: register to get/set the Pmin value.
  */
 struct exynos_tmu_registers {
-	u32	triminfo_data;
-
 	u32	triminfo_ctrl[MAX_TRIMINFO_CTRL_REG];
 	u32	triminfo_ctrl_count;
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 54d30bc..0f1f1f1 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -26,7 +26,6 @@
 
 #if defined(CONFIG_CPU_EXYNOS4210)
 static const struct exynos_tmu_registers exynos4210_tmu_registers = {
-	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
@@ -86,7 +85,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS3250)
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
-	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON1,
 	.triminfo_ctrl[1] = EXYNOS_TMU_TRIMINFO_CON2,
 	.triminfo_ctrl_count = 2,
@@ -173,7 +171,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
-	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON2,
 	.triminfo_ctrl_count = 1,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
@@ -271,7 +268,6 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS5260)
 static const struct exynos_tmu_registers exynos5260_tmu_registers = {
-	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
@@ -354,7 +350,6 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS5420)
 static const struct exynos_tmu_registers exynos5420_tmu_registers = {
-	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
@@ -445,7 +440,6 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS5440)
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
-	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
 	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
-- 
1.8.2.3


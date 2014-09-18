Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbaIRPdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:33:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14701 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbaIRPaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:30:06 -0400
X-AuditID: cbfee61b-f79f86d00000144c-07-541afa7d4ab5
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 25/33] thermal: exynos: remove TMU_SUPPORT_FALLING_TRIP flag
Date: Thu, 18 Sep 2014 17:27:42 +0200
Message-id: <1411054070-25757-26-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAd3aX1IhBouPc1g0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvjeu8ZloIpehX/Dr9hamCcqN7FyMkhIWAiceH6
	BlYIW0ziwr31bF2MXBxCAosYJb437GaCcLqYJL6vvsYCUsUmYCUxsX0VI4gtIqAlceLSdrAi
	ZoFbTBKvb0wGSwgL+EhM+/mUHcRmEVCV2L/lANgKXgFPiWNrpjNBrFOU6H42gQ3E5gSKN9za
	BFYvJOAh0bblLvMERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJD7Zn0DsZVDRaH
	GAU4GJV4eA/wSoUIsSaWFVfmHmKU4GBWEuH98xEoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdg
	q3WgkEB6YklqdmpqQWoRTJaJg1OqgbFKxbFIxWR25B6hxHtXzmYpysxfPWOdw33tjUVRW+wf
	+F+REp27yj7IfMrECE2/Ewdtc47mnUjvTHt0+LhI7nPBxCQRgRnqJyz/H+g02TBfelO0Hvd6
	kw+Pxazkv17X7nbOnbPj9Q7111FM/n36XCa8Ujlyb999aenVmmz8q+DA0pXffFcs11ZiKc5I
	NNRiLipOBACvTqTAMQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace TMU_SUPPORT_FALLING_TRIP flag check in
exynos[4210,5440]_tmu_control() by an explicit check
for a SoC type (all SoC types except Exynos4210 have
TMU_SUPPORT_FALLING_TRIP flag set in their struct
exynos_tmu_init_data instances).

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |  6 ++----
 drivers/thermal/samsung/exynos_tmu.h      |  7 ++-----
 drivers/thermal/samsung/exynos_tmu_data.c | 20 ++++++++------------
 3 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 30fd87a..121bc5d 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -388,7 +388,7 @@ static void exynos4210_tmu_control(struct platform_device *pdev, bool on)
 			pdata->trigger_enable[2] << EXYNOS_TMU_INTEN_RISE2_SHIFT |
 			pdata->trigger_enable[1] << EXYNOS_TMU_INTEN_RISE1_SHIFT |
 			pdata->trigger_enable[0] << EXYNOS_TMU_INTEN_RISE0_SHIFT;
-		if (TMU_SUPPORTS(pdata, FALLING_TRIP))
+		if (data->soc != SOC_ARCH_EXYNOS4210)
 			interrupt_en |=
 				interrupt_en << EXYNOS_TMU_INTEN_FALL0_SHIFT;
 	} else {
@@ -414,9 +414,7 @@ static void exynos5440_tmu_control(struct platform_device *pdev, bool on)
 			pdata->trigger_enable[2] << EXYNOS5440_TMU_INTEN_RISE2_SHIFT |
 			pdata->trigger_enable[1] << EXYNOS5440_TMU_INTEN_RISE1_SHIFT |
 			pdata->trigger_enable[0] << EXYNOS5440_TMU_INTEN_RISE0_SHIFT;
-		if (TMU_SUPPORTS(pdata, FALLING_TRIP))
-			interrupt_en |=
-				interrupt_en << EXYNOS5440_TMU_INTEN_FALL0_SHIFT;
+		interrupt_en |= interrupt_en << EXYNOS5440_TMU_INTEN_FALL0_SHIFT;
 	} else {
 		con &= ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
 		interrupt_en = 0; /* Disable all interrupts */
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index c4c0aa5..ed83d3d 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -51,8 +51,6 @@ enum soc_type {
  *			temperature to the TMU controller.
  * TMU_SUPPORT_MULTI_INST - This features denotes that the soc
  *			has many instances of TMU.
- * TMU_SUPPORT_FALLING_TRIP - This features shows that interrupt can
- *			be registered for falling trips also.
  * TMU_SUPPORT_EMUL_TIME - This features allows to set next temp emulation
  *			sample time.
  * TMU_SUPPORT_ADDRESS_MULTIPLE - This feature tells that the different TMU
@@ -61,9 +59,8 @@ enum soc_type {
  */
 #define TMU_SUPPORT_EMULATION			BIT(0)
 #define TMU_SUPPORT_MULTI_INST			BIT(1)
-#define TMU_SUPPORT_FALLING_TRIP		BIT(2)
-#define TMU_SUPPORT_EMUL_TIME			BIT(3)
-#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(4)
+#define TMU_SUPPORT_EMUL_TIME			BIT(2)
+#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(3)
 
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index d35ec15..39b9651 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -101,8 +101,7 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_EMUL_TIME)
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS3250)
@@ -154,8 +153,7 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_EMUL_TIME)
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS4412)
@@ -223,8 +221,7 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 #define EXYNOS5260_TMU_DATA \
 	__EXYNOS5260_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5260, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_EMUL_TIME)
 
 struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 	.tmu_data = {
@@ -278,14 +275,13 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 #define EXYNOS5420_TMU_DATA \
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5420, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_EMUL_TIME)
 
 #define EXYNOS5420_TMU_DATA_SHARED \
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5420_TRIMINFO, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_ADDRESS_MULTIPLE)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_EMUL_TIME | \
+			TMU_SUPPORT_ADDRESS_MULTIPLE)
 
 struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.tmu_data = {
@@ -319,8 +315,8 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.second_point_trim = 70, \
 	.default_temp_offset = 25, \
 	.type = SOC_ARCH_EXYNOS5440, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_ADDRESS_MULTIPLE),
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_MULTI_INST | \
+			TMU_SUPPORT_ADDRESS_MULTIPLE),
 
 struct exynos_tmu_init_data const exynos5440_default_tmu_data = {
 	.tmu_data = {
-- 
1.8.2.3


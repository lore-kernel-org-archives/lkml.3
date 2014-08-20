Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaHTME2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:04:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15355 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaHTMEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:04:24 -0400
X-AuditID: cbfee61b-f79f86d00000144c-db-53f48ec5ee83
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH] thermal: samsung: Exynos5260 and Exynos5420 should not use
 TRIM_RELOAD flag
Date: Wed, 20 Aug 2014 14:04:18 +0200
Message-id: <6263189.obPAjoFMg7@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAd2jfV+CDS4/MLNouBpicff5YUaL
	61+es1rMv3KN1eJs0xt2i8u75rBZfO49wmgx4/w+JosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKeL/rPHvBb+GKF68vsjYw9gt2MXJySAiYSJyaNoUNwhaT
	uHBvPZDNxSEksIhRYuWE4+wQTguTxIR3l1hBqtgErCQmtq9iBEmICGxhlLi19jBYO7PAOkaJ
	O388QGxhgTiJPQ9XsIPYLAKqEl++nAer4RXQlHj+6DUjiC0q4CmxY/tKqLigxI/J91gg5shL
	7Ns/lRXC1pJYv/M40wRGvllIymYhKZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxN
	jOAAfia9g3FVg8UhRgEORiUeXof2z8FCrIllxZW5hxglOJiVRHjbO78EC/GmJFZWpRblxxeV
	5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamBUr3p2/qmdt7m9XiyDdIkMs/LS
	hG2ZijKXRX65iNwp9l9w5z7zpd1XX92+Xyv6/JTlXZ8bixafmn2fZ16vRuiVo8ZWX+WXC5bL
	GTrk/p7PpxsnWGulMLM48v3VDjmR27nvj94sWLrS5N/sV4c/ejQXxG/9dIXrSva10ip2Du4z
	KlcXyywyTLipxFKckWioxVxUnAgAccceUVwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently these SoCs claim TRIM_RELOAD support but don't have
triminfo_ctrl register address defined in their struct
exynos_tmu_registers entries.  This causes incorrect write of
value "1" to data->base + 0x00 address (which happens to be
TRIMINFO register).  Fix it by removing TMU_SUPPORT_TRIM_RELOAD
flag for Exynos5260 and Exynos5420

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu_data.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index aa8e0de..8c0ada2 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -359,9 +359,8 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 #define EXYNOS5260_TMU_DATA \
 	__EXYNOS5260_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5260, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
-			TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
+			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME)
 
 struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 	.tmu_data = {
@@ -451,16 +450,15 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 #define EXYNOS5420_TMU_DATA \
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5250, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
-			TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
+			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME)
 
 #define EXYNOS5420_TMU_DATA_SHARED \
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5420_TRIMINFO, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
-			TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_ADDRESS_MULTIPLE)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
+			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME | \
+			TMU_SUPPORT_ADDRESS_MULTIPLE)
 
 struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.tmu_data = {
-- 
1.8.2.3



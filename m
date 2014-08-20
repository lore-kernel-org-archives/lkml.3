Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaHTN5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:57:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61837 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaHTN52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:57:28 -0400
X-AuditID: cbfee61b-f79f86d00000144c-9f-53f4a9451678
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] thermal: samsung: Exynos5260 and Exynos5420 should not use
 TRIM_RELOAD flag
Date: Wed, 20 Aug 2014 15:57:20 +0200
Message-id: <1633286.4v5Jz9xi2j@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t9jAV3XlV+CDd79VLRouBpicff5YUaL
	61+es1rMv3KN1eJs0xt2i8u75rBZfO49wmgx4/w+JosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKOL5zMlPBLdGK/uYXTA2Mp4W6GDk4JARMJD7PY+ti5AQy
	xSQu3FsPZHNxCAksYpT4tugCK4TTwiQx899mZpAqNgEriYntqxhBbBEBLYkTl7YzgRQxC+xi
	kph2ZwULSEJYIFHiXdd1sAYWAVWJbVs+g63gFdCUOL18K1hcVMBTYsf2lVBxQYkfk++B9TIL
	yEvs2z+VFcLWkli/8zjTBEa+WUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT8
	3E2M4PB9Jr2DcVWDxSFGAQ5GJR7eG4u+BAuxJpYVV+YeYpTgYFYS4W3vBArxpiRWVqUW5ccX
	leakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgnB69SN/9yga/5T69PTJyeVeY
	d5+eZmu3ZtM2xfU8IccvM33L91i1SdOu5ZSi+NkvNyv3JS9LcvL0KAtdeSFpus2EZ563tPKv
	R57s7tZ4pDJn7dF1s78FSdSte2/86/qynSkbuvtOntsfofMwhHnPUa68ySoKtR9ExDPC+6a2
	vstbInzSQLDrqBJLcUaioRZzUXEiALlCQQ9bAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently these SoCs claim TRIM_RELOAD support but don't have
triminfo_ctrl register address defined in their struct
exynos_tmu_registers entries.  This causes incorrect write of
value "1" to data->base + 0x00 address (which happens to be
TRIMINFO register).  Additionally according to the documentation
that I have neither Exynos5260 nor Exynos5420 support/require
TRIM_RELOAD feature.  Thus fix the aforementioned issue by
removing TMU_SUPPORT_TRIM_RELOAD flag for both Exynos5260 and
Exynos5420.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2:
- enhanced patch description per Eduardo's request

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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaIKNBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:01:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23540 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaIKNBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:01:01 -0400
X-AuditID: cbfee61a-f79e46d00000134f-46-54119d0b47c9
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] thermal: exynos: use correct offset for TMU_CONTROL register
 on Exynos5260
Date: Thu, 11 Sep 2014 15:00:49 +0200
Message-id: <1594947.1Ri7fFnV5h@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t9jQV3uuYIhBo1fRSwaroZY3H1+mNFi
	/pVrrBZnm96wW7x5uJnR4vKuOWwWn3uPMFrMOL+PyeLJwz42B06PnbPusnss3vOSyaNvyypG
	j8+b5AJYorhsUlJzMstSi/TtErgy3vy+w1JwTbBi2861rA2MR/i7GDk5JARMJCZc+MUMYYtJ
	XLi3nq2LkYtDSGA6o8SsX0+YIZwWJonNpzeCVbEJWElMbF/FCGKLCGhJnLi0nQmkiFlgD5PE
	7G1XWUASwgKxEl37OplAbBYBVYlHTX/Zuxg5OHgFNCWWPuUBCYsKeErs2L6SDcTmFRCU+DH5
	Hlgrs4C8xL79U1khbC2J9TuPM01g5JuFpGwWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7N
	S9dLzs/dxAgO32dSOxhXNlgcYhTgYFTi4a1gEQwRYk0sK67MPcQowcGsJMJ7YzpQiDclsbIq
	tSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA6PFdLmNNjuuH4tV3vB1
	vVFPavLvhp+Hp8S3Blyt3piXOs3N72tpxvQP5g/3NTSEqMWIsn4Q4/4565jjUdFWxwamvznN
	FtvCjuVuCVwwt2eRykx9By/m1hfBZ69WH/HYO++eoq0Dj5LOrfdJJV/lhW8t87873WbxR48J
	rAseSL/0N49kULuRJafEUpyRaKjFXFScCABYfZIjWwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In exynos5260_tmu_registers tmu_ctrl entry is erroneously
assigned twice.  The second assignment (to EXYNOS_TMU_REG_CONTROL1
define which represents 0x24 value) overrides the first one
(to EXYNOS_TMU_REG_CONTROL define which represents 0x20 value)
which results in the wrong (according to the Exynos5260 SoC
documentation that I have) offset being used for TMU_CONTROL
register.  Fix it by removing the wrong assignment and then
remove no longer used EXYNOS_TMU_REG_CONTROL1 define.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu_data.c |    1 -
 drivers/thermal/samsung/exynos_tmu_data.h |    1 -
 2 files changed, 2 deletions(-)

Index: b/drivers/thermal/samsung/exynos_tmu_data.c
===================================================================
--- a/drivers/thermal/samsung/exynos_tmu_data.c	2014-09-11 14:41:12.567347442 +0200
+++ b/drivers/thermal/samsung/exynos_tmu_data.c	2014-09-11 14:43:00.211350284 +0200
@@ -273,7 +273,6 @@ struct exynos_tmu_init_data const exynos
 static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL1,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
Index: b/drivers/thermal/samsung/exynos_tmu_data.h
===================================================================
--- a/drivers/thermal/samsung/exynos_tmu_data.h	2014-09-11 14:41:12.243347433 +0200
+++ b/drivers/thermal/samsung/exynos_tmu_data.h	2014-09-11 14:43:36.167351233 +0200
@@ -83,7 +83,6 @@
 #define EXYNOS_MAX_TRIGGER_PER_REG	4
 
 /* Exynos5260 specific */
-#define EXYNOS_TMU_REG_CONTROL1			0x24
 #define EXYNOS5260_TMU_REG_INTEN		0xC0
 #define EXYNOS5260_TMU_REG_INTSTAT		0xC4
 #define EXYNOS5260_TMU_REG_INTCLEAR		0xC8


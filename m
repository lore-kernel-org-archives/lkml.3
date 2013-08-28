Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3H1JQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:16:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29198 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3H1JQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:16:46 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-b2-521dbffb1042
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH 1/3 v2] thermal: samsung: correct the fall interrupt en,
 status bit fields
Date: Wed, 28 Aug 2013 14:46:47 +0530
Message-id: <1377681409-18166-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkTvfPftkgg20X2CwaroZYzD9yjtVi
	zf6fTBa9C66yWVzeNYfN4nPvEUaLGef3MVks2vaf2eLJwz42B06PnbPusnss3vOSyaNvyypG
	j+M3tjN5fN4kF8AaxWWTkpqTWZZapG+XwJUxv+MUU8Fe2YqN21UbGBdJdjFyckgImEj07djC
	CGGLSVy4t54NxBYSWMoosXVlDEzNrpYHrF2MXEDx6YwS+z5vZoFwepgkntzcwApSxSZgJnFw
	0Wp2EFtEwEti1sOrTCBFzALrGSUObV/L3MXIwSEsECOxq08OpIZFQFXi/sL/YNt4BVwlNly7
	xQJSIiGgIDFnkg1ImFPATeLFsn1MEAe5Srz4NZMdZKSEwDp2icndmxgh5ghIfJt8CKpXVmLT
	AWaIoyUlDq64wTKBUXgBI8MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMCgP/3v2YQdjPcO
	WB9iTAYaN5FZSjQ5Hxg1eSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUX
	leakFh9iZOLglGpgjPlV+6tGJODIE+3shmwJMW+nzu6pctxqTVU3Qzfs1dtxKVXqomGd99p7
	ZilStz741QlOuG2VPqVu36qN305c3bnO5tzFn9sPPxGwLF76q0WV6eofBbaVsc0KX3d/WJHr
	s11UfvqWEOaUj2+e3XIxiZimZC1s9v+P0PSqvWLx3Ll3m/juPFb2UWIpzkg01GIuKk4EAPNz
	cc2QAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd3f+2WDDC78tLRouBpiMf/IOVaL
	Nft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PY7f2M7k8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjPkdp5gK
	9spWbNyu2sC4SLKLkZNDQsBEYlfLA1YIW0ziwr31bF2MXBxCAtMZJfZ93swC4fQwSTy5uQGs
	ik3ATOLgotXsILaIgJfErIdXmUCKmAXWM0oc2r6WuYuRg0NYIEZiV58cSA2LgKrE/YX/2UBs
	XgFXiQ3XbrGAlEgIKEjMmWQDEuYUcJN4sWwfE4gtBFTy4tdM9gmMvAsYGVYxiqYWJBcUJ6Xn
	GukVJ+YWl+al6yXn525iBEfVM+kdjKsaLA4xCnAwKvHwWmyWCRJiTSwrrsw9xCjBwawkwsu/
	XTZIiDclsbIqtSg/vqg0J7X4EGMy0FETmaVEk/OBEZ9XEm9obGJuamxqaWJhYmZJmrCSOO/B
	VutAIYH0xJLU7NTUgtQimC1MHJxSDYzlhaYaOu2VKg/19hVO2nDPwSn///48puQZjELHgy/a
	b53Xc/JdvA9rzVKHPF232c5TG0zm2t/j/PWpLPN8ScWVAyXf22fu3rLdvG9CspNDZdjf7Y/n
	BjWv7Nkm4F0Vf5VvT40Wt42v4+Nu5cpyab8znslHpDtf88/1cUzp0dz4MP0xa/99PiWW4oxE
	Qy3mouJEAPKgL7PuAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FALL interrupt related en, status bits are available at an offset of
16 on INTEN, INTSTAT registers and at an offset of
12 on INTCLEAR register.

This patch corrects the same for exyns5250 and exynos5440

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---

Changes since v1:
  None

 drivers/thermal/samsung/exynos_tmu.c      |    2 +-
 drivers/thermal/samsung/exynos_tmu.h      |    2 ++
 drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
 drivers/thermal/samsung/exynos_tmu_data.h |    3 ++-
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index ec01dfe..d201ed8 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -265,7 +265,7 @@ skip_calib_data:
 				data->base + reg->threshold_th1);
 
 		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
-			(reg->inten_fall_mask << reg->inten_fall_shift),
+			(reg->inten_fall_mask << reg->intclr_fall_shift),
 				data->base + reg->tmu_intclear);
 
 		/* if last threshold limit is also present */
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index b364c9e..7c6c34a 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -134,6 +134,7 @@ enum soc_type {
  * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
+ * @intclr_fall_shift: shift bits for interrupt clear fall 0
  * @emul_con: TMU emulation controller register.
  * @emul_temp_shift: shift bits of emulation temperature.
  * @emul_time_shift: shift bits of emulation time.
@@ -204,6 +205,7 @@ struct exynos_tmu_registers {
 	u32	tmu_intstat;
 
 	u32	tmu_intclear;
+	u32	intclr_fall_shift;
 
 	u32	emul_con;
 	u32	emul_temp_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 9002499..23fea23 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -122,6 +122,7 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
 	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
 	.emul_con = EXYNOS_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
@@ -210,6 +211,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
 	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
+	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
 	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
 	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index dc7feb5..8788a87 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -69,9 +69,10 @@
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
 #define EXYNOS_TMU_RISE_INT_SHIFT	0
 #define EXYNOS_TMU_FALL_INT_MASK	0x111
-#define EXYNOS_TMU_FALL_INT_SHIFT	12
+#define EXYNOS_TMU_FALL_INT_SHIFT	16
 #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
 #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
+#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
 #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
-- 
1.7.9.5


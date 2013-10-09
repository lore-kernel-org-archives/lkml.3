Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3JIMGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:06:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20454 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3JIMGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:06:13 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-24-525546b46571
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 1/3 v4] thermal: samsung: correct the fall interrupt en,
 status bit fields
Date: Wed, 09 Oct 2013 17:38:27 +0530
Message-id: <1381320509-23967-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSrbvFLTTIoG07u0XD1RCLjTPWs1rM
	P3KO1WLN/p9MFr0LrrJZXN41h83ic+8RRosZ5/cxWSza9p/Z4snDPjYHLo+ds+6yeyze85LJ
	o2/LKkaP4ze2M3l83iQXwBrFZZOSmpNZllqkb5fAldH2+R1zwSPZirW9z9gaGA9KdjFyckgI
	mEis/7iYFcIWk7hwbz1bFyMXh5DAUkaJry0LWWGK/n1sZYZITGeU+Dj5EyuE08MksevFDiaQ
	KjYBM4mDi1azg9giAjISU6/sBytiFvjJKNE5p5ENJCEsECMxe/9HZhCbRUBV4uOBRUDNHBy8
	Aq4Se+7yQ2xTlOh+NgGsnBMoPPVWL1i5kICLxPL3r8HOkxDYxC6x4fc0Vog5AhLfJh9iAZkj
	ISArsekAM8QcSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMApO/3s2
	cQfj/QPWhxiTgcZNZJYSTc4HRlFeSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLpiSWp2amp
	BalF8UWlOanFhxiZODilGhh1DU7Grv+y6YrdnMW7Or4/l5UO1ZNjsAo4LDj5xPKoYu9Y7RVf
	f3XND7jC5pM6p+LelLcvbUwFrj6wrnyfY6clG52ZdtZjI8NURrukj7lcRy8GfzHO+uNy0I9z
	pcdku4XOsxaG7YtKX5P0Mu3z0dqXm1uU9JszZ7do/rPPf8JfdzPvpHrUiSIlluKMREMt5qLi
	RADri/LDmAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jQd3NbqFBBm0vrSwaroZYbJyxntVi
	/pFzrBZr9v9ksuhdcJXN4vKuOWwWn3uPMFrMOL+PyWLRtv/MFk8e9rE5cHnsnHWX3WPxnpdM
	Hn1bVjF6HL+xncnj8ya5ANaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ
	bZ/fMRc8kq1Y2/uMrYHxoGQXIyeHhICJxL+PrcwQtpjEhXvr2boYuTiEBKYzSnyc/IkVwulh
	ktj1YgcTSBWbgJnEwUWr2UFsEQEZialX9oMVMQv8ZJTonNPIBpIQFoiRmL3/I9hYFgFViY8H
	FgE1c3DwCrhK7LnLD7FNUaL72QSwck6g8NRbvWDlQgIuEsvfv2abwMi7gJFhFaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZwjD2T3sG4qsHiEKMAB6MSD+8D/pAgIdbEsuLK3EOMEhzMSiK8
	vhahQUK8KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD4z/vJJ4Q2MTc1NjU0sTCxMzS9KElcR5
	D7ZaBwoJpCeWpGanphakFsFsYeLglGpg1BdNKI2aL2MbwjZrq80rw7mvosIb45uma0TxPz9g
	8cDSgLc38P/J8ksSew9uvC/203WKTAHrDqPPK1L3Wu5Lffnt/13O5KjQNy97b6ZJuqXbnTQo
	4BetkMiO8Lt7Z7W5ldvB8te8MobfwhenRPL/5348m+fBrZ8qecEL+JytUnYfszywaVq1Ektx
	RqKhFnNRcSIAIRImGfUCAAA=
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
Changes since v2:
Changes since v3:
  None

 drivers/thermal/samsung/exynos_tmu.c      |    2 +-
 drivers/thermal/samsung/exynos_tmu.h      |    2 ++
 drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
 drivers/thermal/samsung/exynos_tmu_data.h |    3 ++-
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index b43afda..af69209 100644
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
1.7.10.4


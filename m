Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab3LJGkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:40:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46349 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3LJGkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:40:31 -0500
X-AuditID: cbfee68e-b7fee6d000003b32-ac-52a6b75c8868
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH v11 1/4] thermal: samsung: replace inten_ bit fields with
 intclr_
Date: Tue, 10 Dec 2013 12:11:28 +0530
Message-id: <1386657688-21542-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1384238168-24561-1-git-send-email-ch.naveen@samsung.com>
References: <1384238168-24561-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSqxuzfVmQwY4HhhYNV0MsNs5Yz2rx
	8pCmxfwj51gt1uz/yWTRu+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjs1g/4zWLA4/H
	zll32T0W73nJ5NG3ZRWjx/Eb25k8Pm+SC2CN4rJJSc3JLEst0rdL4Mr4cusKa8ETl4o3Oy8y
	NTB2WXcxcnJICJhI3Niwjh3CFpO4cG89WxcjF4eQwFJGibnH57HBFL2+t4oJIrGIUeLt6TtQ
	VT1MEgvXLQVrZxMwkzi4aDWYLSIgIzH1yn5WkCJmgflMEof+rAVLCAsES/w6fZgZxGYRUJW4
	cuYbC4jNK+AqsWXxF6g7FCW6n00AW80p4CZxZuZOJhBbCKhm49WDYGdICOxjl7g5YzIrxCAB
	iW+TDwEN4gBKyEpsOsAMMUdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/d
	xAiMjNP/nvXtYLx5wPoQYzLQuInMUqLJ+cDIyiuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAh
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjGZVt+z75E+Lm7ur1ReyPrWKdeMUq1y/gn+rtllt
	d3u/l7XeiWumkUybJby+6Zod6mP/w/fKfdf9Y/3LDvwOemZp/l1B5sQP+RWskiXTk31cup3O
	Nc5JemW1nCe4WbfxG4tGYQzfw4jrGYUl00SnLV+Zdn76vaOXdB/FPHjLab2m99Bac4ciJZbi
	jERDLeai4kQApJDchKICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jAd2Y7cuCDPYeVbNouBpisXHGelaL
	l4c0LeYfOcdqsWb/TyaL3gVX2Swu75rDZvG59wijxYzz+5gsFm37z2zx5GEfm8X6Ga9ZHHg8
	ds66y+6xeM9LJo++LasYPY7f2M7k8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjC+3rrAWPHGpeLPzIlMDY5d1FyMnh4SAicTre6uYIGwxiQv31rN1MXJxCAks
	YpR4e/oOlNPDJLFw3VJ2kCo2ATOJg4tWg9kiAjISU6/sZwUpYhaYzyRx6M9asISwQLDEr9OH
	mUFsFgFViStnvrGA2LwCrhJbFn9hh1inKNH9bAIbiM0p4CZxZuZOsDOEgGo2Xj3INIGRdwEj
	wypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Lh7JrWDcWWDxSFGAQ5GJR7eAoZlQUKsiWXF
	lbmHGCU4mJVEeD3rgEK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD0wJeSXxhsYm5qbGppYm
	FiZmlqQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAKLh/rm5cnUXZA8GYBBeRT4r2sarZ
	zY/Xz3P9/Sl24d/gvDSmAgsll2b/L89PLJtntnfiZLlAtXKVTA/P33sfv7ypGWMV+j/33EfP
	zIOuDLafdUVXTW35fXOx8twEryjp0HezNcwVetYlrgk7ZzVT71PykgO73i2a9s+orV79ewp/
	onTD0zvNSizFGYmGWsxFxYkA0G8LN/8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the inten_rise_shift/mask and inten_fall_shift/mask
with intclr_rise_shift/mask and intclr_fall_shift/mask respectively.
Currently, inten_rise_shift/mask and inten_fall_shift/mask bits are only used
to configure intclr related registers.

Description of H/W:
The offset for the bits in the CLEAR register are not consistent across TMU
modules in Exynso5250, 5420 and 5440.

On Exynos5250, the FALL interrupt related en, status and clear bits are
available at an offset of
16 in INTEN, INTSTAT registers and at an offset of
12 in INTCLEAR register.

On Exynos5420, the FALL interrupt related en, status and clear bits are
available at an offset of
16 in INTEN, INTSTAT and INTCLEAR registers.

On Exynos5440,
the FALL_IRQEN bits are at an offset of 4
and the RISE_IRQEN bits are at an offset of 0

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Changes since v10:
None

 drivers/thermal/samsung/exynos_tmu.c      |    6 +++---
 drivers/thermal/samsung/exynos_tmu.h      |   16 ++++++++--------
 drivers/thermal/samsung/exynos_tmu_data.c |   18 +++++++++---------
 drivers/thermal/samsung/exynos_tmu_data.h |    4 ++--
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 32f38b9..c493245 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -237,7 +237,7 @@ skip_calib_data:
 			writeb(pdata->trigger_levels[i], data->base +
 			reg->threshold_th0 + i * sizeof(reg->threshold_th0));
 
-		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
+		writel(reg->intclr_rise_mask, data->base + reg->tmu_intclear);
 	} else {
 		/* Write temperature code for rising and falling threshold */
 		for (i = 0;
@@ -264,8 +264,8 @@ skip_calib_data:
 		writel(falling_threshold,
 				data->base + reg->threshold_th1);
 
-		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
-			(reg->inten_fall_mask << reg->inten_fall_shift),
+		writel((reg->intclr_rise_mask << reg->intclr_rise_shift) |
+			(reg->intclr_fall_mask << reg->intclr_fall_shift),
 				data->base + reg->tmu_intclear);
 
 		/* if last threshold limit is also present */
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 3fb6554..980859a 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -122,10 +122,6 @@ enum soc_type {
  * @threshold_th3_l0_shift: shift bits of level0 threshold temperature.
  * @tmu_inten: register containing the different threshold interrupt
 	enable bits.
- * @inten_rise_shift: shift bits of all rising interrupt bits.
- * @inten_rise_mask: mask bits of all rising interrupt bits.
- * @inten_fall_shift: shift bits of all rising interrupt bits.
- * @inten_fall_mask: mask bits of all rising interrupt bits.
  * @inten_rise0_shift: shift bits of rising 0 interrupt bits.
  * @inten_rise1_shift: shift bits of rising 1 interrupt bits.
  * @inten_rise2_shift: shift bits of rising 2 interrupt bits.
@@ -136,6 +132,10 @@ enum soc_type {
  * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
+ * @intclr_fall_shift: shift bits for interrupt clear fall 0
+ * @intclr_rise_shift: shift bits of all rising interrupt bits.
+ * @intclr_rise_mask: mask bits of all rising interrupt bits.
+ * @intclr_fall_mask: mask bits of all rising interrupt bits.
  * @emul_con: TMU emulation controller register.
  * @emul_temp_shift: shift bits of emulation temperature.
  * @emul_time_shift: shift bits of emulation time.
@@ -191,10 +191,6 @@ struct exynos_tmu_registers {
 	u32	threshold_th3_l0_shift;
 
 	u32	tmu_inten;
-	u32	inten_rise_shift;
-	u32	inten_rise_mask;
-	u32	inten_fall_shift;
-	u32	inten_fall_mask;
 	u32	inten_rise0_shift;
 	u32	inten_rise1_shift;
 	u32	inten_rise2_shift;
@@ -207,6 +203,10 @@ struct exynos_tmu_registers {
 	u32	tmu_intstat;
 
 	u32	tmu_intclear;
+	u32	intclr_fall_shift;
+	u32	intclr_rise_shift;
+	u32	intclr_fall_mask;
+	u32	intclr_rise_mask;
 
 	u32	emul_con;
 	u32	emul_temp_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 073c292..7cdb04e 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -40,13 +40,13 @@ static const struct exynos_tmu_registers exynos4210_tmu_registers = {
 	.threshold_temp = EXYNOS4210_TMU_REG_THRESHOLD_TEMP,
 	.threshold_th0 = EXYNOS4210_TMU_REG_TRIG_LEVEL0,
 	.tmu_inten = EXYNOS_TMU_REG_INTEN,
-	.inten_rise_mask = EXYNOS4210_TMU_TRIG_LEVEL_MASK,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
 	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
 	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_rise_mask = EXYNOS4210_TMU_TRIG_LEVEL_MASK,
 };
 
 struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
@@ -112,10 +112,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
 	.tmu_inten = EXYNOS_TMU_REG_INTEN,
-	.inten_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
-	.inten_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
-	.inten_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
-	.inten_fall_shift = EXYNOS_TMU_FALL_INT_SHIFT,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
 	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
@@ -123,6 +119,10 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
+	.intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
+	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
+	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
@@ -217,10 +217,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.threshold_th2 = EXYNOS5440_TMU_S0_7_TH2,
 	.threshold_th3_l0_shift = EXYNOS5440_TMU_TH_RISE4_SHIFT,
 	.tmu_inten = EXYNOS5440_TMU_S0_7_IRQEN,
-	.inten_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
-	.inten_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
-	.inten_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
-	.inten_fall_shift = EXYNOS5440_TMU_FALL_INT_SHIFT,
 	.inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
 	.inten_rise2_shift = EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
@@ -228,6 +224,10 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
 	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
+	.intclr_fall_shift = EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT,
+	.intclr_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
+	.intclr_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
+	.intclr_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
 	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
 	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index a1ea19d..d9495a4 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -69,9 +69,10 @@
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
 #define EXYNOS_TMU_RISE_INT_SHIFT	0
 #define EXYNOS_TMU_FALL_INT_MASK	0x111
-#define EXYNOS_TMU_FALL_INT_SHIFT	12
 #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
 #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
+#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
+#define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT	4
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
 #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
@@ -119,7 +120,6 @@
 #define EXYNOS5440_TMU_RISE_INT_MASK		0xf
 #define EXYNOS5440_TMU_RISE_INT_SHIFT		0
 #define EXYNOS5440_TMU_FALL_INT_MASK		0xf
-#define EXYNOS5440_TMU_FALL_INT_SHIFT		4
 #define EXYNOS5440_TMU_INTEN_RISE0_SHIFT	0
 #define EXYNOS5440_TMU_INTEN_RISE1_SHIFT	1
 #define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2
-- 
1.7.10.4


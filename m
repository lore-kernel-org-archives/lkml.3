Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab3KSNDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:03:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:56989 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab3KSNC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:02:56 -0500
X-AuditID: cbfee68f-b7f836d000001b39-4e-528b617ebfe0
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH 1/4 v10] thermal: samsung: replace inten_ bit fields with
 intclr_
Date: Tue, 19 Nov 2013 18:34:19 +0530
Message-id: <1384866259-15983-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1384238168-24561-1-git-send-email-ch.naveen@samsung.com>
References: <1384238168-24561-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSrVuX2B1k0H9D16LhaojFxhnrWS1e
	HtK0mH/kHKvFmv0/mSx6F1xls7i8aw6bxefeI4wWM87vY7JYtO0/s8WTh31sFutnvGZx4PHY
	Oesuu8fiPS+ZPPq2rGL0OH5jO5PH501yAaxRXDYpqTmZZalF+nYJXBld508yF3xxrVi97SVz
	A2ObTRcjJ4eEgInEmQVPGSFsMYkL99azdTFycQgJLGWUuLfrFDtM0axF95hBbCGB6YwS537p
	QhT1MEl8OL6EDSTBJmAmcXDRarAGEQEZialX9rOCFDELzGeSOPRnLVCCg0NYIFhi/9FSkBoW
	AVWJ/oNXmEBsXgFXiTd3pjBDLFOU6H42AWwmp4CbxJmZO5kgFrtKbLx6kAlkpoTAIXaJ2wvn
	s0AMEpD4NvkQC8h8CQFZiU0HoOZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6
	yfm5mxiBUXH637P+HYx3D1gfYkwGGjeRWUo0OR8YVXkl8YbGZkYWpiamxkbmlmakCSuJ895/
	mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbFo3ebDYZdnOeenPzl/71y08ds9349Mjt9V
	fvMc65sbFrLHavKO//qptmzX7s3mWhN5RBSi6k9pcNtfTLimxMU3sepUS1PAk1b1+y0Pixgn
	xcadf/v4h4jbkR1aD//sbOlOD01jKQnrvN5w98G9P/E3LhrMOiL7KshH0/HDsjcnV3xaJSlQ
	vq1DiaU4I9FQi7moOBEA+Is6EqACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jQd26xO4gg4UHlSwaroZYbJyxntXi
	5SFNi/lHzrFarNn/k8mid8FVNovLu+awWXzuPcJoMeP8PiaLRdv+M1s8edjHZrF+xmsWBx6P
	nbPusnss3vOSyaNvyypGj+M3tjN5fN4kF8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9q
	ZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0npJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35Ag
	uB4jAzSQsIYxo+v8SeaCL64Vq7e9ZG5gbLPpYuTkkBAwkZi16B4zhC0mceHeejYQW0hgOqPE
	uV+6XYxcQHYPk8SH40vAEmwCZhIHF61mB7FFBGQkpl7ZzwpSxCwwn0ni0J+1QAkODmGBYIn9
	R0tBalgEVCX6D15hArF5BVwl3tyZArVMUaL72QSwmZwCbhJnZu5kgljsKrHx6kGmCYy8CxgZ
	VjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx9wz6R2MqxosDjEKcDAq8fBOcO8KEmJNLCuu
	zD3EKMHBrCTCaxzUHSTEm5JYWZValB9fVJqTWnyIMRnoqonMUqLJ+cB0kFcSb2hsYm5qbGpp
	YmFiZkmasJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjMwqYWozmB671pj/ubw/6Wpeuq6L
	2r6u9WrHFu/JMNN/q/Pj4uL8vz9+GBz7Kdr56qV4WIb5xPg3bmvzFr6RLN5zoHSi6uJPbMra
	Fix/jNe5l39XPP3zmtCPg7u252yqnf/+i8HzQ6ueHrDbE6vS5mfMqXPnSgDTlyPCUi9FuX7F
	GTFcmDLRPFuJpTgj0VCLuag4EQD4TzEE/QIAAA==
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
Changes since v9:
Just respinning

Changes since v8:
1. Modified the patch description,
2. replaces the inten_rise/fall_shift/mask with intclr_rise/fall_shift/mask

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


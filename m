Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3KGFvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:51:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:45284 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3KGFvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:06 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-9f-527b2a483c61
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: [PATCH 1/3 v8] thermal: samsung: add intclr_fall_shift bit in
 exynos_tmu_register struct
Date: Thu, 07 Nov 2013 11:22:42 +0530
Message-id: <1383803562-31752-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1381979473-7079-1-git-send-email-ch.naveen@samsung.com>
References: <1381979473-7079-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2JSq+uhVR1ksHWpikXD1RCLjTPWs1q8
	PKRpMf/IOVaLNft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYHLg9ds66y+6x
	eM9LJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfG+/2rWAvOG1f8v3eYuYGxS6eL
	kZNDQsBE4vH/J+wQtpjEhXvr2boYuTiEBJYySsyccoYdpuhn00JGiMR0Ron9cz6wQjg9TBJX
	D7WCVbEJmEkcXLQazBYRkJGYemU/WBGzQDeTxPwV51hAEsICyRJT2jrZQGwWAVWJjomXmEBs
	XgFXiXd3HzNDrFOU6H42AayGEyj+7XUfUC8H0DYXie03mUFmSghsY5e4cukgC8QcAYlvkw+B
	1UgIyEpsOgA1RlLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECIyG0/+e
	9e1gvHnA+hBjMtC4icxSosn5wGjKK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2MaduFbL1OSCjstJgeNI1TQaHSWD7sQELly0SPT9vf//ijd+D3
	1YMXvExC922envYk7MQNu7cdTmL5RnyugvrBR3b82jrjnsPz8vZbnOv23Jne2vTroUz6o0Oz
	J3UfKg040xW8N+O9clqg4HrbJ7N76lS9JRyfL92T47N5//+C9Lp59VfMYyc4K7EUZyQaajEX
	FScCACtG/TicAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQV0Preogg68TJS0aroZYbJyxntXi
	5SFNi/lHzrFarNn/k8mid8FVNovLu+awWXzuPcJoMeP8PiaLRdv+M1s8edjH5sDtsXPWXXaP
	xXteMnn0bVnF6HH8xnYmj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOALlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAG
	EtYwZrzfv4q14Lxxxf97h5kbGLt0uhg5OSQETCR+Ni1khLDFJC7cW8/WxcjFISQwnVFi/5wP
	rBBOD5PE1UOt7CBVbAJmEgcXrQazRQRkJKZe2Q9WxCzQzSQxf8U5FpCEsECyxJS2TjYQm0VA
	VaJj4iUmEJtXwFXi3d3HzBDrFCW6n00Aq+EEin973QfUywG0zUVi+03mCYy8CxgZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEx9oz6R2MqxosDjEKcDAq8fDOqKkKEmJNLCuuzD3EKMHB
	rCTCe+8ZUIg3JbGyKrUoP76oNCe1+BBjMtBRE5mlRJPzgWkgryTe0NjE3NTY1NLEwsTMkjRh
	JXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYZV/XXP/vU/X9K3PUPpYZ7yUnW/TLa5r9KmzS
	XvVC82Njy3/Nnblsci8CJziXhy/f+WmqvE1Cz+U9Os8fTONIthXa/UVogoLEu1MXLwiGT9jy
	qKV+qemxE929JRePbT6eKDhXelb1k6VMh9UvNPh88b35rvb+xqvN2t22u1IXbimpeS22r892
	gxJLcUaioRZzUXEiAEv+ZHr5AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This patch introduces a new bit field intclr_fall_shift to handle the
offset for exyns5250 and exynos5440
Also removes the unused macros EXYNOS_TMU_FALL_INT_SHIFT and
EXYNOS5440_TMU_FALL_INT_SHIFT, inten_fall_shift field

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
Changes since v2:
Changes since v3:
  None
Changes since v4:
 Correct the CLEAR_FALL_INT_SHIFT for Exynos5250/Exynos5440
Changes since v5:
 Modify the commit message
Changes since v6:
 - Use EXYNOS_TMU_CLEAR_FALL_INT_SHIFT instead of EXYNOS5250_TMU_CLEAR_FALL_INT_SHIFT
 as the same is being used for Exynos4412
Changes since v7:
 - also removes the unused macros EXYNOS_TMU_FALL_INT_SHIFT and
 EXYNOS5440_TMU_FALL_INT_SHIFT, inten_fall_shift field

 
 drivers/thermal/samsung/exynos_tmu.c      |    2 +-
 drivers/thermal/samsung/exynos_tmu.h      |    4 ++--
 drivers/thermal/samsung/exynos_tmu_data.c |    4 ++--
 drivers/thermal/samsung/exynos_tmu_data.h |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 32f38b9..b2202fa 100644
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
index 3fb6554..39fca47 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -124,7 +124,6 @@ enum soc_type {
 	enable bits.
  * @inten_rise_shift: shift bits of all rising interrupt bits.
  * @inten_rise_mask: mask bits of all rising interrupt bits.
- * @inten_fall_shift: shift bits of all rising interrupt bits.
  * @inten_fall_mask: mask bits of all rising interrupt bits.
  * @inten_rise0_shift: shift bits of rising 0 interrupt bits.
  * @inten_rise1_shift: shift bits of rising 1 interrupt bits.
@@ -136,6 +135,7 @@ enum soc_type {
  * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
+ * @intclr_fall_shift: shift bits for interrupt clear fall 0
  * @emul_con: TMU emulation controller register.
  * @emul_temp_shift: shift bits of emulation temperature.
  * @emul_time_shift: shift bits of emulation time.
@@ -193,7 +193,6 @@ struct exynos_tmu_registers {
 	u32	tmu_inten;
 	u32	inten_rise_shift;
 	u32	inten_rise_mask;
-	u32	inten_fall_shift;
 	u32	inten_fall_mask;
 	u32	inten_rise0_shift;
 	u32	inten_rise1_shift;
@@ -207,6 +206,7 @@ struct exynos_tmu_registers {
 	u32	tmu_intstat;
 
 	u32	tmu_intclear;
+	u32	intclr_fall_shift;
 
 	u32	emul_con;
 	u32	emul_temp_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 073c292..70ad559 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -115,7 +115,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.inten_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
 	.inten_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
 	.inten_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
-	.inten_fall_shift = EXYNOS_TMU_FALL_INT_SHIFT,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
 	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
@@ -123,6 +122,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
 	.emul_con = EXYNOS_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
@@ -220,7 +220,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.inten_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
 	.inten_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
 	.inten_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
-	.inten_fall_shift = EXYNOS5440_TMU_FALL_INT_SHIFT,
 	.inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
 	.inten_rise2_shift = EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
@@ -228,6 +227,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
 	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
+	.intclr_fall_shift = EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT,
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


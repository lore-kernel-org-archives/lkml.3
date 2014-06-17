Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbaFQR25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:28:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29236 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbaFQR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:28:54 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-84-53a07ad28780
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 1/9] thermal: exynos: remove unused struct
 exynos_tmu_registers entries
Date: Tue, 17 Jun 2014 19:27:17 +0200
Message-id: <1403026045-16024-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQd3LVQuCDb6tYrFouBpisXHGelaL
	Nft/MlmcbXrDbnF51xw2i8+9RxgtZpzfx2Rx5vQlVosnD/vYLNbPeM3iwOWxeM9LJo8tV9tZ
	PPq2rGL0OH5jO5PH501yAaxRXDYpqTmZZalF+nYJXBmrT09iLGgPrji78jx7A+Myty5GTg4J
	AROJlb+/sUPYYhIX7q1n62Lk4hASmM4oMfvAInYIp4tJYtn2/WBVbAJWEhPbVzGC2CICehI3
	XjxhAiliFjjOJPHz93k2kISwQIzEwb7NLCA2i4CqxO4pa8DivAIeEp9XNDNBrFOU6H42ASzO
	KeApceNeC5gtBFQz/2In0wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgoPumdQO
	xpUNFocYBTgYlXh4OXIXBAuxJpYVV+YeYpTgYFYS4T2XBRTiTUmsrEotyo8vKs1JLT7EKM3B
	oiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXAuM5r4VK1tQeuJ2yZ0cu6fgpLxPQL0es0wl8J
	u8zKOLgz5plDjY5xrfmE4MxFc+e/6lIVnSv5c97BY/Wvpr/Qlr5UdP3hLuXzu+e19UpJpDBx
	Wjz90r/+6YO30X+2ap4xfrR53u2+pHaulLdNeUuil/N3T+yUeW399fPK8tPcSTbRTRZuSTVv
	riqxFGckGmoxFxUnAgALhFMgNgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused / write-only entries from struct exynos_tmu_registers.
Then remove unused defines while at it.

We don't keep the unused/untested features in the kernel just
in case that some future hardware might need it.  Such code has
a real maintainance cost (all other code changes have to take
the dead code into account) and usually makes future changes
more difficult, not easier (i.e. recent additions of Exynos5420
SoC and Exynos5260 SoC thermal support has not made use of any
of the driver's currently unused/untested features, moreover
the recently added code is more complex than needed because of
the existing dead code).  Also all removed dead code is still
accessible in the kernel git repository and can be easily
brought back if/when needed.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.h      | 40 -------------------------------
 drivers/thermal/samsung/exynos_tmu_data.c |  4 ----
 drivers/thermal/samsung/exynos_tmu_data.h | 29 +---------------------
 3 files changed, 1 insertion(+), 72 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index edd08cf..59799ef 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -84,8 +84,6 @@ enum soc_type {
  * @triminfo_25_shift: shift bit of the 25 C trim value in triminfo_data reg.
  * @triminfo_85_shift: shift bit of the 85 C trim value in triminfo_data reg.
  * @triminfo_ctrl: trim info controller register.
- * @triminfo_reload_shift: shift of triminfo reload enable bit in triminfo_ctrl
-	reg.
  * @tmu_ctrl: TMU main controller register.
  * @test_mux_addr_shift: shift bits of test mux address.
  * @buf_vref_sel_shift: shift bits of reference voltage in tmu_ctrl register.
@@ -100,27 +98,13 @@ enum soc_type {
 	register.
  * @calib_mode_mask: mask bits of calibration mode value in tmu_ctrl
 	register.
- * @therm_trip_tq_en_shift: shift bits of thermal trip enable by TQ pin in
-	tmu_ctrl register.
  * @core_en_shift: shift bits of TMU core enable bit in tmu_ctrl register.
  * @tmu_status: register drescribing the TMU status.
  * @tmu_cur_temp: register containing the current temperature of the TMU.
- * @tmu_cur_temp_shift: shift bits of current temp value in tmu_cur_temp
-	register.
  * @threshold_temp: register containing the base threshold level.
  * @threshold_th0: Register containing first set of rising levels.
- * @threshold_th0_l0_shift: shift bits of level0 threshold temperature.
- * @threshold_th0_l1_shift: shift bits of level1 threshold temperature.
- * @threshold_th0_l2_shift: shift bits of level2 threshold temperature.
- * @threshold_th0_l3_shift: shift bits of level3 threshold temperature.
  * @threshold_th1: Register containing second set of rising levels.
- * @threshold_th1_l0_shift: shift bits of level0 threshold temperature.
- * @threshold_th1_l1_shift: shift bits of level1 threshold temperature.
- * @threshold_th1_l2_shift: shift bits of level2 threshold temperature.
- * @threshold_th1_l3_shift: shift bits of level3 threshold temperature.
  * @threshold_th2: Register containing third set of rising levels.
- * @threshold_th2_l0_shift: shift bits of level0 threshold temperature.
- * @threshold_th3: Register containing fourth set of rising levels.
  * @threshold_th3_l0_shift: shift bits of level0 threshold temperature.
  * @tmu_inten: register containing the different threshold interrupt
 	enable bits.
@@ -129,9 +113,6 @@ enum soc_type {
  * @inten_rise2_shift: shift bits of rising 2 interrupt bits.
  * @inten_rise3_shift: shift bits of rising 3 interrupt bits.
  * @inten_fall0_shift: shift bits of falling 0 interrupt bits.
- * @inten_fall1_shift: shift bits of falling 1 interrupt bits.
- * @inten_fall2_shift: shift bits of falling 2 interrupt bits.
- * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
  * @intclr_fall_shift: shift bits for interrupt clear fall 0
@@ -141,7 +122,6 @@ enum soc_type {
  * @emul_con: TMU emulation controller register.
  * @emul_temp_shift: shift bits of emulation temperature.
  * @emul_time_shift: shift bits of emulation time.
- * @emul_time_mask: mask bits of emulation time.
  * @tmu_irqstatus: register to find which TMU generated interrupts.
  * @tmu_pmin: register to get/set the Pmin value.
  */
@@ -152,7 +132,6 @@ struct exynos_tmu_registers {
 
 	u32	triminfo_ctrl;
 	u32	triminfo_ctrl1;
-	u32	triminfo_reload_shift;
 
 	u32	tmu_ctrl;
 	u32     test_mux_addr_shift;
@@ -165,32 +144,17 @@ struct exynos_tmu_registers {
 	u32	buf_slope_sel_mask;
 	u32	calib_mode_shift;
 	u32	calib_mode_mask;
-	u32	therm_trip_tq_en_shift;
 	u32	core_en_shift;
 
 	u32	tmu_status;
 
 	u32	tmu_cur_temp;
-	u32	tmu_cur_temp_shift;
 
 	u32	threshold_temp;
 
 	u32	threshold_th0;
-	u32	threshold_th0_l0_shift;
-	u32	threshold_th0_l1_shift;
-	u32	threshold_th0_l2_shift;
-	u32	threshold_th0_l3_shift;
-
 	u32	threshold_th1;
-	u32	threshold_th1_l0_shift;
-	u32	threshold_th1_l1_shift;
-	u32	threshold_th1_l2_shift;
-	u32	threshold_th1_l3_shift;
-
 	u32	threshold_th2;
-	u32	threshold_th2_l0_shift;
-
-	u32	threshold_th3;
 	u32	threshold_th3_l0_shift;
 
 	u32	tmu_inten;
@@ -199,9 +163,6 @@ struct exynos_tmu_registers {
 	u32	inten_rise2_shift;
 	u32	inten_rise3_shift;
 	u32	inten_fall0_shift;
-	u32	inten_fall1_shift;
-	u32	inten_fall2_shift;
-	u32	inten_fall3_shift;
 
 	u32	tmu_intstat;
 
@@ -214,7 +175,6 @@ struct exynos_tmu_registers {
 	u32	emul_con;
 	u32	emul_temp_shift;
 	u32	emul_time_shift;
-	u32	emul_time_mask;
 
 	u32	tmu_irqstatus;
 	u32	tmu_pmin;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index c1d81dc..41e8168 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -96,7 +96,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
-	.triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
@@ -126,7 +125,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.emul_con = EXYNOS_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
-	.emul_time_mask = EXYNOS_EMUL_TIME_MASK,
 };
 
 #define EXYNOS4412_TMU_DATA \
@@ -228,7 +226,6 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.emul_con = EXYNOS5260_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
-	.emul_time_mask = EXYNOS_EMUL_TIME_MASK,
 };
 
 #define __EXYNOS5260_TMU_DATA	\
@@ -320,7 +317,6 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.emul_con = EXYNOS_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
-	.emul_time_mask = EXYNOS_EMUL_TIME_MASK,
 };
 
 #define __EXYNOS5420_TMU_DATA	\
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index d268981..8018815 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -42,20 +42,8 @@
 /* Exynos4210 specific registers */
 #define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
 #define EXYNOS4210_TMU_REG_TRIG_LEVEL0	0x50
-#define EXYNOS4210_TMU_REG_TRIG_LEVEL1	0x54
-#define EXYNOS4210_TMU_REG_TRIG_LEVEL2	0x58
-#define EXYNOS4210_TMU_REG_TRIG_LEVEL3	0x5C
-#define EXYNOS4210_TMU_REG_PAST_TEMP0	0x60
-#define EXYNOS4210_TMU_REG_PAST_TEMP1	0x64
-#define EXYNOS4210_TMU_REG_PAST_TEMP2	0x68
-#define EXYNOS4210_TMU_REG_PAST_TEMP3	0x6C
-
-#define EXYNOS4210_TMU_TRIG_LEVEL0_MASK	0x1
-#define EXYNOS4210_TMU_TRIG_LEVEL1_MASK	0x10
-#define EXYNOS4210_TMU_TRIG_LEVEL2_MASK	0x100
-#define EXYNOS4210_TMU_TRIG_LEVEL3_MASK	0x1000
+
 #define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
-#define EXYNOS4210_TMU_INTCLEAR_VAL	0x1111
 
 /* Exynos5250 and Exynos4412 specific registers */
 #define EXYNOS_TMU_TRIMINFO_CON	0x14
@@ -63,14 +51,11 @@
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
 
-#define EXYNOS_TRIMINFO_RELOAD_SHIFT	1
 #define EXYNOS_TRIMINFO_25_SHIFT	0
 #define EXYNOS_TRIMINFO_85_SHIFT	8
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
 #define EXYNOS_TMU_RISE_INT_SHIFT	0
 #define EXYNOS_TMU_FALL_INT_MASK	0x111
-#define EXYNOS_TMU_CLEAR_RISE_INT	0x111
-#define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
 #define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
 #define EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT	16
 #define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT	4
@@ -85,9 +70,6 @@
 #define EXYNOS_TMU_INTEN_RISE2_SHIFT	8
 #define EXYNOS_TMU_INTEN_RISE3_SHIFT	12
 #define EXYNOS_TMU_INTEN_FALL0_SHIFT	16
-#define EXYNOS_TMU_INTEN_FALL1_SHIFT	20
-#define EXYNOS_TMU_INTEN_FALL2_SHIFT	24
-#define EXYNOS_TMU_INTEN_FALL3_SHIFT	28
 
 #define EXYNOS_EMUL_TIME	0x57F0
 #define EXYNOS_EMUL_TIME_MASK	0xffff
@@ -122,13 +104,11 @@
 #define EXYNOS5440_TMU_S0_7_TH0			0x110
 #define EXYNOS5440_TMU_S0_7_TH1			0x130
 #define EXYNOS5440_TMU_S0_7_TH2			0x150
-#define EXYNOS5440_TMU_S0_7_EVTEN		0x1F0
 #define EXYNOS5440_TMU_S0_7_IRQEN		0x210
 #define EXYNOS5440_TMU_S0_7_IRQ			0x230
 /* exynos5440 common registers */
 #define EXYNOS5440_TMU_IRQ_STATUS		0x000
 #define EXYNOS5440_TMU_PMIN			0x004
-#define EXYNOS5440_TMU_TEMP			0x008
 
 #define EXYNOS5440_TMU_RISE_INT_MASK		0xf
 #define EXYNOS5440_TMU_RISE_INT_SHIFT		0
@@ -138,13 +118,6 @@
 #define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2
 #define EXYNOS5440_TMU_INTEN_RISE3_SHIFT	3
 #define EXYNOS5440_TMU_INTEN_FALL0_SHIFT	4
-#define EXYNOS5440_TMU_INTEN_FALL1_SHIFT	5
-#define EXYNOS5440_TMU_INTEN_FALL2_SHIFT	6
-#define EXYNOS5440_TMU_INTEN_FALL3_SHIFT	7
-#define EXYNOS5440_TMU_TH_RISE0_SHIFT		0
-#define EXYNOS5440_TMU_TH_RISE1_SHIFT		8
-#define EXYNOS5440_TMU_TH_RISE2_SHIFT		16
-#define EXYNOS5440_TMU_TH_RISE3_SHIFT		24
 #define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
 #define EXYNOS5440_EFUSE_SWAP_OFFSET		8
 
-- 
1.8.2.3


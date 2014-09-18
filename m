Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaIRP3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:29:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29181 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbaIRP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:28:55 -0400
X-AuditID: cbfee61a-f79e46d00000134f-55-541afa35bb67
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 09/33] thermal: exynos: remove needless emul_time_shift
 abstraction
Date: Thu, 18 Sep 2014 17:27:26 +0200
Message-id: <1411054070-25757-10-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAV3TX1IhBsd2GVs0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSuj7/kx9oJl8hUrpvazNzBekepi5OSQEDCRmHm6
	gwXCFpO4cG89WxcjF4eQwCJGiXVP+1ghnC4miW2rFzGCVLEJWElMbF8FZosIaEmcuLSdCaSI
	WeAWk8TrG5PBEsICoRK/bq9kBrFZBFQlvj+fxApi8wp4Snza28IKsU5RovvZBDYQmxMo3nBr
	EzuILSTgIdG25S7zBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCQ+2Z1A7GlQ0W
	hxgFOBiVeHgP8EqFCLEmlhVX5h5ilOBgVhLh/fMRKMSbklhZlVqUH19UmpNafIhRmoNFSZz3
	QKt1oJBAemJJanZqakFqEUyWiYNTqoFx7/cJR8MKcoLrZ1cv6Pl62NO5v9jhdFqH/abbLwQe
	b6xbvPfJUZNffmwXS6y5Tmvt5H3PN/fzN6bZS+TmFfxfbZ6rvSS1NWTLZx4n9f5Jlk8EFivd
	yL3gPvnGjYmGN6sesHrnLjcz+cP6eV6BxMn9yfv95LYJ5f16y6uzhnOC6v3I0v5L/MmlSizF
	GYmGWsxFxYkA6JTo6DECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->emul_time_shift is used only in exynos_tmu_set_emulation()
and accessed only if TMU_SUPPORT_EMUL_TIME flag is set.  This
flag is not set for Exynos4210 and Exynos5440 (reg->emul_time_shift
field is not even assigned in exynos[4210,5440]_tmu_registers
and is assigned to identical value for all other SoC types) so
the abstraction is not needed and can be removed.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 4 ++--
 drivers/thermal/samsung/exynos_tmu.h      | 2 --
 drivers/thermal/samsung/exynos_tmu_data.c | 4 ----
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 974c337..a4ed576 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -365,8 +365,8 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 		temp /= MCELSIUS;
 
 		if (TMU_SUPPORTS(pdata, EMUL_TIME)) {
-			val &= ~(EXYNOS_EMUL_TIME_MASK << reg->emul_time_shift);
-			val |= (EXYNOS_EMUL_TIME << reg->emul_time_shift);
+			val &= ~(EXYNOS_EMUL_TIME_MASK << EXYNOS_EMUL_TIME_SHIFT);
+			val |= (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT);
 		}
 		val &= ~(EXYNOS_EMUL_DATA_MASK << EXYNOS_EMUL_DATA_SHIFT);
 		val |= (temp_to_code(data, temp) << EXYNOS_EMUL_DATA_SHIFT) |
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 649a654..6567293 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -96,7 +96,6 @@ enum soc_type {
  * @intclr_rise_mask: mask bits of all rising interrupt bits.
  * @intclr_fall_mask: mask bits of all rising interrupt bits.
  * @emul_con: TMU emulation controller register.
- * @emul_time_shift: shift bits of emulation time.
  * @tmu_irqstatus: register to find which TMU generated interrupts.
  * @tmu_pmin: register to get/set the Pmin value.
  */
@@ -126,7 +125,6 @@ struct exynos_tmu_registers {
 	u32	intclr_rise_mask;
 
 	u32	emul_con;
-	u32	emul_time_shift;
 
 	u32	tmu_irqstatus;
 	u32	tmu_pmin;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 3ae0376..b9a3778 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -99,7 +99,6 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
 	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS_EMUL_CON,
-	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
 };
 
 #define EXYNOS3250_TMU_DATA \
@@ -175,7 +174,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
 	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS_EMUL_CON,
-	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
 };
 
 #define EXYNOS4412_TMU_DATA \
@@ -263,7 +261,6 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.intclr_rise_mask = EXYNOS5260_TMU_RISE_INT_MASK,
 	.intclr_fall_mask = EXYNOS5260_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS5260_EMUL_CON,
-	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
 };
 
 #define __EXYNOS5260_TMU_DATA	\
@@ -341,7 +338,6 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
 	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS_EMUL_CON,
-	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
 };
 
 #define __EXYNOS5420_TMU_DATA	\
-- 
1.8.2.3


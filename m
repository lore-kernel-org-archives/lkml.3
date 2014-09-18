Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaIRP2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:28:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20317 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaIRP2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:28:36 -0400
X-AuditID: cbfee61a-f79e46d00000134f-24-541afa21f84c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 05/33] thermal: exynos: remove needless test_mux_addr_shift
 abstraction
Date: Thu, 18 Sep 2014 17:27:22 +0200
Message-id: <1411054070-25757-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAV2lX1IhBm/mM1o0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj84WvzAVXZSrOzljP1sD4VKKLkZNDQsBEYueD
	aSwQtpjEhXvr2boYuTiEBBYxSuw/84wZwuliklh7bR4rSBWbgJXExPZVjCC2iICWxIlL25lA
	ipgFbjFJvL4xGSwhLBAp8XbqPLCxLAKqEmdb5jOB2LwCHhKdvQuYINYpSnQ/m8AGYnMKeEo0
	3NrEDmILAdW0bbnLPIGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4FB7JrWDcWWD
	xSFGAQ5GJR7eA7xSIUKsiWXFlbmHGCU4mJVEeP98BArxpiRWVqUW5ccXleakFh9ilOZgURLn
	PdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgXCBxR/voNgONKb7fLsqxnpww7dndY98e7mr8Gngl
	bt1MFY+oJaKtdX8/Tp8V+H/98rfP+pklu/7r6/kVq3NpB/kf2/9l1oww/vmc+/LcC69OcFL+
	l3j+6NqG+P9LbxkUnAg/4PqUc7711j9B+5pdq34ovwl7pv+Re22W3cynygmdm5KO+nZzOSmx
	FGckGmoxFxUnAgCI7DBMMQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->test_mux_addr_shift is used only if pdata->test_mux is
non-zero.  pdata->test_mux is defined only on Exynos3250 and
Exynos4412 (other SoC types don't even have pdata->test_mux
entry assigned in their struct exynos_tmu_registers instances)
so the abstraction is not needed and can be removed.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 2 +-
 drivers/thermal/samsung/exynos_tmu.h      | 2 --
 drivers/thermal/samsung/exynos_tmu_data.c | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 52bcc23..1527b25 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -280,7 +280,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	con = readl(data->base + reg->tmu_ctrl);
 
 	if (pdata->test_mux)
-		con |= (pdata->test_mux << reg->test_mux_addr_shift);
+		con |= (pdata->test_mux << EXYNOS4412_MUX_ADDR_SHIFT);
 
 	con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK << EXYNOS_TMU_REF_VOLTAGE_SHIFT);
 	con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index d12e242..5bcf7a8 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -77,7 +77,6 @@ enum soc_type {
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
  * @tmu_ctrl: TMU main controller register.
- * @test_mux_addr_shift: shift bits of test mux address.
  * @therm_trip_mode_shift: shift bits of tripping mode in tmu_ctrl register.
  * @therm_trip_mode_mask: mask bits of tripping mode in tmu_ctrl register.
  * @therm_trip_en_shift: shift bits of tripping enable in tmu_ctrl register.
@@ -107,7 +106,6 @@ enum soc_type {
  */
 struct exynos_tmu_registers {
 	u32	tmu_ctrl;
-	u32     test_mux_addr_shift;
 	u32	therm_trip_mode_shift;
 	u32	therm_trip_mode_mask;
 	u32	therm_trip_en_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 04f1d71..988e327 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -84,7 +84,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS3250)
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
@@ -164,7 +163,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-- 
1.8.2.3


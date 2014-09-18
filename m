Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbaIRPai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:30:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29453 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbaIRPac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:30:32 -0400
X-AuditID: cbfee61b-f79f86d00000144c-25-541afa960d51
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 30/33] thermal: exynos: remove test_mux pdata field
Date: Thu, 18 Sep 2014 17:27:47 +0200
Message-id: <1411054070-25757-31-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAd1pv6RCDPa/UrVouBpisXHGelaL
	u88PM1rMv3KN1eJs0xt2izcPNzNaXN41h83ic+8RRosZ5/cxWTx52MfmwOWxc9Zddo/Fe14y
	efRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfGwbM72Ao+S1R87f7I1MDYJtrFyMkhIWAi8XDP
	IUYIW0ziwr31bF2MXBxCAosYJabNO8UC4XQxSaw8e4sFpIpNwEpiYvsqsA4RAS2JE5e2M4EU
	MQvcYpJ4fWMyWEJYwFmiZ+9fMJtFQFVi0YzVYM28Ap4Sv7b0MkOsU5TofjaBDcTmBIo33NrE
	DmILCXhItG25yzyBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBQeya9g3FVg8Uh
	RgEORiUe3gO8UiFCrIllxZW5hxglOJiVRHj/fAQK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Y
	ah0oJJCeWJKanZpakFoEk2Xi4JRqYNSZaDr/sZbsP/NLR169MLC64jp5WqDIL4n5e5N0VY/u
	sJjaYLz1WlxalaLl935HU7/Tmze9dn1gy83xdJmIyv2rX1abyzLzTr34RGqVXuJT+eBPeupH
	9HSaEvLCzq+6VZtyLFRsmazDg1BO9VK2DZt7axwCgpkuy3Bfvh36JZJn+VX53w6XVJVYijMS
	DbWYi4oTAYV/Ce8xAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace pdata->test_mux check in get_con_reg() by explicitly
checking for SoC type.

Also since the used pdata->test_mux value is always identical
use it directly and remove pdata->test_mux completely.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 5 +++--
 drivers/thermal/samsung/exynos_tmu.h      | 2 --
 drivers/thermal/samsung/exynos_tmu_data.c | 2 --
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 367f4eb..80961e3 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -193,8 +193,9 @@ static u32 get_con_reg(struct exynos_tmu_data *data, u32 con)
 {
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 
-	if (pdata->test_mux)
-		con |= (pdata->test_mux << EXYNOS4412_MUX_ADDR_SHIFT);
+	if (data->soc == SOC_ARCH_EXYNOS4412 ||
+	    data->soc == SOC_ARCH_EXYNOS3250)
+		con |= (EXYNOS4412_MUX_ADDR_VALUE << EXYNOS4412_MUX_ADDR_SHIFT);
 
 	con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK << EXYNOS_TMU_REF_VOLTAGE_SHIFT);
 	con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 2eb4cb9..8de0f82 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -89,7 +89,6 @@ enum soc_type {
  * @first_point_trim: temp value of the first point trimming
  * @second_point_trim: temp value of the second point trimming
  * @default_temp_offset: default temperature offset in case of no trimming
- * @test_mux; information if SoC supports test MUX
  * @cal_type: calibration type for temperature
  * @freq_clip_table: Table representing frequency reduction percentage.
  * @freq_tab_count: Count of the above table as frequency reduction may
@@ -115,7 +114,6 @@ struct exynos_tmu_platform_data {
 	u8 first_point_trim;
 	u8 second_point_trim;
 	u8 default_temp_offset;
-	u8 test_mux;
 
 	enum calibration_type cal_type;
 	enum soc_type type;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index d90b050..708c3e1 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -109,7 +109,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 		{
 			EXYNOS3250_TMU_DATA,
 			.type = SOC_ARCH_EXYNOS3250,
-			.test_mux = EXYNOS4412_MUX_ADDR_VALUE,
 		},
 	},
 	.tmu_count = 1,
@@ -160,7 +159,6 @@ struct exynos_tmu_init_data const exynos4412_default_tmu_data = {
 		{
 			EXYNOS4412_TMU_DATA,
 			.type = SOC_ARCH_EXYNOS4412,
-			.test_mux = EXYNOS4412_MUX_ADDR_VALUE,
 		},
 	},
 	.tmu_count = 1,
-- 
1.8.2.3


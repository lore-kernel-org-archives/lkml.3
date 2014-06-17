Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043AbaFQRbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:31:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25874 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964772AbaFQRbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:31:09 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-3d-53a07b5c671d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 8/9] thermal: exynos: remove redundant pdata checks from
 exynos_tmu_control()
Date: Tue, 17 Jun 2014 19:27:24 +0200
Message-id: <1403026045-16024-9-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQd2Y6gXBBjNmc1o0XA2x2DhjPavF
	mv0/mSzONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PJYvOclk8eWq+0s
	Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsEroxznx+yFmwSqrg8bTljA+MZ/i5GTg4J
	AROJddtfMkHYYhIX7q1n62Lk4hASmM4osXbfAkYIp4tJ4t7hp6wgVWwCVhIT21cxgtgiAnoS
	N148YQIpYhY4ziTx8/d5NpCEsECSxNE7bWANLAKqElN+PGEBsXkFPCT2z7rGCLFOUaL72QSw
	ek4BT4kb91rAbCGgmvkXO5kmMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcdM+k
	djCubLA4xCjAwajEw8uRuyBYiDWxrLgy9xCjBAezkgjvuSygEG9KYmVValF+fFFpTmrxIUZp
	DhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsYe1sbILX575l+o/Ra8InxWpCnzK0H3b3z5
	vFOYlxTtf6p+KOBMdkbq1O1rmep7H2+rXWizx8nRZO2Uza//tyr/Kept+tSaGZ+waO+qVe6W
	bvqmT4x43eoYjzucWj1x16lz9d+FxGTXRwrkmvIK8v7y9PDLmbzh6e0P7YUL/JYplD6a8n/u
	PGklluKMREMt5qLiRACCnpBJNgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdata->reference_voltage and pdata->gain are always defined
to non-zero values so remove the redundant checks from
exynos_tmu_control().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 12 ++++--------
 drivers/thermal/samsung/exynos_tmu.h |  4 ++--
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 9455b23..b22f358 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -229,15 +229,11 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	if (pdata->test_mux)
 		con |= (pdata->test_mux << reg->test_mux_addr_shift);
 
-	if (pdata->reference_voltage) {
-		con &= ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
-		con |= pdata->reference_voltage << reg->buf_vref_sel_shift;
-	}
+	con &= ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
+	con |= pdata->reference_voltage << reg->buf_vref_sel_shift;
 
-	if (pdata->gain) {
-		con &= ~(reg->buf_slope_sel_mask << reg->buf_slope_sel_shift);
-		con |= (pdata->gain << reg->buf_slope_sel_shift);
-	}
+	con &= ~(reg->buf_slope_sel_mask << reg->buf_slope_sel_shift);
+	con |= (pdata->gain << reg->buf_slope_sel_shift);
 
 	if (pdata->noise_cancel_mode) {
 		con &= ~(reg->therm_trip_mode_mask <<
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index b1c9f8d..5d36708 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -188,10 +188,10 @@ struct exynos_tmu_registers {
  * @max_trigger_level: max trigger level supported by the TMU
  * @non_hw_trigger_levels: number of defined non-hardware trigger levels
  * @gain: gain of amplifier in the positive-TC generator block
- *	0 <= gain <= 15
+ *	0 < gain <= 15
  * @reference_voltage: reference voltage of amplifier
  *	in the positive-TC generator block
- *	0 <= reference_voltage <= 31
+ *	0 < reference_voltage <= 31
  * @noise_cancel_mode: noise cancellation mode
  *	000, 100, 101, 110 and 111 can be different modes
  * @type: determines the type of SOC
-- 
1.8.2.3


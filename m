Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaGaRL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:11:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33171 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbaGaRLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:11:54 -0400
X-AuditID: cbfee61b-f79f86d00000144c-35-53da78d84e79
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v3 7/8] thermal: exynos: remove redundant pdata checks from
 exynos_tmu_control()
Date: Thu, 31 Jul 2014 19:11:05 +0200
Message-id: <1406826667-2289-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
References: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jAd0bFbeCDR6/NLdouBpisXHGelaL
	Nft/MlmcbXrDbnF51xw2i8+9RxgtZpzfx2Rx5vQlVosnD/vYLNbPeM3iwOWxeM9LJo8tV9tZ
	PPq2rGL0OH5jO5PH501yAaxRXDYpqTmZZalF+nYJXBkzD9xlL9gkVHH8k2oD4xn+LkZODgkB
	E4mFxy8xQdhiEhfurWfrYuTiEBJYxCjx9O4XZgini0niQ/MbRpAqNgEriYntq8BsEQE9iRsv
	njCBFDELHGeS+Pn7PBtIQlggSeL/ypcsIDaLgKrEzRPTgGwODl4Bd4ndP0MhtilKdD+bAFbO
	KeAhcaB9BpgtBFTyd9NJ1gmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAfcM+kd
	jKsaLA4xCnAwKvHwOoTeChZiTSwrrsw9xCjBwawkwutSDhTiTUmsrEotyo8vKs1JLT7EKM3B
	oiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAaGiR5/VwncZlSWPzrt2ban84nfmpb/XkYoTn
	48WKcR8bv0hdlS/pKPwXemueMhvbJHYRmbrdne8YPcVb31l2WSy8wCpQ/vBVmVHL5T7pxONs
	qVI3NWYs33pWd42ddu+LX4/s9f2v739SOWNlhOWpRaeMPzrIOQvkce/esVD3zcErJ7m4thSZ
	KLEUZyQaajEXFScCAPwUy4k0AgAA
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
index 6bc8a20..122ae66 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -274,15 +274,11 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
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
index 5514d68..327c64f 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -201,10 +201,10 @@ struct exynos_tmu_registers {
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


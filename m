Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaEELUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:20:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47536 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbaEELUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:20:20 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-96-536773f34908
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 09/10] thermal: exynos: remove redundant pdata checks from
 exynos_tmu_control()
Date: Mon, 05 May 2014 13:15:38 +0200
Message-id: <1399288539-1793-10-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jAd3PxenBBp9eSFg0XA2x2DhjPavF
	mv0/mSzONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PJYvOclk8eWq+0s
	Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsEroyG+ZNYC+ZyV+w//pW5gfECZxcjB4eE
	gInErwspXYycQKaYxIV769m6GLk4hAQWMUo8ev6RFcLpYpJYs/YeM0gVm4CVxMT2VYwgtoiA
	nsSNF0+YQIqYBY4zSfz8fZ4NJCEskCjRsuI5WAOLgKrE5U/HwRp4BTwkriy6zQKxTlGi+9kE
	sHpOoPj+l4/B6oUE3CUOPp7MPIGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4JB7
	JrWDcWWDxSFGAQ5GJR7eBOb0YCHWxLLiytxDjBIczEoivNmJQCHelMTKqtSi/Pii0pzU4kOM
	0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2Mk46vN3gtlMfpvdlKQVnw9+o/Idc3RUe5
	ZR56EhensHRv6ffpB2YfbuTc7a775EC1xW6eV5/XTT9ceK1MUeaQr98Xt69d/DcO8lxjy1UP
	fLUi4M3TOyErl3KnnLqV9vDWqYPq1w4ZJSke/9+xKvfqXikBMZ34s2dPb3rA6idmHVF6T9Nw
	wYU2DyWW4oxEQy3mouJEAOQtcJY1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdata->reference_voltage and pdata->gain are always defined
to non-zero values so remove the redundant checks from
exynos_tmu_control().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index a8d9524..45d7c6f 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -215,15 +215,11 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
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
-- 
1.8.2.3


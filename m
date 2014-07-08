Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaGHNLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:11:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15944 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbaGHNLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:11:44 -0400
X-AuditID: cbfee61a-f79e46d00000134f-f8-53bbee0ea6e6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] thermal: exynos: fix ordering in exynos_tmu_remove()
Date: Tue, 08 Jul 2014 15:09:56 +0200
Message-id: <10113119.9fnj2984Hk@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jQV2+d7uDDX51y1s0XA2xWLP/J5PF
	2aY37BaXd81hs/jce4TRYsb5fUwWTx72sTmweyze85LJo2/LKkaP4ze2M3l83iQXwBLFZZOS
	mpNZllqkb5fAlfFgziaWggPsFc/O72VtYNzD1sXIySEhYCJxc/pSZghbTOLCvfVAcS4OIYHp
	jBIf+p8wQjgtTBKr3i9jBKliE7CSmNi+CswWEdCTuPHiCROIzSxwj1Gib7kBiC0s4Cpx//kE
	FhCbRUBV4v3GnawgNq+AlkTTialgcVEBT4kd21eyQcQFJX5MvscCMUdeYt/+qawQtpbE+p3H
	mSYw8s1CUjYLSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSH6jOpHYwrGywO
	MQpwMCrx8K44uCtYiDWxrLgy9xCjBAezkgjvl1O7g4V4UxIrq1KL8uOLSnNSiw8xSnOwKInz
	Hmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwdnw0mZUyc0bX7RxxI5vlt7s92H8oKC/ZusW2fab8
	WsHCd1OnpRVNzDgiX7CufPXDM97ptZn8au/WdTzZYJ/xNlIh8prPnUfzOJ+ebrp2ytVlHf+j
	YGXOy18q2it2r3wWPGNKm0mKf5oMY5vABRdxf4/61Z/YtXjupG2NWXT0wzGGYG2PecXdSizF
	GYmGWsxFxYkAsz4uzlECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might not be a problem currently but unregister/uninitialize things
in the reverse order that they are registered/initialized.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index d7ca9f4..6243ba0 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -759,10 +759,10 @@ static int exynos_tmu_remove(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 
-	exynos_tmu_control(pdev, false);
-
 	exynos_unregister_thermal(data->reg_conf);
 
+	exynos_tmu_control(pdev, false);
+
 	clk_unprepare(data->clk);
 	if (!IS_ERR(data->clk_sec))
 		clk_unprepare(data->clk_sec);
-- 
1.8.2.3



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbaHZBbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:31:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44204 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbaHZBbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:31:20 -0400
X-AuditID: cbfee68f-f797f6d000001173-26-53fbe36593a2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, ch.naveen@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv5 4/4] thermal: exynos: Remove duplicate code when reading
 triminfo register of Exynos5440
Date: Tue, 26 Aug 2014 10:31:05 +0900
Message-id: <1409016665-3824-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
References: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkQDf18e9gg8srRC0aroZYbJyxntXi
	7vPDjBbXvzxntViz/yeTxfwr11gtehdcZbM42/SG3WLTYyD38q45bBafe48wWsw4v4/J4snD
	PjYHXo+ds+6yeyze85LJY/OSeo++LasYPY7f2M7k8XmTXABbFJdNSmpOZllqkb5dAlfGhNUX
	WQoucVb8WrmJrYHxD3sXIyeHhICJxP/OTUwQtpjEhXvr2boYuTiEBJYyShy928cIU7SluR0q
	MZ1R4vT+SawQThOTRP+blawgVWwCWhL7X9xgA7FFBDwl5i5sYQIpYhbYwyTxrvspM0hCWCBH
	4uiMbywgNouAqsSH/1/BbF4BF4mGQxtYIdbJSXzY8wjsPk4BV4n/U86A9QoB1XTN+8UIMlRC
	4Bi7RO/DvawQgwQkvk0+BDSIAyghK7HpADPEHEmJgytusExgFF7AyLCKUTS1ILmgOCm9yFiv
	ODG3uDQvXS85P3cTIzBaTv971r+D8e4B60OMAhyMSjy8N+N/BwuxJpYVV+YeYjQF2jCRWUo0
	OR8Yk3kl8YbGZkYWpiamxkbmlmZK4rwLpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDM
	225wSel60T3+BYf2uLa78zzaIaxubql5WfaAqeeNcP5HR2bOdVtby71pxTIZ9VnFJe2+H75P
	nnSmpfxam6yJ0tyAe9WZ8x5OTtDb/PHgxu0y704aLfJ9slPawrr3V9AS62tcXr8a/76wfdz8
	xOya+ufd+lfEuD808U379DdKQztN5lPhfvErSizFGYmGWsxFxYkA84QT35ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQd3Ux7+DDTZM5LVouBpisXHGelaL
	u88PM1pc//Kc1WLN/p9MFvOvXGO16F1wlc3ibNMbdotNj4Hcy7vmsFl87j3CaDHj/D4miycP
	+9gceD12zrrL7rF4z0smj81L6j36tqxi9Dh+YzuTx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAhyoplCXmlAKFAhKLi5X07TBNCA1x
	07WAaYzQ9Q0JgusxMkADCWsYMyasvshScImz4tfKTWwNjH/Yuxg5OSQETCS2NLezQdhiEhfu
	rQeyuTiEBKYzSpzeP4kVwmlikuh/s5IVpIpNQEti/4sbYB0iAp4Scxe2MIEUMQvsYZJ41/2U
	GSQhLJAjcXTGNxYQm0VAVeLD/69gNq+Ai0TDoQ2sEOvkJD7seQR2BqeAq8T/KWfAeoWAarrm
	/WKcwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwLD6T2sG4ssHiEKMAB6MSD++N
	+N/BQqyJZcWVuYcYJTiYlUR4GR4ChXhTEiurUovy44tKc1KLDzGaAl01kVlKNDkfmCbySuIN
	jU3MjCyNzA0tjIzNlcR5D7RaBwoJpCeWpGanphakFsH0MXFwSjUwblwTnDsj+3LmQY2NMr/t
	9yldWnri22n9MyukCuPkitunMX83jvhQw/iZLfGQoDPftkjHDIfSQ4wmRdeqr0YG+Yr7FX4w
	zqnco7C6/gCTt7a4i9r0o/6Njnu7pC+9TTy6/v2Ce45HVvwN5V/lfyes9Hzc/tj99xOCH5/9
	mjB3ls8r1uX7Ay27lFiKMxINtZiLihMBDHYF1tsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove simply duplicate code when reading triminfo register of Exynos5440.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 64c702a..5888467 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -187,15 +187,13 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		 */
 		switch (data->id) {
 		case 0:
+		case 2:
 			trim_info = readl(data->base +
 			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
 			break;
 		case 1:
 			trim_info = readl(data->base + reg->triminfo_data);
 			break;
-		case 2:
-			trim_info = readl(data->base -
-			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
 		}
 	} else {
 		/* On exynos5420 the triminfo register is in the shared space */
-- 
1.8.0


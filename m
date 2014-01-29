Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaA2JTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:19:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:15578 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaA2JTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:19:48 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-d7-52e8c7a30c1a
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/9 v5] crypto:s5p-sss: Use platform_get_irq() instead of
 _byname()
Date: Wed, 29 Jan 2014 14:49:24 +0530
Message-id: <1390987164-18459-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkTnfx8RdBBld+yVjcfX6Y0eLlIU2L
	OedbWCy6X8lY3L/3k8ni8q45bBYzzu9jsli07T+zxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoErY/GrRvaCLyIVfxetZG9gnCPYxcjJISFgItH+6xkb
	hC0mceHeeiCbi0NIYCmjxOEZb9hgil6taWCBSExnlDi/opMdwulnkpj4tYEJpIpNwEzi4KLV
	7CC2iICzxO/mNawgRcwCtxklFh17ywKSEBYIlXi44xcriM0ioCpxvn0tmM0r4Crx9sp9oGYO
	oHUKEnMm2YCEOQXcJA583wM2Xwio5PueI2DnSQisY5f4N/UVC8QcAYlvkw+xQPTKSmw6wAxx
	taTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERj2p/89693BePuA9SHG
	ZKBxE5mlRJPzgXGTVxJvaGxmZGFqYmpsZG5pRpqwkjhv0sOkICGB9MSS1OzU1ILUovii0pzU
	4kOMTBycUg2MQitmntOfcemf8oM7AZuPuv1nEKwRYCwyz01eFsVf0MVkv+pFu+18kbZXb4p9
	+o41Gr+ctP1UaIpAq+Ny/itumeEb678FyXt83epuvLrJaP6jlAC/EGEhYc68Ly7X3jdnnrwi
	t04qX3+D8TURvdImp+Wcl4PmNS5qfHqsMPbUlXfxT/RL848psRRnJBpqMRcVJwIAwBsPR5EC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd3Fx18EGcz5I2hx9/lhRouXhzQt
	5pxvYbHofiVjcf/eTyaLy7vmsFnMOL+PyWLRtv/MFmfnHGJy4PTYsvImk8fOWXfZPbYdUPXo
	27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoHOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBmLXzWyF3wR
	qfi7aCV7A+McwS5GTg4JAROJV2saWCBsMYkL99azdTFycQgJTGeUOL+ikx3C6WeSmPi1gQmk
	ik3ATOLgotXsILaIgLPE7+Y1rCBFzAK3GSUWHXsLNkpYIFTi4Y5frCA2i4CqxPn2tWA2r4Cr
	xNsr94GaOYDWKUjMmWQDEuYUcJM48H0P2HwhoJLve46wTWDkXcDIsIpRNLUguaA4KT3XUK84
	Mbe4NC9dLzk/dxMjOKqeSe1gXNlgcYhRgINRiYd3xcXnQUKsiWXFlbmHGCU4mJVEeE9sehEk
	xJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnAiM8riTc0NjE3NTa1NLEwMbMkTVhJnPdAq3Wg
	kEB6YklqdmpqQWoRzBYmDk6pBsYQRZ/sS++PKHmlHK/X3FMl9Lz00VHrM8l3F/XOFZxWcf+r
	6YEt4XtjVK4/UVxkouhYNf8f00lLNY2gpkVfewpYv7Yphf6X+HP+Y3V91b/b5T5ccbGLv99S
	vmAl3/b7z5m1pctsnsnIvur4ua1psfaP6tsHbxx0/t1ZbPdYb9+hO7O2193K2DxZiaU4I9FQ
	i7moOBEABB/ptu4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Ch <ch.naveen@samsung.com>

This patch uses the platform_get_irq() instead of the
platform_get_irq_byname(). Making feeder control interrupt
as resource "0" and hash interrupt as "1".

reasons for this change.
1. Cannot find any Arch which is currently using this driver
2. Samsung Exynos4 and 5 SoCs only use the feeder control interrupt
3. Patches adding support for DT and H/W version are in pipeline

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v4:
None
Changes since v3:
None
 drivers/crypto/s5p-sss.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index cf149b1..93cddeb 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -592,29 +592,29 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	pdata->ioaddr = devm_ioremap(dev, res->start,
 				     resource_size(res));
 
-	pdata->irq_hash = platform_get_irq_byname(pdev, "hash");
-	if (pdata->irq_hash < 0) {
-		err = pdata->irq_hash;
-		dev_warn(dev, "hash interrupt is not available.\n");
+	pdata->irq_fc = platform_get_irq(pdev, 0);
+	if (pdata->irq_fc < 0) {
+		err = pdata->irq_fc;
+		dev_warn(dev, "feed control interrupt is not available.\n");
 		goto err_irq;
 	}
-	err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
+	err = devm_request_irq(dev, pdata->irq_fc, s5p_aes_interrupt,
 			       IRQF_SHARED, pdev->name, pdev);
 	if (err < 0) {
-		dev_warn(dev, "hash interrupt is not available.\n");
+		dev_warn(dev, "feed control interrupt is not available.\n");
 		goto err_irq;
 	}
 
-	pdata->irq_fc = platform_get_irq_byname(pdev, "feed control");
-	if (pdata->irq_fc < 0) {
-		err = pdata->irq_fc;
-		dev_warn(dev, "feed control interrupt is not available.\n");
+	pdata->irq_hash = platform_get_irq(pdev, 1);
+	if (pdata->irq_hash < 0) {
+		err = pdata->irq_hash;
+		dev_warn(dev, "hash interrupt is not available.\n");
 		goto err_irq;
 	}
-	err = devm_request_irq(dev, pdata->irq_fc, s5p_aes_interrupt,
+	err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
 			       IRQF_SHARED, pdev->name, pdev);
 	if (err < 0) {
-		dev_warn(dev, "feed control interrupt is not available.\n");
+		dev_warn(dev, "hash interrupt is not available.\n");
 		goto err_irq;
 	}
 
-- 
1.7.9.5


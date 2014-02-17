Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaBQJpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:45:20 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55424 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaBQJpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:45:10 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-39-5301da249850
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net,
        Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 1/9 v7] crypto:s5p-sss: Use platform_get_irq() instead of
 _byname()
Date: Mon, 17 Feb 2014 15:14:27 +0530
Message-id: <1392630275-8667-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkWlflFmOwwZPTphZ3nx9mtHh5SNNi
	zvkWFovuVzIW9+/9ZLK4vGsOm8WM8/uYLBZt+89scXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DK2L/7B3vBN5GKf0svsTQwzhHsYuTkkBAwkZiz5icT
	hC0mceHeerYuRi4OIYGljBI9DU3sMEV/Fm5ghEgsYpQ4d/MzO4TTzyQxr+keM0gVm4CZxMFF
	q8E6RAScJX43r2EFKWIWOMoosefcazaQhLBAqMSfK6dYQGwWAVWJl8eXgTXzCrhIvLi0B6iG
	A2idgsScSTYgYU4BV4nOO9vByoWAStZ1XmIBmSkhsI5dYsmdSYwQcwQkvk0+xALRKyux6QAz
	xNWSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZg2J/+96x3B+PtA9aH
	GJOBxk1klhJNzgfGTV5JvKGxmZGFqYmpsZG5pRlpwkrivEkPk4KEBNITS1KzU1MLUovii0pz
	UosPMTJxcEo1MJr9unZjXurWo5uuxjssqKji21pTGX4s7+zHh+KbdGS+bvqTnXr8Od/MJ3Iv
	jHd7/rGJXOGp27hnVvG0uS0v3X00JDcvTku/G3DjTLyvkPFynlkG1gvDbBiLctSD0qR3BCss
	YDOfaO3KoNDcGF5xSeLup+byNdMTSvZLV967b6H6yO/GevEFN5RYijMSDbWYi4oTAQp6z0mR	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV2VW4zBBrcfa1vcfX6Y0eLlIU2L
	OedbWCy6X8lY3L/3k8ni8q45bBYzzu9jsli07T+zxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b+3T/YC76J
	VPxbeomlgXGOYBcjJ4eEgInEn4UbGCFsMYkL99azdTFycQgJLGKUOHfzMzuE088kMa/pHjNI
	FZuAmcTBRavZQWwRAWeJ381rWEGKmAWOMkrsOfeaDSQhLBAq8efKKRYQm0VAVeLl8WVgzbwC
	LhIvLu0BquEAWqcgMWeSDUiYU8BVovPOdrByIaCSdZ2XWCYw8i5gZFjFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERxVz6R2MK5ssDjEKMDBqMTDa1DNGCzEmlhWXJl7iFGCg1lJhNd2HVCI
	NyWxsiq1KD++qDQntfgQYzLQUROZpUST84ERn1cSb2hsYm5qbGppYmFiZkmasJI474FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjMqJa0tv2cxeIhg/RffO+xkvOTsS3zX8uxm4w/TIpDeON2PE
	uk3+nBHWWf2yVcdBfpdmMsf0Z3mttlPz177uW+d06tm2ba7aNxZzPd/R0/K29ZPN34dT01RX
	iE6Qyyr8sGZWgtD6WxtOPfoYdaHWZ32CyZekWWofO6ZIvpDJrHuXmPRzvuvTqQeVWIozEg21
	mIuKEwFhFeMS7gIAAA==
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
Changes since v6:
None
Changes since v5:
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


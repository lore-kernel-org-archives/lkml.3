Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269Ab3JIEAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 00:00:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61418 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3JIEAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 00:00:46 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-42-5254d4ec6d67
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Alessandro Rubini <rubini@gnudd.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH] rtc: pl030: Use devm_kzalloc() instead of kmalloc()
Date: Wed, 09 Oct 2013 13:00:40 +0900
Message-id: <1381291240-23727-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWyRsSkSPfNlZAgg5YlxhaXd81hs9j84SWb
	xf7ODkaL3yeTLRbsKXFg9Whp7mHz2Np6gNVjz8STbB59W1YxenzeJBfAGsVlk5Kak1mWWqRv
	l8CVcfnqKuaCY9wVLYteMDUwbuPsYuTkkBAwkTh17DgrhC0mceHeerYuRi4OIYGljBJLdm1l
	gim60HeIESKxCCgxdQszSEJIoI1J4vRrSRCbTUBX4smBy2BxEYEwiZurWoCmcnAwC6RL3Pqh
	ChIWFnCReDNrKthMFgFViZ/7OxlBSngFPCR+bhcEMSUEFCTmTLIB2SQh8JlN4sDUWcwQ5QIS
	3yYfYoGokZXYdIAZ4jJJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMw
	ME//ezZxB+P9A9aHGJOBxk1klhJNzgcGdl5JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGBU1769QuP8vrK3Yx2jhj9m7D69Za+V57UD28TZuCYUZ
	IcWLJvKYyy/Ir/77pbqaq6dvZ9kX3g+q1pULb964UMnhvcffWqfe+FpqZPly66mJqk+mrJ90
	7eKNTdkJfPGfHldb7pi19JqcdL1CVtixoGChxrMGZt8PPL74/fKGT5vK5RWUdGaH2ymxFGck
	GmoxFxUnAgDLTwF3YgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jAd03V0KCDPZv17a4vGsOm8XmDy/Z
	LPZ3djBa/D6ZbLFgT4kDq0dLcw+bx9bWA6weeyaeZPPo27KK0ePzJrkA1qgGRpuM1MSU1CKF
	1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoN1KCmWJOaVAoYDE4mIl
	fTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozLV1cxFxzjrmhZ9IKpgXEbZxcjJ4eEgInEhb5D
	jBC2mMSFe+vZuhi5OIQEFjFKLJm6hRkkISTQxiRx+rUkiM0moCvx5MBlsLiIQJjEzVUtrF2M
	HBzMAukSt36ogoSFBVwk3syaygRiswioSvzc38kIUsIr4CHxc7sgiCkhoCAxZ5LNBEbuBYwM
	qxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCw/6Z9A7GVQ0WhxgFOBiVeHgf8IcECbEmlhVX
	5h5ilOBgVhLhzVsIFOJNSaysSi3Kjy8qzUktPsSYDLR7IrOUaHI+MCbzSuINjU3MjCyNzA0t
	jIzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFxlsCRb5EBzx6uytd4/a3ad/nLnTLz
	Q5+55XI9eJnvnmfOL+96erv0fodMG2vNL4xN1/ICG9ZfSCjODtCcufzEt6qQrqjnHBefypsc
	LhHbqis/xf3Gw21PIo5cXvLu8Zez0txWzYujjNuzArUZO2Qflq/yKPNj6O8o9WNu+OPt2Od4
	WFZN/bwSS3FGoqEWc1FxIgAGNIv3vwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be free automatically and make the cleanup paths more
simple, use devm_kzalloc() instead of kzalloc().

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/rtc/rtc-pl030.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index 22bacdb..ecd57c6 100644
--- a/drivers/rtc/rtc-pl030.c
+++ b/drivers/rtc/rtc-pl030.c
@@ -106,7 +106,7 @@ static int pl030_probe(struct amba_device *dev, const struct amba_id *id)
 	if (ret)
 		goto err_req;
 
-	rtc = kmalloc(sizeof(*rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&dev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc) {
 		ret = -ENOMEM;
 		goto err_rtc;
@@ -115,7 +115,7 @@ static int pl030_probe(struct amba_device *dev, const struct amba_id *id)
 	rtc->base = ioremap(dev->res.start, resource_size(&dev->res));
 	if (!rtc->base) {
 		ret = -ENOMEM;
-		goto err_map;
+		goto err_rtc;
 	}
 
 	__raw_writel(0, rtc->base + RTC_CR);
@@ -141,8 +141,6 @@ static int pl030_probe(struct amba_device *dev, const struct amba_id *id)
 	free_irq(dev->irq[0], rtc);
  err_irq:
 	iounmap(rtc->base);
- err_map:
-	kfree(rtc);
  err_rtc:
 	amba_release_regions(dev);
  err_req:
@@ -160,7 +158,6 @@ static int pl030_remove(struct amba_device *dev)
 	free_irq(dev->irq[0], rtc);
 	rtc_device_unregister(rtc->rtc);
 	iounmap(rtc->base);
-	kfree(rtc);
 	amba_release_regions(dev);
 
 	return 0;
-- 
1.7.9.5


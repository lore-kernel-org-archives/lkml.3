Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab3JIF27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 01:28:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30171 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3JIF24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:28:56 -0400
X-AuditID: cbfee68e-b7f756d000004512-3e-5254e9977fe1
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Joe Perches <joe@perches.com>, Alessandro Rubini <rubini@gnudd.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH v2] rtc: pl030: Use devm_kzalloc() instead of kmalloc()
Date: Wed, 09 Oct 2013 14:28:51 +0900
Message-id: <1381296531-24360-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkSHf6y5Agg6dneS1m33/MYnF51xw2
	i80fXrJZ7O/sYLT4fTLZYsGeEgc2j5bmHjaPra0HWD32TDzJ5vFl1TVmj74tqxg9Pm+SC2CL
	4rJJSc3JLEst0rdL4MpY+WAyc8Ex7oq/644zNTBu4+xi5OSQEDCRaP7zghXCFpO4cG89Wxcj
	F4eQwFJGiXvXf7DAFG168w0qsYhRYveyB0wQThuTxPoV68Gq2AR0JZ4cuMwMYosIlEoc+3QD
	KM7BwSyQLnHrhypIWFjAXWLLs6XsIDaLgKrEr6XTGUFsXgEPieuTTrOBlEsIKEjMmWQDMl5C
	4D+bxIuW50wQ9QIS3yYfYoGokZXYdIAZ4jZJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchIrzgx
	t7g0L10vOT93EyMwYE//e9a3g/HmAetDjMlA4yYyS4km5wMDPq8k3tDYzMjC1MTU2Mjc0ow0
	YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjIErv/Lts+Bg/xRwRHXHjZ5In0dZ
	hi4s4tLrWReY7gzpW/RGuSxVw31KmKzYtcTex8kLL7O/euicnxtZwVXIn1EfHd5qm/Yiymd+
	kPCMjaccvjBeyrgdljH5QuXHtg/lfApvptQ0p5hu2TlHbmvA9MKVexoaeHQC/t1kaxR5rhKS
	keb+wqVAiaU4I9FQi7moOBEAZgIgnm4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd3pL0OCDF5MZbWYff8xi8XlXXPY
	LDZ/eMlmsb+zg9Hi98lkiwV7ShzYPFqae9g8trYeYPXYM/Ekm8eXVdeYPfq2rGL0+LxJLoAt
	qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoCiWF
	ssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxsoHk5kLjnFX/F13nKmBcRtn
	FyMnh4SAicSmN9/YIGwxiQv31gPZXBxCAosYJXYve8AE4bQxSaxfsZ4FpIpNQFfiyYHLzCC2
	iECpxLFPN4DiHBzMAukSt36ogoSFBdwltjxbyg5iswioSvxaOp0RxOYV8JC4Puk0G0i5hICC
	xJxJNhMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6HZ1I7GFc2WBxiFOBgVOLh
	fcAfEiTEmlhWXJl7iFGCg1lJhDdvIVCINyWxsiq1KD++qDQntfgQYzLQ8onMUqLJ+cBYzSuJ
	NzQ2MTOyNDI3tDAyNidNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRpOw93JLo9bHO51r
	nm1uzv/rS9k3zQ52u5TXD13NU5hd97h+5DvZ3OSt++rMlzuK9TKrObc5HHg77ednFb1LX8IW
	aSRvjDDWTuxmdb/YqOGl7/TlEeeV3e+ucHk9lUtc+Hv3s/ddkVKlqQ+m7Y9veLPrVUjguSa9
	8meByffjlytq72m6mRAuocRSnJFoqMVcVJwIALqHD0bLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be free automatically and make the cleanup paths more
simple, use devm_kzalloc() instead of kmalloc().

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


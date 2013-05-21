Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3EUGRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:17:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27726 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3EUGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:16:59 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-6b-519b115977ec
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/8] rtc: rtc-jz4740: use devm_*() functions
Date: Tue, 21 May 2013 15:16:57 +0900
Message-id: <000501ce55ea$cc10e2d0$6432a870$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5V6slUZvfzdHYVQ6uAQh+thUOCmQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zY91IwdmBBg93mFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8fhjK0vBSfmKY0dmsDQwXpHsYuTkkBAwkZi0+w0bhC0mceHeeiCbi0NIYBmjxMFt
	G5m6GDnAipasMwExhQSmM0o8LoIo+cUo8WDTanaQXjYBNYkvXw6zg9SICOhLtLVogNQwC3Qz
	SjxqnssMUiMsYCOx5O57sF0sAqoS83dNYAWxeQUsJZZPfcQOYQtK/Jh8jwXEZhbQkli/8zgT
	hC0vsXnNW2aIOxUkdpx9zQhiiwjoSfybuw+qXkRi34t3jCCLJQROsUv8mjmLHWKZgMS3yYdY
	IH6Rldh0AGqOpMTBFTdYJjCKzUKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRYZ6xYm5xaV5
	6XrJ+bmbGCFx17uD8fYB60OMyUDrJzJLiSbnA+M2ryTe0NjMyMLUxNTYyNzSjDRhJXFetRbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MdbIH5mi6Ti9m+fw2cx1DX3boCsELC08JrQzh
	NChU/39X5wbb20BzrzX5LbJJs3afjZRLmLJI9u/dazZqMofVPlVuWrrZckdywVJPIS+x951L
	u/qvKs9KLu6/W/zhqeWKI5dD56wwUuy88edUW9pmL8cJ/fMT1fbln/Svnh7F0ZJ3411PxtIf
	SizFGYmGWsxFxYkANXVzD9ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd1IwdmBBnMnGlgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPH4YytLwUn5imNHZrA0MF6R7GLk4JAQMJFY
	ss6ki5ETyBSTuHBvPRtIWEhgOqPE46IuRi4g8xejxINNq9lBatgE1CS+fDnMDlIjIqAv0dai
	AVLDLNDNKPGoeS4zSI2wgI3Ekrvv2UBsFgFVifm7JrCC2LwClhLLpz5ih7AFJX5MvscCYjML
	aEms33mcCcKWl9i85i0zxD0KEjvOvmYEsUUE9CT+zd0HVS8ise/FO8YJjAKzkIyahWTULCSj
	ZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOKqfSe9gXNVgcYhRgINRiYdXwHBW
	oBBrYllxZe4hRgkOZiUR3u/NQCHelMTKqtSi/Pii0pzU4kOMyUCfTmSWEk3OByacvJJ4Q2MT
	MyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgdF+9Zmban2qZkw4zN77d
	wd3xcmrGxB0P53EvUp7/1EbiJtMGO6X3u8/957txZsLODBlOrv28DA9NFO1NLwcek/V6IDzb
	eENKl/98rbPZC2f0fTTa/vlDwI5ry73PzVaV5TQ95bkhfc2tcoX5ah4VlSzit783qP4NWHxl
	5rn/OR2CApveFgvnZyixFGckGmoxFxUnAgAvYlYOLgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-jz4740.c |   65 ++++++++++++----------------------------------
 1 file changed, 16 insertions(+), 49 deletions(-)

diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index c6573585..1b126d2 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -216,37 +217,34 @@ static int jz4740_rtc_probe(struct platform_device *pdev)
 	struct jz4740_rtc *rtc;
 	uint32_t scratchpad;
 
-	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
 		return -ENOMEM;
 
 	rtc->irq = platform_get_irq(pdev, 0);
 	if (rtc->irq < 0) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform irq\n");
-		goto err_free;
+		return -ENOENT;
 	}
 
 	rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!rtc->mem) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform mmio memory\n");
-		goto err_free;
+		return -ENOENT;
 	}
 
-	rtc->mem = request_mem_region(rtc->mem->start, resource_size(rtc->mem),
-					pdev->name);
+	rtc->mem = devm_request_mem_region(&pdev->dev, rtc->mem->start,
+					resource_size(rtc->mem), pdev->name);
 	if (!rtc->mem) {
-		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		goto err_free;
+		return -EBUSY;
 	}
 
-	rtc->base = ioremap_nocache(rtc->mem->start, resource_size(rtc->mem));
+	rtc->base = devm_ioremap_nocache(&pdev->dev, rtc->mem->start,
+					resource_size(rtc->mem));
 	if (!rtc->base) {
-		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
-		goto err_release_mem_region;
+		return -EBUSY;
 	}
 
 	spin_lock_init(&rtc->lock);
@@ -255,19 +253,19 @@ static int jz4740_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev, &jz4740_rtc_ops,
-					THIS_MODULE);
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&jz4740_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
 		dev_err(&pdev->dev, "Failed to register rtc device: %d\n", ret);
-		goto err_iounmap;
+		return ret;
 	}
 
-	ret = request_irq(rtc->irq, jz4740_rtc_irq, 0,
+	ret = devm_request_irq(&pdev->dev, rtc->irq, jz4740_rtc_irq, 0,
 				pdev->name, rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request rtc irq: %d\n", ret);
-		goto err_unregister_rtc;
+		return ret;
 	}
 
 	scratchpad = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_SCRATCHPAD);
@@ -276,43 +274,13 @@ static int jz4740_rtc_probe(struct platform_device *pdev)
 		ret = jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SEC, 0);
 		if (ret) {
 			dev_err(&pdev->dev, "Could not write write to RTC registers\n");
-			goto err_free_irq;
+			return ret;
 		}
 	}
 
 	return 0;
-
-err_free_irq:
-	free_irq(rtc->irq, rtc);
-err_unregister_rtc:
-	rtc_device_unregister(rtc->rtc);
-err_iounmap:
-	iounmap(rtc->base);
-err_release_mem_region:
-	release_mem_region(rtc->mem->start, resource_size(rtc->mem));
-err_free:
-	kfree(rtc);
-
-	return ret;
 }
 
-static int jz4740_rtc_remove(struct platform_device *pdev)
-{
-	struct jz4740_rtc *rtc = platform_get_drvdata(pdev);
-
-	free_irq(rtc->irq, rtc);
-
-	rtc_device_unregister(rtc->rtc);
-
-	iounmap(rtc->base);
-	release_mem_region(rtc->mem->start, resource_size(rtc->mem));
-
-	kfree(rtc);
-
-	return 0;
-}
-
-
 #ifdef CONFIG_PM
 static int jz4740_rtc_suspend(struct device *dev)
 {
@@ -344,7 +312,6 @@ static const struct dev_pm_ops jz4740_pm_ops = {
 
 static struct platform_driver jz4740_rtc_driver = {
 	.probe	 = jz4740_rtc_probe,
-	.remove	 = jz4740_rtc_remove,
 	.driver	 = {
 		.name  = "jz4740-rtc",
 		.owner = THIS_MODULE,
-- 
1.7.10.4



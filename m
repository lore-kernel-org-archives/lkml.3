Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3LAX4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 18:56:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10841 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3LAX4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 18:56:46 -0500
X-AuditID: cbfee68f-b7f336d00000481b-40-529bccbc745d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
In-reply-to: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
Subject: [PATCH 3/8] backlight: omap1: use devm_backlight_device_register()
Date: Mon, 02 Dec 2013 08:56:44 +0900
Message-id: <000201ceeef0$fd142280$f73c6780$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7u8NgcVnqPK6OFQjq+Xy+HsAignwAABqkQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zA909Z2YHGTTesLCYs34Nm8XlhZdY
	LS7vmsPmwOxxYsZvFo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DK2LP8AHvBKe6KU7c7GRsY
	b3J2MXJySAiYSOx58owdwhaTuHBvPVsXIxeHkMAyRonN6xexwBRt/bkUKrGIUeLfq9/MEM4v
	Rok1yz4yglSxCahJfPlyGGgUB4eIgL5EW4sGiMks4CJxdJoISIWQgK3EhkfnmUBsTgE7iQk3
	/4DZwgLeEo2zH4FNYRFQlVjb9ZsRpJUXqH7nTBmQMK+AoMSPyffAzmEW0JJYv/M4E4QtL7F5
	zVtmkHIJAXWJR391IfYbSUz5ogRRISKx78U7RpB7JQQOsUuc2reNCWKTgMS3yYdYIFplJTYd
	YIZ4VlLi4IobLBMYJWYhWTwLyeJZSBbPQrJiASPLKkbR1ILkguKk9CJjveLE3OLSvHS95Pzc
	TYyQ2OvfwXj3gPUhxmSg9ROZpUST84Gxm1cSb2hsZmRhamJqbGRuaUaasJI47/2HSUFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGJVkHWKc/xkvmPt+yY7O+XedH1goOSTzHL+edOLA+z2z
	el99i1+7YIlpvvmpCINFBqWZDJLzLk5xsy3Oa+FfdYY7a+EcK5m+2IaUtHbHLcdnRD55wGC9
	N+Oo6rr5Dc3X16/8syw4RpJjnYfSvQ+L17zfW5S7ePP3FZ+Ln25Vkn1mvNkm7tzk/RZKLMUZ
	iYZazEXFiQApvGcC0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd09Z2YHGSxZYWoxZ/0aNovLCy+x
	WlzeNYfNgdnjxIzfLB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZg
	qGtoaWGupJCXmJtqq+TiE6DrlpkDtElJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjHmLFn+QH2glPcFadudzI2MN7k7GLk5JAQMJHY+nMpG4QtJnHh3nogm4tDSGARo8S/
	V7+ZIZxfjBJrln1kBKliE1CT+PLlMHsXIweHiIC+RFuLBojJLOAicXSaCEiFkICtxIZH55lA
	bE4BO4kJN/+A2cIC3hKNsx+BTWERUJVY2/WbEaSVF6h+50wZkDCvgKDEj8n3WEBsZgEtifU7
	jzNB2PISm9e8ZQYplxBQl3j0Vxdiv5HElC9KEBUiEvtevGOcwCg0C8mgWUgGzUIyaBaSlgWM
	LKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgiP7mdQOxpUNFocYBTgYlXh4K47NDhJiTSwr
	rsw9xCjBwawkwmvxdVaQEG9KYmVValF+fFFpTmrxIcZkoDcnMkuJJucDk05eSbyhsYmZkaWR
	mYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTA6X49c90uzvOer1YY6mevHKgy2
	hMhwP42+kaf7qqQ9YpZEK+eav+UWc50mmfkqadQUS2/xPaF46x/LBabGR3vmLm4t2Zvll/Lz
	23SBQ+XXs933Z7w+ya24ND1sh/bpZoOsybIXX6rapomfEryjOG9f66qO6KBphy00/9n5PfCM
	aXnwZY7orJlKLMUZiYZazEXFiQDsn0OTMAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/omap1_bl.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index ac11a46..a0dcd88 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -146,8 +146,8 @@ static int omapbl_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = OMAPBL_MAX_INTENSITY;
-	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops,
-					&props);
+	dev = devm_backlight_device_register(&pdev->dev, "omap-bl", &pdev->dev,
+					bl, &omapbl_ops, &props);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
@@ -170,20 +170,10 @@ static int omapbl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int omapbl_remove(struct platform_device *pdev)
-{
-	struct backlight_device *dev = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(dev);
-
-	return 0;
-}
-
 static SIMPLE_DEV_PM_OPS(omapbl_pm_ops, omapbl_suspend, omapbl_resume);
 
 static struct platform_driver omapbl_driver = {
 	.probe		= omapbl_probe,
-	.remove		= omapbl_remove,
 	.driver		= {
 		.name	= "omap-bl",
 		.pm	= &omapbl_pm_ops,
-- 
1.7.10.4



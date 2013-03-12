Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab3CLFvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:51:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34736 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3CLFvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:51:43 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-8a-513ec26e1af4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 08/14] backlight: ep93xx: convert ep93xx to dev_pm_ops
Date: Tue, 12 Mar 2013 14:51:42 +0900
Message-id: <004501ce1ee5$ac09cab0$041d6010$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAAFYXg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zQ928Q3aBBr8Pyltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mmf1XGQsO8lY8eCXdwLiUu4uRg0NCwERi3rLyLkZOIFNM4sK9
	9WxdjFwcQgLLGCVm7D/FBpEwkVj4fz8LRGIRo8S1HX9ZIZzZTBJv1n1kBaliE1CT+PLlMDvI
	VBEBfYm2Fg2QMLNAqcTWB+9ZQGwhAVuJu+ufM4KUcArYSWz5mwUSFhZwk3gz4Q0TiM0ioCrx
	cfkKRhCbF6h88s95zBC2oMSPyfdYIEZqSazfeZwJwpaX2LzmLTPEL+oSj/7qgoRFBIwkdm/4
	xAZRIiKx78U7RpCLJQSWsUvs/zudGWKXgMS3yYdYIHplJTYdYIZ4V1Li4IobLBMYJWYh2TwL
	yeZZSDbPQrJiASPLKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYyQmOrfwXj3gPUhxmSg9ROZ
	pUST84ExmVcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGRpbJR0wtD52r40zaFb8jpHzaqyuuF56kNt0MYnjasrGX4Wb3eVuVU86aEUHHFj8piKw6
	tvb4Eb3gneXbPe8m/G/d3rokrEHP81hAXlZe/+SNUu0FGd1h02awhkn45s52zX/EOCc26Lxw
	uMH6zXMvHvBje/ztxFadxJALMpdXK5otmJ+6y8B7txJLcUaioRZzUXEiAKjL8PC/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG7eIbtAgy+zZSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxsz+q4wFB3krHrySbmBc
	yt3FyMkhIWAisfD/fhYIW0ziwr31bF2MXBxCAosYJa7t+MsK4cxmkniz7iMrSBWbgJrEly+H
	2bsYOThEBPQl2lo0QMLMAqUSWx+8BxskJGArcXf9c0aQEk4BO4ktf7NAwsICbhJvJrxhArFZ
	BFQlPi5fwQhi8wKVT/45jxnCFpT4MfkeC8RILYn1O48zQdjyEpvXvGUGGSkhoC7x6K8uSFhE
	wEhi94ZPbBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz
	0vWS83M3MYJj9pnUDsaVDRaHGAU4GJV4eBW/2QYKsSaWFVfmHmKU4GBWEuHN2GwXKMSbklhZ
	lVqUH19UmpNafIgxGejRicxSosn5wHSSVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS
	1OzU1ILUIpgtTBycUg2MQSXJx37/OvZkt5Dsgc7/AU4mu5XaD5z8sHzG7r2vrbUrPiZLSP89
	8ic2Xd2mRFrOyWzzgSKH+VJ90cVrJQUOPdvTFbnamo+xYnpK7duzfVc8lt9Zsfpj1kXR3Dcb
	vYRi7nsbBx3aNNE4+/XJPfO9bPMcTvzZdWOv4c1rRus+Lroq8OdKblqBvhJLcUaioRZzUXEi
	AEsGOGwdAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ep93xx_bl.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index ef3e21e..734b7fe 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -115,35 +115,33 @@ static int ep93xxbl_remove(struct platform_device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ep93xxbl_suspend(struct platform_device *dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int ep93xxbl_suspend(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(dev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	return ep93xxbl_set(bl, 0);
 }
 
-static int ep93xxbl_resume(struct platform_device *dev)
+static int ep93xxbl_resume(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(dev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	backlight_update_status(bl);
 	return 0;
 }
-#else
-#define ep93xxbl_suspend	NULL
-#define ep93xxbl_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(ep93xxbl_pm_ops, ep93xxbl_suspend, ep93xxbl_resume);
+
 static struct platform_driver ep93xxbl_driver = {
 	.driver		= {
 		.name	= "ep93xx-bl",
 		.owner	= THIS_MODULE,
+		.pm	= &ep93xxbl_pm_ops,
 	},
 	.probe		= ep93xxbl_probe,
 	.remove		= ep93xxbl_remove,
-	.suspend	= ep93xxbl_suspend,
-	.resume		= ep93xxbl_resume,
 };
 
 module_platform_driver(ep93xxbl_driver);
-- 
1.7.2.5



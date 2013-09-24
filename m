Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3IXJUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:20:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61162 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3IXJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:20:02 -0400
X-AuditID: cbfee68e-b7f756d000004512-a8-524159415c6d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 21/22] backlight: tps65217_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:20:00 +0900
Message-id: <005b01ceb907$3ec1a1f0$bc44e5d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAii1g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI13HSMcggw0P2S3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErowL/Y2s
	BV+5KmZc/8HSwDiTs4uRk0NCwERix51/TBC2mMSFe+vZuhi5OIQEljFKzFmyiwmmaM2GXkaI
	xHRGiVPdj6CqfjFKPNo6ixWkik1ATeLLl8PsXYwcHCIC+hJtLRogYWaBHIn7T2axg9hCArYS
	6z7MBrM5BewkTi09wwZiCwuESmx49BDMZhFQlfjb2cAIYvMC1e84uZUJwhaU+DH5HgvETC2J
	zduaWCFseYnNa94yg6yVEFCXePRXFyQsImAkcfTcNyaIEhGJfS/eMUL8co5d4uGldIhVAhLf
	Jh9igWiVldh0gBmiRFLi4IobLBMYJWYhWTwLyeJZSBbPQrJhASPLKkbR1ILkguKk9CIjveLE
	3OLSvHS95PzcTYyQmOzbwXjzgPUhxmSg9ROZpUST84ExnVcSb2hsZmRhamJqbGRuaUaasJI4
	r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxra756Wu9J9kLJprES203DpUrHB7wqd7
	r75OCzYR4Sxs2eH/KEvZVL/8CNf+G/3XixZMZbl2QFPbvffI3iqh+I4spocRW4xVWdjSVW13
	Kn0IT3vAHyP+M++ZaYx+nLGjW44bq/2FP0V8G3Pz4goSDS0/2z7c8LP8pcekw2dajLXKSj9N
	+rJdiaU4I9FQi7moOBEAbeXFC98CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQV3HSMcgg/tXmS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMC/2NrAVfuSpmXP/B0sA4k7OLkZNDQsBEYs2GXkYIW0ziwr31
	bF2MXBxCAtMZJU51P4JyfjFKPNo6ixWkik1ATeLLl8PsXYwcHCIC+hJtLRogYWaBHIn7T2ax
	g9hCArYS6z7MBrM5BewkTi09wwZiCwuESmx49BDMZhFQlfjb2QC2mBeofsfJrUwQtqDEj8n3
	WCBmakls3tbECmHLS2xe85YZZK2EgLrEo7+6IGERASOJo+e+MUGUiEjse/GOcQKj0Cwkk2Yh
	mTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO+WdSOxhXNlgcYhTgYFTi
	4d3h7RAkxJpYVlyZe4hRgoNZSYT3hq1jkBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnA9NR
	Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUw1qsGTzVzC1j2
	uXMPg9iJrWuOy2V07WpoVzzmuuBDRk7nxluOt2Yqhyy4cmdvQy3DW89Lq04YTnBoPxqw2eL3
	Y/bl29RfyYjPyJfL1E6U0GIXvnDmTvupTZYW5cULhPclP7BckXjxa2r4f839W12WKy97m6Gy
	4iHTR5O5i8RcFe212s3Mpdw9lFiKMxINtZiLihMB/tiv+z0DAAA=
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
 drivers/video/backlight/tps65217_bl.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/video/backlight/tps65217_bl.c b/drivers/video/backlight/tps65217_bl.c
index 4ea2039..cbba37e 100644
--- a/drivers/video/backlight/tps65217_bl.c
+++ b/drivers/video/backlight/tps65217_bl.c
@@ -313,7 +313,7 @@ static int tps65217_bl_probe(struct platform_device *pdev)
 	bl_props.type = BACKLIGHT_RAW;
 	bl_props.max_brightness = 100;
 
-	tps65217_bl->bl = backlight_device_register(pdev->name,
+	tps65217_bl->bl = devm_backlight_device_register(&pdev->dev, pdev->name,
 						tps65217_bl->dev, tps65217_bl,
 						&tps65217_bl_ops, &bl_props);
 	if (IS_ERR(tps65217_bl->bl)) {
@@ -329,18 +329,8 @@ static int tps65217_bl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int tps65217_bl_remove(struct platform_device *pdev)
-{
-	struct tps65217_bl *tps65217_bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(tps65217_bl->bl);
-
-	return 0;
-}
-
 static struct platform_driver tps65217_bl_driver = {
 	.probe		= tps65217_bl_probe,
-	.remove		= tps65217_bl_remove,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "tps65217-bl",
-- 
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3BUId4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:33:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45023 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3BUIdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:33:55 -0500
X-AuditID: cbfee68f-b7f656d000000d78-e0-5125dbf298d3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 03/12] rtc: rtc-vt8500: use devm_*() functions
Date: Thu, 21 Feb 2013 17:33:53 +0900
Message-id: <00ce01ce100e$2e72b8e0$8b582aa0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAAC/5Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zI91Pt1UDDf6eYbK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZx9eeYy74IVKxb4twA+NEwS5GTg4JAROJaU9WskPYYhIX7q1n
	62Lk4hASWMYoMXH1NkaYoobrv1lBbCGBRYwSOz/rQBTNZpKYtO4UWDebgJrEly+HgWwODhEB
	fYm2Fg2QGmaBXkaJM7272SGabSXmfLjGDGJzCthJXN72BWyoMJD9o2EBC4jNIqAqseX0GbDF
	vED1FxpPQdmCEj8m3wOrYRbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUEjCTW/drLBlEi
	IrHvxTtGkHskBBaxS9y/8glql4DEt8mHWCB6ZSU2HWCG+FdS4uCKGywTGCVmIdk8C8nmWUg2
	z0KyYgEjyypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkLjq38F494D1IcZkoPUTmaVEk/OB
	cZlXEm9obGxiZmJqYm5pam5KmrCSOK/8JZlAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYze
	BXu9vY4VW+d0qkwUaF/5r6GB1ed919Tvhtfq2ILXv038e2Ry8B/+xLd8Vv0mgUvZJSKCn3Cu
	bpQ7uD1xvnmqnsypuovl/zpOJ3Gnr3+RLbtso1j6mehlDfNtWFj+sq9o9o0KvMht3Tcr8UDP
	4qdJARLnuqYaSYgcWnl+waoHWz1OfNafz6TEUpyRaKjFXFScCADVtZVKwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7H26qBBtffWlhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjONrzzEX/BCp2LdFuIFx
	omAXIyeHhICJRMP136wQtpjEhXvr2UBsIYFFjBI7P+t0MXIB2bOZJCatO8UOkmATUJP48uUw
	kM3BISKgL9HWogFSwyzQyyhxpnc3O0SzrcScD9eYQWxOATuJy9u+gC0QBrJ/NCxgAbFZBFQl
	tpw+wwhi8wLVX2g8BWULSvyYfA+shllAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYRMJJY
	92svG0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOCofSa9g3FVg8UhRgEORiUe3gUvVQKFWBPLiitzDzFKcDArifAqAmNeiDclsbIqtSg/
	vqg0J7X4EGMy0KMTmaVEk/OBCSWvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tSs1NT
	C1KLYLYwcXBKNTC6LQvpWn7i7I4pWxf/3q2VtffzjImunbWzv4afc6242ps07/4u70gDE6mZ
	EaW/F8i6z1uy5dCB2G7GzicK8asq3CxyUp8zbT454d7JagOl4gx9UbdPSU+ub9nb5yf67nmn
	pXzZar1rTXwnOGfX8Qm/tbhwveNqxPlnr+tXOZ9sN/GT0ebwyP6rxFKckWioxVxUnAgAe4vQ
	/R4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-vt8500.c |   28 ++++++++++------------------
 1 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index 2730533..a000bc0 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -231,20 +231,21 @@ static int vt8500_rtc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	vt8500_rtc->res = request_mem_region(vt8500_rtc->res->start,
-					     resource_size(vt8500_rtc->res),
-					     "vt8500-rtc");
+	vt8500_rtc->res = devm_request_mem_region(&pdev->dev,
+					vt8500_rtc->res->start,
+					resource_size(vt8500_rtc->res),
+					"vt8500-rtc");
 	if (vt8500_rtc->res == NULL) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
 		return -EBUSY;
 	}
 
-	vt8500_rtc->regbase = ioremap(vt8500_rtc->res->start,
+	vt8500_rtc->regbase = devm_ioremap(&pdev->dev, vt8500_rtc->res->start,
 				      resource_size(vt8500_rtc->res));
 	if (!vt8500_rtc->regbase) {
 		dev_err(&pdev->dev, "Unable to map RTC I/O memory\n");
 		ret = -EBUSY;
-		goto err_release;
+		goto err_return;
 	}
 
 	/* Enable RTC and set it to 24-hour mode */
@@ -257,11 +258,11 @@ static int vt8500_rtc_probe(struct platform_device *pdev)
 		ret = PTR_ERR(vt8500_rtc->rtc);
 		dev_err(&pdev->dev,
 			"Failed to register RTC device -> %d\n", ret);
-		goto err_unmap;
+		goto err_return;
 	}
 
-	ret = request_irq(vt8500_rtc->irq_alarm, vt8500_rtc_irq, 0,
-			  "rtc alarm", vt8500_rtc);
+	ret = devm_request_irq(&pdev->dev, vt8500_rtc->irq_alarm,
+				vt8500_rtc_irq, 0, "rtc alarm", vt8500_rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't get irq %i, err %d\n",
 			vt8500_rtc->irq_alarm, ret);
@@ -272,11 +273,7 @@ static int vt8500_rtc_probe(struct platform_device *pdev)
 
 err_unreg:
 	rtc_device_unregister(vt8500_rtc->rtc);
-err_unmap:
-	iounmap(vt8500_rtc->regbase);
-err_release:
-	release_mem_region(vt8500_rtc->res->start,
-			   resource_size(vt8500_rtc->res));
+err_return:
 	return ret;
 }
 
@@ -284,15 +281,10 @@ static int vt8500_rtc_remove(struct platform_device *pdev)
 {
 	struct vt8500_rtc *vt8500_rtc = platform_get_drvdata(pdev);
 
-	free_irq(vt8500_rtc->irq_alarm, vt8500_rtc);
-
 	rtc_device_unregister(vt8500_rtc->rtc);
 
 	/* Disable alarm matching */
 	writel(0, vt8500_rtc->regbase + VT8500_RTC_IS);
-	iounmap(vt8500_rtc->regbase);
-	release_mem_region(vt8500_rtc->res->start,
-			   resource_size(vt8500_rtc->res));
 
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.2.5



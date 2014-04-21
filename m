Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaDUJhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:37:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21881 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaDUJg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:36:27 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-93-5354e69806ef
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gg@slimlogic.co.uk, kishon@ti.com, balbi@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        sangjung.woo@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 4/9] extcon: max77693: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 18:36:21 +0900
Message-id: <1398072986-17386-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
References: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSpDvjWUiwwaUbwhYH79dbTH34hM3i
	35Qb7BbXvzxntejf4mLx+oWhxYWnPWwWZ5vesFtc3jWHzeJ24wo2iwV7Shy4PTat6mTzeDnx
	N5tH35ZVjB5Tp/xl9Dh+YzuTx+dNcgFsUVw2Kak5mWWpRfp2CVwZn/acYizYxVlxdU0/UwPj
	Z/YuRk4OCQETicNrH7BC2GISF+6tZ+ti5OIQEljKKHF2/2q4ornnOtkhEosYJbafes8K4TQx
	Sfz89QKsnU1AS2L/ixtsILaIgILE5t5nYEXMAg1MEnM+LWACSQgLhEj83HoYrIFFQFVi9t0W
	RhCbV8BVYtLSZYwQ6+QkPux5BLaaU8BNYt2PbrB6IaCajvd9jCBDJQR2sUssnziLGWKQgMS3
	yYdYuhg5gBKyEpsOMEPMkZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcx
	AqPi9L9nvTsYbx+wPsSYDDRuIrOUaHI+MKrySuINjc2MLExNTI2NzC3NSBNWEudNepgUJCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoFRcJWymn9k+2nPSdG8O5z9X+bWF/10lZy/efbRhYon
	snJiC8/ksjEwf2aMeTot+oVF2RTh71aT2N+qLj2ZckZwe4l4GUO01cZj6/z4f5WtXnL0xMTo
	W8tKM9ps9R4vu1VutXv26h9XwrM8O3ZMufi9Y/qU72GlZ0yEl58348g34r0Rrv19w/ufSizF
	GYmGWsxFxYkAO0HQg6ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd0Zz0KCDbY847Y4eL/eYurDJ2wW
	/6bcYLe4/uU5q0X/FheL1y8MLS487WGzONv0ht3i8q45bBa3G1ewWSzYU+LA7bFpVSebx8uJ
	v9k8+rasYvSYOuUvo8fxG9uZPD5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjDmPFpzynGgl2cFVfX9DM1MH5m72Lk5JAQMJGYe64TyhaTuHBvPVsXIxeHkMAiRont
	p96zQjhNTBI/f71gBaliE9CS2P/iBhuILSKgILG59xlYEbNAA5PEnE8LmEASwgIhEj+3HgZr
	YBFQlZh9t4URxOYVcJWYtHQZI8Q6OYkPex6BreYUcJNY96MbrF4IqKbjfR/jBEbeBYwMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY+6Z9A7GVQ0WhxgFOBiVeHhf5IcEC7EmlhVX5h5i
	lOBgVhLhjVgPFOJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YDrIK4k3NDYxM7I0Mje0MDI2
	J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGbVohJ3d9mKnFzHwl73B+9nv/lOa1h+ab
	+kkbP1zt/q1lSq7ofPZzAQWph6WNhN84Fs62MNSv/i5z/mPleuU3K0w+Od9Q/LxmfsVi60rh
	Dgs1ob271oacVIpKuuCccvvko4gLCg3u050dtld7Rretqktf/vNiW1iT6vLSBK/W6XayYvoP
	W9iUWIozEg21mIuKEwGeTti0/QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 39cd095..01e9179 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1175,8 +1175,8 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize extcon device */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
-				  GFP_KERNEL);
+	info->edev = devm_extcon_dev_allocate(&pdev->dev,
+					      max77693_extcon_cable);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
@@ -1184,7 +1184,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
-	info->edev->supported_cable = max77693_extcon_cable;
+
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-- 
1.8.0


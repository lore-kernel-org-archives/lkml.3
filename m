Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3LAX43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 18:56:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:14074 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3LAX41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 18:56:27 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-e4-529bcca98b03
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
In-reply-to: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
Subject: [PATCH 2/8] backlight: hp680_bl: use devm_backlight_device_register()
Date: Mon, 02 Dec 2013 08:56:25 +0900
Message-id: <000101ceeef0$f1a95050$d4fbf0f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7u8NgcVnqPK6OFQjq+Xy+HsAignwAAAT3g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zfd2VZ2YHGfzZpGsxZ/0aNovLCy+x
	WlzeNYfNgdnjxIzfLB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVMfvbSaaCGxwVne8esTQw
	LmHvYuTkkBAwkdi89D0rhC0mceHeerYuRi4OIYFljBJ3Lu5mgSm68aGPESIxnVHi0L82Zgjn
	F6PEp6m/mECq2ATUJL58OQw0loNDREBfoq1FA8RkFnCRODpNBKRCSMBWYsOj82DVnAJ2EhNu
	/gGzhQX8JGY9aGcDsVkEVCWWzrsLZvMC1Z/ZuokRwhaU+DH5Htg9zAJaEut3HmeCsOUlNq95
	ywyySkJAXeLRX12QsIiAkcSyBXcZIUpEJPa9eAd2voTAIXaJLWemQO0SkPg2+RALRK+sxKYD
	zBDvSkocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7
	iRESf707GG8fsD7EmAy0fiKzlGhyPjB+80riDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qB8WxOc6PNAf5dAjJCk/ZuU+Rbp/R0/RPL/SpW61Y/mb7e
	b9JOjYvFSR+UnjqFflvCGbz97u6Fc5UOOH+sCG3edLjd5wLj/iUno+vnxZ8I6vHcL3/QcYLm
	zYTvTXsk2PLz7H++2ZJcXZQerMBSOI37HVuHJWu+s/mz0tjg6tP3j24MN1r6IOpLvhJLcUai
	oRZzUXEiANyGP/TVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd2VZ2YHGby9pGkxZ/0aNovLCy+x
	WlzeNYfNgdnjxIzfLB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZg
	qGtoaWGupJCXmJtqq+TiE6DrlpkDtElJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjHmDH720mmghscFZ3vHrE0MC5h72Lk5JAQMJG48aGPEcIWk7hwbz1bFyMXh5DAdEaJ
	Q//amCGcX4wSn6b+YgKpYhNQk/jy5TBQNweHiIC+RFuLBojJLOAicXSaCEiFkICtxIZH58Gq
	OQXsJCbc/ANmCwv4Scx60M4GYrMIqEosnXcXzOYFqj+zdRMjhC0o8WPyPRYQm1lAS2L9zuNM
	ELa8xOY1b5lBVkkIqEs8+qsLEhYRMJJYtuAuI0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUB
	I8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODofia9g3FVg8UhRgEORiUe3gsnZgcJsSaW
	FVfmHmKU4GBWEuG1+DorSIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgYknryTe0NjEzMjS
	yMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYJzFcvhBzZPEzRY6MBe/Vr6dt
	l7y+zH0j89HeGU6lE9e4zD/j6riBNfa96WLnV7ZX3dZJ/F3PYVn10Uh529LrKzTdppT+X3Pq
	kp/b6tYl/86vmxTK77LB8Yt0z+zTlmnaKVPvXznyocdvl+fCf8sUGEpzM53/fH9svyLHNSgw
	09Ph6HebJtajBUosxRmJhlrMRcWJAF9djAUyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/hp680_bl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 00076ec..8ea42b8 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -110,8 +110,8 @@ static int hp680bl_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = HP680_MAX_INTENSITY;
-	bd = backlight_device_register("hp680-bl", &pdev->dev, NULL,
-				       &hp680bl_ops, &props);
+	bd = devm_backlight_device_register(&pdev->dev, "hp680-bl", &pdev->dev,
+					NULL, &hp680bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
@@ -131,8 +131,6 @@ static int hp680bl_remove(struct platform_device *pdev)
 	bd->props.power = 0;
 	hp680bl_send_intensity(bd);
 
-	backlight_device_unregister(bd);
-
 	return 0;
 }
 
-- 
1.7.10.4



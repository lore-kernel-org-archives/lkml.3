Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3IXJFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:05:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20457 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3IXJFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:05:38 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-5c-524155e1c27a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 02/22] backlight: aat2870: use devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:05:36 +0900
Message-id: <004801ceb905$3bd6f000$b384d000$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAABOOQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA92HoY5BBoceiFnMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBk31z5i
	LWjhqbh/ZgNTA+Nfzi5GTg4JAROJPUvnskPYYhIX7q1nA7GFBJYxSpxfxQ9T0/d3I2sXIxdQ
	fBGjxNX1W5ggin4xSszekQBiswmoSXz5chhoEAeHiIC+RFuLBkiYWSBH4v6TWewQ5bYS6z7M
	BrM5BewkTi09A7ZLWMBfonvhJrA4i4CqxNcHx1lAbF6g+umT29ggbEGJH5PvsUDM1JLYvK2J
	FcKWl9i85i0zyFoJAXWJR391QcIiAkYS6x7MgioRkdj34h0jyPkSApfYJfY3dTJD7BKQ+Db5
	EAtEr6zEpgPMEO9KShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKxXnJhb
	XJqXrpecn7uJERKR/TsY7x6wPsSYDLR+IrOUaHI+MKLzSuINjc2MLExNTI2NzC3NSBNWEudV
	a7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4Wc2oUaWv7lNxUP7aSAVHr0vhT7k6Zudr
	sR84lWO7w8Bqi0bymmItZR/mT6GXzBUU6tljTZ1/6kQuYlig0t2yzW5LyNOle5PObJ26ONEv
	saa9NuKavPDu+RGiQZy+Ls+KZ/nuuZmdUlTm5PiUu/XStZ/uV8OyEmKrTr/eJm53Zsu8GLHN
	q5VYijMSDbWYi4oTAbhidjHeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd2HoY5BBje/CFnMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZN9c+Yi1o4am4f2YDUwPjX84uRk4OCQETib6/G1khbDGJC/fW
	s3UxcnEICSxilLi6fgsTSEJI4BejxOwdCSA2m4CaxJcvh9m7GDk4RAT0JdpaNEDCzAI5Evef
	zGKHKLeVWPdhNpjNKWAncWrpGTYQW1jAX6J74SawOIuAqsTXB8dZQGxeoPrpk9vYIGxBiR+T
	77FAzNSS2LytiRXClpfYvOYtM8haCQF1iUd/dUHCIgJGEusezIIqEZHY9+Id4wRGoVlIJs1C
	MmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc8c+kdjCubLA4xCjAwajE
	w7vD2yFIiDWxrLgy9xCjBAezkgjvDVvHICHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OByaj
	vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgZGp/94evVs7/
	bQ3Lgdftx/6b7E3UTb16Rv5FAlOt6eH+rQeux9dyF+57yr3n2fXLp6ryDzfdzVh0Q+aGwePi
	3HXzb8qs3vlvEd/iQ+ukzp1J2ncrR8uGcZP1Vc7A/Yw+56fKPV2lcp1t9T+5wzy7Wr0eb9hx
	5Injhag7RfydbyyFLkqt/jWhP1eJpTgj0VCLuag4EQD5SMpQPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/aat2870_bl.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
index c68232b..ee0c0a9 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -158,8 +158,9 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 
 	props.type = BACKLIGHT_RAW;
-	bd = backlight_device_register("aat2870-backlight", &pdev->dev,
-				       aat2870_bl, &aat2870_bl_ops, &props);
+	bd = devm_backlight_device_register(&pdev->dev, "aat2870-backlight",
+					&pdev->dev, aat2870_bl, &aat2870_bl_ops,
+					&props);
 	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev,
 			"Failed allocate memory for backlight device\n");
@@ -194,13 +195,11 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 	ret = aat2870_bl_update_status(bd);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to initialize\n");
-		goto out_bl_dev_unregister;
+		return ret;
 	}
 
 	return 0;
 
-out_bl_dev_unregister:
-	backlight_device_unregister(bd);
 out:
 	return ret;
 }
@@ -214,8 +213,6 @@ static int aat2870_bl_remove(struct platform_device *pdev)
 	bd->props.brightness = 0;
 	backlight_update_status(bd);
 
-	backlight_device_unregister(bd);
-
 	return 0;
 }
 
-- 
1.7.10.4



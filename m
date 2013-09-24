Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3IXJZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:25:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26782 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3IXJZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:25:32 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-9c-52415a8bd2fa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
In-reply-to: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
Subject: [PATCH 7/8] backlight: platform_lcd: use devm_lcd_device_register()
Date: Tue, 24 Sep 2013 18:25:31 +0900
Message-id: <006801ceb908$03b23290$0b1697b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65B4cS+dNU2Dj7TgWyLrp1FJz2pQAAGv+g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI93uKMcgg97fahZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8b6lSeY
	C87yVHT82snawHiAq4uRk0NCwETi0L51bBC2mMSFe+uBbC4OIYFljBLzt59igynq6Z4CZgsJ
	TGeUmNluB1H0i1Fi48NlLCAJNgE1iS9fDrN3MXJwiAjoS7S1aICEmQVyJO4/mcUO0WsrsXrm
	VTCbU8BO4v3UM2CtwgI+Et92zGQGsVkEVCWOTFoPtosXqP7j3WVQtqDEj8n3WCBmakls3tbE
	CmHLS2xe85YZZK2EgLrEo7+6IGERASOJtqv9UOUiEvtevGMEOVlC4Bi7xLOG26wQuwQkvk0+
	xALRKyux6QAzxLuSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmegVJ+YW
	l+al6yXn525ihMTkhB2M9w5YH2JMBlo/kVlKNDkfGNN5JfGGxmZGFqYmpsZG5pZmpAkrifOq
	t1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDUqpZevjFuwbqXBz7nvvAol85XnrGsf7PM
	Drkeo89zDZ7Ic//cOSGY237Bkfs7xOMCs+5fcpHo+zTxlk5iLKvEMq8ZX34npW9N+aDqcOjw
	7k39l38bMQnXr98SV/tTT1VQ+crz9idWbEunmV6emLz4V/NRUYcLNh7hi+/6RCTJzjwekB7k
	5iioxFKckWioxVxUnAgAL07lM98CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd3uKMcgg5YtyhZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPG+pUnmAvO8lR0/NrJ2sB4gKuLkZNDQsBEoqd7ChuELSZx4d56
	MFtIYDqjxMx2uy5GLiD7F6PExofLWEASbAJqEl++HGbvYuTgEBHQl2hr0QAJMwvkSNx/Mosd
	otdWYvXMq2A2p4CdxPupZ8BahQV8JL7tmMkMYrMIqEocmQSxixeo/uPdZVC2oMSPyfdYIGZq
	SWze1sQKYctLbF7zlhlkrYSAusSjv7ogYREBI4m2q/1Q5SIS+168Y5zAKDQLyaRZSCbNQjJp
	FpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/6Z1A7GlQ0WhxgFOBiVeHh3eDsE
	CbEmlhVX5h5ilOBgVhLhvWHrGCTEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cBklFcSb2hs
	YmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjPlFl5/svf6jyr1V+++X
	e/Hbjul48x5qS7SbmbWEOSTAS9dZe+n/nIp+8e4NTRZmb6e/s3jHXDaDUzVuc5/e1Pp1THfP
	L1yh45/xWM+y8ZJSz6YFOhc++E9cti1E4R+vqm925Mauv7ei7n5wrEhiC68+wSZlx72wNdhv
	24OyRscsziTDcyaflViKMxINtZiLihMBVIc3OjwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/platform_lcd.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index cc0f067..d01884d 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -101,30 +101,17 @@ static int platform_lcd_probe(struct platform_device *pdev)
 
 	plcd->us = dev;
 	plcd->pdata = pdata;
-	plcd->lcd = lcd_device_register(dev_name(dev), dev,
-					plcd, &platform_lcd_ops);
+	plcd->lcd = devm_lcd_device_register(&pdev->dev, dev_name(dev), dev,
+						plcd, &platform_lcd_ops);
 	if (IS_ERR(plcd->lcd)) {
 		dev_err(dev, "cannot register lcd device\n");
-		err = PTR_ERR(plcd->lcd);
-		goto err;
+		return PTR_ERR(plcd->lcd);
 	}
 
 	platform_set_drvdata(pdev, plcd);
 	platform_lcd_set_power(plcd->lcd, FB_BLANK_NORMAL);
 
 	return 0;
-
- err:
-	return err;
-}
-
-static int platform_lcd_remove(struct platform_device *pdev)
-{
-	struct platform_lcd *plcd = platform_get_drvdata(pdev);
-
-	lcd_device_unregister(plcd->lcd);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -168,7 +155,6 @@ static struct platform_driver platform_lcd_driver = {
 		.of_match_table = of_match_ptr(platform_lcd_of_match),
 	},
 	.probe		= platform_lcd_probe,
-	.remove		= platform_lcd_remove,
 };
 
 module_platform_driver(platform_lcd_driver);
-- 
1.7.10.4



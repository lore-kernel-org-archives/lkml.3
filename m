Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3CFHw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:52:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52880 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3CFHwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:52:55 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-82-5136f5ce6fb6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 15/30] rtc: rtc-max8997: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:52:46 +0900
Message-id: <008901ce1a3f$9778a0d0$c669e270$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAALIMg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zI91zX80CDSY8N7e4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZTy99Zi5o4Ko4uaaTtYFxOUcXIyeHhICJxMszc9ggbDGJC/fW
	g9lCAssYJZpPlMHUPH+2jLGLkQsovohR4uXVfewQzmwmiUO7bjGCVLEJqEl8+XIYKMHBISKg
	L9HWogFSwyzQyyhxpnc3WFxIwFaiZx4PSDmngJ3ElImP2UFsYQEviY2rljCD2CwCqhL/29eC
	jeQFKl/d9ZUVwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wg4yUE1CUe/dUFCYsIGEncer2G
	EaJERGLfi3dg90sILGOXmPnvGRPELgGJb5MPsUD0ykpsOsAM8a+kxMEVN1gmMErMQrJ5FpLN
	s5BsnoVkxQJGllWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYIXHVv4Px7gHrQ4zJQOsnMkuJ
	JucD4zKvJN7Q2NjEzMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	Ghg51mdyZvDLH9DM7NFmFP5hPcUx0l9tZ13R3wQHtSXPfETm/ey82TLv3CZPnc/pFfeDMr5v
	ff+n+ufWsJdSl6evjo8OkdEu6AsQ4GDoc38732fW1uWn69NUZP9ncC+rCFr76H2R4jnWua5L
	P26e+GRGuolEWEzTJ73D0hdPS5+2ZBOeEvzU/KASS3FGoqEWc1FxIgBWT6MmwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO65r2aBBrM6TCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxtNLn5kLGrgqTq7pZG1g
	XM7RxcjJISFgIvH82TJGCFtM4sK99WxdjFwcQgKLGCVeXt3HDuHMZpI4tOsWWBWbgJrEly+H
	gRIcHCIC+hJtLRogNcwCvYwSZ3p3g8WFBGwleubxgJRzCthJTJn4mB3EFhbwkti4agkziM0i
	oCrxv30t2EheoPLVXV9ZIWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMMl5CQF3i0V9dkLCI
	gJHErddrGCFKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgTH7TOpHYwrGywOMQpwMCrx8FoomQUKsSaWFVfmHmKU4GBWEuHlOgMU4k1JrKxK
	LcqPLyrNSS0+xJgM9OhEZinR5HxgSskriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU
	7NTUgtQimC1MHJxSDYwX3P77XTx5dcefiIbDkXa/Iix2/Yi54Jsj+/Ju5oevGV9WNLD0cgtm
	TE3i+bDg+ItUWeUXZ50ar5z5tW9tnsxu9dWeEzf8mdn0bEcV34MfuYnvVoRMbwrpmi6aK9F0
	746/0fpfi5JnHb7yNH3dz4X5/5qmCO1WL58jX975IJzXp3vSBobrJpuFlViKMxINtZiLihMB
	tv5n6h8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-max8997.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
index 00e505b..d12acc4 100644
--- a/drivers/rtc/rtc-max8997.c
+++ b/drivers/rtc/rtc-max8997.c
@@ -479,8 +479,8 @@ static int max8997_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register("max8997-rtc", &pdev->dev,
-			&max8997_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "max8997-rtc",
+					&max8997_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
@@ -507,17 +507,11 @@ static int max8997_rtc_probe(struct platform_device *pdev)
 	return ret;
 
 err_out:
-	rtc_device_unregister(info->rtc_dev);
 	return ret;
 }
 
 static int max8997_rtc_remove(struct platform_device *pdev)
 {
-	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
-
-	if (info)
-		rtc_device_unregister(info->rtc_dev);
-
 	return 0;
 }
 
-- 
1.7.2.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3CFHtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:49:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45678 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab3CFHt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:49:28 -0500
X-AuditID: cbfee690-b7f6b6d000004563-f6-5136f507a9e4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 06/30] rtc: rtc-ds1511: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:49:27 +0900
Message-id: <008001ce1a3f$20a3ca70$61eb5f50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAET4w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zfV32r2aBBu0dihZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlzDnxnr2gg6ti1aPbzA2MSzm6GDk5JARMJJbMWM4MYYtJXLi3ng3EFhJYxijRcksC
	pmbp9/vsXYxcQPHpjBLnNk5kgnB+MUq09k8A62ATUJP48uUwUBUHh4iAvkRbiwZIDbNAL6PE
	md7dYHEhAVuJnnk8IOWcAnYSUyY+ZgexhQU8JS787GMCsVkEVCWO3b8KZvMClX//v5sZwhaU
	+DH5HguIzSygJbF+53EmCFteYvOat8wg4yUE1CUe/dUFCYsIGEncvLsKqkREYt+Ld4wg50gI
	3GOX2DX7PtQuAYlvkw+xQPTKSmw6AA0HSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVT
	C5ILipPSi0z0ihNzi0vz0vWS83M3MULidMIOxnsHrA8xJgOtn8gsJZqcD4zzvJJ4Q2NjEzMT
	UxNzS1NzU9KElcR55S/JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpgrJ59Uuy45E1Fjq+7
	JC3/SM64zVJSEMo3p+P2o+jkD6aZwbNzTqx3dXifETl/94GO5LvntywNNTmql/OA7eFiF+3l
	zaLcrbeuPGzb896jv+VBvlGtpvfPmLZX3TPXlr97H9YhvvSmdlXSqWPBUy+WuGkbHef4NO/Q
	hrPvZ/vWeL60mPY+gPGLhhJLcUaioRZzUXEiAAi6pT3pAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV32r2aBBrOuyFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDHnxHv2gg6uilWPbjM3MC7l6GLk5JAQMJFY
	+v0+O4QtJnHh3nq2LkYuDiGB6YwS5zZOZIJwfjFKtPZPYAOpYhNQk/jy5TBQBweHiIC+RFuL
	BkgNs0Avo8SZ3t1gcSEBW4meeTwg5ZwCdhJTJj4GWyAs4Clx4WcfE4jNIqAqcez+VTCbF6j8
	+//dzBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlBhkvIaAu8eivLkhYRMBI4ubdVVAlIhL7
	XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLTwDOp
	HYwrGywOMQpwMCrx8FoomQUKsSaWFVfmHmKU4GBWEuHlOgMU4k1JrKxKLcqPLyrNSS0+xJgM
	9OhEZinR5HxgisoriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1MHJxS
	DYz71121uRSs8ZD/whGlSZfvhWzYe/6vTg53l9xaH5GNTC9XPr1h92nStFtHg5utV6z0+F7Q
	UMm8JfTQwvX8y5iM1m+9VhFyW5LDlP8i/9qHErnxHbPer7O79eZow3nFPxfPV/7f3fRgt+y1
	G0J7ed7Iu5hU9bb8MuTtj1FLXr9A+83HEv4Lpc+FlFiKMxINtZiLihMBDzzBt0cDAAA=
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

 drivers/rtc/rtc-ds1511.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 6a3fcfe..6ce8a99 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -538,15 +538,14 @@ static int ds1511_rtc_probe(struct platform_device *pdev)
 		}
 	}
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev, &ds1511_rtc_ops,
-		THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name, &ds1511_rtc_ops,
+					THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
-	if (ret)
-		rtc_device_unregister(pdata->rtc);
+
 	return ret;
 }
 
@@ -555,7 +554,6 @@ static int ds1511_rtc_remove(struct platform_device *pdev)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	if (pdata->irq > 0) {
 		/*
 		 * disable the alarm interrupt
-- 
1.7.2.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3C1Iiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:38:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14931 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab3C1Iin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:38:43 -0400
X-AuditID: cbfee68d-b7f786d000005188-ab-515401927aa8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
In-reply-to: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
Subject: [PATCH 5/8] rtc: rtc-puv3: convert puv3_rtc_driver to dev_pm_ops
Date: Thu, 28 Mar 2013 17:38:42 +0900
Message-id: <001401ce2b8f$a71211a0$f53634e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rj2FhCGvCEF7CQ36UwoHUUgpQOwAADvrg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY91JjCGBBhPWKlksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0Xk9puCMSMXtxRsZGxivCnQxcnJICJhI/J0znQnCFpO4cG89WxcjF4eQwDJGiea1
	V1hgijZ/+8MOkZjOKLG+/w5U1S9GiVcrprGCVLEJqEl8+XIYqIqDQ0RAX6KtRQOkhlmgl1Hi
	TO9udpAaIQFbiXOHrzKD2JwCdhLta7aCbRAW8JTYN/U9I4jNIqAq8enQSrAaXqD6GTOfskLY
	ghI/Jt8Dq2cW0JJYv/M4E4QtL7F5zVtmkL0SAuoSj/7qgoRFBIwker+uZYYoEZHY9+IdI8g9
	EgL32CWmrZ7CBLFLQOLb5EMsEL2yEpsOMEM8LClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFl
	FaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIpPbuYLx9wPoQYzLQ+onMUqLJ+cBIzyuJNzQ2
	M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY2dD0vrClBe6
	LPtTal+tFcps+XctY8mEkutXz3Ua6/2bXTXhVH9n86OS32e+z83Z8HifhaXulswE36O+jDMm
	GJrdYX/wUe7LFK2rW9gXL7rMGp28gC2v6+gBzfYdHa8rUvSfd7n7GaQs1X3j4ZG+qPRjYK/C
	1r+Z1TmPXrc59PH2T+aRfDNZSomlOCPRUIu5qDgRAD1KByvqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd1JjCGBBlN2yVosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNF5PabgjEjF7cUbGRsYrwp0MXJySAiYSGz+
	9ocdwhaTuHBvPVsXIxeHkMB0Ron1/XegnF+MEq9WTGMFqWITUJP48uUwUAcHh4iAvkRbiwZI
	DbNAL6PEmd7dYJOEBGwlzh2+ygxicwrYSbSv2coCYgsLeErsm/qeEcRmEVCV+HRoJVgNL1D9
	jJlPWSFsQYkfk++B1TMLaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIiAkYSvV/XMkOUiEjs
	e/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOA8+k
	djCubLA4xCjAwajEw1shEBwoxJpYVlyZe4hRgoNZSYT3UCdQiDclsbIqtSg/vqg0J7X4EGMy
	0KMTmaVEk/OBKSqvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODil
	GhjDv12fwPlma4Ij+/4ZPVsjlvy4t3BDfFhE+UPhcsczRYVrdR+/YRfS+SfPO6cvSXIiz6r1
	1TfldgtP/yk3S02NNT34u6zwmj7Xtbladekp7+Nf5SvMsz7suvae7nSm24qcDjbWAn9s1mn+
	lvI8Jv1RtLhkOl/AizKz453RMiut5y5I38YVwK/EUpyRaKjFXFScCAABzU1uRwMAAA==
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
 drivers/rtc/rtc-puv3.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index 0407e13..72f4371 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -207,14 +207,14 @@ static const struct rtc_class_ops puv3_rtcops = {
 	.proc	        = puv3_rtc_proc,
 };
 
-static void puv3_rtc_enable(struct platform_device *pdev, int en)
+static void puv3_rtc_enable(struct device *dev, int en)
 {
 	if (!en) {
 		writel(readl(RTC_RTSR) & ~RTC_RTSR_HZE, RTC_RTSR);
 	} else {
 		/* re-enable the device, and check it is ok */
 		if ((readl(RTC_RTSR) & RTC_RTSR_HZE) == 0) {
-			dev_info(&pdev->dev, "rtc disabled, re-enabling\n");
+			dev_info(dev, "rtc disabled, re-enabling\n");
 			writel(readl(RTC_RTSR) | RTC_RTSR_HZE, RTC_RTSR);
 		}
 	}
@@ -276,7 +276,7 @@ static int puv3_rtc_probe(struct platform_device *pdev)
 		goto err_nores;
 	}
 
-	puv3_rtc_enable(pdev, 1);
+	puv3_rtc_enable(&pdev->dev, 1);
 
 	/* register RTC and exit */
 	rtc = rtc_device_register("pkunity", &pdev->dev, &puv3_rtcops,
@@ -296,44 +296,41 @@ static int puv3_rtc_probe(struct platform_device *pdev)
 	return 0;
 
  err_nortc:
-	puv3_rtc_enable(pdev, 0);
+	puv3_rtc_enable(&pdev->dev, 0);
 	release_resource(puv3_rtc_mem);
 
  err_nores:
 	return ret;
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static int ticnt_save;
 
-static int puv3_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int puv3_rtc_suspend(struct device *dev)
 {
 	/* save RTAR for anyone using periodic interrupts */
 	ticnt_save = readl(RTC_RTAR);
-	puv3_rtc_enable(pdev, 0);
+	puv3_rtc_enable(dev, 0);
 	return 0;
 }
 
-static int puv3_rtc_resume(struct platform_device *pdev)
+static int puv3_rtc_resume(struct device *dev)
 {
-	puv3_rtc_enable(pdev, 1);
+	puv3_rtc_enable(dev, 1);
 	writel(ticnt_save, RTC_RTAR);
 	return 0;
 }
-#else
-#define puv3_rtc_suspend NULL
-#define puv3_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(puv3_rtc_pm_ops, puv3_rtc_suspend, puv3_rtc_resume);
+
 static struct platform_driver puv3_rtc_driver = {
 	.probe		= puv3_rtc_probe,
 	.remove		= puv3_rtc_remove,
-	.suspend	= puv3_rtc_suspend,
-	.resume		= puv3_rtc_resume,
 	.driver		= {
 		.name	= "PKUnity-v3-RTC",
 		.owner	= THIS_MODULE,
+		.pm	= &puv3_rtc_pm_ops,
 	}
 };
 
-- 
1.7.2.5



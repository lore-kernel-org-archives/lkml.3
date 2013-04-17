Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3DQBIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:08:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33137 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab3DQBI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:08:29 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-cc-516df6034601
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
In-reply-to: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
Subject: [PATCH RESEND 5/8] rtc: rtc-puv3: convert puv3_rtc_driver to dev_pm_ops
Date: Wed, 17 Apr 2013 10:08:18 +0900
Message-id: <003401ce3b08$0c1d3160$24579420$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B9XUIMaX4YjsSbW0FEYgtMIOOAAACt7Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA13mb7mBBud2C1gsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0Xk9puCMSMXtxRsZGxivCnQxcnBICJhIrF0g0sXICWSKSVy4t56ti5GLQ0hgGaPE
	9MVtLBAJE4nni6ewQiSmM0rMu3wPquoXo8SSl/tYQarYBNQkvnw5zA4yVURAX6KtRQOkhlmg
	l1HiTO9udpAaIQFbiZsdh5hAbE4BO4lvR+4wgtjCAgESE+ZdBKthEVCVmNv0FMzmBao/Pnc2
	I4QtKPFj8j2wi5gFtCTW7zzOBGHLS2xe85YZ4ht1iUd/dUHCIgJGEus+/2OGKBGR2PfiHSPI
	PRIC99gluuauZYHYJSDxbfIhFoheWYlNB5ghHpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDI
	sopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJE4n7mC8f8D6EGMy0PqJzFKiyfnAOM8riTc0
	NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2NtWa2+wYdN
	uRqXpwkcnMf/i5Op+HH/bP7u18Lz7u3a6+AW3dbsfGzp2mWR/BtW++2P6V45xzTk14/Vkc4J
	LqU2uXJf/5+4Pt34sGvs5ZwymQgn7bN54u2XWvKf2KyaG3vxs81XzYXyITyeFT0GIu/33RKI
	410fzT399J5S+X/mHMznzxnN6lZiKc5INNRiLipOBAA3dT3L6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV3mb7mBBjdu81gsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNF5PabgjEjF7cUbGRsYrwp0MXJySAiYSDxf
	PIUVwhaTuHBvPVsXIxeHkMB0Rol5l+9BOb8YJZa83AdWxSagJvHly2H2LkYODhEBfYm2Fg2Q
	GmaBXkaJM7272UFqhARsJW52HGICsTkF7CS+HbnDCGILCwRITJh3EayGRUBVYm7TUzCbF6j+
	+NzZjBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBIYt3nf8wQJSIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC08Az
	6R2MqxosDjEKcDAq8fBeKMgNFGJNLCuuzD3EKMHBrCTCq7gKKMSbklhZlVqUH19UmpNafIgx
	GejRicxSosn5wBSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2MCbp9TJ+1vl7NSpvc0BK1VDAvv8H5AqtBfuCFhZNm8qoXnL918GLZ1OWi0s8nz2r4JJCR
	9v5g+ZFdgfNipZiu6BgskfJTOf3ow6GADmkbh6CZWwRLfVw3BHW2JxyZHNnyvulkS+Kpg9+3
	Ga7L5Z/Dxs7enPDd//oOu0bDg8eC3lzkcy22WH1diaU4I9FQi7moOBEAy38sYUcDAAA=
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



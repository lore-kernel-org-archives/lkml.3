Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3D2J0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:26:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22643 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab3D2J0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:26:43 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-bd-517e3cd1cb10
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 2/2] watchdog: s3c2410_wdt: convert s3c2410wdt to
 dev_pm_ops
Date: Mon, 29 Apr 2013 18:26:41 +0900
Message-id: <000801ce44bb$a877ce00$f9676a00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Eu6eW3bLz0wbLSMyhE4iwhaHjNw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zY92LNnWBBt++mlrMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	7D29jLngn2DFuqYvbA2M3/i6GDk5JARMJK7fOMIMYYtJXLi3nq2LkYtDSGAZo0TfmifMMEUX
	/p5nhEhMZ5S4/uIUE4Tzi1Hi2PeJYFVsAmoSX74cZu9i5OAQEdCXaGvRAKlhFuhglDjwdCkr
	SI2wQKhE7+ajYDUsAqoS+xtFQMK8ApYSX3t7mCBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3kL
	dZCCxI6zrxlBbBEBPYm9G39C1YhI7HvxDuxQCYF97BL/rz8AK2IREJD4NvkQC8heCQFZiU0H
	oOZIShxccYNlAqPYLCSrZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJ
	ERJvfTsYbx6wPsSYDLR+IrOUaHI+MF7zSuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJ
	zU5NLUgtii8qzUktPsTIxMEp1cAooi7ex93hst9W88LKpSI50Q/jeW/ui+OY+2z9yhV6Eyuf
	Wew8sGxFeW/ylS8paikZvNX59w7abT5Rwtsq7qDxU+iyWapo2CkLjctRWhNkPYzMvsh3Rv97
	w+ZSJaq8ulXhVqXq6wXi7deMHl0t77A9IsqVNrf/zZmncRq5OZ+7Lz3eED911hclluKMREMt
	5qLiRAAQQFW1zQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd2LNnWBBvNXGlrMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZuw9vYy54J9gxbqmL2wNjN/4uhg5OSQETCQu/D3PCGGL
	SVy4t56ti5GLQ0hgOqPE9RenmCCcX4wSx75PZAapYhNQk/jy5TB7FyMHh4iAvkRbiwZIDbNA
	B6PEgadLWUFqhAVCJXo3HwWrYRFQldjfKAIS5hWwlPja28MEYQtK/Jh8jwXEZhbQkli/8zgT
	hC0vsXnNW2aIgxQkdpx9DXaciICexN6NP6FqRCT2vXjHOIFRYBaSUbOQjJqFZNQsJC0LGFlW
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH8zPpHYyrGiwOMQpwMCrx8AZsrg0UYk0sK67M
	PcQowcGsJMK7wrIuUIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgYkmryTe0NjEzMjSyMzC
	yMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoY+/u8ww9czL3sVOWVVSpzU/Fs+FqR
	hsWrVQPFWl61NBxP/+NxQbwlquNpSWH6HsHv102XHvjAUlH1g3+F+YaC6R8uaV5b+KDk89pM
	u5Dni5xn5mgt6jzFLH48J1ws4+00rbg9O3Zyqjz8FHjq2xFZlZgtJUzBLb/vH2d1j/eU1u19
	k9t+rMVZiaU4I9FQi7moOBEAMZgCYCoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer
dev_pm_ops structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/s3c2410_wdt.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index c9f480d..d15fbe3 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -439,12 +439,12 @@ static void s3c2410wdt_shutdown(struct platform_device *dev)
 	s3c2410wdt_stop(&s3c2410_wdd);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 static unsigned long wtcon_save;
 static unsigned long wtdat_save;
 
-static int s3c2410wdt_suspend(struct platform_device *dev, pm_message_t state)
+static int s3c2410wdt_suspend(struct device *dev)
 {
 	/* Save watchdog state, and turn it off. */
 	wtcon_save = readl(wdt_base + S3C2410_WTCON);
@@ -456,7 +456,7 @@ static int s3c2410wdt_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int s3c2410wdt_resume(struct platform_device *dev)
+static int s3c2410wdt_resume(struct device *dev)
 {
 	/* Restore watchdog state. */
 
@@ -464,16 +464,15 @@ static int s3c2410wdt_resume(struct platform_device *dev)
 	writel(wtdat_save, wdt_base + S3C2410_WTCNT); /* Reset count */
 	writel(wtcon_save, wdt_base + S3C2410_WTCON);
 
-	dev_info(&dev->dev, "watchdog %sabled\n",
+	dev_info(dev, "watchdog %sabled\n",
 		(wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
 
 	return 0;
 }
+#endif
 
-#else
-#define s3c2410wdt_suspend NULL
-#define s3c2410wdt_resume  NULL
-#endif /* CONFIG_PM */
+static SIMPLE_DEV_PM_OPS(s3c2410wdt_pm_ops, s3c2410wdt_suspend,
+			s3c2410wdt_resume);
 
 #ifdef CONFIG_OF
 static const struct of_device_id s3c2410_wdt_match[] = {
@@ -487,11 +486,10 @@ static struct platform_driver s3c2410wdt_driver = {
 	.probe		= s3c2410wdt_probe,
 	.remove		= s3c2410wdt_remove,
 	.shutdown	= s3c2410wdt_shutdown,
-	.suspend	= s3c2410wdt_suspend,
-	.resume		= s3c2410wdt_resume,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "s3c2410-wdt",
+		.pm	= &s3c2410wdt_pm_ops,
 		.of_match_table	= of_match_ptr(s3c2410_wdt_match),
 	},
 };
-- 
1.7.2.5



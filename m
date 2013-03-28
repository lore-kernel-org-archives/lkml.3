Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3C1Iia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:38:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41483 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab3C1IiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:38:25 -0400
X-AuditID: cbfee68e-b7f946d000001e37-8f-51540180bf19
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
In-reply-to: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
Subject: [PATCH 4/8] rtc: rtc-omap: convert omap_rtc_driver to dev_pm_ops
Date: Thu, 28 Mar 2013 17:38:23 +0900
Message-id: <001301ce2b8f$9c0b0a50$d4211ef0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rj2FhCGvCEF7CQ36UwoHUUgpQOwAAC/Ew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ90GxpBAg0m3BS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK2Hj4MGvBTeGKoz+2sDUwrhboYuTkkBAwkTj88AcrhC0mceHeerYuRi4OIYFljBL7
	rt9khyma/mYXG4gtJDCdUWLtEi2Iol+MEjsmbmEESbAJqEl8+XIYqIGDQ0RAX6KtRQOkhlmg
	l1HiTO9udohmW4lzh68yg9icAnYS7Wu2soDYwgKeEu9/rQZbwCKgKvH0+gJmkDm8QPVPXmWB
	hHkFBCV+TL4HVs4soCWxfudxJghbXmLzmrdg5RIC6hKP/upCXGAkcWyfLUSFiMS+F+8YQa6R
	ELjFLvF5zgNWiE0CEt8mH2KBaJWV2HSAGeJbSYmDK26wTGCUmIVk8Swki2chWTwLyYoFjCyr
	GEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MUKitG8H480D1ocYk4HWT2SWEk3OB0Z5Xkm8obGZ
	kYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYeRVPrvsk9GhH
	9LetlyUXxRvmXXzwb96Oa1NWZ5697d6RvuRN+LlypsPHi/Y0vjeS3zj5t0DZjpVcl/7bL+GL
	vK1tmuvkGqDpYGUnnRT8vfhKhmpryLSrhz+teRI6aXHNj69nXI5+/vZ3k67GmZVTvr64JGxa
	1ZMWrXhZ7eiOA1uY+tYlXNr5XlqJpTgj0VCLuag4EQCpVka+6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd0GxpBAg79/eSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNh4+DBrwU3hiqM/trA1MK4W6GLk5JAQMJGY
	/mYXG4QtJnHh3nowW0hgOqPE2iVaXYxcQPYvRokdE7cwgiTYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDLKHGmdzc7RLOtxLnDV5lBbE4BO4n2NVtZQGxhAU+J979Wgy1gEVCVeHp9ATPIHF6g
	+ievskDCvAKCEj8m3wMrZxbQkli/8zgThC0vsXnNW7ByCQF1iUd/dSEuMJI4ts8WokJEYt+L
	d4wTGIVmIRk0C8mgWUgGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcAp4Jr2D
	cVWDxSFGAQ5GJR7eCoHgQCHWxLLiytxDjBIczEoivIc6gUK8KYmVValF+fFFpTmpxYcYk4He
	nMgsJZqcD0xPeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXA
	yPvagTFpXylzQmhW0CqOGUL58c4X7gdNqE9+V/wk12FySkNewkPn/PAzzDtFZlxvLc3kWpXP
	GjhBLCe07Ne8DzMN/TR3BklP82z+abUz0OilL3u9rN+91ll8rDs1dj21aT8o+XVr8hOhY9UX
	u5t9Xi1dX/6Xe2XtCeFGHdvT3Cu/72J/LD5NiaU4I9FQi7moOBEAW9MwekUDAAA=
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
 drivers/rtc/rtc-omap.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index a1f9d30..4e1bdb8 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -464,11 +464,10 @@ static int __exit omap_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static u8 irqstat;
 
-static int omap_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int omap_rtc_suspend(struct device *dev)
 {
 	irqstat = rtc_read(OMAP_RTC_INTERRUPTS_REG);
 
@@ -476,34 +475,32 @@ static int omap_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	 * source, and in fact this enable() call is just saving a flag
 	 * that's never used...
 	 */
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(dev))
 		enable_irq_wake(omap_rtc_alarm);
 	else
 		rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
 	/* Disable the clock/module */
-	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_put_sync(dev);
 
 	return 0;
 }
 
-static int omap_rtc_resume(struct platform_device *pdev)
+static int omap_rtc_resume(struct device *dev)
 {
 	/* Enable the clock/module so that we can access the registers */
-	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_get_sync(dev);
 
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(dev))
 		disable_irq_wake(omap_rtc_alarm);
 	else
 		rtc_write(irqstat, OMAP_RTC_INTERRUPTS_REG);
 	return 0;
 }
-
-#else
-#define omap_rtc_suspend NULL
-#define omap_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(omap_rtc_pm_ops, omap_rtc_suspend, omap_rtc_resume);
+
 static void omap_rtc_shutdown(struct platform_device *pdev)
 {
 	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
@@ -512,12 +509,11 @@ static void omap_rtc_shutdown(struct platform_device *pdev)
 MODULE_ALIAS("platform:omap_rtc");
 static struct platform_driver omap_rtc_driver = {
 	.remove		= __exit_p(omap_rtc_remove),
-	.suspend	= omap_rtc_suspend,
-	.resume		= omap_rtc_resume,
 	.shutdown	= omap_rtc_shutdown,
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
+		.pm	= &omap_rtc_pm_ops,
 		.of_match_table = of_match_ptr(omap_rtc_of_match),
 	},
 	.id_table	= omap_rtc_devtype,
-- 
1.7.2.5



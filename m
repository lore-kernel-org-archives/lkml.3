Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab3CLFrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:47:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33896 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab3CLFrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:47:17 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-6e-513ec16453fa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] rtc: rtc-s3c: convert s3c_rtc to dev_pm_ops
Date: Tue, 12 Mar 2013 14:47:15 +0900
Message-id: <003b01ce1ee5$0d2585b0$27709110$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5QzoWT5v6vTcQW+UrZiGx5ZsKA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zfd2Ug3aBBu/Xc1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0Tn1EHPBNMmK050rmRsYr4t0MXJySAiYSMxe28QOYYtJXLi3nq2LkYtDSGAZo8Tt
	U9fYYIq2PmhmgkhMZ5S4OfUZO4Tzi1Fi7rtjrCBVbAJqEl++HAZKcHCICOhLtLVogNQwC/Qy
	Spzp3Q22QljARmLH02awehYBVYm3J88yg9TzCthKPNsZCRLmFRCU+DH5HguIzSygJbF+53Em
	CFteYvOat2DlEgLqEo/+6oKERQT0JHb/m84GUSIise/FO0aIm0+xS9w7rQGxSUDi2+RDLBCt
	shKbDjBDlEhKHFxxg2UCo9gsJItnIVk8C8niWUg2LGBkWcUomlqQXFCclF5krFecmFtcmpeu
	l5yfu4kREnf9OxjvHrA+xJgMtH4is5Rocj4wbvNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4U
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBh3OvHRwmN+P3nWWhe/EeX9rql154H//1Xic4T/
	yjo7sPX+ahAT6u7/6uQ51eXF5q6GZ0vElLnStv71dLFJKJrnPs35G4tPzSufOK3KCWfnZyZK
	ey1hfafPqr8p77Vufrh5oGpy/zO5jZN2J2fnS8xa3FpxmCXF9c3yYN7mI8cimJxjT8mVK7EU
	ZyQaajEXFScCAFqGHTXRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd2Ug3aBBvvfsFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNE59RBzwTTJitOdK5kbGK+LdDFyckgImEhs
	fdDMBGGLSVy4t56ti5GLQ0hgOqPEzanP2CGcX4wSc98dYwWpYhNQk/jy5TBQgoNDREBfoq1F
	A6SGWaCXUeJM7252kBphARuJHU+bwepZBFQl3p48ywxSzytgK/FsZyRImFdAUOLH5HssIDaz
	gJbE+p3HmSBseYnNa96ClUsIqEs8+qsLEhYR0JPY/W86G0SJiMS+F+8YJzAKzEIyaRaSSbOQ
	TJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOC4fia1g3Flg8UhRgEORiUeXsVv
	toFCrIllxZW5hxglOJiVRHgzNtsFCvGmJFZWpRblxxeV5qQWH2JMBvpzIrOUaHI+MOXklcQb
	GpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANjRIjJaR6Gg3KVFVtc
	on4ul2Per1yw615TSUSvbWGj8+/XqlmnHyxv3H0h5lrx+cqg97l7HiqnnZ9Vrvb4ZnGoBK/P
	tI1nPQ8LdUlPEvCfazPdceHmD9tjLRWOSiZu9ipPF3tSomZUqfVqHat+icxqtl8p734qTX2e
	VZ295KVv3I4vOqmXjRYpsRRnJBpqMRcVJwIAAHqpFy8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer
dev_pm_ops structure allows better control over power management.
Also, 'wake_en' variable is moved, because it is only used when
CONFIG_PM_SLEEP is enabled.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-s3c.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index fb994e9..c863a93 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -51,7 +51,6 @@ static struct clk *rtc_clk;
 static void __iomem *s3c_rtc_base;
 static int s3c_rtc_alarmno = NO_IRQ;
 static int s3c_rtc_tickno  = NO_IRQ;
-static bool wake_en;
 static enum s3c_cpu_type s3c_rtc_cpu_type;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
@@ -583,14 +582,16 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 	return ret;
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 /* RTC Power management control */
 
 static int ticnt_save, ticnt_en_save;
+static bool wake_en;
 
-static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int s3c_rtc_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
+
 	clk_enable(rtc_clk);
 	/* save TICNT for anyone using periodic interrupts */
 	ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
@@ -600,19 +601,20 @@ static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	}
 	s3c_rtc_enable(pdev, 0);
 
-	if (device_may_wakeup(&pdev->dev) && !wake_en) {
+	if (device_may_wakeup(dev) && !wake_en) {
 		if (enable_irq_wake(s3c_rtc_alarmno) == 0)
 			wake_en = true;
 		else
-			dev_err(&pdev->dev, "enable_irq_wake failed\n");
+			dev_err(dev, "enable_irq_wake failed\n");
 	}
 	clk_disable(rtc_clk);
 
 	return 0;
 }
 
-static int s3c_rtc_resume(struct platform_device *pdev)
+static int s3c_rtc_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	unsigned int tmp;
 
 	clk_enable(rtc_clk);
@@ -623,7 +625,7 @@ static int s3c_rtc_resume(struct platform_device *pdev)
 		writew(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
 	}
 
-	if (device_may_wakeup(&pdev->dev) && wake_en) {
+	if (device_may_wakeup(dev) && wake_en) {
 		disable_irq_wake(s3c_rtc_alarmno);
 		wake_en = false;
 	}
@@ -631,11 +633,10 @@ static int s3c_rtc_resume(struct platform_device *pdev)
 
 	return 0;
 }
-#else
-#define s3c_rtc_suspend NULL
-#define s3c_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(s3c_rtc_pm_ops, s3c_rtc_suspend, s3c_rtc_resume);
+
 #ifdef CONFIG_OF
 static struct s3c_rtc_drv_data s3c_rtc_drv_data_array[] = {
 	[TYPE_S3C2410] = { TYPE_S3C2410 },
@@ -685,12 +686,11 @@ MODULE_DEVICE_TABLE(platform, s3c_rtc_driver_ids);
 static struct platform_driver s3c_rtc_driver = {
 	.probe		= s3c_rtc_probe,
 	.remove		= s3c_rtc_remove,
-	.suspend	= s3c_rtc_suspend,
-	.resume		= s3c_rtc_resume,
 	.id_table	= s3c_rtc_driver_ids,
 	.driver		= {
 		.name	= "s3c-rtc",
 		.owner	= THIS_MODULE,
+		.pm	= &s3c_rtc_pm_ops,
 		.of_match_table	= of_match_ptr(s3c_rtc_dt_match),
 	},
 };
-- 
1.7.2.5



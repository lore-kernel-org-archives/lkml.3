Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3DQBI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:08:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14212 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab3DQBI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:08:58 -0400
X-AuditID: cbfee68e-b7f946d000001e37-8b-516df62900c6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
In-reply-to: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
Subject: [PATCH RESEND 7/8] rtc: rtc-stmp3xxx: convert stmp3xxx_rtcdrv to
 dev_pm_ops
Date: Wed, 17 Apr 2013 10:08:56 +0900
Message-id: <003601ce3b08$22c70ad0$68552070$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B9XUIMaX4YjsSbW0FEYgtMIOOAAAENaw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zfV3Nb7mBBt93c1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0bzzGFPBFP6KpecfMjYwXubpYuTkkBAwkZh75QMLhC0mceHeerYuRi4OIYFljBI/
	P51ngSla++82M0RiEaPEzp7PLBDOL0aJrUv+sYNUsQmoSXz5chjI5uAQEdCXaGvRAKlhFuhl
	lDjTuxusRkjAVuJmxyEmEJtTwE7i25E7jCC2sECYxOJpr9hAbBYBVYm9X/eDbeYFqv8z6zIz
	hC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJgJNG+7y47RImIxL4X7xhB
	7pEQeMQu0XK1iQVil4DEt8mHWCB6ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEj
	yypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkFjt28F484D1IcZkoPUTmaVEk/OBsZ5XEm9o
	bGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsY1T6dMcfvC
	rlXHWZFzQm7uqVULVpgxiT1OZjH8+Gh6+FS/Vx2ttTeVk5zZtF9puAX9jWQ/8Zx1VuYu3anm
	Bx9Ff2OtfizRIOrmd4XZu5ZtX/fcrYy1hn5NgXNE/jKdqp3N4GIcb6+mKOW5O2uXF7Pn/lui
	AfPX/d+g7F9iWXzPtHYvt/e7c0osxRmJhlrMRcWJADmFxuzrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAV3Nb7mBBn3n2C2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzGjeeYypYAp/xdLzDxkbGC/zdDFyckgImEis
	/XebGcIWk7hwbz1bFyMXh5DAIkaJnT2fWSCcX4wSW5f8YwepYhNQk/jy5TCQzcEhIqAv0dai
	AVLDLNDLKHGmdzdYjZCArcTNjkNMIDangJ3EtyN3GEFsYYEwicXTXrGB2CwCqhJ7v+5nAbF5
	ger/zLrMDGELSvyYfA8sziygJbF+53EmCFteYvOat8wgeyUE1CUe/dUFCYsIGEm077vLDlEi
	IrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgR
	PJPewbiqweIQowAHoxIP74WC3EAh1sSy4srcQ4wSHMxKIryKq4BCvCmJlVWpRfnxRaU5qcWH
	GJOBHp3ILCWanA9MUnkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLE
	wSnVwKj257h42fRNa9uFJpy4wV4rdvHD+kNXbwrtyc9/rnvn3apLD8uru69LqPScup/Y1P1b
	MPCD0Ne+RQpbSn0qJkrtNPpvErx8v8k2ke/PXZtXK57aHdIUfCr66sHmtMhmr6rVq99l6THc
	vNu8yZdxWZJcMtsGbS6P5Gmzzz9/fLJl211r/v22cWeVWIozEg21mIuKEwG6VokySAMAAA==
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
 drivers/rtc/rtc-stmp3xxx.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 67d2612..30eacdb 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -307,15 +307,15 @@ out_free:
 	return err;
 }
 
-#ifdef CONFIG_PM
-static int stmp3xxx_rtc_suspend(struct platform_device *dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int stmp3xxx_rtc_suspend(struct device *dev)
 {
 	return 0;
 }
 
-static int stmp3xxx_rtc_resume(struct platform_device *dev)
+static int stmp3xxx_rtc_resume(struct device *dev)
 {
-	struct stmp3xxx_rtc_data *rtc_data = platform_get_drvdata(dev);
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	stmp_reset_block(rtc_data->io);
 	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
@@ -324,11 +324,11 @@ static int stmp3xxx_rtc_resume(struct platform_device *dev)
 			rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
 	return 0;
 }
-#else
-#define stmp3xxx_rtc_suspend	NULL
-#define stmp3xxx_rtc_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(stmp3xxx_rtc_pm_ops, stmp3xxx_rtc_suspend,
+			stmp3xxx_rtc_resume);
+
 static const struct of_device_id rtc_dt_ids[] = {
 	{ .compatible = "fsl,stmp3xxx-rtc", },
 	{ /* sentinel */ }
@@ -338,11 +338,10 @@ MODULE_DEVICE_TABLE(of, rtc_dt_ids);
 static struct platform_driver stmp3xxx_rtcdrv = {
 	.probe		= stmp3xxx_rtc_probe,
 	.remove		= stmp3xxx_rtc_remove,
-	.suspend	= stmp3xxx_rtc_suspend,
-	.resume		= stmp3xxx_rtc_resume,
 	.driver		= {
 		.name	= "stmp3xxx-rtc",
 		.owner	= THIS_MODULE,
+		.pm	= &stmp3xxx_rtc_pm_ops,
 		.of_match_table = of_match_ptr(rtc_dt_ids),
 	},
 };
-- 
1.7.2.5



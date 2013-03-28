Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3C1Ijy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:39:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41704 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3C1Ijv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:39:51 -0400
X-AuditID: cbfee690-b7f656d0000007e3-47-515401d661cd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
In-reply-to: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
Subject: [PATCH 8/8] rtc: rtc-twl: convert twl4030rtc_driver to dev_pm_ops
Date: Thu, 28 Mar 2013 17:39:50 +0900
Message-id: <001701ce2b8f$cfd58e00$6f80aa00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rj2FhCGvCEF7CQ36UwoHUUgpQOwAAGKIg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ91rjCGBBqcfW1gsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsfupSMEv3orvl08zNjDu5+5i5OSQEDCRWHv7NjuELSZx4d56ti5GLg4hgWWMEruu
	7mCBKVp+agIrRGI6o8TEP/+ZIJxfjBL//95lBqliE1CT+PLlMNAoDg4RAX2JthYNkBpmgV5G
	iTO9u8FWCAnYSpw7fBWsnlPATqJ9zVawDcICXhIzdk1nArFZBFQljt0/wgpi8wLVz5o7lwnC
	FpT4MfkeWD2zgJbE+p3HmSBseYnNa94yg+yVEFCXePRXFyQsImAk0XGyA6pcRGLfi3eMIPdI
	CNxjlzh0+wU7xC4BiW+TD7FA9MpKbDrADPGwpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZV
	jKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGCGROmEH470D1ocYk4HWT2SWEk3OB0Z6Xkm8obGZ
	kYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYAw/xCXfNPhBz
	YO7WB3XzVOZphW297LF/hoPN4tLNU747shQ6HO13O5SaECcs+ufXXAeTtrOL0tRnPTq2Svf2
	oYAl+l8f3QgUtf6RJM1aG839XOfApjnXPNf2X8sMrHvD2rBJKuXztjNCLVcstwg5rcrtrvrU
	MYu1V8PSYELIRQ7u/SeUSzteKbEUZyQaajEXFScCAGQ+2OfqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd1rjCGBBq+umFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLH7qUjBL96K75dPMzYw7ufuYuTkkBAwkVh+
	agIrhC0mceHeerYuRi4OIYHpjBIT//xngnB+MUr8/3uXGaSKTUBN4suXw+xdjBwcIgL6Em0t
	GiA1zAK9jBJnenezg9QICdhKnDt8FayeU8BOon3NVhYQW1jAS2LGrulMIDaLgKrEsftHwDbz
	AtXPmjuXCcIWlPgx+R5YPbOAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcXJCwiYCTRcbIDqlxE
	Yt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcBp4
	Jr2DcVWDxSFGAQ5GJR7eCoHgQCHWxLLiytxDjBIczEoivIc6gUK8KYmVValF+fFFpTmpxYcY
	k4EencgsJZqcD0xReSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXAOIWPN1N7x1rvtaaH4jwZt5+6NGtOI7PVt89v3grVTeOVYdHMC/dZOs9nFe/eaSdmJjwy
	/t4s7PhvQ4Viv/BsC5aWjCXWGVu+59vmrY1cupF9Q7hsx47MFPWSuVNs86zZi0uY5SJiqw1C
	1SaY3HbzD73yXqzmn3jbAquyk+uzinn4TV2yjQ4psRRnJBpqMRcVJwIAhv8BnkcDAAA=
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
 drivers/rtc/rtc-twl.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 8bc6c80..8751a52 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -566,11 +566,10 @@ static void twl_rtc_shutdown(struct platform_device *pdev)
 	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static unsigned char irqstat;
 
-static int twl_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int twl_rtc_suspend(struct device *dev)
 {
 	irqstat = rtc_irq_bits;
 
@@ -578,17 +577,15 @@ static int twl_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int twl_rtc_resume(struct platform_device *pdev)
+static int twl_rtc_resume(struct device *dev)
 {
 	set_rtc_irq_bit(irqstat);
 	return 0;
 }
-
-#else
-#define twl_rtc_suspend NULL
-#define twl_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(twl_rtc_pm_ops, twl_rtc_suspend, twl_rtc_resume);
+
 #ifdef CONFIG_OF
 static const struct of_device_id twl_rtc_of_match[] = {
 	{.compatible = "ti,twl4030-rtc", },
@@ -603,11 +600,10 @@ static struct platform_driver twl4030rtc_driver = {
 	.probe		= twl_rtc_probe,
 	.remove		= twl_rtc_remove,
 	.shutdown	= twl_rtc_shutdown,
-	.suspend	= twl_rtc_suspend,
-	.resume		= twl_rtc_resume,
 	.driver		= {
 		.owner		= THIS_MODULE,
 		.name		= "twl_rtc",
+		.pm		= &twl_rtc_pm_ops,
 		.of_match_table = of_match_ptr(twl_rtc_of_match),
 	},
 };
-- 
1.7.2.5



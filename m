Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab3DQBIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:08:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33054 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab3DQBIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:08:01 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-e8-516df5ef20af
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
In-reply-to: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
Subject: [PATCH RESEND 4/8] rtc: rtc-omap: convert omap_rtc_driver to dev_pm_ops
Date: Wed, 17 Apr 2013 10:07:59 +0900
Message-id: <003301ce3b08$00b06360$02112a20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B9XUIMaX4YjsSbW0FEYgtMIOOAAAB23w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ90PX3MDDV4XWSy5eJXdYs76NWwW
	lxdeYrW4vGsOm8X+zg5GB1aPPRNPsnmcmPGbxaNvyypGj+nzfjJ5fN4kF8AaxWWTkpqTWZZa
	pG+XwJWx8fBh1oKbwhVHf2xha2BcLdDFyMkhIWAisWV/EwuELSZx4d56ti5GLg4hgWWMEl83
	3WSFKXpx4xkTRGI6o8Shg7eZIZxfjBKvWnYwglSxCahJfPlymL2LkYNDREBfoq1FA6SGWaCX
	UeJM7252kBohAVuJmx2HmEBsTgE7iW9H7oD1CgsESMyY2gFmswioSpw49xvsJF6g+nObZzFC
	2IISPybfA4szC2hJrN95nAnClpfYvOYtM8heCQF1iUd/dSFOMJKYONEOokJEYt+Ld4wg50gI
	3GOXWPX3FRPEKgGJb5MPsUC0ykpsOsAM8a+kxMEVN1gmMErMQrJ4FpLFs5AsnoVkxQJGllWM
	oqkFyQXFSelFpnrFibnFpXnpesn5uZsYIXE6cQfj/QPWhxiTgdZPZJYSTc4HxnleSbyhsZmR
	hamJqbGRuaUZacJK4rzqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgtAlIutz++o/Bt
	u/3mAyGe4XOyBVKu3UhlXvyweq6en1bzLNGtLFsXP1898cX3RZs2CpzL2vsoTCImyWrVhd+X
	N76VCd65bsms+5dO7tUKyNSKCfIz1/66gNVki2DF5OXuL+8uVsl9+MJRYcuvywvYtJ3Wb5b6
	kGniuSVTzlown//1vwecHzTjlViKMxINtZiLihMBZ66MlOkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd33X3MDDZoXW1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLHx8GHWgpvCFUd/bGFrYFwt0MXIySEhYCLx
	4sYzJghbTOLCvfVsXYxcHEIC0xklDh28zQzh/GKUeNWygxGkik1ATeLLl8PsXYwcHCIC+hJt
	LRogNcwCvYwSZ3p3s4PUCAnYStzsOAQ2lVPATuLbkTtgvcICARIzpnaA2SwCqhInzv1mAbF5
	gerPbZ7FCGELSvyYfA8sziygJbF+53EmCFteYvOat8wgeyUE1CUe/dWFOMFIYuJEO4gKEYl9
	L94xTmAUmoVk0Cwkg2YhGTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFp4Jn0
	DsZVDRaHGAU4GJV4eC8U5AYKsSaWFVfmHmKU4GBWEuFVXAUU4k1JrKxKLcqPLyrNSS0+xJgM
	9OdEZinR5HxgisoriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6p
	BkaxQgdNfRvvGetlvV/ttJ12yXz2vRkVom9PfJgdPGlXlXhx73KNxYuP7eYSVP3aHMr9+czZ
	Xz3MNhWCARvz/Sb+Sd3wu1Q28GzON6HttT2ZyddU474Y/2g14WZ/ddrr4NUpKpqfNljdz+dp
	1G0wfZv2o1bwoktKl5Qf36yvt57rvgiTNX/rLabEUpyRaKjFXFScCABJYU41RwMAAA==
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



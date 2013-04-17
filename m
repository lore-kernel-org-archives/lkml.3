Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935217Ab3DQBDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:03:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23844 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3DQBDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:03:01 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-27-516df4c37282
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH RESEND 1/3] backlight: omap1: convert omapbl to dev_pm_ops
Date: Wed, 17 Apr 2013 10:02:58 +0900
Message-id: <002d01ce3b07$4d838d80$e88aa880$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B00Xwwr4eF6YRha9Jkf5kKWYlA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zQ93DX3IDDRo65S3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroye3RfY
	Cj7zV3SfX8ncwLiIt4uRk0NCwETidf9NRghbTOLCvfVsXYxcHEICyxglGvdfZoYpenJxKyuI
	LSSwiFHi3C0BiKJfjBL/jtxhA0mwCahJfPlymL2LkYNDREBfoq1FAyTMLFAqsfXBexYQW1jA
	S2LR3YNgc1gEVCUu7exhB7F5BWwldq+ezQphC0r8mHyPBaJXS2L9zuNMELa8xOY1b5lBxksI
	qEs8+qsLEhYR0JPYvWcHI0SJiMS+F+8YQU6TENjGLnG8+wYzxC4BiW+TD7FA9MpKbDoA9Zak
	xMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYITHW
	v4Px7gHrQ4zJQOsnMkuJJucDYzSvJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYw5brqCmxrq7odG/tHimcjftO7//ee2NRPX3XuQpJE248cbPVPd
	Pazap0M/NVs8OHI1WHaOgeHTQyKWJw+6rgyennqNZVvVrWz+lJQMOc97z+uWyTsFvnf+LtCm
	LsaWXjh/k2rm1+flYjvELDj1uRuPPCi5beWv583VOW3fz6A+xf5jFlE/DyqxFGckGmoxFxUn
	AgBxk20+xwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd3DX3IDDeZ3S1vMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZPbsvsBV85q/oPr+SuYFxEW8XIyeHhICJxJOLW1khbDGJC/fW
	s4HYQgKLGCXO3RLoYuQCsn8xSvw7cgcswSagJvHly2H2LkYODhEBfYm2Fg2QMLNAqcTWB+9Z
	QGxhAS+JRXcPgs1kEVCVuLSzhx3E5hWwldi9ejYrhC0o8WPyPRaIXi2J9TuPM0HY8hKb17xl
	BhkvIaAu8eivLkhYREBPYveeHYwQJSIS+168Y5zAKDALyaRZSCbNQjJpFpKWBYwsqxhFUwuS
	C4qT0nON9IoTc4tL89L1kvNzNzGCI/iZ9A7GVQ0WhxgFOBiVeHgvFOQGCrEmlhVX5h5ilOBg
	VhLhVVwFFOJNSaysSi3Kjy8qzUktPsSYDPToRGYp0eR8YHLJK4k3NDYxM7I0MrMwMjE3J01Y
	SZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGppz7yU9ORIv/bbKYNdtw5aPE6aZza5e4CQd4
	Hb9VK/Ky+3GC+4HUM9v8zXvsN05cJNi4I8J29nT7MzN2c61oe/vM+lGh3uuvlcdm/Fh5RWWp
	+438WRPiX21YYJ+umsNtGpN26mB7fcqtvITkSy8fz7zxzFJWdWPtceYb7o8+z/Cz+lOS1/lj
	mxJLcUaioRZzUXEiAEFNQZYkAwAA
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
 drivers/video/backlight/omap1_bl.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 0aed176..812e22e 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -71,27 +71,24 @@ static void omapbl_blank(struct omap_backlight *bl, int mode)
 	}
 }
 
-#ifdef CONFIG_PM
-static int omapbl_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int omapbl_suspend(struct device *dev)
 {
-	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = bl_get_data(dev);
+	struct backlight_device *bl_dev = dev_get_drvdata(dev);
+	struct omap_backlight *bl = bl_get_data(bl_dev);
 
 	omapbl_blank(bl, FB_BLANK_POWERDOWN);
 	return 0;
 }
 
-static int omapbl_resume(struct platform_device *pdev)
+static int omapbl_resume(struct device *dev)
 {
-	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = bl_get_data(dev);
+	struct backlight_device *bl_dev = dev_get_drvdata(dev);
+	struct omap_backlight *bl = bl_get_data(bl_dev);
 
 	omapbl_blank(bl, bl->powermode);
 	return 0;
 }
-#else
-#define omapbl_suspend	NULL
-#define omapbl_resume	NULL
 #endif
 
 static int omapbl_set_power(struct backlight_device *dev, int state)
@@ -182,13 +179,14 @@ static int omapbl_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(omapbl_pm_ops, omapbl_suspend, omapbl_resume);
+
 static struct platform_driver omapbl_driver = {
 	.probe		= omapbl_probe,
 	.remove		= omapbl_remove,
-	.suspend	= omapbl_suspend,
-	.resume		= omapbl_resume,
 	.driver		= {
 		.name	= "omap-bl",
+		.pm	= &omapbl_pm_ops,
 	},
 };
 
-- 
1.7.2.5



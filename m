Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3CLFuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:50:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30319 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3CLFt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:49:59 -0400
X-AuditID: cbfee68e-b7f946d000001e37-33-513ec2065b9a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 03/14] backlight: s6e63m0: convert s6e63m0 to dev_pm_ops
Date: Tue, 12 Mar 2013 14:49:57 +0900
Message-id: <004001ce1ee5$6dd717c0$49854740$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAABPww
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI122Q3aBBrdesFvMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBl/d/5m
	L7glUNG0pIO5gfElbxcjJ4eEgIlE76Y1bBC2mMSFe+uBbC4OIYFljBLNZ24zwhSd27CICSIx
	nVFi+boJUFW/GCUevL7AAlLFJqAm8eXLYfYuRg4OEQF9ibYWDZAws0CpxNYH78FKhARsJe6u
	f84IUsIpYCex5W8WSFhYwENi35aXYLtYBFQlnrQdAyvnBSo/0XSJDcIWlPgx+R4LxEgtifU7
	jzNB2PISm9e8ZQYZKSGgLvHory5IWETASOL3jBY2iBIRiX0v3jGCXCwhcIld4s3kD8wQuwQk
	vk0+xALRKyux6QAzxLuSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXGekV
	J+YWl+al6yXn525ihMRk3w7GmwesDzEmA62fyCwlmpwPjOm8knhDYzMjC1MTU2Mjc0sz0oSV
	xHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAWCqa/WVm/jP/K20mqNe9yqqNf7F8/
	8dyEafIVf/P/5K4tlVatf+Py78q/Pfp35Xg0ZSu/BHH5uqndviifXLFD1ICvUyhgXkT18qVi
	l26s5fE5s2RNgupWo8V5pfsXR/8x325vdH1Tyd9r3y1nRGb4X5E7su38v7xUlvAA7aU31z9Z
	7/TpgcVtJZbijERDLeai4kQArPjEjN8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQV22Q3aBBu8vM1vMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZf3f+Zi+4JVDRtKSDuYHxJW8XIyeHhICJxLkNi5ggbDGJC/fW
	s3UxcnEICUxnlFi+bgKU84tR4sHrCywgVWwCahJfvhxm72Lk4BAR0Jdoa9EACTMLlEpsffAe
	rERIwFbi7vrnjCAlnAJ2Elv+ZoGEhQU8JPZteckIYrMIqEo8aTsGVs4LVH6i6RIbhC0o8WPy
	PRaIkVoS63ceZ4Kw5SU2r3nLDDJSQkBd4tFfXZCwiICRxO8ZLWwQJSIS+168Y5zAKDQLyaRZ
	SCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/6Z1A7GlQ0WhxgFOBiV
	eHgVv9kGCrEmlhVX5h5ilOBgVhLhzdhsFyjEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cBk
	lFcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjAolLC8eWnNf
	0K0zerVs7m2bldZvggrW6PbdZ4x4O2N+9eKVOTt6xDeGfJ6SOUUkx2bnop61O/RqJPQVVeNu
	8i1lfTp3z7tUg1D1tMd1296fcuxo1Fv+eF77q5yZdjscvTbnnJ3nxts/k0nU6+cnuYb9J97s
	uHTFfh9TtdVrhmKlBUlW3Kfe9yuxFGckGmoxFxUnAgDF+HIZPAMAAA==
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
 drivers/video/backlight/s6e63m0.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 9c2677f..b37bb18 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -817,12 +817,12 @@ static int s6e63m0_remove(struct spi_device *spi)
 	return 0;
 }
 
-#if defined(CONFIG_PM)
-static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int s6e63m0_suspend(struct device *dev)
 {
-	struct s6e63m0 *lcd = spi_get_drvdata(spi);
+	struct s6e63m0 *lcd = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+	dev_dbg(dev, "lcd->power = %d\n", lcd->power);
 
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
@@ -831,19 +831,18 @@ static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
 	return s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int s6e63m0_resume(struct spi_device *spi)
+static int s6e63m0_resume(struct device *dev)
 {
-	struct s6e63m0 *lcd = spi_get_drvdata(spi);
+	struct s6e63m0 *lcd = dev_get_drvdata(dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
 	return s6e63m0_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define s6e63m0_suspend		NULL
-#define s6e63m0_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(s6e63m0_pm_ops, s6e63m0_suspend, s6e63m0_resume);
+
 /* Power down all displays on reboot, poweroff or halt. */
 static void s6e63m0_shutdown(struct spi_device *spi)
 {
@@ -856,12 +855,11 @@ static struct spi_driver s6e63m0_driver = {
 	.driver = {
 		.name	= "s6e63m0",
 		.owner	= THIS_MODULE,
+		.pm	= &s6e63m0_pm_ops,
 	},
 	.probe		= s6e63m0_probe,
 	.remove		= s6e63m0_remove,
 	.shutdown	= s6e63m0_shutdown,
-	.suspend	= s6e63m0_suspend,
-	.resume		= s6e63m0_resume,
 };
 
 module_spi_driver(s6e63m0_driver);
-- 
1.7.2.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab3CLFuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:50:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20328 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3CLFuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:50:17 -0400
X-AuditID: cbfee690-b7f656d0000007e3-22-513ec2177fd4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 04/14] backlight: adp5520: convert adp5520_bl to dev_pm_ops
Date: Tue, 12 Mar 2013 14:50:15 +0900
Message-id: <004101ce1ee5$7842c970$68c85c50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAACaKg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zfV2JQ3aBBmuNLOasX8NmcXnhJVaL
	y7vmsFns3vWU1YHF48SM3ywee+b/YPXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujK936wra
	+CpWTrnE3MD4iLuLkYNDQsBE4vZ05S5GTiBTTOLCvfVsXYxcHEICyxglXqx4yQiRMJHYufsG
	I0RiOqPEnWf3WSGcX4wSKzadAatiE1CT+PLlMDvIVBEBfYm2Fg2QMLNAqcTWB+9ZQGwhAVuJ
	u+ufM4KUcArYSWz5mwUSFhbwlvj49yMTiM0ioCrx4v0FsHJeoPKNU5qZIWxBiR+T77FAjNSS
	WL/zOBOELS+xec1bZohf1CUe/dUFCYsIGEl0X5oPVS4ise/FO6hXzrFL/NjtALFKQOLb5EMs
	EK2yEpsOMEOUSEocXHGDZQKjxCwki2chWTwLyeJZSDYsYGRZxSiaWpBcUJyUXmSiV5yYW1ya
	l66XnJ+7iRESixN2MN47YH2IMRlo/URmKdHkfGAs55XEGxqbGVmYmpgaG5lbmpEmrCTOq95i
	HSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkeHFi+1b+y5Y3b+7Man1i4tNfYFO7lEJrr8W
	sk+q7zo11fcr/TgZ6PYvOOTChZu2qScupenP+7FReHqRhc2i+z9Mr9aV7cp4VZmXOlPT9VJL
	O7PUXLWWN4YStmrdBm/lZFbdu5+6aP3zftVlUzk+3JrD63f57zYxW6E3h448eLdRkiF9176N
	n5VYijMSDbWYi4oTARTPZfLbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQV3xQ3aBBqdXW1rMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZX+/WFbTxVayccom5gfERdxcjJ4eEgInEzt03GCFsMYkL99az
	dTFycQgJTGeUuPPsPiuE84tRYsWmM2BVbAJqEl++HGbvYuTgEBHQl2hr0QAJMwuUSmx98J4F
	xBYSsJW4u/45I0gJp4CdxJa/WSBhYQFviY9/PzKB2CwCqhIv3l8AK+cFKt84pZkZwhaU+DH5
	HgvESC2J9TuPM0HY8hKb17xlBhkpIaAu8eivLkhYRMBIovvSfKhyEYl9L94xTmAUmoVk0iwk
	k2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHx/kxqB+PKBotDjAIcjEo8
	vIrfbAOFWBPLiitzDzFKcDArifBmbLYLFOJNSaysSi3Kjy8qzUktPsSYDPToRGYp0eR8YCrK
	K4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGhS26T1nfl0dt
	fNg04d2h4L0rrR0YJpzweme1c+n3t+u/TOh7zONSJc4hve/vnCVTrzgLPHt83MhHuZ6ZdWNs
	0KHMhqAj6ZIzGn7sPLqj1KYq/qR+vsC0rok1KU+uOit9ya/Y+mZjW9aZlmfRG2bJ33tlc7ao
	Y2agnnLm77nuJ6Uzt4U+M728UYmlOCPRUIu5qDgRAK+x++k7AwAA
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
 drivers/video/backlight/adp5520_bl.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index a1e41d4..962d120 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -349,35 +349,34 @@ static int adp5520_bl_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int adp5520_bl_suspend(struct platform_device *pdev,
-				 pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int adp5520_bl_suspend(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
+
 	return adp5520_bl_set(bl, 0);
 }
 
-static int adp5520_bl_resume(struct platform_device *pdev)
+static int adp5520_bl_resume(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	backlight_update_status(bl);
 	return 0;
 }
-#else
-#define adp5520_bl_suspend	NULL
-#define adp5520_bl_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(adp5520_bl_pm_ops, adp5520_bl_suspend,
+			adp5520_bl_resume);
+
 static struct platform_driver adp5520_bl_driver = {
 	.driver		= {
 		.name	= "adp5520-backlight",
 		.owner	= THIS_MODULE,
+		.pm	= &adp5520_bl_pm_ops,
 	},
 	.probe		= adp5520_bl_probe,
 	.remove		= adp5520_bl_remove,
-	.suspend	= adp5520_bl_suspend,
-	.resume		= adp5520_bl_resume,
 };
 
 module_platform_driver(adp5520_bl_driver);
-- 
1.7.2.5



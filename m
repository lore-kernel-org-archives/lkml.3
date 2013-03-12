Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab3CLFwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:52:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57341 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3CLFwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:52:43 -0400
X-AuditID: cbfee68e-b7f946d000001e37-42-513ec2aae32a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 11/14] backlight: lm3533_bl: convert lm3533_bl to dev_pm_ops
Date: Tue, 12 Mar 2013 14:52:41 +0900
Message-id: <004801ce1ee5$cfa7d570$6ef78050$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAAHudA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI91Vh+wCDX7v5LeYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDKuXZzD
	VrBQoOLF2m6mBsbrvF2MnBwSAiYSbd9Xs0HYYhIX7q0Hsrk4hASWMUr8m3uZEaZoU38bC0Ri
	OqPEuw+nmCCcX4wSx64sYwapYhNQk/jy5TB7FyMHh4iAvkRbiwZImFmgVGLrg/csILaQgK3E
	3fXPGUFKOAXsJLb8zQIJCwv4SGxYtxlsCouAqsT9a1uZQGxeoPI3rw+wQNiCEj8m32OBGKkl
	sX7ncSYIW15i85q3zCAjJQTUJR791YU4wEhi2pVyiAoRiX0v3jGCHCwhcI5dYt+HlSwQqwQk
	vk0+xALRKiux6QAzxLeSEgdX3GCZwCgxC8niWUgWz0KyeBaSFQsYWVYxiqYWJBcUJ6UXGekV
	J+YWl+al6yXn525ihERk3w7GmwesDzEmA62fyCwlmpwPjOi8knhDYzMjC1MTU2Mjc0sz0oSV
	xHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBq/P/NeHaHQP/JRZ5PFnWcF7K5q197
	55/r6ZdOc+4k8/7MKDz+cn3W2Rl+dz7eub4s1Oy+xIf9HkeO/JuZz5y0uTFTQ4DvAMdfIavb
	OzgyVYtnzzq5+0Gal5Hkr2h97nU3zDjTjq3VUW5pWfdlV1PQ2cRF0/dlBYbMbLl+vLT/RORh
	7iXPOA8sU2Ipzkg01GIuKk4EAPvRv77eAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd1Vh+wCDSZc5LaYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzrl2cw1awUKDixdpupgbG67xdjJwcEgImEpv621ggbDGJC/fW
	s3UxcnEICUxnlHj34RQThPOLUeLYlWXMIFVsAmoSX74cZu9i5OAQEdCXaGvRAAkzC5RKbH3w
	HmyQkICtxN31zxlBSjgF7CS2/M0CCQsL+EhsWLcZbAqLgKrE/WtbmUBsXqDyN68PsEDYghI/
	Jt9jgRipJbF+53EmCFteYvOat8wgIyUE1CUe/dWFOMBIYtqVcogKEYl9L94xTmAUmoVk0Cwk
	g2YhGTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHx/kx6B+OqBotDjAIcjEo8
	vArfbAOFWBPLiitzDzFKcDArifBmbLYLFOJNSaysSi3Kjy8qzUktPsSYDPTnRGYp0eR8YCrK
	K4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGTe8y6i46dXQx
	1pimmt9z7Ug0cDiwdmmBk45YWNxBN9dyXfcul9rjryzsYj+EJ81VC3wXaq4c+C7D1Ud3UtDB
	qz8ZoxdqTeUuf3bj3pOsg4/W57/Qaj3odrJ0p87faTIfHOPthBXaBI8JWc5TZQ53+rM/e9eP
	3BCGjd8tjD/0iplcmhYscl+JpTgj0VCLuag4EQA4ytApOwMAAA==
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
 drivers/video/backlight/lm3533_bl.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index 5d18d4d..1d1dbfb 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -368,29 +368,28 @@ static int lm3533_bl_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int lm3533_bl_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int lm3533_bl_suspend(struct device *dev)
 {
-	struct lm3533_bl *bl = platform_get_drvdata(pdev);
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
 
-	dev_dbg(&pdev->dev, "%s\n", __func__);
+	dev_dbg(dev, "%s\n", __func__);
 
 	return lm3533_ctrlbank_disable(&bl->cb);
 }
 
-static int lm3533_bl_resume(struct platform_device *pdev)
+static int lm3533_bl_resume(struct device *dev)
 {
-	struct lm3533_bl *bl = platform_get_drvdata(pdev);
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
 
-	dev_dbg(&pdev->dev, "%s\n", __func__);
+	dev_dbg(dev, "%s\n", __func__);
 
 	return lm3533_ctrlbank_enable(&bl->cb);
 }
-#else
-#define lm3533_bl_suspend	NULL
-#define lm3533_bl_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(lm3533_bl_pm_ops, lm3533_bl_suspend, lm3533_bl_resume);
+
 static void lm3533_bl_shutdown(struct platform_device *pdev)
 {
 	struct lm3533_bl *bl = platform_get_drvdata(pdev);
@@ -404,12 +403,11 @@ static struct platform_driver lm3533_bl_driver = {
 	.driver = {
 		.name	= "lm3533-backlight",
 		.owner	= THIS_MODULE,
+		.pm	= &lm3533_bl_pm_ops,
 	},
 	.probe		= lm3533_bl_probe,
 	.remove		= lm3533_bl_remove,
 	.shutdown	= lm3533_bl_shutdown,
-	.suspend	= lm3533_bl_suspend,
-	.resume		= lm3533_bl_resume,
 };
 module_platform_driver(lm3533_bl_driver);
 
-- 
1.7.2.5



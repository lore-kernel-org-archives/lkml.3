Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3CLFwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:52:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57264 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3CLFwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:52:22 -0400
X-AuditID: cbfee690-b7f656d0000007e3-6c-513ec2957f88
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 10/14] backlight: kb3886_bl: convert kb3886bl to dev_pm_ops
Date: Tue, 12 Mar 2013 14:52:20 +0900
Message-id: <004701ce1ee5$c321f650$4965e2f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAAG9Yw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI92ph+wCDT5sEbS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZZ65cZSyYzV8x4+5MlgbGhzxdjJwcEgImEpv6GlkgbDGJC/fW
	s3UxcnEICSxjlLh+vZcdpujQovdsILaQwCJGiV9tSRBFs5kkTlx5BJZgE1CT+PLlMFADB4eI
	gL5EW4sGSJhZoFRi64P3LBC9thJ31z9nBCnhFLCT2PI3CyQsLOAt8aNvIdgUFgFViRfT2sDW
	8gKV/1l3gRnCFpT4MfkeC8RILYn1O48zQdjyEpvXvGUGGSkhoC7x6K8uSFhEwEji3JMHjBAl
	IhL7XrxjBLlYQmARu8Tl5j2MELsEJL5NPsQC0SsrsekAM8S3khIHV9xgmcAoMQvJ5llINs9C
	snkWkhULGFlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYoRE1YQdjPcOWB9iTAZaP5FZSjQ5
	HxiVeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg
	DLfcJyi27NSCAz/67IKL1biiHWaVXtUUUTu76F661kSF7tznpdmWhlHbk6832PBH33vDZvhR
	qeW7t/cRNeZbG1crfDugrfj6Sart1a/uCrPWBF/YNZHFVmuvpNPasws+OF/20l4vG17zg9Xl
	M5vrKUkVzbAbnFfXSncyPHZ4feZjZtOtzacNlViKMxINtZiLihMBa7NjX8ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO7UQ3aBBjd38lhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjDNXrjIWzOavmHF3JksD
	40OeLkZODgkBE4lDi96zQdhiEhfurQezhQQWMUr8akvqYuQCsmczSZy48ggswSagJvHly2H2
	LkYODhEBfYm2Fg2QMLNAqcTWB+9ZIHptJe6uf84IUsIpYCex5W8WSFhYwFviR99CsCksAqoS
	L6a1sYPYvEDlf9ZdYIawBSV+TL7HAjFSS2L9zuNMELa8xOY1b5lBRkoIqEs8+qsLEhYRMJI4
	9+QBI0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOCYfSa9g3FVg8UhRgEORiUeXoVvtoFCrIllxZW5hxglOJiVRHgzNtsFCvGmJFZWpRbl
	xxeV5qQWH2JMBnp0IrOUaHI+MJ3klcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1
	tSC1CGYLEwenVANj2+nT6UsSNfcFcK1SUjw9e2lJbnTW+jUZDUJKSrNNjk5O0Dle4Xp9du3m
	X9NbFK+c+uQntDmvIiU9tXbJJ2HnR2+3RUzKjNI/wtp/UOvHr0rRPfePaM3lOf0s3/dH+YeQ
	x66B19hMMs37ObZMYDqoPnG7Y5tNMFvH04qD9vU7b/gYLLrTM/etEktxRqKhFnNRcSIA1WUq
	2h0DAAA=
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
 drivers/video/backlight/kb3886_bl.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index 6c5ed6b..bca6ccc 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -106,29 +106,28 @@ static int kb3886bl_send_intensity(struct backlight_device *bd)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int kb3886bl_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int kb3886bl_suspend(struct device *dev)
 {
-	struct backlight_device *bd = platform_get_drvdata(pdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	kb3886bl_flags |= KB3886BL_SUSPENDED;
 	backlight_update_status(bd);
 	return 0;
 }
 
-static int kb3886bl_resume(struct platform_device *pdev)
+static int kb3886bl_resume(struct device *dev)
 {
-	struct backlight_device *bd = platform_get_drvdata(pdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	kb3886bl_flags &= ~KB3886BL_SUSPENDED;
 	backlight_update_status(bd);
 	return 0;
 }
-#else
-#define kb3886bl_suspend	NULL
-#define kb3886bl_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(kb3886bl_pm_ops, kb3886bl_suspend, kb3886bl_resume);
+
 static int kb3886bl_get_intensity(struct backlight_device *bd)
 {
 	return kb3886bl_intensity;
@@ -179,10 +178,9 @@ static int kb3886bl_remove(struct platform_device *pdev)
 static struct platform_driver kb3886bl_driver = {
 	.probe		= kb3886bl_probe,
 	.remove		= kb3886bl_remove,
-	.suspend	= kb3886bl_suspend,
-	.resume		= kb3886bl_resume,
 	.driver		= {
 		.name	= "kb3886-bl",
+		.pm	= &kb3886bl_pm_ops,
 	},
 };
 
-- 
1.7.2.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaCJSru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:47:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37179 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaCJSrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:47:46 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-arm-msm@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] rtc: pm8xxx: move device_init_wakeup() before rtc_register
Date: Mon, 10 Mar 2014 13:44:48 -0500
Message-Id: <1394477089-3996-6-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup wakeup capability before rtc_register to ensure the rtc class core
properly sets up our 'wakealarm' sysfs attribute.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/rtc/rtc-pm8xxx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 6e3cd34..197699f 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -429,6 +429,8 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc_dd);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	/* Register the RTC device */
 	rtc_dd->rtc = devm_rtc_device_register(&pdev->dev, "pm8xxx_rtc",
 					       &pm8xxx_rtc_ops, THIS_MODULE);
@@ -448,8 +450,6 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 		return rc;
 	}
 
-	device_init_wakeup(&pdev->dev, 1);
-
 	dev_dbg(&pdev->dev, "Probe success !!\n");
 
 	return 0;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


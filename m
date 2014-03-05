Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaCETdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:33:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59860 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaCETc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:32:26 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] rtc: pm8xxx: move device_init_wakeup() before rtc_register
Date: Wed,  5 Mar 2014 13:29:35 -0600
Message-Id: <1394047776-13827-6-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup wakeup capability before rtc_register to ensure the rtc class core
properly sets up our 'wakealarm' sysfs attribute.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/rtc/rtc-pm8xxx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index cb5576f..761be65 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -422,6 +422,8 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc_dd);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	/* Register the RTC device */
 	rtc_dd->rtc = devm_rtc_device_register(&pdev->dev, "pm8xxx_rtc",
 					       &pm8xxx_rtc_ops, THIS_MODULE);
@@ -441,8 +443,6 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 		return rc;
 	}
 
-	device_init_wakeup(&pdev->dev, 1);
-
 	dev_dbg(&pdev->dev, "Probe success !!\n");
 
 	return 0;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


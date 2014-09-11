Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaIKHiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:38:19 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45517 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaIKHiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:38:18 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: akpm@linux-foundation.org
Cc: zhangqing@rock-chips.com, xxx@rock-chips.com, dianders@chromium.org,
        heiko@sntech.de, Chris Zhong <zyw@rock-chips.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] RTC: RK808: remove tm_def structure
Date: Thu, 11 Sep 2014 15:37:43 +0800
Message-Id: <1410421063-3028-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the date/time is invalid at bootup, there's no reason to set it to
a bogus value. We can just let the data and time be invalid until
someone makes it valid.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
---

Changes in v2:
Adviced by Doug Anderson
- add a description

 drivers/rtc/rtc-rk808.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/rtc/rtc-rk808.c b/drivers/rtc/rtc-rk808.c
index 22c8514..df42257 100644
--- a/drivers/rtc/rtc-rk808.c
+++ b/drivers/rtc/rtc-rk808.c
@@ -325,17 +325,6 @@ static int rk808_rtc_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(rk808_rtc_pm_ops,
 	rk808_rtc_suspend, rk808_rtc_resume);
 
-/* 2014.1.1 12:00:00 Saturday */
-static struct rtc_time tm_def = {
-	.tm_wday = 6,
-	.tm_year = 114,
-	.tm_mon = 0,
-	.tm_mday = 1,
-	.tm_hour = 12,
-	.tm_min = 0,
-	.tm_sec = 0,
-};
-
 static int rk808_rtc_probe(struct platform_device *pdev)
 {
 	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
@@ -376,10 +365,8 @@ static int rk808_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 	ret = rtc_valid_tm(&tm);
-	if (ret) {
-		dev_warn(&pdev->dev, "invalid date/time and init time\n");
-		rk808_rtc_set_time(&pdev->dev, &tm_def);
-	}
+	if (ret)
+		dev_warn(&pdev->dev, "invalid date/time\n");
 
 	device_init_wakeup(&pdev->dev, 1);
 
-- 
1.7.9.5


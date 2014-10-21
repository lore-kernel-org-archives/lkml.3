Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbaJURpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:45:12 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:56810 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbaJURoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:44:55 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 07/20] rtc: omap: use dev_info
Date: Tue, 21 Oct 2014 19:37:53 +0200
Message-Id: <1413913086-12730-8-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413913086-12730-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_info rather than pr_info.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index c750678de652..dbb88e46c25d 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -427,8 +427,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	/* clear old status */
 	reg = rtc_read(OMAP_RTC_STATUS_REG);
 	if (reg & (u8) OMAP_RTC_STATUS_POWER_UP) {
-		pr_info("%s: RTC power up reset detected\n",
-			pdev->name);
+		dev_info(&pdev->dev, "RTC power up reset detected\n");
 		rtc_write(OMAP_RTC_STATUS_POWER_UP, OMAP_RTC_STATUS_REG);
 	}
 	if (reg & (u8) OMAP_RTC_STATUS_ALARM)
@@ -437,7 +436,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
 	reg = rtc_read(OMAP_RTC_CTRL_REG);
 	if (reg & (u8) OMAP_RTC_CTRL_STOP)
-		pr_info("%s: already running\n", pdev->name);
+		dev_info(&pdev->dev, "already running\n");
 
 	/* force to 24 hour mode */
 	new_ctrl = reg & (OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
@@ -458,7 +457,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	 */
 
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
-		pr_info("%s: split power mode\n", pdev->name);
+		dev_info(&pdev->dev, "split power mode\n");
 
 	if (reg != new_ctrl)
 		rtc_write(new_ctrl, OMAP_RTC_CTRL_REG);
-- 
2.0.4


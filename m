Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3CBHl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 02:41:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51140 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab3CBHlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 02:41:22 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: patches@opensource.wolfsonmicro.com, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] leds: wm8350: Complain if we fail to reenable DCDC
Date: Sat,  2 Mar 2013 15:40:46 +0800
Message-Id: <1362210046-13651-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide some trace, though the hardware is most likely non-functional if
this happens.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/leds/leds-wm8350.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
index ed15157..86bdab3 100644
--- a/drivers/leds/leds-wm8350.c
+++ b/drivers/leds/leds-wm8350.c
@@ -129,7 +129,11 @@ static void wm8350_led_disable(struct wm8350_led *led)
 	ret = regulator_disable(led->isink);
 	if (ret != 0) {
 		dev_err(led->cdev.dev, "Failed to disable ISINK: %d\n", ret);
-		regulator_enable(led->dcdc);
+		ret = regulator_enable(led->dcdc);
+		if (ret != 0) {
+			dev_err(led->cdev.dev, "Failed to reenable DCDC: %d\n",
+				ret);
+		}
 		return;
 	}
 
-- 
1.7.10.4


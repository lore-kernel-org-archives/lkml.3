Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab3CFFDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:03:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42456 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710Ab3CFFDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:03:04 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: patches@opensource.wolfsonmicro.com, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] leds: wm8350: Complain if we fail to reenable DCDC
Date: Wed,  6 Mar 2013 13:01:37 +0800
Message-Id: <1362546097-13740-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide some trace, though the hardware is most likely non-functional if
this happens.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/leds/leds-wm8350.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
index ed15157..8a181d5 100644
--- a/drivers/leds/leds-wm8350.c
+++ b/drivers/leds/leds-wm8350.c
@@ -129,7 +129,10 @@ static void wm8350_led_disable(struct wm8350_led *led)
 	ret = regulator_disable(led->isink);
 	if (ret != 0) {
 		dev_err(led->cdev.dev, "Failed to disable ISINK: %d\n", ret);
-		regulator_enable(led->dcdc);
+		ret = regulator_enable(led->dcdc);
+		if (ret != 0)
+			dev_err(led->cdev.dev, "Failed to reenable DCDC: %d\n",
+				ret);
 		return;
 	}
 
-- 
1.7.10.4


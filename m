Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021AbaGYK3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:29:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54274 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaGYK3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:29:06 -0400
From: Michael Olbrich <m.olbrich@pengutronix.de>
To: Thierry Reding <thierry.reding@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Michael Olbrich <m.olbrich@pengutronix.de>
Subject: [PATCH] pwm-backlight: fix probing from device-tree without enable-gpios
Date: Fri, 25 Jul 2014 12:28:35 +0200
Message-Id: <1406284115-489-1-git-send-email-m.olbrich@pengutronix.de>
X-Mailer: git-send-email 2.0.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: mol@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 257462dbf3ed ("pwm-backlight: switch to gpiod interface")
enable_gpio is no longer set and remains 0 when probing from
device-tree. This is a valid gpio number. With no enable-gpios
specified in the device-tree this is used and probing fails
with:

pwm-backlight lcd-backlight.3: failed to request GPIO#0: -16

Fix this by setting enable_gpio to -1 which is not a valid gpio
number.

Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
---
 drivers/video/backlight/pwm_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 38ca88b..5213d13 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -211,6 +211,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev, "failed to find platform data\n");
 			return ret;
 		}
+		devdata.enable_gpio = -1;
 
 		data = &defdata;
 	}
-- 
2.0.1


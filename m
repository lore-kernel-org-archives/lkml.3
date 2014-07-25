Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbaGYLsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:48:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60917 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaGYLsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:48:13 -0400
From: Michael Olbrich <m.olbrich@pengutronix.de>
To: Thierry Reding <thierry.reding@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Michael Olbrich <m.olbrich@pengutronix.de>
Subject: [PATCH v2] pwm-backlight: fix probing from device-tree without enable-gpios
Date: Fri, 25 Jul 2014 13:47:21 +0200
Message-Id: <1406288841-23140-1-git-send-email-m.olbrich@pengutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406284115-489-1-git-send-email-m.olbrich@pengutronix.de>
References: <1406284115-489-1-git-send-email-m.olbrich@pengutronix.de>
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

Sorry, I sent the wrong version. This one actually compiles.

Michael

 drivers/video/backlight/pwm_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 38ca88b..e7e43cd 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -211,6 +211,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev, "failed to find platform data\n");
 			return ret;
 		}
+		defdata.enable_gpio = -1;
 
 		data = &defdata;
 	}
-- 
2.0.1


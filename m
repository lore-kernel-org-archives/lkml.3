Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3JVR1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:27:17 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64195 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab3JVR1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:27:14 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/9] backlight: atmel-pwm-bl: fix reported brightness
Date: Tue, 22 Oct 2013 19:26:51 +0200
Message-Id: <1382462819-28576-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver supports 16-bit brightness values, but the value returned
from get_brightness was truncated to eight bits.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 66885fb..8aac273 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -70,7 +70,7 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
 static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
 {
 	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
-	u8 intensity;
+	u32 intensity;
 
 	if (pwmbl->pdata->pwm_active_low) {
 		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
@@ -80,7 +80,7 @@ static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
 			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
 	}
 
-	return intensity;
+	return (u16)intensity;
 }
 
 static int atmel_pwm_bl_init_pwm(struct atmel_pwm_bl *pwmbl)
-- 
1.8.4


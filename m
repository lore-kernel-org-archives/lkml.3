Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3JVR1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:27:19 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:59857 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3JVR1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:27:14 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 5/9] backlight: atmel-pwm-bl: clean up get_intensity
Date: Tue, 22 Oct 2013 19:26:55 +0200
Message-Id: <1382462819-28576-6-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up get_intensity to increase readability.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 52a8134..504061c 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -70,15 +70,14 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
 static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
 {
 	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
+	u32 cdty;
 	u32 intensity;
 
-	if (pwmbl->pdata->pwm_active_low) {
-		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
-			pwmbl->pdata->pwm_duty_min;
-	} else {
-		intensity = pwmbl->pdata->pwm_duty_max -
-			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
-	}
+	cdty = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
+	if (pwmbl->pdata->pwm_active_low)
+		intensity = cdty - pwmbl->pdata->pwm_duty_min;
+	else
+		intensity = pwmbl->pdata->pwm_duty_max - cdty;
 
 	return (u16)intensity;
 }
-- 
1.8.4


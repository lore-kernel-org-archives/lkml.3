Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3JWJ4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:56:04 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:61610 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3JWJz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:55:59 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 5/9] backlight: atmel-pwm-bl: clean up get_intensity
Date: Wed, 23 Oct 2013 11:55:39 +0200
Message-Id: <1382522143-32072-6-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up get_intensity to increase readability.

Acked-by: Jingoo Han <jg1.han@samsung.com>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3JaSAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:00:39 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34681 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3JaR6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:58:19 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 5/9] backlight: atmel-pwm-bl: clean up get_intensity
Date: Thu, 31 Oct 2013 18:57:40 +0100
Message-Id: <1383242264-7652-6-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383242264-7652-1-git-send-email-jhovold@gmail.com>
References: <1383064064-4983-1-git-send-email-jhovold@gmail.com>
 <1383242264-7652-1-git-send-email-jhovold@gmail.com>
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
index 01af5c2..abfaada 100644
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
 
 	return intensity & 0xffff;
 }
-- 
1.8.4.2


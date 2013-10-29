Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab3J2QaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:30:06 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:34334 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab3J2Q2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:28:13 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/9] backlight: atmel-pwm-bl: fix reported brightness
Date: Tue, 29 Oct 2013 17:27:36 +0100
Message-Id: <1383064064-4983-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383064064-4983-1-git-send-email-jhovold@gmail.com>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
 <1383064064-4983-1-git-send-email-jhovold@gmail.com>
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
index 66885fb..0971a8e 100644
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
+	return intensity & 0xffff;
 }
 
 static int atmel_pwm_bl_init_pwm(struct atmel_pwm_bl *pwmbl)
-- 
1.8.4.2


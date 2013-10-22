Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3JVR1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:27:25 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:52618 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3JVR1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:27:15 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 7/9] backlight: atmel-pwm-bl: use gpio_is_valid
Date: Tue, 22 Oct 2013 19:26:57 +0200
Message-Id: <1382462819-28576-8-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio_is_valid rather than open coding the more restrictive != -1
test.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index db68cab..ffc30d2 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -48,7 +48,7 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
 		pwm_duty = pwmbl->pdata->pwm_duty_min;
 
 	if (!intensity) {
-		if (pwmbl->gpio_on != -1) {
+		if (gpio_is_valid(pwmbl->gpio_on)) {
 			gpio_set_value(pwmbl->gpio_on,
 					0 ^ pwmbl->pdata->on_active_low);
 		}
@@ -57,7 +57,7 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
 	} else {
 		pwm_channel_enable(&pwmbl->pwmc);
 		pwm_channel_writel(&pwmbl->pwmc, PWM_CUPD, pwm_duty);
-		if (pwmbl->gpio_on != -1) {
+		if (gpio_is_valid(pwmbl->gpio_on)) {
 			gpio_set_value(pwmbl->gpio_on,
 					1 ^ pwmbl->pdata->on_active_low);
 		}
@@ -146,7 +146,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 	if (retval)
 		return retval;
 
-	if (pwmbl->gpio_on != -1) {
+	if (gpio_is_valid(pwmbl->gpio_on)) {
 		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
 					"gpio_atmel_pwm_bl");
 		if (retval)
@@ -196,7 +196,7 @@ static int atmel_pwm_bl_remove(struct platform_device *pdev)
 {
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
-	if (pwmbl->gpio_on != -1) {
+	if (gpio_is_valid(pwmbl->gpio_on)) {
 		gpio_set_value(pwmbl->gpio_on,
 					0 ^ pwmbl->pdata->on_active_low);
 	}
-- 
1.8.4


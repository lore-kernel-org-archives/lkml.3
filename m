Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3JaSAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:00:38 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:43981 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3JaR6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:58:19 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 7/9] backlight: atmel-pwm-bl: use gpio_is_valid
Date: Thu, 31 Oct 2013 18:57:42 +0100
Message-Id: <1383242264-7652-8-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383242264-7652-1-git-send-email-jhovold@gmail.com>
References: <1383064064-4983-1-git-send-email-jhovold@gmail.com>
 <1383242264-7652-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio_is_valid rather than open coding the more restrictive != -1
test.

Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index bfd6a96..c254209 100644
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
1.8.4.2


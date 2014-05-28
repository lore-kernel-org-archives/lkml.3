Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaE1XVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:21:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47829 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755121AbaE1XVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:21:06 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-leds@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 06/15] ARM: at91: remove useless at91_pwm_leds()
Date: Thu, 29 May 2014 01:20:09 +0200
Message-Id: <1401319218-16772-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401319218-16772-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1401319218-16772-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all at91 boards using leds-atmel-pwm switched to leds-pwm, the
at91_pwm_leds() function is not used anymore.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board.h |  1 -
 arch/arm/mach-at91/leds.c  | 37 -------------------------------------
 2 files changed, 38 deletions(-)

diff --git a/arch/arm/mach-at91/board.h b/arch/arm/mach-at91/board.h
index 4e773b55bc2d..836e9a537e0c 100644
--- a/arch/arm/mach-at91/board.h
+++ b/arch/arm/mach-at91/board.h
@@ -123,6 +123,5 @@ extern void __init at91_add_device_can(struct at91_can_data *data);
 
  /* LEDs */
 extern void __init at91_gpio_leds(struct gpio_led *leds, int nr);
-extern void __init at91_pwm_leds(struct gpio_led *leds, int nr);
 
 #endif
diff --git a/arch/arm/mach-at91/leds.c b/arch/arm/mach-at91/leds.c
index 77c4d8fd03fd..eb22e3357e87 100644
--- a/arch/arm/mach-at91/leds.c
+++ b/arch/arm/mach-at91/leds.c
@@ -54,40 +54,3 @@ void __init at91_gpio_leds(struct gpio_led *leds, int nr)
 void __init at91_gpio_leds(struct gpio_led *leds, int nr) {}
 #endif
 
-
-/* ------------------------------------------------------------------------- */
-
-#if defined (CONFIG_LEDS_ATMEL_PWM)
-
-/*
- * PWM Leds
- */
-
-static struct gpio_led_platform_data pwm_led_data;
-
-static struct platform_device at91_pwm_leds_device = {
-	.name			= "leds-atmel-pwm",
-	.id			= -1,
-	.dev.platform_data	= &pwm_led_data,
-};
-
-void __init at91_pwm_leds(struct gpio_led *leds, int nr)
-{
-	int i;
-	u32 pwm_mask = 0;
-
-	if (!nr)
-		return;
-
-	for (i = 0; i < nr; i++)
-		pwm_mask |= (1 << leds[i].gpio);
-
-	pwm_led_data.leds = leds;
-	pwm_led_data.num_leds = nr;
-
-	at91_add_device_pwm(pwm_mask);
-	platform_device_register(&at91_pwm_leds_device);
-}
-#else
-void __init at91_pwm_leds(struct gpio_led *leds, int nr){}
-#endif
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3L3JNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 04:13:35 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53399 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3L3JNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 04:13:33 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Cc: rpurdie@rpsys.net, cooloney@gmail.com
Subject: [PATCH] leds: s3c24xx: Fix build failure
Date: Mon, 30 Dec 2013 14:39:55 +0530
Message-Id: <1388394595-1347-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes following build error.
drivers/leds/leds-s3c24xx.c: In function ‘s3c24xx_led_probe’:
drivers/leds/leds-s3c24xx.c:100:2: error: implicit declaration of
function ‘s3c_gpio_setpull’ [-Werror=implicit-function-declaration]

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Tested at next-20131224.

 drivers/leds/leds-s3c24xx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index 76483fb..87cf215 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -21,6 +21,7 @@
 
 #include <mach/hardware.h>
 #include <mach/regs-gpio.h>
+#include <plat/gpio-cfg.h>
 #include <linux/platform_data/leds-s3c24xx.h>
 
 /* our context */
-- 
1.7.9.5


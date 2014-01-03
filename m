Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750889AbaACF3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:29:51 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:44711 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaACF3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:29:49 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Cc: rpurdie@rpsys.net, cooloney@gmail.com
Subject: [PATCH V2] leds: s3c24xx: Fix build failure
Date: Fri,  3 Jan 2014 10:55:57 +0530
Message-Id: <1388726757-7387-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388394595-1347-1-git-send-email-tushar.behera@linaro.org>
References: <1388394595-1347-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c67d0f29262b ("ARM: s3c24xx: get rid of custom <mach/gpio.h>")
removed the usage of mach/gpio.h file, but we need to include
plat/gpio-cfg.h to avoid following build error.

Fixes following build error.
drivers/leds/leds-s3c24xx.c: In function ‘s3c24xx_led_probe’:
drivers/leds/leds-s3c24xx.c:100:2: error: implicit declaration of
function ‘s3c_gpio_setpull’ [-Werror=implicit-function-declaration]

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes for V2:
* Updated commit message

Bryan,

I should have been more explicit regarding this patch. This patch fixes
build error on linux-next after the above patch was merged.

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


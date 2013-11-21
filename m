Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3KUPkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:40:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47305 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3KUPka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:40:30 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>
CC: <prabhakar.csengg@gmail.com>, <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 1/2] gpio: davinci: get rid of DAVINCI_N_GPIO
Date: Thu, 21 Nov 2013 17:34:35 +0200
Message-ID: <1385048076-7875-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385048076-7875-1-git-send-email-grygorii.strashko@ti.com>
References: <1385048076-7875-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Davinci GPIO driver is moved to support gpiolib it has to use
ARCH_NR_GPIOS (can be configured using CONFIG_ARCH_NR_GPIO Kconfig
option) configuration instead of any mach/platform specific options.

Hence, replace private DAVINCI_N_GPIO with common ARCH_NR_GPIOS. This is
safe because default value for ARCH_NR_GPIOS=256 and maximum number of
supported GPIOs for Davinci is DAVINCI_N_GPIO=144.

More over, this is one of steps to re-use Davinci GPIO driver by other
mach/platform.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/gpio/gpio-davinci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 1f33fcd..944c819 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -160,8 +160,8 @@ static int davinci_gpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (WARN_ON(DAVINCI_N_GPIO < ngpio))
-		ngpio = DAVINCI_N_GPIO;
+	if (WARN_ON(ARCH_NR_GPIOS < ngpio))
+		ngpio = ARCH_NR_GPIOS;
 
 	chips = devm_kzalloc(dev,
 			     ngpio * sizeof(struct davinci_gpio_controller),
-- 
1.7.9.5


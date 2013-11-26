Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab3KZTqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:46:45 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54632 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243Ab3KZToE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:44:04 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-gpio@vger.kernel.org>, <nsekhar@ti.com>
CC: <prabhakar.csengg@gmail.com>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC v1 1/9] gpio: davinci: get rid of DAVINCI_N_GPIO
Date: Tue, 26 Nov 2013 21:40:07 +0200
Message-ID: <1385494815-15740-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
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
index 5bdd9f8..70b5f2f 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -200,8 +200,8 @@ static int davinci_gpio_probe(struct platform_device *pdev)
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


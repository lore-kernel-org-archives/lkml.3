Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaBIIqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 03:46:35 -0500
Received: from gnurou.org ([207.192.72.5]:35644 "EHLO mail.gnurou.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435AbaBIIqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 03:46:17 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] gpiolib: ACPI: remove gpio_to_desc() usage
Date: Sun,  9 Feb 2014 17:43:55 +0900
Message-Id: <1391935435-29002-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1391935435-29002-1-git-send-email-acourbot@nvidia.com>
References: <1391935435-29002-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_to_desc() must die. Replace one of its usage by the
newly-introduced gpiochip_get_desc() function.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
Mika, can we have your review on this?

 drivers/gpio/gpiolib-acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 716ee98..b7db098 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -60,7 +60,7 @@ static struct gpio_desc *acpi_get_gpiod(char *path, int pin)
 	if (pin < 0 || pin > chip->ngpio)
 		return ERR_PTR(-EINVAL);
 
-	return gpio_to_desc(chip->base + pin);
+	return gpiochip_get_desc(chip, pin);
 }
 
 static irqreturn_t acpi_gpio_irq_handler(int irq, void *data)
-- 
1.8.5.4


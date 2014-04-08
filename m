Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbaDHSYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:24:15 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41828 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbaDHSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:21:19 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RFC PATCH 4/5] gpio: twl4030: convert driver to use gpio_chip_ops
Date: Tue,  8 Apr 2014 20:20:14 +0200
Message-Id: <1396981215-24888-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO controller operations has been split to be stored
on a separate struct gpio_chip_ops virtual function table.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/gpio/gpio-twl4030.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index 3ebb1a5..0d40bc0 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -386,15 +386,19 @@ static int twl_to_irq(struct gpio_chip *chip, unsigned offset)
 		: -EINVAL;
 }
 
-static struct gpio_chip template_chip = {
-	.label			= "twl4030",
-	.owner			= THIS_MODULE,
+const struct gpio_chip_ops ops = {
 	.request		= twl_request,
 	.free			= twl_free,
 	.direction_input	= twl_direction_in,
 	.get			= twl_get,
 	.direction_output	= twl_direction_out,
 	.set			= twl_set,
+};
+
+static struct gpio_chip template_chip = {
+	.label			= "twl4030",
+	.owner			= THIS_MODULE,
+	.ops			= &ops,
 	.to_irq			= twl_to_irq,
 	.can_sleep		= true,
 };
-- 
1.9.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaDYQWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:22:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:6991 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaDYQWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:22:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="499798311"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 1/3] Input: gpio_keys - use dev instead of pdev in gpio_keys_setup_key()
Date: Fri, 25 Apr 2014 19:22:15 +0300
Message-Id: <1398442937-15309-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398442937-15309-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1398442937-15309-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform device is not used in gpio_keys_setup_key(). This patch
substitutes it by struct device.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/input/keyboard/gpio_keys.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 2db1324..209d4c6 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -424,13 +424,12 @@ out:
 	return IRQ_HANDLED;
 }
 
-static int gpio_keys_setup_key(struct platform_device *pdev,
+static int gpio_keys_setup_key(struct device *dev,
 				struct input_dev *input,
 				struct gpio_button_data *bdata,
 				const struct gpio_keys_button *button)
 {
 	const char *desc = button->desc ? button->desc : "gpio_keys";
-	struct device *dev = &pdev->dev;
 	irq_handler_t isr;
 	unsigned long irqflags;
 	int irq, error;
@@ -719,7 +718,7 @@ static int gpio_keys_probe(struct platform_device *pdev)
 
 	input->name = pdata->name ? : pdev->name;
 	input->phys = "gpio-keys/input0";
-	input->dev.parent = &pdev->dev;
+	input->dev.parent = dev;
 	input->open = gpio_keys_open;
 	input->close = gpio_keys_close;
 
@@ -736,7 +735,7 @@ static int gpio_keys_probe(struct platform_device *pdev)
 		const struct gpio_keys_button *button = &pdata->buttons[i];
 		struct gpio_button_data *bdata = &ddata->data[i];
 
-		error = gpio_keys_setup_key(pdev, input, bdata, button);
+		error = gpio_keys_setup_key(dev, input, bdata, button);
 		if (error)
 			goto fail2;
 
-- 
1.9.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab3HSXEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:04:47 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:41986 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3HSXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:04:08 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v2 2/3] gpio: pcf857x: Remove pdata argument to pcf857x_irq_domain_init()
Date: Tue, 20 Aug 2013 01:04:53 +0200
Message-Id: <1376953494-9684-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376953494-9684-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376953494-9684-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The argument is not used, remove it. No board registers a pcf857x device
with an IRQ without specifying platform data, IRQ domain registration
behaviour is thus not affected by this change.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpio/gpio-pcf857x.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index ea9f3580..070e81f 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -223,7 +223,6 @@ static void pcf857x_irq_domain_cleanup(struct pcf857x *gpio)
 }
 
 static int pcf857x_irq_domain_init(struct pcf857x *gpio,
-				   struct pcf857x_platform_data *pdata,
 				   struct i2c_client *client)
 {
 	int status;
@@ -286,8 +285,8 @@ static int pcf857x_probe(struct i2c_client *client,
 	gpio->chip.ngpio		= id->driver_data;
 
 	/* enable gpio_to_irq() if platform has settings */
-	if (pdata && client->irq) {
-		status = pcf857x_irq_domain_init(gpio, pdata, client);
+	if (client->irq) {
+		status = pcf857x_irq_domain_init(gpio, client);
 		if (status < 0) {
 			dev_err(&client->dev, "irq_domain init failed\n");
 			goto fail;
@@ -388,7 +387,7 @@ fail:
 	dev_dbg(&client->dev, "probe error %d for '%s'\n",
 			status, client->name);
 
-	if (pdata && client->irq)
+	if (client->irq)
 		pcf857x_irq_domain_cleanup(gpio);
 
 	return status;
@@ -411,7 +410,7 @@ static int pcf857x_remove(struct i2c_client *client)
 		}
 	}
 
-	if (pdata && client->irq)
+	if (client->irq)
 		pcf857x_irq_domain_cleanup(gpio);
 
 	status = gpiochip_remove(&gpio->chip);
-- 
1.8.1.5


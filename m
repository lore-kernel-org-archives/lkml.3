Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab3G2SiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:38:19 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:32852 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3G2SiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:38:13 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 2/3] gpio: pcf857x: Remove pdata argument to pcf857x_irq_domain_init()
Date: Mon, 29 Jul 2013 20:39:04 +0200
Message-Id: <1375123145-31648-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1375123145-31648-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1375123145-31648-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
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


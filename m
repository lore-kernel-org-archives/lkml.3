Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaI3Obl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:31:41 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:42880 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbaI3Obf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:31:35 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH 2/2] led: remove use of gpiochip_remove() retval
Date: Tue, 30 Sep 2014 20:05:07 +0530
Message-Id: <1412087707-8313-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of using return value from gpiochip_remove() as it returns
void.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-leds@vger.kernel.org

Cc: linux-gpio@vger.kernel.org

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/leds/leds-pca9532.c |   10 ++--------
 drivers/leds/leds-tca6507.c |    7 ++-----
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 4a0e786..5a6363d 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -319,14 +319,8 @@ static int pca9532_destroy_devices(struct pca9532_data *data, int n_devs)
 	}
 
 #ifdef CONFIG_LEDS_PCA9532_GPIO
-	if (data->gpio.dev) {
-		int err = gpiochip_remove(&data->gpio);
-		if (err) {
-			dev_err(&data->client->dev, "%s failed, %d\n",
-						"gpiochip_remove()", err);
-			return err;
-		}
-	}
+	if (data->gpio.dev)
+		gpiochip_remove(&data->gpio);
 #endif
 
 	return 0;
diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index 3d9e267..20fa8e7 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -667,11 +667,8 @@ static int tca6507_probe_gpios(struct i2c_client *client,
 
 static void tca6507_remove_gpio(struct tca6507_chip *tca)
 {
-	if (tca->gpio.ngpio) {
-		int err = gpiochip_remove(&tca->gpio);
-		dev_err(&tca->client->dev, "%s failed, %d\n",
-			"gpiochip_remove()", err);
-	}
+	if (tca->gpio.ngpio)
+		gpiochip_remove(&tca->gpio);
 }
 #else /* CONFIG_GPIOLIB */
 static int tca6507_probe_gpios(struct i2c_client *client,
-- 
1.7.9.5


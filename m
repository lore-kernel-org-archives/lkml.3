Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab3BTIgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:36:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38553 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758761Ab3BTIgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:36:15 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeong, Daniel" <Daniel.Jeong@ti.com>
Subject: [PATCH 3/3] leds: lm355x, lm3642: support Camera LED triggers for
 flash/torch
Thread-Topic: [PATCH 3/3] leds: lm355x, lm3642: support Camera LED triggers
 for flash/torch
Thread-Index: Ac4PRVJ3SGmj92PeR3KMCnJVlQN+aA==
Date: Wed, 20 Feb 2013 08:36:05 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F79273681@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LM355x and LM3642 support flash and torch functionality.

 (Camera driver)          (LED trigger for camera)       (LED driver)
 Turn on the flash  ...>  ledtrig_flash_ctrl(true) ...>  LM355x or LM3642
                                                         brightness ctrl
                                                       <actual driving here>

Flash/torch LEDs are controlled by other driver using LED camera trigger
APIs, ledtrig_flash_ctrl()/ledtrig_torch_ctrl().
Then, actual device control is activated by each LED driver such like
LM355x or LM3642.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lm355x.c |    2 ++
 drivers/leds/leds-lm3642.c |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/leds/leds-lm355x.c b/drivers/leds/leds-lm355x.c
index 4117235..d81a8e7 100644
--- a/drivers/leds/leds-lm355x.c
+++ b/drivers/leds/leds-lm355x.c
@@ -477,6 +477,7 @@ static int lm355x_probe(struct i2c_client *client,
 	chip->cdev_flash.name = "flash";
 	chip->cdev_flash.max_brightness = 16;
 	chip->cdev_flash.brightness_set = lm355x_strobe_brightness_set;
+	chip->cdev_flash.default_trigger = "flash";
 	err = led_classdev_register((struct device *)
 				    &client->dev, &chip->cdev_flash);
 	if (err < 0)
@@ -486,6 +487,7 @@ static int lm355x_probe(struct i2c_client *client,
 	chip->cdev_torch.name = "torch";
 	chip->cdev_torch.max_brightness = 8;
 	chip->cdev_torch.brightness_set = lm355x_torch_brightness_set;
+	chip->cdev_torch.default_trigger = "torch";
 	err = led_classdev_register((struct device *)
 				    &client->dev, &chip->cdev_torch);
 	if (err < 0)
diff --git a/drivers/leds/leds-lm3642.c b/drivers/leds/leds-lm3642.c
index 9f428d9..f361bbe 100644
--- a/drivers/leds/leds-lm3642.c
+++ b/drivers/leds/leds-lm3642.c
@@ -363,6 +363,7 @@ static int lm3642_probe(struct i2c_client *client,
 	chip->cdev_flash.name = "flash";
 	chip->cdev_flash.max_brightness = 16;
 	chip->cdev_flash.brightness_set = lm3642_strobe_brightness_set;
+	chip->cdev_flash.default_trigger = "flash";
 	err = led_classdev_register((struct device *)
 				    &client->dev, &chip->cdev_flash);
 	if (err < 0) {
@@ -380,6 +381,7 @@ static int lm3642_probe(struct i2c_client *client,
 	chip->cdev_torch.name = "torch";
 	chip->cdev_torch.max_brightness = 8;
 	chip->cdev_torch.brightness_set = lm3642_torch_brightness_set;
+	chip->cdev_torch.default_trigger = "torch";
 	err = led_classdev_register((struct device *)
 				    &client->dev, &chip->cdev_torch);
 	if (err < 0) {
-- 
1.7.9.5


Best Regards,
Milo



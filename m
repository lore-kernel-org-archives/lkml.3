Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab3BTI40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:56:26 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:33899 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597Ab3BTI4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:56:25 -0500
Date: Wed, 20 Feb 2013 00:56:22 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] MFD: remove incorrect __exit annotations
Message-ID: <20130220085621.GA12685@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if bus is not hot-pluggable, the devices can be unbound from the
driver via sysfs, so we should not be using __exit annotations on
remove() methods.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Not tested - no hardware.

 drivers/mfd/menelaus.c | 4 ++--
 drivers/mfd/tps65010.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 998ce8c..fda3211 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1265,7 +1265,7 @@ fail1:
 	return err;
 }
 
-static int __exit menelaus_remove(struct i2c_client *client)
+static int menelaus_remove(struct i2c_client *client)
 {
 	struct menelaus_chip	*menelaus = i2c_get_clientdata(client);
 
@@ -1287,7 +1287,7 @@ static struct i2c_driver menelaus_i2c_driver = {
 		.name		= DRIVER_NAME,
 	},
 	.probe		= menelaus_probe,
-	.remove		= __exit_p(menelaus_remove),
+	.remove		= menelaus_remove,
 	.id_table	= menelaus_id,
 };
 
diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
index da2691f..9030233 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -514,7 +514,7 @@ static int tps65010_gpio_get(struct gpio_chip *chip, unsigned offset)
 
 static struct tps65010 *the_tps;
 
-static int __exit tps65010_remove(struct i2c_client *client)
+static int tps65010_remove(struct i2c_client *client)
 {
 	struct tps65010		*tps = i2c_get_clientdata(client);
 	struct tps65010_board	*board = client->dev.platform_data;
@@ -687,7 +687,7 @@ static struct i2c_driver tps65010_driver = {
 		.name	= "tps65010",
 	},
 	.probe	= tps65010_probe,
-	.remove	= __exit_p(tps65010_remove),
+	.remove	= tps65010_remove,
 	.id_table = tps65010_id,
 };
 
-- 
1.7.11.7


-- 
Dmitry

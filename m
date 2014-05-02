Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaEBMCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:02:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaEBMCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:02:46 -0400
From: Jan Moskyto Matejka <mq@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>
Cc: Jan Moskyto Matejka <mq@suse.cz>
Subject: [PATCH] [linux-next] serial: sc16is7xx: compile I2C when REGMAP_I2C is module
Date: Fri,  2 May 2014 14:02:25 +0200
Message-Id: <1399032145-1055-1-git-send-email-mq@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/serial/sc16is7xx.c:1060:12: warning: 'sc16is7xx_probe' defined but not used [-Wunused-function]
 static int sc16is7xx_probe(struct device *dev,
            ^
drivers/tty/serial/sc16is7xx.c:1176:12: warning: 'sc16is7xx_remove' defined but not used [-Wunused-function]
 static int sc16is7xx_remove(struct device *dev)
            ^
drivers/tty/serial/sc16is7xx.c:1215:29: warning: 'regcfg' defined but not used [-Wunused-variable]
 static struct regmap_config regcfg = {
                             ^

Fixed these warnings by removing the `#ifdef CONFIG_REGMAP_I2C' around their
calls as this driver selects REGMAP_I2C in Kconfig. This part of driver just
didn't compile at all when REGMAP_I2C configured as module (CONFIG_REGMAP_I2C
is not defined, just CONFIG_REGMAP_I2C_MODULE).

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
---
 drivers/tty/serial/sc16is7xx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 7206a64..80b0ca6 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1221,7 +1221,6 @@ static struct regmap_config regcfg = {
 	.precious_reg = sc16is7xx_regmap_precious,
 };
 
-#ifdef CONFIG_REGMAP_I2C
 static int sc16is7xx_i2c_probe(struct i2c_client *i2c,
 			       const struct i2c_device_id *id)
 {
@@ -1273,7 +1272,6 @@ static struct i2c_driver sc16is7xx_i2c_uart_driver = {
 };
 module_i2c_driver(sc16is7xx_i2c_uart_driver);
 MODULE_ALIAS("i2c:sc16is7xx");
-#endif
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jon Ringle <jringle@gridpoint.com>");
-- 
1.8.4.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3JBLq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:46:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36300 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3JBLqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:46:54 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] misc: bh1780: probe from compatible string
Date: Wed,  2 Oct 2013 13:46:47 +0200
Message-Id: <1380714407-22881-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the BH1780GLI I2C driver relies on the device tree node
having the right name, but this is fragile. Use the compatible
string to probe the driver instead.

Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/misc/bh1780gli.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index 057580e..48ea33d 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/of.h>
 
 #define BH1780_REG_CONTROL	0x80
 #define BH1780_REG_PARTID	0x8A
@@ -244,6 +245,15 @@ static const struct i2c_device_id bh1780_id[] = {
 	{ },
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id of_bh1780_match[] = {
+	{ .compatible = "rohm,bh1780gli", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, of_bh1780_match);
+#endif
+
 static struct i2c_driver bh1780_driver = {
 	.probe		= bh1780_probe,
 	.remove		= bh1780_remove,
@@ -251,6 +261,7 @@ static struct i2c_driver bh1780_driver = {
 	.driver = {
 		.name = "bh1780",
 		.pm	= &bh1780_pm,
+		.of_match_table = of_match_ptr(of_bh1780_match),
 	},
 };
 
-- 
1.8.3.1


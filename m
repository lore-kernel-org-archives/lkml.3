Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbaLEIP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:15:26 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33666 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaLEIPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:15:24 -0500
From: "jeffrey.lin" <yajohn@gmail.com>
X-Google-Original-From: "jeffrey.lin" <jeffrey.lin@rad-ic.com>
To: dmitry.torokhov@gmail.com, shc_work@mail.ru, bleung@chromium.org,
        lee.jones@linaro.org, charliemooney@chromium.org
Cc: KP.li@rad-ic.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, "jeffrey.lin" <jeffrey.lin@rad-ic.com>
Subject: [PATCH] driver: input :touchscreen : add Raydium I2C touch driver
Date: Fri,  5 Dec 2014 16:15:01 +0800
Message-Id: <1417767301-20141-1-git-send-email-jeffrey.lin@rad-ic.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jeffrey.lin" <jeffrey.lin@rad-ic.com>

This patch is porting Raydium I2C touch driver. Developer can enable raydium touch driver by modifying define
"CONFIG_TOUCHSCREEN_RM_TS".

Signed-off-by: jeffrey.lin@rad-ic.com
---
 drivers/input/touchscreen/Kconfig  | 12 ++++++++++++
 drivers/input/touchscreen/Makefile |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3ce9181..d0324d2 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -955,4 +955,16 @@ config TOUCHSCREEN_ZFORCE
 	  To compile this driver as a module, choose M here: the
 	  module will be called zforce_ts.
 
+config TOUCHSCREEN_RM_TS
+	tristate "Raydium I2C Touchscreen"
+	depends on I2C
+	help
+	  Say Y here if you have Raydium series I2C touchscreen,
+	  such as RM31100 , connected to your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rm31100_ts.
+
 endif
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 687d5a7..3220f66 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
 obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
 obj-$(CONFIG_TOUCHSCREEN_ZFORCE)	+= zforce_ts.o
+obj-$(CONFIG_TOUCHSCREEN_RM_TS)		+= rm31100_ts.o
-- 
2.1.2


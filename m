Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966787Ab3E2PGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:06:17 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48365 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966410Ab3E2PGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:06:16 -0400
From: Wei Shuai <cpuwolf@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Wei Shuai <cpuwolf@gmail.com>
Subject: [PATCH] USB: serial: add support Infineon modem USB flashloader driver
Date: Wed, 29 May 2013 23:05:56 +0800
Message-Id: <1369839956-28645-1-git-send-email-cpuwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you want to download Infineon modem via USB, this Infineon USB 
flashloader driver is required.


Signed-off-by: Wei Shuai <cpuwolf@gmail.com>
---
 drivers/usb/serial/Kconfig       |   10 ++++++++++
 drivers/usb/serial/Makefile      |    1 +
 drivers/usb/serial/flashloader.c |   39 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+)
 create mode 100644 drivers/usb/serial/flashloader.c

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 17b7f9a..cccd495 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -693,6 +693,16 @@ config USB_SERIAL_QT2
 	  To compile this driver as a module, choose M here: the
 	  module will be called quatech-serial.
 
+config USB_SERIAL_FLASHLOADER
+	tristate "Infineon Modem Flashloader USB interface driver"
+	help
+	  Say Y here if you want to download Infineon Modem
+	  via USB Flashloader serial driver.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called flashloader.
+
+
 config USB_SERIAL_DEBUG
 	tristate "USB Debugging Device"
 	help
diff --git a/drivers/usb/serial/Makefile b/drivers/usb/serial/Makefile
index eaf5ca1..0b2ce56 100644
--- a/drivers/usb/serial/Makefile
+++ b/drivers/usb/serial/Makefile
@@ -64,3 +64,4 @@ obj-$(CONFIG_USB_SERIAL_VIVOPAY_SERIAL)		+= vivopay-serial.o
 obj-$(CONFIG_USB_SERIAL_XSENS_MT)		+= xsens_mt.o
 obj-$(CONFIG_USB_SERIAL_ZIO)			+= zio.o
 obj-$(CONFIG_USB_SERIAL_ZTE)			+= zte_ev.o
+obj-$(CONFIG_USB_SERIAL_FLASHLOADER)		+= flashloader.o
diff --git a/drivers/usb/serial/flashloader.c b/drivers/usb/serial/flashloader.c
new file mode 100644
index 0000000..e6f5c10
--- /dev/null
+++ b/drivers/usb/serial/flashloader.c
@@ -0,0 +1,39 @@
+/*
+ * Infineon Flashloader driver
+ *
+ * Copyright (C) 2013 Wei Shuai <cpuwolf@gmail.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/tty.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/serial.h>
+#include <linux/uaccess.h>
+
+static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(0x8087, 0x0716) },
+	{ },
+};
+MODULE_DEVICE_TABLE(usb, id_table);
+
+static struct usb_serial_driver flashloader_device = {
+	.driver = {
+		.owner =	THIS_MODULE,
+		.name =		"flashloader",
+	},
+	.id_table =		id_table,
+	.num_ports =		1,
+};
+
+static struct usb_serial_driver * const serial_drivers[] = {
+	&flashloader_device, NULL
+};
+
+module_usb_serial_driver(serial_drivers, id_table);
+MODULE_LICENSE("GPL");
-- 
1.7.9.5


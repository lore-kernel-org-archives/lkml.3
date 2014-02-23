Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaBWQii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 11:38:38 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:59904 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaBWQhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 11:37:51 -0500
From: <vladimir.barinov@cogentembedded.com>
To: <linux-sh@vger.kernel.org>
Cc: <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        <magnus.damm@gmail.com>, <horms@verge.net.au>, <gnurou@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH] gpio: gpio-rcar: init at postcore level
Date: Sun, 23 Feb 2014 20:37:47 +0400
Message-Id: <1393173467-12240-1-git-send-email-vladimir.barinov@cogentembedded.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

This adds ability to use gpio API at board init_machine level.

F.e. it can be used in the following situation.
Many reference hardware has onboard switches that selects which periferals
to connect to the system. The gpio input state from switches can be used
in choosing platform devices runtime in board code instead of ifdefs/defconfig
changes.

Signed-off-by: <vladimir.barinov@cogentembedded.com>

---
 drivers/gpio/gpio-rcar.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: build/drivers/gpio/gpio-rcar.c
===================================================================
--- build.orig/drivers/gpio/gpio-rcar.c	2014-02-22 23:21:51.456229152 +0400
+++ build/drivers/gpio/gpio-rcar.c	2014-02-22 23:21:52.320229133 +0400
@@ -485,7 +485,17 @@
 	}
 };
 
-module_platform_driver(gpio_rcar_device_driver);
+static int __init gpio_rcar_init(void)
+{
+	return platform_driver_register(&gpio_rcar_device_driver);
+}
+postcore_initcall(gpio_rcar_init);
+
+static void __exit gpio_rcar_exit(void)
+{
+	platform_driver_unregister(&gpio_rcar_device_driver);
+}
+module_exit(gpio_rcar_exit);
 
 MODULE_AUTHOR("Magnus Damm");
 MODULE_DESCRIPTION("Renesas R-Car GPIO Driver");

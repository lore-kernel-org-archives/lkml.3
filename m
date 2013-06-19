Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934772Ab3FSOG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:06:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49941 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853Ab3FSOGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:06:22 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>, <tony@atomide.com>
CC: <balbi@ti.com>, <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC PATCH 1/6] mfd: omap-usb-host: move initialization to module_init()
Date: Wed, 19 Jun 2013 17:05:48 +0300
Message-ID: <1371650753-11452-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371650753-11452-1-git-send-email-rogerq@ti.com>
References: <1371650753-11452-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer need to be initialized in any particular order
so move driver initialization to the standard place i.e. module_init()

CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |   10 +---------
 drivers/mfd/omap-usb-tll.c  |    8 +-------
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 759fae3..6601a49 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -908,15 +908,7 @@ static int __init omap_usbhs_drvinit(void)
 {
 	return platform_driver_probe(&usbhs_omap_driver, usbhs_omap_probe);
 }
-
-/*
- * init before ehci and ohci drivers;
- * The usbhs core driver should be initialized much before
- * the omap ehci and ohci probe functions are called.
- * This usbhs core driver should be initialized after
- * usb tll driver
- */
-fs_initcall_sync(omap_usbhs_drvinit);
+module_init(omap_usbhs_drvinit);
 
 static void __exit omap_usbhs_drvexit(void)
 {
diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index e59ac4c..fb7c73e 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -482,13 +482,7 @@ static int __init omap_usbtll_drvinit(void)
 {
 	return platform_driver_register(&usbtll_omap_driver);
 }
-
-/*
- * init before usbhs core driver;
- * The usbtll driver should be initialized before
- * the usbhs core driver probe function is called.
- */
-fs_initcall(omap_usbtll_drvinit);
+module_init(omap_usbtll_drvinit);
 
 static void __exit omap_usbtll_drvexit(void)
 {
-- 
1.7.4.1


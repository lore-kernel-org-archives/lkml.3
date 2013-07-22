Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab3GVSKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:10:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:41806 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab3GVSKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:10:17 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 04/16] usb: musb: remove ti81xx pieces from musb
Date: Mon, 22 Jul 2013 20:09:55 +0200
Message-Id: <1374516607-2705-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ti81xx does not have a baseport mainline i.e. it should not boot. The
amount of rework that is required makes it easier to simply remove that
platform (i.e. that possible platform device) and add it later once it
comes back with DT support.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_dsps.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index ab723fa..1440fac 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -46,9 +46,7 @@
 
 #include "musb_core.h"
 
-#ifdef CONFIG_OF
 static const struct of_device_id musb_dsps_of_match[];
-#endif
 
 /**
  * avoid using musb_readx()/musb_writex() as glue layer should not be
@@ -659,23 +657,12 @@ static const struct dsps_musb_wrapper ti81xx_driver_data = {
 	.instances		= 1,
 };
 
-static const struct platform_device_id musb_dsps_id_table[] = {
-	{
-		.name	= "musb-ti81xx",
-		.driver_data	= (kernel_ulong_t) &ti81xx_driver_data,
-	},
-	{  },	/* Terminating Entry */
-};
-MODULE_DEVICE_TABLE(platform, musb_dsps_id_table);
-
-#ifdef CONFIG_OF
 static const struct of_device_id musb_dsps_of_match[] = {
 	{ .compatible = "ti,musb-am33xx",
 		.data = (void *) &ti81xx_driver_data, },
 	{  },
 };
 MODULE_DEVICE_TABLE(of, musb_dsps_of_match);
-#endif
 
 static struct platform_driver dsps_usbss_driver = {
 	.probe		= dsps_probe,
@@ -684,7 +671,6 @@ static struct platform_driver dsps_usbss_driver = {
 		.name   = "musb-dsps",
 		.of_match_table	= of_match_ptr(musb_dsps_of_match),
 	},
-	.id_table	= musb_dsps_id_table,
 };
 
 MODULE_DESCRIPTION("TI DSPS MUSB Glue Layer");
-- 
1.8.3.2


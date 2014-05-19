Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbaESKKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:10:20 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55688 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaESKKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:10:16 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 5/5] usb: gadget: net2280: Use module_pci_driver macro
Date: Mon, 19 May 2014 12:10:05 +0200
Message-Id: <1400494205-26566-5-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1400494205-26566-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400494205-26566-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/net2280.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index b43725a..bd851de 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -3588,6 +3588,9 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	void			__iomem *base = NULL;
 	int			retval, i;
 
+	if (!use_dma)
+		use_dma_chaining = 0;
+
 	/* alloc, and start init */
 	dev = kzalloc (sizeof *dev, GFP_KERNEL);
 	if (dev == NULL){
@@ -3833,20 +3836,8 @@ static struct pci_driver net2280_pci_driver = {
 	/* FIXME add power management support */
 };
 
+module_pci_driver(net2280_pci_driver);
+
 MODULE_DESCRIPTION (DRIVER_DESC);
 MODULE_AUTHOR ("David Brownell");
 MODULE_LICENSE ("GPL");
-
-static int __init init (void)
-{
-	if (!use_dma)
-		use_dma_chaining = 0;
-	return pci_register_driver (&net2280_pci_driver);
-}
-module_init (init);
-
-static void __exit cleanup (void)
-{
-	pci_unregister_driver (&net2280_pci_driver);
-}
-module_exit (cleanup);
-- 
2.0.0.rc0


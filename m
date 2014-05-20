Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaETQdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:33:10 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:61720 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaETQaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:30:30 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 05/10] usb: gadget: net2280: Use module_pci_driver macro
Date: Tue, 20 May 2014 18:30:07 +0200
Message-Id: <1400603412-19406-6-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400603412-19406-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400603412-19406-1-git-send-email-ricardo.ribalda@gmail.com>
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
2.0.0.rc2


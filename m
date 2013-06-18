Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab3FRTpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:45:40 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34756 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3FRTpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:45:39 -0400
Date: Tue, 18 Jun 2013 14:43:58 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 6/11] rsxx: Changing the adapter name to the official name.
Message-ID: <20130618194358.GG6492@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061819-5806-0000-0000-000021C3F0A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Changing the adapter name from FlashSystem-80 to the official
name: Flash Adapter 900GB Full Height.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/Kconfig linux-block/drivers/block/Kconfig
--- linux-block-vanilla/drivers/block/Kconfig	2013-03-26 09:56:33.287027889 -0500
+++ linux-block/drivers/block/Kconfig	2013-06-18 10:51:57.561840636 -0500
@@ -532,11 +532,11 @@ config BLK_DEV_RBD
 	  If unsure, say N.
 
 config BLK_DEV_RSXX
-	tristate "IBM FlashSystem 70/80 PCIe SSD Device Driver"
+	tristate "IBM Flash Adapter 900GB Full Height PCIe Device Driver"
 	depends on PCI
 	help
 	  Device driver for IBM's high speed PCIe SSD
-	  storage devices: FlashSystem-70 and FlashSystem-80.
+	  storage device: Flash Adapter 900GB Full Height.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rsxx.
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-06-18 10:48:45.337841335 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-06-18 10:48:29.184905847 -0500
@@ -41,7 +41,7 @@
 #define NO_LEGACY 0
 #define SYNC_START_TIMEOUT (10 * 60) /* 10 minutes */
 
-MODULE_DESCRIPTION("IBM FlashSystem 70/80 PCIe SSD Device Driver");
+MODULE_DESCRIPTION("IBM Flash Adapter 900GB Full Height Device Driver");
 MODULE_AUTHOR("Joshua Morris/Philip Kelleher, IBM");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRIVER_VERSION);
@@ -336,7 +336,7 @@ static int rsxx_eeh_frozen(struct pci_de
 	int i;
 	int st;
 
-	dev_warn(&dev->dev, "IBM FlashSystem PCI: preparing for slot reset.\n");
+	dev_warn(&dev->dev, "IBM Flash Adapter PCI: preparing for slot reset.\n");
 
 	card->eeh_state = 1;
 	rsxx_mask_interrupts(card);
@@ -376,7 +376,7 @@ static void rsxx_eeh_failure(struct pci_
 	int i;
 	int cnt = 0;
 
-	dev_err(&dev->dev, "IBM FlashSystem PCI: disabling failed card.\n");
+	dev_err(&dev->dev, "IBM Flash Adapter PCI: disabling failed card.\n");
 
 	card->eeh_state = 1;
 	card->halt = 1;
@@ -450,7 +450,7 @@ static pci_ers_result_t rsxx_slot_reset(
 	int st;
 
 	dev_warn(&dev->dev,
-		"IBM FlashSystem PCI: recovering from slot reset.\n");
+		"IBM Flash Adapter PCI: recovering from slot reset.\n");
 
 	st = pci_enable_device(dev);
 	if (st)
@@ -503,7 +503,7 @@ static pci_ers_result_t rsxx_slot_reset(
 				&card->ctrl[i].issue_dma_work);
 	}
 
-	dev_info(&dev->dev, "IBM FlashSystem PCI: recovery complete.\n");
+	dev_info(&dev->dev, "IBM Flash Adapter PCI: recovery complete.\n");
 
 	return PCI_ERS_RESULT_RECOVERED;
 
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/MAINTAINERS linux-block/MAINTAINERS
--- linux-block-vanilla/MAINTAINERS	2013-05-28 14:59:22.885014780 -0500
+++ linux-block/MAINTAINERS	2013-06-18 10:50:24.798840540 -0500
@@ -3297,7 +3297,7 @@ F:	Documentation/firmware_class/
 F:	drivers/base/firmware*.c
 F:	include/linux/firmware.h
 
-FLASHSYSTEM DRIVER (IBM FlashSystem 70/80 PCI SSD Flash Card)
+FLASH ADAPTER DRIVER (IBM Flash Adapter 900GB Full Height PCI Flash Card)
 M:	Joshua Morris <josh.h.morris@us.ibm.com>
 M:	Philip Kelleher <pjk1939@linux.vnet.ibm.com>
 S:	Maintained


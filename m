Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114Ab3B0PZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:25:42 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49807 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759978Ab3B0PZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:25:41 -0500
Date: Wed, 27 Feb 2013 09:24:59 -0600
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com
Subject: [PATCHv2 3/4] block: IBM RamSan 70/80 branding changes.
Message-ID: <20130227152459.GC10908@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022715-9360-0000-0000-000011177913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

This patch includes changing the hardware branding name from
IBM RamSan to IBM FlashSystem.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------
v2 Changes include:
o Removing the unnecessary IBM Vendor ID #define

v1 Changes include:
o Changed all references of RamSan to FlashSystem.
o Changed the vendor/device IDs for the product.
o Changed driver version number.
o Updated the MAINTAINERS file.
o Various other little things.


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/Kconfig linux-block/drivers/block/Kconfig
--- linux-block-vanilla/drivers/block/Kconfig	2013-02-26 12:49:05.066184722 -0600
+++ linux-block/drivers/block/Kconfig	2013-02-27 09:02:12.983193548 -0600
@@ -532,11 +532,11 @@ config BLK_DEV_RBD
 	  If unsure, say N.
 
 config BLK_DEV_RSXX
-	tristate "RamSam PCIe Flash SSD Device Driver"
+	tristate "IBM FlashSystem 70/80 PCIe SSD Device Driver"
 	depends on PCI
 	help
 	  Device driver for IBM's high speed PCIe SSD
-	  storage devices: RamSan-70 and RamSan-80.
+	  storage devices: FlashSystem-70 and FlashSystem-80.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rsxx.
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/config.c linux-block/drivers/block/rsxx/config.c
--- linux-block-vanilla/drivers/block/rsxx/config.c	2013-02-27 09:03:30.928256988 -0600
+++ linux-block/drivers/block/rsxx/config.c	2013-02-27 09:02:12.991192439 -0600
@@ -35,7 +35,7 @@ static void initialize_config(struct rsx
 
 	cfg->data.block_size        = RSXX_HW_BLK_SIZE;
 	cfg->data.stripe_size       = RSXX_HW_BLK_SIZE;
-	cfg->data.vendor_id         = RSXX_VENDOR_ID_TMS_IBM;
+	cfg->data.vendor_id         = RSXX_VENDOR_ID_IBM;
 	cfg->data.cache_order       = (-1);
 	cfg->data.intr_coal.mode    = RSXX_INTR_COAL_DISABLED;
 	cfg->data.intr_coal.count   = 0;
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-02-27 09:03:30.938244922 -0600
+++ linux-block/drivers/block/rsxx/core.c	2013-02-27 09:02:12.996308907 -0600
@@ -39,8 +39,8 @@
 
 #define NO_LEGACY 0
 
-MODULE_DESCRIPTION("IBM RamSan PCIe Flash SSD Device Driver");
-MODULE_AUTHOR("IBM <support@ramsan.com>");
+MODULE_DESCRIPTION("IBM FlashSystem 70/80 PCIe SSD Device Driver");
+MODULE_AUTHOR("Joshua Morris/Philip Kelleher, IBM");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRIVER_VERSION);
 
@@ -593,10 +593,8 @@ static void rsxx_pci_shutdown(struct pci
 }
 
 static DEFINE_PCI_DEVICE_TABLE(rsxx_pci_ids) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_TMS_IBM, PCI_DEVICE_ID_RS70_FLASH)},
-	{PCI_DEVICE(PCI_VENDOR_ID_TMS_IBM, PCI_DEVICE_ID_RS70D_FLASH)},
-	{PCI_DEVICE(PCI_VENDOR_ID_TMS_IBM, PCI_DEVICE_ID_RS80_FLASH)},
-	{PCI_DEVICE(PCI_VENDOR_ID_TMS_IBM, PCI_DEVICE_ID_RS81_FLASH)},
+	{PCI_DEVICE(PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_FS70_FLASH)},
+	{PCI_DEVICE(PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_FS80_FLASH)},
 	{0,},
 };
 
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-02-27 09:03:30.950236458 -0600
+++ linux-block/drivers/block/rsxx/dma.c	2013-02-27 09:02:13.002308102 -0600
@@ -28,7 +28,7 @@
 struct rsxx_dma {
 	struct list_head	 list;
 	u8			 cmd;
-	unsigned int		 laddr;     /* Logical address on the ramsan */
+	unsigned int		 laddr;     /* Logical address */
 	struct {
 		u32		 off;
 		u32		 cnt;
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/Makefile linux-block/drivers/block/rsxx/Makefile
--- linux-block-vanilla/drivers/block/rsxx/Makefile	2013-02-26 12:49:05.100181652 -0600
+++ linux-block/drivers/block/rsxx/Makefile	2013-02-27 09:02:13.004192089 -0600
@@ -1,2 +1,2 @@
 obj-$(CONFIG_BLK_DEV_RSXX) += rsxx.o
-rsxx-y := config.o core.o cregs.o dev.o dma.o
+rsxx-objs := config.o core.o cregs.o dev.o dma.o
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_cfg.h linux-block/drivers/block/rsxx/rsxx_cfg.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_cfg.h	2013-02-26 12:49:05.131182149 -0600
+++ linux-block/drivers/block/rsxx/rsxx_cfg.h	2013-02-27 09:02:13.005304819 -0600
@@ -58,7 +58,7 @@ struct rsxx_card_cfg {
 };
 
 /* Vendor ID Values */
-#define RSXX_VENDOR_ID_TMS_IBM		0
+#define RSXX_VENDOR_ID_IBM		0
 #define RSXX_VENDOR_ID_DSI		1
 #define RSXX_VENDOR_COUNT		2
 
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-02-26 12:49:05.135184209 -0600
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-02-27 09:02:42.298185186 -0600
@@ -45,16 +45,13 @@
 
 struct proc_cmd;
 
-#define PCI_VENDOR_ID_TMS_IBM		0x15B6
-#define PCI_DEVICE_ID_RS70_FLASH	0x0019
-#define PCI_DEVICE_ID_RS70D_FLASH	0x001A
-#define PCI_DEVICE_ID_RS80_FLASH	0x001C
-#define PCI_DEVICE_ID_RS81_FLASH	0x001E
+#define PCI_DEVICE_ID_FS70_FLASH	0x04A9
+#define PCI_DEVICE_ID_FS80_FLASH	0x04AA
 
 #define RS70_PCI_REV_SUPPORTED	4
 
 #define DRIVER_NAME "rsxx"
-#define DRIVER_VERSION "3.7"
+#define DRIVER_VERSION "4.0"
 
 /* Block size is 4096 */
 #define RSXX_HW_BLK_SHIFT		12
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/MAINTAINERS linux-block/MAINTAINERS
--- linux-block-vanilla/MAINTAINERS	2013-02-26 12:48:57.073182071 -0600
+++ linux-block/MAINTAINERS	2013-02-27 09:02:13.009305332 -0600
@@ -3157,6 +3157,12 @@ F:	Documentation/firmware_class/
 F:	drivers/base/firmware*.c
 F:	include/linux/firmware.h
 
+FLASHSYSTEM DRIVER (IBM FlashSystem 70/80 PCI SSD Flash Card)
+M:	Joshua Morris <josh.h.morris@us.ibm.com>
+M:	Philip Kelleher <pjk1939@linux.vnet.ibm.com>
+S:	Maintained
+F:	drivers/block/rsxx/
+
 FLOPPY DRIVER
 M:	Jiri Kosina <jkosina@suse.cz>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git
@@ -6312,12 +6318,6 @@ S:	Maintained
 F:	Documentation/blockdev/ramdisk.txt
 F:	drivers/block/brd.c
 
-RAMSAM DRIVER (IBM RamSan 70/80 PCI SSD Flash Card)
-M:	Joshua Morris <josh.h.morris@us.ibm.com>
-M:	Philip Kelleher <pjk1939@linux.vnet.ibm.com>
-S:	Maintained
-F:	drivers/block/rsxx/
-
 RANDOM NUMBER DRIVER
 M:	Theodore Ts'o" <tytso@mit.edu>
 S:	Maintained


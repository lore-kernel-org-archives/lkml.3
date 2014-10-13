Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaJMMlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:41:51 -0400
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:48040 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893AbaJMMlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:41:49 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] staging: comedi: cb_pcimdas: add support for PCIe-DAS1602/16
Date: Mon, 13 Oct 2014 13:41:22 +0100
Message-Id: <1413204082-14757-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413204082-14757-1-git-send-email-abbotti@mev.co.uk>
References: <1413204082-14757-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Measurement Computing PCIe-DAS1602/16 is a PCI-Express version of
the PCIM-DAS1602/16, but has a different PCI device ID.  Add support
for this device and update the driver description, Kconfig description
and MODULE_DESCRIPTION.

Thanks to Christoph Langbein for supplying the PCI device ID.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/Kconfig              |  4 ++--
 drivers/staging/comedi/drivers/cb_pcimdas.c | 21 ++++++++++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index a8bc2b5..77c5013 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -939,11 +939,11 @@ config COMEDI_CB_PCIDDA
 	  called cb_pcidda.
 
 config COMEDI_CB_PCIMDAS
-	tristate "MeasurementComputing PCIM-DAS1602/16 support"
+	tristate "MeasurementComputing PCIM-DAS1602/16, PCIe-DAS1602/16 support"
 	select COMEDI_8255
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI Migration
-	  series PCIM-DAS1602/16
+	  series PCIM-DAS1602/16 and PCIe-DAS1602/16.
 
 	  To compile this driver as a module, choose M here: the module will be
 	  called cb_pcimdas.
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 433941a..73e5c96 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -1,6 +1,6 @@
 /*
  * comedi/drivers/cb_pcimdas.c
- * Comedi driver for Computer Boards PCIM-DAS1602/16
+ * Comedi driver for Computer Boards PCIM-DAS1602/16 and PCIe-DAS1602/16
  *
  * COMEDI - Linux Control and Measurement Device Interface
  * Copyright (C) 2000 David A. Schleef <ds@schleef.org>
@@ -19,24 +19,26 @@
 /*
  * Driver: cb_pcimdas
  * Description: Measurement Computing PCI Migration series boards
- * Devices: [ComputerBoards] PCIM-DAS1602/16 (cb_pcimdas)
+ * Devices: [ComputerBoards] PCIM-DAS1602/16 (cb_pcimdas), PCIe-DAS1602/16
  * Author: Richard Bytheway
- * Updated: Wed, 13 Nov 2002 12:34:56 +0000
+ * Updated: Mon, 13 Oct 2014 11:57:39 +0000
  * Status: experimental
  *
- * Written to support the PCIM-DAS1602/16 on a 2.4 series kernel.
+ * Written to support the PCIM-DAS1602/16 and PCIe-DAS1602/16.
  *
  * Configuration Options:
  *   none
  *
- * Manual configuration of PCI cards is not supported; they are configured
+ * Manual configuration of PCI(e) cards is not supported; they are configured
  * automatically.
  *
  * Developed from cb_pcidas and skel by Richard Bytheway (mocelet@sucs.org).
  * Only supports DIO, AO and simple AI in it's present form.
  * No interrupts, multi channel or FIFO AI,
  * although the card looks like it could support this.
- * See http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf for more details.
+ *
+ * http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf
+ * http://www.mccdaq.com/PDFs/Manuals/pcie-das1602-16.pdf
  */
 
 #include <linux/module.h>
@@ -48,7 +50,7 @@
 #include "plx9052.h"
 #include "8255.h"
 
-/* Registers for the PCIM-DAS1602/16 */
+/* Registers for the PCIM-DAS1602/16 and PCIe-DAS1602/16 */
 
 /* DAC Offsets */
 #define ADC_TRIG 0
@@ -254,7 +256,8 @@ static int cb_pcimdas_pci_probe(struct pci_dev *dev,
 }
 
 static const struct pci_device_id cb_pcimdas_pci_table[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0056) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0056) },	/* PCIM-DAS1602/16 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0115) },	/* PCIe-DAS1602/16 */
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, cb_pcimdas_pci_table);
@@ -268,5 +271,5 @@ static struct pci_driver cb_pcimdas_pci_driver = {
 module_comedi_pci_driver(cb_pcimdas_driver, cb_pcimdas_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
-MODULE_DESCRIPTION("Comedi low-level driver");
+MODULE_DESCRIPTION("Comedi driver for PCIM-DAS1602/16 and PCIe-DAS1602/16");
 MODULE_LICENSE("GPL");
-- 
2.1.1


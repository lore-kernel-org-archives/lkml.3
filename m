Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab3GPPZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:25:38 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:56314 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3GPPZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:25:34 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jul 2013 11:25:33 EDT
From: Ian Abbott <abbotti@mev.co.uk>
To: linux-pci@vger.kernel.org, linux-serial@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 1/4] pci_ids.h: move PCI_VENDOR_ID_AMCC here
Date: Tue, 16 Jul 2013 16:14:38 +0100
Message-Id: <1373987681-18245-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1373987681-18245-1-git-send-email-abbotti@mev.co.uk>
References: <1373987681-18245-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI_VENDOR_ID_AMCC is defined locally in
"drivers/staging/comedi/comedidev.h" for a few comedi hardware drivers,
namely "adl_pci9118", "addi_apci_1500" and "addi_apci_3120" (also
"addi_apci_1710" but that is not currently built and will probably be
removed soon).  Move the define into "include/linux/pci_ids.h" as it is
shared by several drivers (albeit all comedi drivers currently).

PCI_VENDOR_ID_AMCC happens to have the same value (0x10e8) as
PCI_VENDOR_ID_ADDIDATA_OLD.  The vendor ID is actually assigned to
Applied Micro Circuits Corporation and Addi-Data were using device IDs
assigned by AMCC on some of their earlier PCI boards. The
PCI_VENDOR_ID_ADDIDATA_OLD define is still being used by the "8250_pci"
PCI serial board driver.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedidev.h | 1 -
 include/linux/pci_ids.h            | 4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index b75915f..9f4f73f 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -400,7 +400,6 @@ int comedi_driver_unregister(struct comedi_driver *);
  */
 #define PCI_VENDOR_ID_KOLTER		0x1001
 #define PCI_VENDOR_ID_ICP		0x104c
-#define PCI_VENDOR_ID_AMCC		0x10e8
 #define PCI_VENDOR_ID_DT		0x1116
 #define PCI_VENDOR_ID_IOTECH		0x1616
 #define PCI_VENDOR_ID_CONTEC		0x1221
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3bed2e8..9d99119 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1311,6 +1311,8 @@
 #define PCI_DEVICE_ID_IMS_TT128		0x9128
 #define PCI_DEVICE_ID_IMS_TT3D		0x9135
 
+#define PCI_VENDOR_ID_AMCC		0x10e8
+
 #define PCI_VENDOR_ID_INTERG		0x10ea
 #define PCI_DEVICE_ID_INTERG_1682	0x1682
 #define PCI_DEVICE_ID_INTERG_2000	0x2000
@@ -2256,7 +2258,7 @@
 /*
  * ADDI-DATA GmbH communication cards <info@addi-data.com>
  */
-#define PCI_VENDOR_ID_ADDIDATA_OLD             0x10E8
+#define PCI_VENDOR_ID_ADDIDATA_OLD             0x10E8	/* actually AMCC */
 #define PCI_VENDOR_ID_ADDIDATA                 0x15B8
 #define PCI_DEVICE_ID_ADDIDATA_APCI7500        0x7000
 #define PCI_DEVICE_ID_ADDIDATA_APCI7420        0x7001
-- 
1.8.2.1


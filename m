Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab3CFOOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:14:55 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:55066 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab3CFOOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:14:53 -0500
From: Ian Abbott <abbotti@mev.co.uk>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH] pci_ids.h: add PCI_VENDOR_ID_AMCC
Date: Wed,  6 Mar 2013 14:14:38 +0000
Message-Id: <1362579278-6534-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vendor ID 0x10e8 is assigned to Applied Micro Circuits Corporation
(recently AppliedMicro, but AMCC on NASDAQ).  The ID currently appears
as PCI_VENDOR_ID_ADDIDATA_OLD in pci_ids.h, which is wrong.  Some older
PCI boards made by ADDI-DATA used PCI interface chips made by AMCC and
used device IDs assigned by AMCC.

Add PCI_VENDOR_ID_AMCC and mark PCI_VENDOR_ID_ADDIDATA_OLD as a
duplicate.

Note that PCI_VENDOR_ID_AMCC is defined identically in
"drivers/staging/comedi/comedidev.h" for use by the adl_pci9118 comedi
driver.  Various other comedi drivers currently use
PCI_VENDOR_ID_ADDIDATA_OLD, but these can be changed to use
PCI_VENDOR_ID_AMCC easily enough.  The only other user of
PCI_VENDOR_ID_ADDIDATA_OLD is "drivers/tty/serial/8250_pci.c" which
could also be changed to use AMCC easily enough.  Once all that is done,
PCI_VENDOR_ID_ADDIDATA_OLD can be removed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 include/linux/pci_ids.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f11c1c2..902e41a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1309,6 +1309,8 @@
 #define PCI_DEVICE_ID_IMS_TT128		0x9128
 #define PCI_DEVICE_ID_IMS_TT3D		0x9135
 
+#define PCI_VENDOR_ID_AMCC		0x10e8
+
 #define PCI_VENDOR_ID_INTERG		0x10ea
 #define PCI_DEVICE_ID_INTERG_1682	0x1682
 #define PCI_DEVICE_ID_INTERG_2000	0x2000
@@ -2249,7 +2251,7 @@
 /*
  * ADDI-DATA GmbH communication cards <info@addi-data.com>
  */
-#define PCI_VENDOR_ID_ADDIDATA_OLD             0x10E8
+#define PCI_VENDOR_ID_ADDIDATA_OLD             0x10E8	/* actually AMCC */
 #define PCI_VENDOR_ID_ADDIDATA                 0x15B8
 #define PCI_DEVICE_ID_ADDIDATA_APCI7500        0x7000
 #define PCI_DEVICE_ID_ADDIDATA_APCI7420        0x7001
-- 
1.8.1.2


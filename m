Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945927Ab3AXVRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:17:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:40634 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab3AXVP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:15:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hugh Daschbach <hugh.daschbach@enmotus.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 02/22] libata: ahci: Add support for Enmotus Bobcat device.
Date: Thu, 24 Jan 2013 13:15:23 -0800
Message-Id: <20130124211505.422824242@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211504.701368763@linuxfoundation.org>
References: <20130124211504.701368763@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Daschbach <hugh.daschbach@enmotus.com>

commit 7f9c9f8e24590e7dcd26ca408458c43df5b83e61 upstream.

Silicon does not support standard AHCI BAR assignment.  Add
vendor/device exception to force BAR 2.

Signed-off-by: Hugh Daschbach <hugh.daschbach@enmotus.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -53,6 +53,7 @@
 
 enum {
 	AHCI_PCI_BAR_STA2X11	= 0,
+	AHCI_PCI_BAR_ENMOTUS	= 2,
 	AHCI_PCI_BAR_STANDARD	= 5,
 };
 
@@ -407,6 +408,9 @@ static const struct pci_device_id ahci_p
 	/* Asmedia */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1061 */
 
+	/* Enmotus */
+	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -1079,9 +1083,11 @@ static int ahci_init_one(struct pci_dev
 		dev_info(&pdev->dev,
 			 "PDC42819 can only drive SATA devices with this driver\n");
 
-	/* The Connext uses non-standard BAR */
+	/* Both Connext and Enmotus devices use non-standard BARs */
 	if (pdev->vendor == PCI_VENDOR_ID_STMICRO && pdev->device == 0xCC06)
 		ahci_pci_bar = AHCI_PCI_BAR_STA2X11;
+	else if (pdev->vendor == 0x1c44 && pdev->device == 0x8000)
+		ahci_pci_bar = AHCI_PCI_BAR_ENMOTUS;
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);



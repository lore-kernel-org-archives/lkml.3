Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3BQXAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:00:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45794 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756326Ab3BQWzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:43 -0500
Message-Id: <20130217225005.363249829@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:33 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Hugh Daschbach <hugh.daschbach@enmotus.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 32/66] [libata] ahci: Add support for Enmotus Bobcat device.
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Daschbach <hugh.daschbach@enmotus.com>

commit 7f9c9f8e24590e7dcd26ca408458c43df5b83e61 upstream.

Silicon does not support standard AHCI BAR assignment.  Add
vendor/device exception to force BAR 2.

Signed-off-by: Hugh Daschbach <hugh.daschbach@enmotus.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7862d17..4979127 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -53,6 +53,7 @@
 
 enum {
 	AHCI_PCI_BAR_STA2X11	= 0,
+	AHCI_PCI_BAR_ENMOTUS	= 2,
 	AHCI_PCI_BAR_STANDARD	= 5,
 };
 
@@ -410,6 +411,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
+	/* Enmotus */
+	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -1098,9 +1102,11 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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



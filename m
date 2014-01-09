Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbaAIALZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 19:11:25 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:52292 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725AbaAIALW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 19:11:22 -0500
Date: Wed, 8 Jan 2014 19:11:18 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata fixes for 3.13-rc7
Message-ID: <20140109001118.GA11420@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Late fixes for libata.  Nothing too interesting.  Adding missing PM
callbacks to satat_sis and an additional PCI ID for ahci.

The commits are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.13-fixes

for you to fetch changes up to 55c82a6c2a513de1d8a20c3b3a769129a1a14d50:

  sata_sis: missing PM support (2014-01-01 15:14:40 -0500)

Thanks.
----------------------------------------------------------------
Alan (1):
      sata_sis: missing PM support

Simon Guinot (1):
      ahci: add PCI ID for Marvell 88SE9170 SATA controller

 drivers/ata/ahci.c     | 3 +++
 drivers/ata/sata_sis.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c0ed4f27..e3a92a6 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -427,6 +427,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9125),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_MARVELL_EXT, 0x9178,
+			 PCI_VENDOR_ID_MARVELL_EXT, 0x9170),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9170 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9172),
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index fe3ca09..1ad2f62 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -83,6 +83,10 @@ static struct pci_driver sis_pci_driver = {
 	.id_table		= sis_pci_tbl,
 	.probe			= sis_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= ata_pci_device_resume,
+#endif
 };
 
 static struct scsi_host_template sis_sht = {

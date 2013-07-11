Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab3GKOtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:49:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42909 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664Ab3GKOZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shane Huang <shane.huang@amd.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 21/98] ahci: Add AMD CZ SATA device ID
Date: Thu, 11 Jul 2013 15:23:51 +0100
Message-Id: <1373552708-15235-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shane Huang <shane.huang@amd.com>

commit fafe5c3d82a470d73de53e6b08eb4e28d974d895 upstream.

To add AMD CZ SATA controller device ID of IDE mode.

[bhelgaas: drop pci_ids.h update]
Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ahci.c   | 1 +
 drivers/pci/quirks.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index edd842d..ec7f1a8 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -316,6 +316,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 
 	/* AMD */
 	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
+	{ PCI_VDEVICE(AMD, 0x7900), board_ahci }, /* AMD CZ */
 	/* AMD is using RAID class only for ahci controllers */
 	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 777e56f..4d0fe7d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1062,6 +1062,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x7900, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, 0x7900, quirk_amd_ide_mode);
 
 /*
  *	Serverworks CSB5 IDE does not fully support native mode
-- 
1.8.1.2


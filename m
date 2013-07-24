Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3GXOe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:34:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45710 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826Ab3GXOG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:29 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Shane Huang" <shane.huang@amd.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, "Tejun Heo" <tj@kernel.org>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.411465664@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [06/85] ahci: Add AMD CZ SATA device ID
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Shane Huang <shane.huang@amd.com>

commit fafe5c3d82a470d73de53e6b08eb4e28d974d895 upstream.

To add AMD CZ SATA controller device ID of IDE mode.

[bhelgaas: drop pci_ids.h update]
Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c   | 1 +
 drivers/pci/quirks.c | 2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -318,6 +318,7 @@ static const struct pci_device_id ahci_p
 
 	/* AMD */
 	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
+	{ PCI_VDEVICE(AMD, 0x7900), board_ahci }, /* AMD CZ */
 	/* AMD is using RAID class only for ahci controllers */
 	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1123,6 +1123,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x7900, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, 0x7900, quirk_amd_ide_mode);
 
 /*
  *	Serverworks CSB5 IDE does not fully support native mode


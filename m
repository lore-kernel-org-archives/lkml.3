Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935153Ab3GSCaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:30:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935025Ab3GSCZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:25:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shane Huang <shane.huang@amd.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Tejun Heo <tj@kernel.org>
Subject: [ 16/24] ahci: Add AMD CZ SATA device ID
Date: Thu, 18 Jul 2013 19:24:48 -0700
Message-Id: <20130719022405.135225565@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719022404.015008451@linuxfoundation.org>
References: <20130719022404.015008451@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shane Huang <shane.huang@amd.com>

commit fafe5c3d82a470d73de53e6b08eb4e28d974d895 upstream.

To add AMD CZ SATA controller device ID of IDE mode.

[bhelgaas: drop pci_ids.h update]
Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c   |    1 +
 drivers/pci/quirks.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -284,6 +284,7 @@ static const struct pci_device_id ahci_p
 
 	/* AMD */
 	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
+	{ PCI_VDEVICE(AMD, 0x7900), board_ahci }, /* AMD CZ */
 	/* AMD is using RAID class only for ahci controllers */
 	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1062,6 +1062,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x7900, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, 0x7900, quirk_amd_ide_mode);
 
 /*
  *	Serverworks CSB5 IDE does not fully support native mode



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3FDRMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:12:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48350 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649Ab3FDQ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:59:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Tejun Heo <tj@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 60/75] ata_piix: add PCI IDs for Intel BayTail
Date: Tue,  4 Jun 2013 09:55:44 -0700
Message-Id: <1370364959-9475-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>

commit fca8c90d519dedd4f4b19901d005c243f7f0bf2e upstream.

Adds IDE-mode SATA Device IDs for the Intel BayTrail platform.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/ata_piix.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 78283bb..12fb576 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -151,6 +151,7 @@ enum piix_controller_ids {
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 	ich8_sata_snb,
 	ich8_2port_sata_snb,
+	ich8_2port_sata_byt,
 };
 
 struct piix_map_db {
@@ -334,6 +335,9 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x8d60, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */
 	{ 0x8086, 0x8d68, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (BayTrail) */
+	{ 0x8086, 0x0F20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
+	{ 0x8086, 0x0F21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
 
 	{ }	/* terminate list */
 };
@@ -441,6 +445,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
 	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
+	[ich8_2port_sata_byt]	= &ich8_2port_map_db,
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -1254,6 +1259,16 @@ static struct ata_port_info piix_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
+
+	[ich8_2port_sata_byt] =
+	{
+		.flags          = PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
+		.pio_mask       = ATA_PIO4,
+		.mwdma_mask     = ATA_MWDMA2,
+		.udma_mask      = ATA_UDMA6,
+		.port_ops       = &piix_sata_ops,
+	},
+
 };
 
 #define AHCI_PCI_BAR 5
-- 
1.8.1.2


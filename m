Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab3GCSv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:51:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab3GCSk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:59 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=HXyPP2Qb0QgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=iL1bFuo9EW0A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=dGJ0OcVc7YAA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184051.055907147@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Tejun Heo <tj@kernel.org>
Subject: [039/141] ata_piix: add PCI IDs for Intel BayTail
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0039-ata_piix-add-PCI-IDs-for-Intel-BayTail.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>

[ Upstream commit fca8c90d519dedd4f4b19901d005c243f7f0bf2e ]

Adds IDE-mode SATA Device IDs for the Intel BayTrail platform.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/ata/ata_piix.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 7bfe093..80c44c30 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -151,6 +151,7 @@ enum piix_controller_ids {
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 	ich8_sata_snb,
 	ich8_2port_sata_snb,
+	ich8_2port_sata_byt,
 };
 
 struct piix_map_db {
@@ -340,6 +341,9 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x9c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (DH89xxCC) */
 	{ 0x8086, 0x2326, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (BayTrail) */
+	{ 0x8086, 0x0F20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
+	{ 0x8086, 0x0F21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
 	{ }	/* terminate list */
 };
 
@@ -504,6 +508,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
 	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
+	[ich8_2port_sata_byt]	= &ich8_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -654,6 +659,16 @@ static struct ata_port_info piix_port_info[] = {
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
 
 static struct pci_bits piix_enable_bits[] = {
-- 
1.7.10.4



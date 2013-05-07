Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab3EGEKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:10:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23893 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948Ab3EGD6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:48 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=4oRZ3Pd6aBQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aluiyOVgDl0A:10 a=QyXUC8HyAAAA:8 a=iox4zFpeAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=dGJ0OcVc7YAA:10 a=n9GBPR9yFnkA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035843.767827142@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Lee, Chun-Yi" <jlee@suse.com>, Youquan Song <youquan.song@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [017/126] ata_piix: Fix DVD not dectected at some Haswell platforms
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0017-ata_piix-Fix-DVD-not-dectected-at-some-Haswell-platf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Youquan Song <youquan.song@intel.com>

[ Upstream commit b55f84e2d527182e7c611d466cd0bb6ddce201de ]

There is a quirk patch 5e5a4f5d5a08c9c504fe956391ac3dae2c66556d
"ata_piix: make DVD Drive recognisable on systems with Intel Sandybridge
 chipsets(v2)" fixing the 4 ports IDE controller 32bit PIO mode.

We've hit a problem with DVD not recognized on Haswell Desktop platform which
includes Lynx Point 2-port SATA controller.

This quirk patch disables 32bit PIO on this controller in IDE mode.

v2: Change spelling error in statememnt pointed by Sergei Shtylyov.
v3: Change comment statememnt and spliting line over 80 characters pointed by
    Libor Pechacek and also rebase the patch against 3.8-rc7 kernel.

Tested-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/ata/ata_piix.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ef773e1..7bfe093 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -150,6 +150,7 @@ enum piix_controller_ids {
 	tolapai_sata,
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 	ich8_sata_snb,
+	ich8_2port_sata_snb,
 };
 
 struct piix_map_db {
@@ -502,6 +503,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[ich8m_apple_sata]	= &ich8m_apple_map_db,
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
+	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -643,6 +645,15 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
+	[ich8_2port_sata_snb] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR
+					| PIIX_FLAG_PIO16,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
-- 
1.7.10.4



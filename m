Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaEVPIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:08:16 -0400
Received: from isis.lip6.fr ([132.227.60.2]:56399 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaEVPIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:08:13 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Jaroslav Kysela <perex@perex.cz>
Cc: benoit.taine@lip6.fr, Takashi Iwai <tiwai@suse.de>,
        kernel-janitors@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Thu, 22 May 2014 17:08:54 +0200
Message-Id: <1400771334-25112-1-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Thu, 22 May 2014 17:08:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should prefer `const struct pci_device_id` over
`DEFINE_PCI_DEVICE_TABLE` to meet kernel coding style guidelines.
This issue was reported by checkpatch.

A simplified version of the semantic patch that makes this change is as
follows (http://coccinelle.lip6.fr/):

// <smpl>

@@
identifier i;
declarer name DEFINE_PCI_DEVICE_TABLE;
initializer z;
@@

- DEFINE_PCI_DEVICE_TABLE(i)
+ const struct pci_device_id i[]
= z;

// </smpl>

It has been tested by compilation.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
 sound/pci/hda/hda_intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 2c54629..ab0fd6d 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1730,7 +1730,7 @@ static void azx_remove(struct pci_dev *pci)
 }
 
 /* PCI IDs */
-static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
+static const struct pci_device_id azx_ids[] = {
 	/* CPT */
 	{ PCI_DEVICE(0x8086, 0x1c20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },


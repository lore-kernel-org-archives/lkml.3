Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaKZWHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:07:32 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:38745 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKZWHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:07:30 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/3] video: fbdev: vt8623fb: suppress build warning
Date: Wed, 26 Nov 2014 22:07:23 +0000
Message-Id: <1417039645-5313-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fixes following build warning:
drivers/video/fbdev/vt8623fb.c: In function ‘vt8623_pci_probe’:
drivers/video/fbdev/vt8623fb.c:734:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  par->state.vgabase = (void __iomem *) vga_res.start;
                       ^
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/video/fbdev/vt8623fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/vt8623fb.c b/drivers/video/fbdev/vt8623fb.c
index 5c7cbc6..ea7f056 100644
--- a/drivers/video/fbdev/vt8623fb.c
+++ b/drivers/video/fbdev/vt8623fb.c
@@ -731,7 +731,7 @@ static int vt8623_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *) (unsigned long) vga_res.start;
 
 	/* Find how many physical memory there is on card */
 	memsize1 = (vga_rseq(par->state.vgabase, 0x34) + 1) >> 1;
-- 
1.9.1


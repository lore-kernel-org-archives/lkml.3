Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaKZWHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:07:36 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48865 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKZWHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:07:33 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/3] video: fbdev: arkfb: suppress build warning
Date: Wed, 26 Nov 2014 22:07:25 +0000
Message-Id: <1417039645-5313-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417039645-5313-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1417039645-5313-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fixes following build warning:

drivers/video/fbdev/arkfb.c: In function ‘ark_pci_probe’:
drivers/video/fbdev/arkfb.c:1019:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  par->state.vgabase = (void __iomem *) vga_res.start;
                       ^
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/video/fbdev/arkfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/arkfb.c b/drivers/video/fbdev/arkfb.c
index adc4ea2..b305a1e 100644
--- a/drivers/video/fbdev/arkfb.c
+++ b/drivers/video/fbdev/arkfb.c
@@ -1016,7 +1016,7 @@ static int ark_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *) (unsigned long) vga_res.start;
 
 	/* FIXME get memsize */
 	regval = vga_rseq(par->state.vgabase, 0x10);
-- 
1.9.1


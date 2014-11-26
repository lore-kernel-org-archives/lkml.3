Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaKZWHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:07:37 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62831 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaKZWHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:07:32 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/3] video: fbdev: s3fb: suppress build warning
Date: Wed, 26 Nov 2014 22:07:24 +0000
Message-Id: <1417039645-5313-2-git-send-email-prabhakar.csengg@gmail.com>
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
drivers/video/fbdev/s3fb.c: In function ‘s3_pci_probe’:
drivers/video/fbdev/s3fb.c:1185:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  par->state.vgabase = (void __iomem *) vga_res.start;
                       ^
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/video/fbdev/s3fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/s3fb.c b/drivers/video/fbdev/s3fb.c
index c43b969..f0ae61a 100644
--- a/drivers/video/fbdev/s3fb.c
+++ b/drivers/video/fbdev/s3fb.c
@@ -1182,7 +1182,7 @@ static int s3_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *) (unsigned long) vga_res.start;
 
 	/* Unlock regs */
 	cr38 = vga_rcrt(par->state.vgabase, 0x38);
-- 
1.9.1


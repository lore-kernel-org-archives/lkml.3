Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaLEITO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:19:14 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12538 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbaLEITM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:19:12 -0500
From: Qiang Chen <qiang2.chen@sonymobile.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qiang Chen <qcwj.lk@gmail.com>
Subject: [PATCH] video: ocfb: Fix data type warning
Date: Fri, 5 Dec 2014 16:18:30 +0800
Message-ID: <1417767510-31462-1-git-send-email-qiang2.chen@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocate framebuffer memory using dma_alloc_coherent(),
we'd better use dma_addr_t instead of phys_addr_t. Because the
address we got in fact is DMA or bus address for the platform.

This patch also fixes below build warning:
drivers/video/fbdev/ocfb.c:335:2:
	warning: passing argument 3 of ‘dma_alloc_attrs’
	from incompatible pointer type [enabled by default]

Signed-off-by: Qiang Chen <qiang2.chen@sonymobile.com>
---
 drivers/video/fbdev/ocfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/ocfb.c b/drivers/video/fbdev/ocfb.c
index 7f9dc9b..de98196 100644
--- a/drivers/video/fbdev/ocfb.c
+++ b/drivers/video/fbdev/ocfb.c
@@ -61,7 +61,7 @@ struct ocfb_dev {
 	/* flag indicating whether the regs are little endian accessed */
 	int little_endian;
 	/* Physical and virtual addresses of framebuffer */
-	phys_addr_t fb_phys;
+	dma_addr_t fb_phys;
 	void __iomem *fb_virt;
 	u32 pseudo_palette[PALETTE_SIZE];
 };
-- 
1.8.2.2


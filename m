Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3LSIXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:23:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50223 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3LSIXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:23:14 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-fbdev@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] video: mx3fb: Allow blocking during framebuffer allocation
Date: Thu, 19 Dec 2013 09:23:08 +0100
Message-Id: <1387441388-10962-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.5.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to allocate the framebuffer from the atomic pool, we are not
in interrupt context. Adding GFP_KERNEL to the framebuffer allocation
allows to use the much bigger CMA pool to allocate the framebuffer.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/video/mx3fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index cfdb380..c882bec 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -1263,7 +1263,7 @@ static int mx3fb_map_video_memory(struct fb_info *fbi, unsigned int mem_len,
 
 	fbi->screen_base = dma_alloc_writecombine(fbi->device,
 						  mem_len,
-						  &addr, GFP_DMA);
+						  &addr, GFP_DMA | GFP_KERNEL);
 
 	if (!fbi->screen_base) {
 		dev_err(fbi->device, "Cannot allocate %u bytes framebuffer memory\n",
-- 
1.8.5.1


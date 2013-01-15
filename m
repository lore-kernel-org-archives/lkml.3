Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab3AONb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:31:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58885 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab3AONbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:31:23 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 08/10] video: da8xx-fb: store struct device *
Date: Tue, 15 Jan 2013 19:02:22 +0530
Message-ID: <772688fb6e53edec2d27bfeca4286b84721be68d.1358250489.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358250489.git.afzal@ti.com>
References: <cover.1358250489.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

store struct device pointer so that dev_dbg/err can be used outside
of probe.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 7f08644..a5341d0 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -150,6 +150,7 @@ static inline void lcdc_write(unsigned int val, unsigned int addr)
 }
 
 struct da8xx_fb_par {
+	struct device		*dev;
 	resource_size_t p_palette_base;
 	unsigned char *v_palette_base;
 	dma_addr_t		vram_phys;
@@ -1291,6 +1292,7 @@ static int fb_probe(struct platform_device *device)
 	}
 
 	par = da8xx_fb_info->par;
+	par->dev = &device->dev;
 	par->lcdc_clk = fb_clk;
 	par->lcd_fck_rate = clk_get_rate(fb_clk);
 	if (fb_pdata->panel_power_ctrl) {
-- 
1.7.9.5


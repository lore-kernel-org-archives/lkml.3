Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3AONdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:33:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46292 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941Ab3AONbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:31:10 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 06/10] video: da8xx-fb: store clk rate even if !CPUFREQ
Date: Tue, 15 Jan 2013 19:02:09 +0530
Message-ID: <564a1730402897cabc71d114b6272120641428bd.1358250489.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358250489.git.afzal@ti.com>
References: <cover.1358250489.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

store lcd clk rate always, i.e. irrespective of whether CPUFREQ is
enabled or not. This can be used to get clk rate directly instead of
enquiring with clock framework with clk handle every time.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index d060f14..f1d88ac 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -174,8 +174,8 @@ struct da8xx_fb_par {
 	unsigned int		which_dma_channel_done;
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
-	unsigned int		lcd_fck_rate;
 #endif
+	unsigned int		lcd_fck_rate;
 	void (*panel_power_ctrl)(int);
 	u32 pseudo_palette[16];
 	struct fb_videomode	mode;
@@ -1302,9 +1302,7 @@ static int fb_probe(struct platform_device *device)
 
 	par = da8xx_fb_info->par;
 	par->lcdc_clk = fb_clk;
-#ifdef CONFIG_CPU_FREQ
 	par->lcd_fck_rate = clk_get_rate(fb_clk);
-#endif
 	par->pxl_clk = lcdc_info->pixclock;
 	if (fb_pdata->panel_power_ctrl) {
 		par->panel_power_ctrl = fb_pdata->panel_power_ctrl;
-- 
1.7.9.5


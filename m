Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3AONap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:30:45 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59526 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab3AONan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:30:43 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 02/10] video: da8xx-fb: simplify lcd_reset
Date: Tue, 15 Jan 2013 19:01:42 +0530
Message-ID: <30c49dcaab7a213673db5086b7e9cc64e64202cf.1358250489.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358250489.git.afzal@ti.com>
References: <cover.1358250489.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lcd_reset function doesn't require any arguement, remove it.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index d00dd17..52977b1 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -681,7 +681,7 @@ static int fb_setcolreg(unsigned regno, unsigned red, unsigned green,
 }
 #undef CNVT_TOHW
 
-static void lcd_reset(struct da8xx_fb_par *par)
+static void da8xx_fb_lcd_reset(void)
 {
 	/* Disable the Raster if previously Enabled */
 	lcd_disable_raster(false);
@@ -721,7 +721,7 @@ static int lcd_init(struct da8xx_fb_par *par, const struct lcd_ctrl_config *cfg,
 	u32 bpp;
 	int ret = 0;
 
-	lcd_reset(par);
+	da8xx_fb_lcd_reset();
 
 	/* Calculate the divider */
 	lcd_calc_clk_divider(par);
-- 
1.7.9.5


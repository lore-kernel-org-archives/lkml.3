Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab3AONbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:31:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44441 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108Ab3AONbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:31:31 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 09/10] video: da8xx-fb: report correct pixclock
Date: Tue, 15 Jan 2013 19:02:28 +0530
Message-ID: <0afcc9a2b298874ec1402db6906e0069fd072e45.1358250489.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358250489.git.afzal@ti.com>
References: <cover.1358250489.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update "var" pixclock with the value that is configurable in hardware.
This lets user know the actual pixclock.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index a5341d0..0f73c76 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -686,6 +686,15 @@ static inline unsigned da8xx_fb_calc_clk_divider(struct da8xx_fb_par *par,
 	return par->lcd_fck_rate / (PICOS2KHZ(pixclock) * 1000);
 }
 
+static inline unsigned da8xx_fb_round_clk(struct da8xx_fb_par *par,
+					  unsigned pixclock)
+{
+	unsigned div;
+
+	div = da8xx_fb_calc_clk_divider(par, pixclock);
+	return KHZ2PICOS(par->lcd_fck_rate / (1000 * div));
+}
+
 static inline void da8xx_fb_config_clk_divider(unsigned div)
 {
 	/* Configure the LCD clock divisor. */
@@ -962,6 +971,8 @@ static int fb_check_var(struct fb_var_screeninfo *var,
 	if (var->yres + var->yoffset > var->yres_virtual)
 		var->yoffset = var->yres_virtual - var->yres;
 
+	var->pixclock = da8xx_fb_round_clk(par, var->pixclock);
+
 	return err;
 }
 
-- 
1.7.9.5


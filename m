Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3AVQxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:53:06 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45829 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab3AVQxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:53:02 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 08/12] video: da8xx-fb: invoke platform callback safely
Date: Tue, 22 Jan 2013 22:22:47 +0530
Message-ID: <80ce1ec4b0b5dd307eecb82029ec97583724a312.1358871750.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358871750.git.afzal@ti.com>
References: <cover.1358871750.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that platform data is present before checking whether platform
callback is present (the one used to control backlight). So far this
was not an issue as driver was purely non-DT triggered, but now DT
support has been added.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 08ee8eb..0beed20 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1347,7 +1347,7 @@ static int fb_probe(struct platform_device *device)
 	par->dev = &device->dev;
 	par->lcdc_clk = fb_clk;
 	par->lcd_fck_rate = clk_get_rate(fb_clk);
-	if (fb_pdata->panel_power_ctrl) {
+	if (fb_pdata && fb_pdata->panel_power_ctrl) {
 		par->panel_power_ctrl = fb_pdata->panel_power_ctrl;
 		par->panel_power_ctrl(1);
 	}
-- 
1.7.12


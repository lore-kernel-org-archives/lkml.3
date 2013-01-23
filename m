Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3AWLst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:48:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44463 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab3AWLsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:48:45 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 08/12] video: da8xx-fb: invoke platform callback safely
Date: Wed, 23 Jan 2013 17:18:34 +0530
Message-ID: <ed23f584e1e0f44145c0db1a537d79b013713ae5.1358937685.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358937685.git.afzal@ti.com>
References: <cover.1358937685.git.afzal@ti.com>
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


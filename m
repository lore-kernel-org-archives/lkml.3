Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab3A1JV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:21:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48053 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab3A1JVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:21:18 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v5 05/12] video: da8xx-fb: ensure non-null cfg in pdata
Date: Mon, 28 Jan 2013 14:51:08 +0530
Message-ID: <dbcaf73c109a654301d0299caaec3b6fb57517dc.1359356015.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1359356015.git.afzal@ti.com>
References: <cover.1359356015.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that platform data contains pointer for lcd_ctrl_config.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 7a32e83..3b146bc 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1320,6 +1320,11 @@ static int fb_probe(struct platform_device *device)
 
 	lcd_cfg = (struct lcd_ctrl_config *)fb_pdata->controller_data;
 
+	if (!lcd_cfg) {
+		ret = -EINVAL;
+		goto err_pm_runtime_disable;
+	}
+
 	da8xx_fb_info = framebuffer_alloc(sizeof(struct da8xx_fb_par),
 					&device->dev);
 	if (!da8xx_fb_info) {
-- 
1.7.12


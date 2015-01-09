Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbbAICAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:00:10 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:47615 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbbAICAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:00:08 -0500
X-Greylist: delayed 718 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 21:00:08 EST
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: hl@rock-chips.com
X-FST-TO: djkurtz@chromium.org
X-SENDER-IP: 104.167.231.161
X-LOGIN-NAME: hl@rock-chips.com
X-UNIQUE-TAG: <f5a2d890e337c354e55923681c8bebce>
X-DNS-TYPE: 0
From: huang lin <hl@rock-chips.com>
To: djkurtz@chromium.org
Cc: dianders@chromium.org, linux-rockchip@lists.infradead.org,
        huang lin <hl@rock-chips.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/panel: Add support for AUO b101ean01 panel
Date: Fri,  9 Jan 2015 09:47:55 +0800
Message-Id: <1420768075-22588-1-git-send-email-hl@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AUO b101ean01 panel is a 10.1" 1280x800 panel,
which can be supported by the simple panel driver.

Signed-off-by: huang lin <hl@rock-chips.com>

---

 drivers/gpu/drm/panel/panel-simple.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index e95385b..4f2baee 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -392,6 +392,29 @@ static const struct panel_desc auo_b116xw03 = {
 	},
 };
 
+static const struct drm_display_mode auo_b101ean01_mode = {
+	.clock = 72500,
+	.hdisplay = 1280,
+	.hsync_start = 1280 + 200,
+	.hsync_end = 1280 + 200 + 147,
+	.htotal = 1280 + 200 + 147 + 32,
+	.vdisplay = 800,
+	.vsync_start = 800 + 16,
+	.vsync_end = 800 + 16 + 4,
+	.vtotal = 800 + 16 + 4 + 4,
+	.vrefresh = 60,
+};
+
+static const struct panel_desc auo_b101ean01 = {
+	.modes = &auo_b101ean01_mode,
+	.num_modes = 1,
+	.bpc = 6,
+	.size = {
+		.width = 228,
+		.height = 148,
+	},
+};
+
 static const struct drm_display_mode auo_b133xtn01_mode = {
 	.clock = 69500,
 	.hdisplay = 1366,
@@ -727,6 +750,9 @@ static const struct of_device_id platform_of_match[] = {
 		.compatible = "auo,b101aw03",
 		.data = &auo_b101aw03,
 	}, {
+		.compatible = "auo,b101ean01",
+		.data = &auo_b101ean01,
+	}, {
 		.compatible = "auo,b101xtn01",
 		.data = &auo_b101xtn01,
 	}, {
-- 
1.9.1



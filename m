Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbbAOG0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 01:26:43 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:35688 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbbAOG0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 01:26:42 -0500
X-Greylist: delayed 647 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2015 01:26:42 EST
X-RL-SENDER: hl@rock-chips.com
X-FST-TO: djkurtz@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: hl@rock-chips.com
X-UNIQUE-TAG: <41f4c2f62cc3b46b2249d18c1cd39d52>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: huang lin <hl@rock-chips.com>
To: djkurtz@chromium.org
Cc: dianders@chromium.org, linux-rockchip@lists.infradead.org,
        huang lin <hl@rock-chips.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] drm/panel: Add support for AUO b101ean01 panel
Date: Thu, 15 Jan 2015 14:15:35 +0800
Message-Id: <1421302535-9369-1-git-send-email-hl@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AUO b101ean01 panel is a 10.1" 1280x800 panel,
which can be supported by the simple panel driver.

Signed-off-by: huang lin <hl@rock-chips.com>

---

Changes in v2:
- changed panel timing

 drivers/gpu/drm/panel/panel-simple.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index e95385b..c02f0e6 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -392,6 +392,29 @@ static const struct panel_desc auo_b116xw03 = {
 	},
 };
 
+static const struct drm_display_mode auo_b101ean01_mode = {
+	.clock = 72500,
+	.hdisplay = 1280,
+	.hsync_start = 1280 + 147,
+	.hsync_end = 1280 + 147 + 32,
+	.htotal = 1280 + 147 + 32 + 21,
+	.vdisplay = 800,
+	.vsync_start = 800 + 4,
+	.vsync_end = 800 + 4 + 4,
+	.vtotal = 800 + 4 + 4 + 8,
+	.vrefresh = 60,
+};
+
+static const struct panel_desc auo_b101ean01 = {
+	.modes = &auo_b101ean01_mode,
+	.num_modes = 1,
+	.bpc = 6,
+	.size = {
+		.width = 217,
+		.height = 136,
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


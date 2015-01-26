Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbbAZB7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 20:59:46 -0500
Received: from sg-smtp01.263.net ([54.255.195.220]:44638 "EHLO
	sg-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbbAZB7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 20:59:43 -0500
X-Greylist: delayed 721 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jan 2015 20:59:43 EST
X-RL-SENDER: hl@rock-chips.com
X-FST-TO: djkurtz@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: hl@rock-chips.com
X-UNIQUE-TAG: <35095458e82cc8f8baffd79e04ce4701>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: huang lin <hl@rock-chips.com>
To: djkurtz@chromium.org
Cc: dianders@chromium.org, linux-rockchip@lists.infradead.org,
        huang lin <hl@rock-chips.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] drm/panel: Add support for AUO b101ean01 panel
Date: Mon, 26 Jan 2015 09:47:25 +0800
Message-Id: <1422236845-25672-1-git-send-email-hl@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AUO b101ean01 panel is a 10.1" 1280x800 panel,
which can be supported by the simple panel driver.

Signed-off-by: huang lin <hl@rock-chips.com>

---

Changes in v4:
- Add auo,b101ean01.txt file

 .../devicetree/bindings/panel/auo,b101ean01.txt    |  7 ++++++
 drivers/gpu/drm/panel/panel-simple.c               | 26 ++++++++++++++++++++++
 2 files changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/auo,b101ean01.txt

diff --git a/Documentation/devicetree/bindings/panel/auo,b101ean01.txt b/Documentation/devicetree/bindings/panel/auo,b101ean01.txt
new file mode 100644
index 0000000..3590b07
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/auo,b101ean01.txt
@@ -0,0 +1,7 @@
+AU Optronics Corporation 10.1" WSVGA TFT LCD panel
+
+Required properties:
+- compatible: should be "auo,b101ean01"
+
+This binding is compatible with the simple-panel binding, which is specified
+in simple-panel.txt in this directory.
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index e95385b..24828e0 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -345,6 +345,29 @@ static const struct panel_desc auo_b101aw03 = {
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
 static const struct drm_display_mode auo_b101xtn01_mode = {
 	.clock = 72000,
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


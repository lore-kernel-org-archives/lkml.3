Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaFENxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:53:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58135 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726AbaFENxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:53:37 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: David Airlie <airlied@linux.ie>, Randy Dunlap <rdunlap@infradead.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 2/2] drm/panel: add support for Foxlink FL500WVR00-A0T panel
Date: Thu,  5 Jun 2014 15:53:32 +0200
Message-Id: <1401976412-27436-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401976412-27436-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1401976412-27436-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This panel is used by Atmel's SAMA5D3 Evaluation Kits (sama5d3xek) and
supported by the simple-panel driver.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 .../bindings/panel/foxlink,fl500wvr00-a0t.txt      |  7 ++++++
 drivers/gpu/drm/panel/panel-simple.c               | 25 ++++++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/foxlink,fl500wvr00-a0t.txt

diff --git a/Documentation/devicetree/bindings/panel/foxlink,fl500wvr00-a0t.txt b/Documentation/devicetree/bindings/panel/foxlink,fl500wvr00-a0t.txt
new file mode 100644
index 0000000..b47f9d8
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/foxlink,fl500wvr00-a0t.txt
@@ -0,0 +1,7 @@
+Foxlink Group 5" WVGA TFT LCD panel
+
+Required properties:
+- compatible: should be "foxlink,fl500wvr00-a0t"
+
+This binding is compatible with the simple-panel binding, which is specified
+in simple-panel.txt in this directory.
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 309f29e..51c5476 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -328,6 +328,28 @@ static const struct panel_desc chunghwa_claa101wb01 = {
 	},
 };
 
+static const struct drm_display_mode foxlink_fl500wvr00_a0t_mode = {
+	.clock = 32260,
+	.hdisplay = 800,
+	.hsync_start = 800 + 168,
+	.hsync_end = 800 + 168 + 64,
+	.htotal = 800 + 168 + 64 + 88,
+	.vdisplay = 480,
+	.vsync_start = 480 + 37,
+	.vsync_end = 480 + 37 + 2,
+	.vtotal = 480 + 37 + 2 + 8,
+	.vrefresh = 60,
+};
+
+static const struct panel_desc foxlink_fl500wvr00_a0t = {
+	.modes = &foxlink_fl500wvr00_a0t_mode,
+	.num_modes = 1,
+	.size = {
+		.width = 108,
+		.height = 65,
+	},
+};
+
 static const struct drm_display_mode lg_lp129qe_mode = {
 	.clock = 285250,
 	.hdisplay = 2560,
@@ -383,6 +405,9 @@ static const struct of_device_id platform_of_match[] = {
 		.compatible = "chunghwa,claa101wb01",
 		.data = &chunghwa_claa101wb01
 	}, {
+		.compatible = "foxlink,fl500wvr00-a0t",
+		.data = &foxlink_fl500wvr00_a0t,
+	}, {
 		.compatible = "lg,lp129qe",
 		.data = &lg_lp129qe,
 	}, {
-- 
1.8.3.2


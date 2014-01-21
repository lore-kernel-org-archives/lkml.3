Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaAUJ5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:57:39 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10750 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbaAUJ5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:57:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 21 Jan 2014 01:56:52 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Airlie <airlied@linux.ie>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/2] drm/panel: add support for LG LH500WX1-SD03 panel
Date: Tue, 21 Jan 2014 18:57:09 +0900
Message-ID: <1390298230-13190-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390298230-13190-1-git-send-email-acourbot@nvidia.com>
References: <1390298230-13190-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This panel is used by the NVIDIA SHIELD and supported by the
simple-panel driver.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../devicetree/bindings/panel/lg,lh500wx1-sd03.txt |  7 ++++++
 drivers/gpu/drm/panel/panel-simple.c               | 28 ++++++++++++++++++++++
 2 files changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/lg,lh500wx1-sd03.txt

diff --git a/Documentation/devicetree/bindings/panel/lg,lh500wx1-sd03.txt b/Documentation/devicetree/bindings/panel/lg,lh500wx1-sd03.txt
new file mode 100644
index 000000000000..a04fd2b2e73d
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/lg,lh500wx1-sd03.txt
@@ -0,0 +1,7 @@
+LG Corporation 5" HD TFT LCD panel
+
+Required properties:
+- compatible: should be "lg,lh500wx1-sd03"
+
+This binding is compatible with the simple-panel binding, which is specified
+in simple-panel.txt in this directory.
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 59d52ca2c67f..410bb83ae2f0 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -383,6 +383,28 @@ static const struct panel_desc samsung_ltn101nt05 = {
 	},
 };
 
+static const struct drm_display_mode lg_lh500wx1_sd03_mode = {
+	.clock = 58000,
+	.hdisplay = 720,
+	.hsync_start = 720 + 12,
+	.hsync_end = 720 + 12 + 4,
+	.htotal = 720 + 12 + 4 + 112,
+	.vdisplay = 1280,
+	.vsync_start = 1280 + 8,
+	.vsync_end = 1280 + 8 + 4,
+	.vtotal = 1280 + 8 + 4 + 12,
+	.vrefresh = 60,
+};
+
+static const struct panel_desc lg_lh500wx1_sd03 = {
+	.modes = &lg_lh500wx1_sd03_mode,
+	.num_modes = 1,
+	.size = {
+		.width = 62,
+		.height = 110,
+	},
+};
+
 static const struct of_device_id platform_of_match[] = {
 	{
 		.compatible = "auo,b101aw03",
@@ -397,6 +419,9 @@ static const struct of_device_id platform_of_match[] = {
 		.compatible = "samsung,ltn101nt05",
 		.data = &samsung_ltn101nt05,
 	}, {
+		.compatible = "lg,lh500wx1-sd03",
+		.data = &lg_lh500wx1_sd03
+	}, {
 		.compatible = "simple-panel",
 	}, {
 		/* sentinel */
@@ -468,6 +493,9 @@ static const struct of_device_id dsi_of_match[] = {
 		.compatible = "panasonic,vvx10f004b00",
 		.data = &panasonic_vvx10f004b00
 	}, {
+		.compatible = "lg,lh500wx1-sd03",
+		.data = &lg_lh500wx1_sd03
+	}, {
 		/* sentinel */
 	}
 };
-- 
1.8.5.3


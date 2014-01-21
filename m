Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaAUJ5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:57:44 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10758 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbaAUJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:57:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 21 Jan 2014 01:56:54 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Airlie <airlied@linux.ie>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] drm/panel: add support for LG LD070WX3-SL01 panel
Date: Tue, 21 Jan 2014 18:57:10 +0900
Message-ID: <1390298230-13190-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390298230-13190-1-git-send-email-acourbot@nvidia.com>
References: <1390298230-13190-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This panel is used by Tegra Note 7 and supported by the simple-panel
driver.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../devicetree/bindings/panel/lg,ld070wx3-sl01.txt |  7 ++++++
 drivers/gpu/drm/panel/panel-simple.c               | 28 ++++++++++++++++++++++
 2 files changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/lg,ld070wx3-sl01.txt

diff --git a/Documentation/devicetree/bindings/panel/lg,ld070wx3-sl01.txt b/Documentation/devicetree/bindings/panel/lg,ld070wx3-sl01.txt
new file mode 100644
index 000000000000..5e649cb9aa1a
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/lg,ld070wx3-sl01.txt
@@ -0,0 +1,7 @@
+LG Corporation 7" WXGA TFT LCD panel
+
+Required properties:
+- compatible: should be "lg,ld070wx3-sl01"
+
+This binding is compatible with the simple-panel binding, which is specified
+in simple-panel.txt in this directory.
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 410bb83ae2f0..a2defc0eb36f 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -405,6 +405,28 @@ static const struct panel_desc lg_lh500wx1_sd03 = {
 	},
 };
 
+static const struct drm_display_mode lg_ld070wx3_sl01_mode = {
+	.clock = 65000,
+	.hdisplay = 800,
+	.hsync_start = 800 + 32,
+	.hsync_end = 800 + 32 + 1,
+	.htotal = 800 + 32 + 1 + 57,
+	.vdisplay = 1280,
+	.vsync_start = 1280 + 28,
+	.vsync_end = 1280 + 28 + 1,
+	.vtotal = 1280 + 28 + 1 + 14,
+	.vrefresh = 60,
+};
+
+static const struct panel_desc lg_ld070wx3_sl01 = {
+	.modes = &lg_ld070wx3_sl01_mode,
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
@@ -422,6 +444,9 @@ static const struct of_device_id platform_of_match[] = {
 		.compatible = "lg,lh500wx1-sd03",
 		.data = &lg_lh500wx1_sd03
 	}, {
+		.compatible = "lg,ld070wx3-sl01",
+		.data = &lg_ld070wx3_sl01,
+	}, {
 		.compatible = "simple-panel",
 	}, {
 		/* sentinel */
@@ -496,6 +521,9 @@ static const struct of_device_id dsi_of_match[] = {
 		.compatible = "lg,lh500wx1-sd03",
 		.data = &lg_lh500wx1_sd03
 	}, {
+		.compatible = "lg,ld070wx3-sl01",
+		.data = &lg_ld070wx3_sl01
+	}, {
 		/* sentinel */
 	}
 };
-- 
1.8.5.3


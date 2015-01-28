Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762745AbbA2Cny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:43:54 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63467 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbbA2Cnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:43:50 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Simon Glass <sjg@chromium.org>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org
Subject: [PATCH v3 03/10] drm/panel: add support for Samsung LTN140AT29 panel
Date: Wed, 28 Jan 2015 11:51:01 +0100
Message-Id: <1422442278-10405-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stéphane Marchesin <marcheu@chromium.org>

This panel is used by the Nyan Blaze board and supported by the simple-panel
driver.

Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>
[tomeu.vizoso@collabora.com: add device tree binding document]
Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 .../bindings/panel/samsung,ltn140at29-301.txt      |  7 ++++++
 drivers/gpu/drm/panel/panel-simple.c               | 26 ++++++++++++++++++++++
 2 files changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/samsung,ltn140at29-301.txt

diff --git a/Documentation/devicetree/bindings/panel/samsung,ltn140at29-301.txt b/Documentation/devicetree/bindings/panel/samsung,ltn140at29-301.txt
new file mode 100644
index 0000000..e7f969d
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/samsung,ltn140at29-301.txt
@@ -0,0 +1,7 @@
+Samsung Electronics 14" WXGA (1366x768) TFT LCD panel
+
+Required properties:
+- compatible: should be "samsung,ltn140at29-301"
+
+This binding is compatible with the simple-panel binding, which is specified
+in simple-panel.txt in this directory.
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 39806c3..2da2285 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -779,6 +779,29 @@ static const struct panel_desc samsung_ltn101nt05 = {
 	},
 };
 
+static const struct drm_display_mode samsung_ltn140at29_301_mode = {
+	.clock = 76300,
+	.hdisplay = 1366,
+	.hsync_start = 1366 + 64,
+	.hsync_end = 1366 + 64 + 48,
+	.htotal = 1366 + 64 + 48 + 128,
+	.vdisplay = 768,
+	.vsync_start = 768 + 2,
+	.vsync_end = 768 + 2 + 5,
+	.vtotal = 768 + 2 + 5 + 17,
+	.vrefresh = 60,
+};
+
+static const struct panel_desc samsung_ltn140at29_301 = {
+	.modes = &samsung_ltn140at29_301_mode,
+	.num_modes = 1,
+	.bpc = 6,
+	.size = {
+		.width = 320,
+		.height = 187,
+	},
+};
+
 static const struct of_device_id platform_of_match[] = {
 	{
 		.compatible = "auo,b101aw03",
@@ -841,6 +864,9 @@ static const struct of_device_id platform_of_match[] = {
 		.compatible = "samsung,ltn101nt05",
 		.data = &samsung_ltn101nt05,
 	}, {
+		.compatible = "samsung,ltn140at29-301",
+		.data = &samsung_ltn140at29_301,
+	}, {
 		/* sentinel */
 	}
 };
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaGVGjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:39:15 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59869 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaGVGjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:39:13 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH v2] drm/panel: add support for InnoLux N156BGE-L21 panel
Date: Tue, 22 Jul 2014 08:38:55 +0200
Message-Id: <1406011135-25417-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140620201456.GA28814@mithrandir>
References: <20140620201456.GA28814@mithrandir>
X-Provags-ID: V02:K0:/tayQw1n5+4EnowEc9PDduW+syqt0mpwFrXChJaBo3Y
 I+ZO0UrxptH0QC6oQJpgj/hMELfy48GE8cUVctRirqoa9dfXvx
 Al+QEBtwGH3uSZ3Khd6ki3TaE3oGEUIxEs73zru1VvI0KHdLSN
 rKMSmjZF3iOnHPm41KscGd76ckns9Lfr5VnlQdxFFVdUkiSBDQ
 6W73iEEzZMnM3ZBYdv2pvrN1OF9MiHPo06xJ1Z00048HUAkm6k
 OBHhcx90zySUUTn1YFneZZPB2gJAye1gUImkpJU9dqp99aH+Vh
 TaeL0+bEY7Muzrj6hF4dOP8OepwtEmO9eDyBiWCALT4smmylBe
 a6gwQZYxQDMY+5/wj8/fKoWSAbEceMirMZFPxFx0hPnQIqQxH8
 yyxXea7Ws4lsN+mR05T/BYIIbz7ADPuuEqM2zDidWfOSzK2wWW
 uTR7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This panel is used by the Medcom Wide and supported by the
simple-panel driver.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
v2: * Added the v/hsync pulses for correctness (the panel doesn't
      really needs them)
    * Fixed the size to report the physical size in mm
---
 .../bindings/panel/innolux,n156bge-l21.txt         |  7 ++++++
 drivers/gpu/drm/panel/panel-simple.c               | 25 ++++++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/innolux,n156bge-l21.txt

diff --git a/Documentation/devicetree/bindings/panel/innolux,n156bge-l21.txt b/Documentation/devicetree/bindings/panel/innolux,n156bge-l21.txt
new file mode 100644
index 0000000..7825844
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/innolux,n156bge-l21.txt
@@ -0,0 +1,7 @@
+InnoLux 15.6" WXGA TFT LCD panel
+
+Required properties:
+- compatible: should be "innolux,n156bge-l21"
+
+This binding is compatible with the simple-panel binding, which is specified
+in simple-panel.txt in this directory.
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index a251361..ce9fffc 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -447,6 +447,28 @@ static const struct panel_desc samsung_ltn101nt05 = {
 	},
 };
 
+static const struct drm_display_mode innolux_n156bge_l21_mode = {
+	.clock = 69300,
+	.hdisplay = 1366,
+	.hsync_start = 1366 + 16,
+	.hsync_end = 1366 + 16 + 34,
+	.htotal = 1366 + 16 + 34 + 50,
+	.vdisplay = 768,
+	.vsync_start = 768 + 2,
+	.vsync_end = 768 + 2 + 6,
+	.vtotal = 768 + 2 + 6 + 12,
+	.vrefresh = 60,
+};
+
+static const struct panel_desc innolux_n156bge_l21 = {
+	.modes = &innolux_n156bge_l21_mode,
+	.num_modes = 1,
+	.size = {
+		.width = 344,
+		.height = 193,
+	},
+};
+
 static const struct of_device_id platform_of_match[] = {
 	{
 		.compatible = "auo,b101aw03",
@@ -476,6 +498,9 @@ static const struct of_device_id platform_of_match[] = {
 		.compatible = "samsung,ltn101nt05",
 		.data = &samsung_ltn101nt05,
 	}, {
+		.compatible = "innolux,n156bge-l21",
+		.data = &innolux_n156bge_l21,
+	}, {
 		.compatible = "simple-panel",
 	}, {
 		/* sentinel */
-- 
2.0.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaFLPJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:09:46 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55881 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbaFLPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:09:45 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH] drm/panel: add support for Innolux N156BGE-L21 panel
Date: Thu, 12 Jun 2014 17:09:05 +0200
Message-Id: <1402585745-28127-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.0.0
X-Provags-ID: V02:K0:VLKowwiMjNNy2guIrD7MrpR0wlugl356BslqDnXWZeH
 DIa+n/4HS7QfHGXqfKPEaK3gzr4KGcJlugT1xpwomt8bMqgQqe
 utdPTeMnDRszDXvZUdDh8sWI4qsd9SX4U1epDAECExlwYg4WUc
 GSQJQ8b7tEmRiHElA9RJ9C2SQc2BTb1rjQxp0clsnte6WdFpLU
 OTFRFUfk0E3MVxmtWKl9XEh46L6E+6POFwnlkgLmpZdGlr/Oxp
 idq6e9m5U8AKPqZuwoEWPrtDdeZWQFUxrG7b96dXBviXjiR5OZ
 PkBSivS/FTdL8xtSAiTws5YDb4O5VJr5bsUbIwMPDYKLSG/KHz
 L1o03CKYr5EmtExn/ozHN45lyAsCBardaQuKiQ5hyWiOq9pK5e
 KA1lJ1yVfxUDfXYgPhvB+RhIgjfvDSpQ0gWKCSXo31ltpEtKRZ
 lGUh+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This panel is used by the Medcom Wide and supported by the
simple-panel driver.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/gpu/drm/panel/panel-simple.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 309f29e..6a361bb 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -372,6 +372,28 @@ static const struct panel_desc samsung_ltn101nt05 = {
 	},
 };
 
+static const struct drm_display_mode innolux_n156bge_l21_mode = {
+	.clock = 69300,
+	.hdisplay = 1366,
+	.hsync_start = 1366,
+	.hsync_end = 1366,
+	.htotal = 1366 + 100,
+	.vdisplay = 768,
+	.vsync_start = 768,
+	.vsync_end = 768,
+	.vtotal = 768 + 20,
+	.vrefresh = 60,
+};
+
+static const struct panel_desc innolux_n156bge_l21 = {
+	.modes = &innolux_n156bge_l21_mode,
+	.num_modes = 1,
+	.size = {
+		.width = 1366,
+		.height = 768,
+	},
+};
+
 static const struct of_device_id platform_of_match[] = {
 	{
 		.compatible = "auo,b101aw03",
@@ -389,6 +411,9 @@ static const struct of_device_id platform_of_match[] = {
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
2.0.0


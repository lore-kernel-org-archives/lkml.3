Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbbAOQOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:14:41 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38597 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbbAOQOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:14:38 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/11] drm/panel: add support for Samsung LTN140AT29 panel
Date: Thu, 15 Jan 2015 17:12:17 +0100
Message-Id: <1421338359-27467-6-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stéphane Marchesin <marcheu@chromium.org>

This panel is used by the Nyan Blaze board and supported by the simple-panel
driver.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index e95385b..5ee1d2c 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -722,6 +722,29 @@ static const struct panel_desc samsung_ltn101nt05 = {
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
@@ -778,6 +801,9 @@ static const struct of_device_id platform_of_match[] = {
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


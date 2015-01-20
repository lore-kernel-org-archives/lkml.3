Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbbATLB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:01:29 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49634 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbATKtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:15 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/36] drm/tegra: dc: No longer disable planes at CRTC disable
Date: Tue, 20 Jan 2015 11:48:29 +0100
Message-Id: <1421750935-4023-11-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The DRM core should take care of disabling all unneeded planes, so there
is no need to do this explicitly.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 0c2972e4b41a..9cee6465b753 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1001,20 +1001,6 @@ static int tegra_dc_wait_idle(struct tegra_dc *dc, unsigned long timeout)
 static void tegra_crtc_disable(struct drm_crtc *crtc)
 {
 	struct tegra_dc *dc = to_tegra_dc(crtc);
-	struct drm_device *drm = crtc->dev;
-	struct drm_plane *plane;
-
-	drm_for_each_legacy_plane(plane, &drm->mode_config.plane_list) {
-		if (plane->crtc == crtc) {
-			tegra_window_plane_disable(plane);
-			plane->crtc = NULL;
-
-			if (plane->fb) {
-				drm_framebuffer_unreference(plane->fb);
-				plane->fb = NULL;
-			}
-		}
-	}
 
 	if (!tegra_dc_idle(dc)) {
 		tegra_dc_stop(dc);
-- 
2.1.3


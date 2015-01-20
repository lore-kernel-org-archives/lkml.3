Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbbATK4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:56:53 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55067 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbbATKtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:39 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/36] drm/tegra: Atomic conversion, phase 3, step 1
Date: Tue, 20 Jan 2015 11:48:43 +0100
Message-Id: <1421750935-4023-25-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Switch out the regular plane helpers for the atomic plane helpers. Also
use the default atomic helpers to implement the ->atomic_check() and
->atomic_commit() callbacks. The driver now exclusively uses the atomic
interfaces.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c  | 12 ++++++------
 drivers/gpu/drm/tegra/drm.c |  4 ++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index cb2bd0088295..469bfa0fe096 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -404,8 +404,8 @@ static void tegra_primary_plane_destroy(struct drm_plane *plane)
 }
 
 static const struct drm_plane_funcs tegra_primary_plane_funcs = {
-	.update_plane = drm_plane_helper_update,
-	.disable_plane = drm_plane_helper_disable,
+	.update_plane = drm_atomic_helper_update_plane,
+	.disable_plane = drm_atomic_helper_disable_plane,
 	.destroy = tegra_primary_plane_destroy,
 	.reset = drm_atomic_helper_plane_reset,
 	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
@@ -690,8 +690,8 @@ static void tegra_cursor_atomic_disable(struct drm_plane *plane,
 }
 
 static const struct drm_plane_funcs tegra_cursor_plane_funcs = {
-	.update_plane = drm_plane_helper_update,
-	.disable_plane = drm_plane_helper_disable,
+	.update_plane = drm_atomic_helper_update_plane,
+	.disable_plane = drm_atomic_helper_disable_plane,
 	.destroy = tegra_plane_destroy,
 	.reset = drm_atomic_helper_plane_reset,
 	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
@@ -740,8 +740,8 @@ static void tegra_overlay_plane_destroy(struct drm_plane *plane)
 }
 
 static const struct drm_plane_funcs tegra_overlay_plane_funcs = {
-	.update_plane = drm_plane_helper_update,
-	.disable_plane = drm_plane_helper_disable,
+	.update_plane = drm_atomic_helper_update_plane,
+	.disable_plane = drm_atomic_helper_disable_plane,
 	.destroy = tegra_overlay_plane_destroy,
 	.reset = drm_atomic_helper_plane_reset,
 	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 58a4ed192e61..0dd81d050ccb 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -10,6 +10,8 @@
 #include <linux/host1x.h>
 #include <linux/iommu.h>
 
+#include <drm/drm_atomic_helper.h>
+
 #include "drm.h"
 #include "gem.h"
 
@@ -29,6 +31,8 @@ static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
 #ifdef CONFIG_DRM_TEGRA_FBDEV
 	.output_poll_changed = tegra_fb_output_poll_changed,
 #endif
+	.atomic_check = drm_atomic_helper_check,
+	.atomic_commit = drm_atomic_helper_commit,
 };
 
 static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
-- 
2.1.3


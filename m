Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbbAWJ0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:26:42 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64103 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbbAWJ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:26:40 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] drm/plane: Make ->atomic_update() mandatory
Date: Fri, 23 Jan 2015 10:26:37 +0100
Message-Id: <1422005197-10964-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-3-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-3-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

There is no use-case where it would be useful for drivers not to
implement this function and the transitional plane helpers already
require drivers to provide an implementation.

v2: add new requirement to kerneldoc

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/drm_atomic_helper.c | 2 +-
 include/drm/drm_plane_helper.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index d467185f7942..010661f23035 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1108,7 +1108,7 @@ void drm_atomic_helper_commit_planes(struct drm_device *dev,
 
 		funcs = plane->helper_private;
 
-		if (!funcs || !funcs->atomic_update)
+		if (!funcs)
 			continue;
 
 		old_plane_state = old_state->plane_states[i];
diff --git a/include/drm/drm_plane_helper.h b/include/drm/drm_plane_helper.h
index 0f2230311aa8..a44139abbd5e 100644
--- a/include/drm/drm_plane_helper.h
+++ b/include/drm/drm_plane_helper.h
@@ -51,7 +51,7 @@ int drm_crtc_init(struct drm_device *dev, struct drm_crtc *crtc,
  * @prepare_fb: prepare a framebuffer for use by the plane
  * @cleanup_fb: cleanup a framebuffer when it's no longer used by the plane
  * @atomic_check: check that a given atomic state is valid and can be applied
- * @atomic_update: apply an atomic state to the plane
+ * @atomic_update: apply an atomic state to the plane (mandatory)
  *
  * The helper operations are called by the mid-layer CRTC helper.
  */
-- 
2.1.3


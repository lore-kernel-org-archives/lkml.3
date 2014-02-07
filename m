Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbaBGNqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:46:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:23612 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbaBGNqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:46:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,800,1384329600"; 
   d="scan'208";a="479633187"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: vijay.a.purushothaman@intel.com, airlied@linux.ie, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, tomi.valkeinen@ti.com, airlied@redhat.com,
        robdclark@gmail.com, archit@ti.com, gregkh@linuxfoundation.org,
        joe@perches.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>
Subject: [PATCH v4 04/11] drm/omap: Switch omapdrm over to drm_mode_create_rotation_property()
Date: Fri,  7 Feb 2014 19:15:09 +0530
Message-Id: <1391780716-21896-5-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Use the new drm_mode_create_rotation_property() in omapdrm.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/omapdrm/omap_plane.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
index 046d5e6..fee8f35 100644
--- a/drivers/gpu/drm/omapdrm/omap_plane.c
+++ b/drivers/gpu/drm/omapdrm/omap_plane.c
@@ -300,16 +300,13 @@ void omap_plane_install_properties(struct drm_plane *plane,
 	if (priv->has_dmm) {
 		prop = priv->rotation_prop;
 		if (!prop) {
-			const struct drm_prop_enum_list props[] = {
-					{ DRM_ROTATE_0,   "rotate-0" },
-					{ DRM_ROTATE_90,  "rotate-90" },
-					{ DRM_ROTATE_180, "rotate-180" },
-					{ DRM_ROTATE_270, "rotate-270" },
-					{ DRM_REFLECT_X,  "reflect-x" },
-					{ DRM_REFLECT_Y,  "reflect-y" },
-			};
-			prop = drm_property_create_bitmask(dev, 0, "rotation",
-					props, ARRAY_SIZE(props));
+			prop = drm_mode_create_rotation_property(dev,
+								 BIT(DRM_ROTATE_0) |
+								 BIT(DRM_ROTATE_90) |
+								 BIT(DRM_ROTATE_180) |
+								 BIT(DRM_ROTATE_270) |
+								 BIT(DRM_REFLECT_X) |
+								 BIT(DRM_REFLECT_Y));
 			if (prop == NULL)
 				return;
 			priv->rotation_prop = prop;
-- 
1.8.5


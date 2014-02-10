Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaBJHbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:31:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:51443 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaBJHbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:31:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="452607169"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        Sagar Kamble <sagar.a.kamble@intel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 04/11] drm/omap: Switch omapdrm over to drm_mode_create_rotation_property()
Date: Mon, 10 Feb 2014 13:01:11 +0530
Message-Id: <1392017478-4945-5-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
References: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Use the new drm_mode_create_rotation_property() in omapdrm.

v5: Fixed conflict due to change in the prior patch in call to
drm_property_create_bitmask()

Cc: David Airlie <airlied@linux.ie>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Sagar Kamble <sagar.a.kamble@intel.com>
Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
 drivers/gpu/drm/omapdrm/omap_plane.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
index b288f38..fee8f35 100644
--- a/drivers/gpu/drm/omapdrm/omap_plane.c
+++ b/drivers/gpu/drm/omapdrm/omap_plane.c
@@ -300,22 +300,13 @@ void omap_plane_install_properties(struct drm_plane *plane,
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
-					props, ARRAY_SIZE(props),
-					BIT(DRM_ROTATE_0) |
-					BIT(DRM_ROTATE_90) |
-					BIT(DRM_ROTATE_180) |
-					BIT(DRM_ROTATE_270) |
-					BIT(DRM_REFLECT_X) |
-					BIT(DRM_REFLECT_Y));
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


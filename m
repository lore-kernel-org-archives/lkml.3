Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaEIIE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:04:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:44595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaEIIEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:04:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1016,1389772800"; 
   d="scan'208";a="537547802"
From: sonika.jindal@intel.com
To: sonika.jindal@intel.com
Cc: David Airlie <airlied@linux.ie>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Dave Airlie <airlied@redhat.com>, Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Archit Taneja <archit@ti.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>
Subject: [PATCH 01/12] drm: Move DRM_ROTATE bits out of omapdrm into drm_crtc.h
Date: Fri,  9 May 2014 13:31:22 +0530
Message-Id: <1399622493-31701-2-git-send-email-sonika.jindal@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399622493-31701-1-git-send-email-sonika.jindal@intel.com>
References: <1399622493-31701-1-git-send-email-sonika.jindal@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala at linux.intel.com>

The rotation property stuff should be standardized among all drivers.
Move the bits to drm_crtc.h from omap_drv.h.

Cc: David Airlie <airlied@linux.ie>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Archit Taneja <archit@ti.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Sagar Kamble <sagar.a.kamble@intel.com>
Tested-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/omapdrm/omap_drv.h |    7 -------
 include/drm/drm_crtc.h             |    8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_drv.h b/drivers/gpu/drm/omapdrm/omap_drv.h
index 428b2981..aac8e10 100644
--- a/drivers/gpu/drm/omapdrm/omap_drv.h
+++ b/drivers/gpu/drm/omapdrm/omap_drv.h
@@ -119,13 +119,6 @@ struct omap_drm_private {
 	struct omap_drm_irq error_handler;
 };
 
-/* this should probably be in drm-core to standardize amongst drivers */
-#define DRM_ROTATE_0	0
-#define DRM_ROTATE_90	1
-#define DRM_ROTATE_180	2
-#define DRM_ROTATE_270	3
-#define DRM_REFLECT_X	4
-#define DRM_REFLECT_Y	5
 
 #ifdef CONFIG_DEBUG_FS
 int omap_debugfs_init(struct drm_minor *minor);
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 27f828c..4775008 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -64,6 +64,14 @@ struct drm_object_properties {
 	uint64_t values[DRM_OBJECT_MAX_PROPERTY];
 };
 
+/* rotation property bits */
+#define DRM_ROTATE_0	0
+#define DRM_ROTATE_90	1
+#define DRM_ROTATE_180	2
+#define DRM_ROTATE_270	3
+#define DRM_REFLECT_X	4
+#define DRM_REFLECT_Y	5
+
 enum drm_connector_force {
 	DRM_FORCE_UNSPECIFIED,
 	DRM_FORCE_OFF,
-- 
1.7.10.4


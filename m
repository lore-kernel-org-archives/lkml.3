Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaBJHbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:31:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:58725 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaBJHbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:31:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="452606950"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: ville.syrjala@linux.intel.com, David Airlie <airlied@linux.ie>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Dave Airlie <airlied@redhat.com>, Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Archit Taneja <archit@ti.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 01/11] drm: Move DRM_ROTATE bits out of omapdrm into drm_crtc.h
Date: Mon, 10 Feb 2014 13:01:08 +0530
Message-Id: <1392017478-4945-2-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
References: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
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
 drivers/gpu/drm/omapdrm/omap_drv.h | 7 -------
 include/drm/drm_crtc.h             | 8 ++++++++
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
index 71727b6..d5c46c1 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -65,6 +65,14 @@ struct drm_object_properties {
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
 /*
  * Note on terminology:  here, for brevity and convenience, we refer to connector
  * control chips as 'CRTCs'.  They can control any type of connector, VGA, LVDS,
-- 
1.8.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbaCHIUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 03:20:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:14969 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaCHIU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 03:20:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,613,1389772800"; 
   d="scan'208";a="488384357"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: Sagar Kamble <sagar.a.kamble@intel.com>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drm: Added plane alpha and color blending property
Date: Sat,  8 Mar 2014 13:51:16 +0530
Message-Id: <1394266879-20522-2-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1394266879-20522-1-git-send-email-sagar.a.kamble@intel.com>
References: <CAKMK7uE3yWRoirtu133JQUwPjhH+D228LFh-+Kk65vAGAj_xww@mail.gmail.com>
 <1394266879-20522-1-git-send-email-sagar.a.kamble@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagar Kamble <sagar.a.kamble@intel.com>

This patch creates a generic blending enum property.
Drivers may support subset of these values.

Cc: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/drm_crtc.c | 33 +++++++++++++++++++++++++++++++++
 include/drm/drm_crtc.h     | 25 +++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 4e43fc2..15281a3 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -4147,3 +4147,36 @@ void drm_mode_config_cleanup(struct drm_device *dev)
 	idr_destroy(&dev->mode_config.crtc_idr);
 }
 EXPORT_SYMBOL(drm_mode_config_cleanup);
+
+struct drm_property *drm_mode_create_blend_property(struct drm_device *dev,
+				unsigned int supported_factors)
+{
+	static const struct drm_prop_enum_list props[] = {
+		{ DRM_BLEND_NONE,   			"none" },
+		{ DRM_BLEND_ZERO,  			"zero" },
+		{ DRM_BLEND_ONE, 			"one" },
+		{ DRM_BLEND_SRC_COLOR, 			"src-color" },
+		{ DRM_BLEND_ONE_MINUS_SRC_COLOR,  	"one-minus-src-color" },
+		{ DRM_BLEND_DST_COLOR, 			"dst-color" },
+		{ DRM_BLEND_ONE_MINUS_DST_COLOR,  	"one-minus-dst-color" },
+		{ DRM_BLEND_SRC_ALPHA, 			"src-alpha" },
+		{ DRM_BLEND_ONE_MINUS_SRC_ALPHA, 	"one-minus-src-alpha" },
+		{ DRM_BLEND_DST_ALPHA, 			"dst-alpha" },
+		{ DRM_BLEND_ONE_MINUS_DST_ALPHA, 	"one-minus-dst-alpha" },
+		{ DRM_BLEND_CONSTANT_COLOR, 		"constant-color" },
+		{ DRM_BLEND_ONE_MINUS_CONSTANT_COLOR, 	"one-minus-constant-color" },
+		{ DRM_BLEND_CONSTANT_ALPHA, 		"constant-alpha" },
+		{ DRM_BLEND_ONE_MINUS_CONSTANT_ALPHA, 	"one-minus-constant-alpha" },
+		{ DRM_BLEND_SRC_ALPHA_SATURATE, 	"alpha-saturate" },
+		{ DRM_BLEND_SRC1_COLOR, 		"src1-color" },
+		{ DRM_BLEND_ONE_MINUS_SRC1_COLOR, 	"one-minus-src1-color" },
+		{ DRM_BLEND_SRC1_ALPHA, 		"src1-alpha" },
+		{ DRM_BLEND_ONE_MINUS_SRC1_ALPHA, 	"one-minus-src1-alpha" },
+		{ DRM_BLEND_PREMULTIPLIED_ALPHA, 	"pre-multiplied-alpha" }
+	};
+
+	return drm_property_create_bitmask(dev, 0, "blend",
+					   props, ARRAY_SIZE(props),
+					   supported_factors);
+}
+EXPORT_SYMBOL(drm_mode_create_blend_property);
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 784a568..6c5847f 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -65,6 +65,29 @@ struct drm_object_properties {
 	uint64_t values[DRM_OBJECT_MAX_PROPERTY];
 };
 
+/* Blending property bits */
+#define DRM_BLEND_NONE				0
+#define DRM_BLEND_ZERO				1
+#define DRM_BLEND_ONE				2
+#define DRM_BLEND_SRC_COLOR			3
+#define DRM_BLEND_ONE_MINUS_SRC_COLOR		4
+#define DRM_BLEND_DST_COLOR			5
+#define DRM_BLEND_ONE_MINUS_DST_COLOR		6
+#define DRM_BLEND_SRC_ALPHA			7
+#define DRM_BLEND_ONE_MINUS_SRC_ALPHA		8
+#define DRM_BLEND_DST_ALPHA			9
+#define DRM_BLEND_ONE_MINUS_DST_ALPHA		10
+#define DRM_BLEND_CONSTANT_COLOR		11
+#define DRM_BLEND_ONE_MINUS_CONSTANT_COLOR	12
+#define DRM_BLEND_CONSTANT_ALPHA		13
+#define DRM_BLEND_ONE_MINUS_CONSTANT_ALPHA	14
+#define DRM_BLEND_SRC_ALPHA_SATURATE		15
+#define DRM_BLEND_SRC1_COLOR			16
+#define DRM_BLEND_ONE_MINUS_SRC1_COLOR		17
+#define DRM_BLEND_SRC1_ALPHA			18
+#define DRM_BLEND_ONE_MINUS_SRC1_ALPHA		19
+#define DRM_BLEND_PREMULTIPLIED_ALPHA		20
+
 /*
  * Note on terminology:  here, for brevity and convenience, we refer to connector
  * control chips as 'CRTCs'.  They can control any type of connector, VGA, LVDS,
@@ -1179,6 +1202,8 @@ extern int drm_format_plane_cpp(uint32_t format, int plane);
 extern int drm_format_horz_chroma_subsampling(uint32_t format);
 extern int drm_format_vert_chroma_subsampling(uint32_t format);
 extern const char *drm_get_format_name(uint32_t format);
+extern struct drm_property *drm_mode_create_blend_property(struct drm_device *dev,
+				unsigned int supported_factors);
 
 /* Helpers */
 static inline struct drm_crtc *drm_crtc_find(struct drm_device *dev,
-- 
1.8.5


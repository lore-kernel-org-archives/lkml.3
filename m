Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaH2PVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:21:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:46637 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbaH2PVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:21:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="591743199"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: airlied@linux.ie
Cc: Mark Rustad <mark.d.rustad@intel.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 1/2] drm: Resolve many missing-field-initializers warnings
Date: Fri, 29 Aug 2014 08:21:25 -0700
Message-Id: <1409325686-13994-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve many missing-field-initializers warnings that appear
in W=2 builds by changing nested object initialization syntax.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/drm/drm_modes.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_modes.h b/include/drm/drm_modes.h
index 91d0582..0a118f3 100644
--- a/include/drm/drm_modes.h
+++ b/include/drm/drm_modes.h
@@ -86,7 +86,7 @@ enum drm_mode_status {
 	.htotal = (ht), .hskew = (hsk), .vdisplay = (vd), \
 	.vsync_start = (vss), .vsync_end = (vse), .vtotal = (vt), \
 	.vscan = (vs), .flags = (f), \
-	.base.type = DRM_MODE_OBJECT_MODE
+	.base = { .type = DRM_MODE_OBJECT_MODE }
 
 #define CRTC_INTERLACE_HALVE_V	(1 << 0) /* halve V values for interlacing */
 #define CRTC_STEREO_DOUBLE	(1 << 1) /* adjust timings for stereo modes */
-- 
1.9.3


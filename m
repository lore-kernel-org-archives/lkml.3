Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3AWCXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 21:23:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:16327 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab3AWCW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 21:22:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,518,1355126400"; 
   d="scan'208";a="194143795"
Message-ID: <1358908049.18561.12.camel@suxuemin.sh.intel.com>
Subject: [PATCH] radeon_display: Use pointer return error codes
From: "Su, Xuemin" <xuemin.su@intel.com>
To: airlied@linux.ie, airlied@redhat.com, alexander.deucher@amd.com,
        s.hauer@pengutronix.de, ihadzic@research.bell-labs.com,
        laurent.pinchart@ideasonboard.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: bo.he@intel.com, xuemin.su@intel.com, yanmin_zhang@linux.intel.com
Date: Wed, 23 Jan 2013 10:27:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xueminsu <xuemin.su@intel.com>
Date: Tue, 22 Jan 2013 22:16:53 +0800
Subject: [PATCH] radeon_display: Use pointer return error codes

drm_mode_addfb() expects fb_create return error code
instead of NULL.

Signed-off-by: xueminsu <xuemin.su@intel.com>
---
 drivers/gpu/drm/radeon/radeon_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 1da2386..ff3def7 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1122,7 +1122,7 @@ radeon_user_framebuffer_create(struct drm_device *dev,
 	if (ret) {
 		kfree(radeon_fb);
 		drm_gem_object_unreference_unlocked(obj);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return &radeon_fb->base;
-- 
1.7.6




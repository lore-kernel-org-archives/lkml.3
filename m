Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3AaFyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 00:54:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:50862 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3AaFyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 00:54:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,574,1355126400"; 
   d="scan'208";a="250611607"
Message-ID: <1359611943.12399.2.camel@suxuemin.sh.intel.com>
Subject: [PATCH] drm/radeon: Calling object_unrefer() when creating fb
 failure
From: "Su, Xuemin" <xuemin.su@intel.com>
To: airlied@linux.ie, airlied@redhat.com, alexander.deucher@amd.com,
        s.hauer@pengutronix.de, ihadzic@research.bell-labs.com,
        laurent.pinchart@ideasonboard.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: bo.he@intel.com, xuemin.su@intel.com, yanmin_zhang@linux.intel.com,
        chuansheng.liu@intel.com
Date: Thu, 31 Jan 2013 13:59:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liu chuansheng <chuansheng.liu@intel.com>
Date: Thu, 31 Jan 2013 22:13:00 +0800
Subject: [PATCH] drm/radeon: Calling object_unrefer() when creating fb
 failure

When kzalloc() failed in radeon_user_framebuffer_create(), need to
call object_unreference() to match the object_reference().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Signed-off-by: xueminsu <xuemin.su@intel.com>
---
 drivers/gpu/drm/radeon/radeon_display.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index ff3def7..05c96fa 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1115,8 +1115,10 @@ radeon_user_framebuffer_create(struct drm_device *dev,
 	}
 
 	radeon_fb = kzalloc(sizeof(*radeon_fb), GFP_KERNEL);
-	if (radeon_fb == NULL)
+	if (radeon_fb == NULL) {
+		drm_gem_object_unreference_unlocked(obj);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	ret = radeon_framebuffer_init(dev, radeon_fb, mode_cmd, obj);
 	if (ret) {
-- 
1.7.6




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab3BSSve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:51:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54246 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933985Ab3BSSva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: liu chuansheng <chuansheng.liu@intel.com>, xueminsu <xuemin.su@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 24/81] drm/radeon: Calling object_unrefer() when creating fb failure
Date: Tue, 19 Feb 2013 15:48:47 -0300
Message-Id: <1361299784-8830-25-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: liu chuansheng <chuansheng.liu@intel.com>

commit f2d68cf4daa4de97d400d94836b907e35228e54f upstream.

When kzalloc() failed in radeon_user_framebuffer_create(), need to
call object_unreference() to match the object_reference().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Signed-off-by: xueminsu <xuemin.su@intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_display.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 4ea672e..70eb18a 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1111,8 +1111,10 @@ radeon_user_framebuffer_create(struct drm_device *dev,
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
1.7.9.5


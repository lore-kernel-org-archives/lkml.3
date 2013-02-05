Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab3BEWVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:21:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48088 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab3BEWLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:11:02 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: xueminsu <xuemin.su@intel.com>, Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 54/93] radeon_display: Use pointer return error codes
Date: Tue,  5 Feb 2013 20:06:43 -0200
Message-Id: <1360102042-10732-55-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: xueminsu <xuemin.su@intel.com>

commit b2f4b03f8a378cd626d2ea67d19e7470c050a098 upstream.

drm_mode_addfb() expects fb_create return error code
instead of NULL.

Signed-off-by: xueminsu <xuemin.su@intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index cf6085b..4ea672e 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1118,7 +1118,7 @@ radeon_user_framebuffer_create(struct drm_device *dev,
 	if (ret) {
 		kfree(radeon_fb);
 		drm_gem_object_unreference_unlocked(obj);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return &radeon_fb->base;
-- 
1.7.9.5


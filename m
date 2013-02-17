Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab3BQXJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:09:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45610 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729Ab3BQWzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:00 -0500
Message-Id: <20130217225003.423164857@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:16 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, liu chuansheng <chuansheng.liu@intel.com>,
        xueminsu <xuemin.su@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 15/66] drm/radeon: Calling object_unrefer() when creating fb failure
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: liu chuansheng <chuansheng.liu@intel.com>

commit f2d68cf4daa4de97d400d94836b907e35228e54f upstream.

When kzalloc() failed in radeon_user_framebuffer_create(), need to
call object_unreference() to match the object_reference().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Signed-off-by: xueminsu <xuemin.su@intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_display.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1110,8 +1110,10 @@ radeon_user_framebuffer_create(struct dr
 	}
 
 	radeon_fb = kzalloc(sizeof(*radeon_fb), GFP_KERNEL);
-	if (radeon_fb == NULL)
+	if (radeon_fb == NULL) {
+		drm_gem_object_unreference_unlocked(obj);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	radeon_framebuffer_init(dev, radeon_fb, mode_cmd, obj);
 



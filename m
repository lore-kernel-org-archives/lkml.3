Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab3BHA5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:57:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759138Ab3BHA5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        liu chuansheng <chuansheng.liu@intel.com>,
        xueminsu <xuemin.su@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 10/34] drm/radeon: Calling object_unrefer() when creating fb failure
Date: Thu,  7 Feb 2013 16:57:06 -0800
Message-Id: <20130208004629.195329323@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: liu chuansheng <chuansheng.liu@intel.com>

commit f2d68cf4daa4de97d400d94836b907e35228e54f upstream.

When kzalloc() failed in radeon_user_framebuffer_create(), need to
call object_unreference() to match the object_reference().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Signed-off-by: xueminsu <xuemin.su@intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_display.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1111,8 +1111,10 @@ radeon_user_framebuffer_create(struct dr
 	}
 
 	radeon_fb = kzalloc(sizeof(*radeon_fb), GFP_KERNEL);
-	if (radeon_fb == NULL)
+	if (radeon_fb == NULL) {
+		drm_gem_object_unreference_unlocked(obj);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	ret = radeon_framebuffer_init(dev, radeon_fb, mode_cmd, obj);
 	if (ret) {



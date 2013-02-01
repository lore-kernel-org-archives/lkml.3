Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161305Ab3BAKt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:49:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:39060 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161062Ab3BAKtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:49:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        xueminsu <xuemin.su@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 10/33] radeon_display: Use pointer return error codes
Date: Fri,  1 Feb 2013 11:49:15 +0100
Message-Id: <20130201104725.390267351@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104724.605715763@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xueminsu <xuemin.su@intel.com>

commit b2f4b03f8a378cd626d2ea67d19e7470c050a098 upstream.

drm_mode_addfb() expects fb_create return error code
instead of NULL.

Signed-off-by: xueminsu <xuemin.su@intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1136,7 +1136,7 @@ radeon_user_framebuffer_create(struct dr
 	if (ret) {
 		kfree(radeon_fb);
 		drm_gem_object_unreference_unlocked(obj);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return &radeon_fb->base;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab3AXAcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:32:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:36278 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab3AXAcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:32:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="194517896"
Message-ID: <1358987804.18561.22.camel@suxuemin.sh.intel.com>
Subject: [PATCH V3] drm_crtc: check if fb_create return NULL
From: "Su, Xuemin" <xuemin.su@intel.com>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: bo.he@intel.com, xuemin.su@intel.com, yanmin_zhang@linux.intel.com
Date: Thu, 24 Jan 2013 08:36:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xueminsu <xuemin.su@intel.com>
Date: Tue, 22 Jan 2013 22:39:39 +0800
Subject: [PATCH] drm_crtc: check if fb_create return NULL

Some buggy driver may still return NULL in fb_create,
which leads to kernel panic.

Signed-off-by: xueminsu <xuemin.su@intel.com>
---
 drivers/gpu/drm/drm_crtc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index f2d667b..ae613ec 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -2172,6 +2172,8 @@ int drm_mode_addfb(struct drm_device *dev,
 		ret = PTR_ERR(fb);
 		goto out;
 	}
+	/* some buggy driver may return NULL here, which may cause panic */
+	BUG_ON(!fb);
 
 	or->fb_id = fb->base.id;
 	list_add(&fb->filp_head, &file_priv->fbs);
-- 
1.7.6




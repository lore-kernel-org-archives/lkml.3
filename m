Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3AWDOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 22:14:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:11237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab3AWDOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 22:14:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,518,1355126400"; 
   d="scan'208";a="280927076"
Message-ID: <1358911167.18561.20.camel@suxuemin.sh.intel.com>
Subject: [PATCH V2 RESEND] drm_crtc: check if fb_create return NULL
From: "Su, Xuemin" <xuemin.su@intel.com>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: bo.he@intel.com, xuemin.su@intel.com, yanmin_zhang@linux.intel.com
Date: Wed, 23 Jan 2013 11:19:27 +0800
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
 drivers/gpu/drm/drm_crtc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index f2d667b..b748498 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -2172,6 +2172,13 @@ int drm_mode_addfb(struct drm_device *dev,
 		ret = PTR_ERR(fb);
 		goto out;
 	}
+	/* some buggy driver may return NULL here, which may cause panic */
+	if (!fb) {
+		WARN(1, "%pf should not return NULL.",
+			dev->mode_config.funcs->fb_create);
+		ret = -EINVAL;
+		goto out;
+	}
 
 	or->fb_id = fb->base.id;
 	list_add(&fb->filp_head, &file_priv->fbs);
-- 
1.7.6





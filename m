Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaBYLPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:15:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaBYLPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:15:09 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm: bochs: drop unused struct fields
Date: Tue, 25 Feb 2014 12:15:01 +0100
Message-Id: <1393326901-28362-1-git-send-email-kraxel@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/bochs/bochs.h       | 2 --
 drivers/gpu/drm/bochs/bochs_fbdev.c | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/bochs/bochs.h b/drivers/gpu/drm/bochs/bochs.h
index 4608205..7eb52dd 100644
--- a/drivers/gpu/drm/bochs/bochs.h
+++ b/drivers/gpu/drm/bochs/bochs.h
@@ -88,8 +88,6 @@ struct bochs_device {
 		struct bochs_framebuffer gfb;
 		struct drm_fb_helper helper;
 		int size;
-		int x1, y1, x2, y2; /* dirty rect */
-		spinlock_t dirty_lock;
 		bool initialized;
 	} fb;
 };
diff --git a/drivers/gpu/drm/bochs/bochs_fbdev.c b/drivers/gpu/drm/bochs/bochs_fbdev.c
index 4da5206..561b844 100644
--- a/drivers/gpu/drm/bochs/bochs_fbdev.c
+++ b/drivers/gpu/drm/bochs/bochs_fbdev.c
@@ -190,7 +190,6 @@ int bochs_fbdev_init(struct bochs_device *bochs)
 	int ret;
 
 	bochs->fb.helper.funcs = &bochs_fb_helper_funcs;
-	spin_lock_init(&bochs->fb.dirty_lock);
 
 	ret = drm_fb_helper_init(bochs->dev, &bochs->fb.helper,
 				 1, 1);
-- 
1.8.3.1


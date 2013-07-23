Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3GWCCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:02:21 -0400
Received: from home.keithp.com ([63.227.221.253]:43589 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3GWCCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:02:19 -0400
X-Greylist: delayed 728 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jul 2013 22:02:19 EDT
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Cc: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH 2/5] drm: Add DRM_MODE_PAGE_FLIP_ASYNC flag definition
Date: Mon, 22 Jul 2013 18:49:59 -0700
Message-Id: <1374544202-15496-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374544202-15496-1-git-send-email-keithp@keithp.com>
References: <1374544202-15496-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This requests that the driver perform the page flip as soon as
possible, not necessarily waiting for vblank.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 include/uapi/drm/drm_mode.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index 53db7ce..5508117 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -412,7 +412,8 @@ struct drm_mode_crtc_lut {
 };
 
 #define DRM_MODE_PAGE_FLIP_EVENT 0x01
-#define DRM_MODE_PAGE_FLIP_FLAGS DRM_MODE_PAGE_FLIP_EVENT
+#define DRM_MODE_PAGE_FLIP_ASYNC 0x02
+#define DRM_MODE_PAGE_FLIP_FLAGS (DRM_MODE_PAGE_FLIP_EVENT|DRM_MODE_PAGE_FLIP_ASYNC)
 
 /*
  * Request a page flip on the specified crtc.
@@ -426,11 +427,14 @@ struct drm_mode_crtc_lut {
  * flip is already pending as the ioctl is called, EBUSY will be
  * returned.
  *
- * The ioctl supports one flag, DRM_MODE_PAGE_FLIP_EVENT, which will
- * request that drm sends back a vblank event (see drm.h: struct
- * drm_event_vblank) when the page flip is done.  The user_data field
- * passed in with this ioctl will be returned as the user_data field
- * in the vblank event struct.
+ * Flag DRM_MODE_PAGE_FLIP_EVENT requests that drm sends back a vblank
+ * event (see drm.h: struct drm_event_vblank) when the page flip is
+ * done.  The user_data field passed in with this ioctl will be
+ * returned as the user_data field in the vblank event struct.
+ *
+ * Flag DRM_MODE_PAGE_FLIP_ASYNC requests that the flip happen
+ * 'as soon as possible', meaning that it not delay waiting for vblank.
+ * This may cause tearing on the screen.
  *
  * The reserved field must be zero until we figure out something
  * clever to use it for.
-- 
1.8.3.2


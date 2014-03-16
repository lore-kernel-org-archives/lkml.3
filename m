Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaCPNnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 09:43:40 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:64888 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaCPNni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 09:43:38 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] drm: enable render-nodes by default
Date: Sun, 16 Mar 2014 14:43:20 +0100
Message-Id: <1394977400-10465-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduced render-nodes about 1/2 year ago and no problems showed up.
Remove the drm_rnodes argument and enable them by default now.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
Hi Dave

This does _not_ depend on the "drm-minor" branch. We decided to not provide
reliable minor-numbers. User-space should just properly enumerate devices
instead of relying on some minor-math-magic. Furthermore, so far no-one
complained about any render-node issues, so I don't think there's any reason to
keep them experimential.

Thanks
David

 drivers/gpu/drm/drm_stub.c | 7 +------
 include/drm/drmP.h         | 1 -
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 98a33c580..be3ad89 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -40,9 +40,6 @@
 unsigned int drm_debug = 0;	/* 1 to enable debug output */
 EXPORT_SYMBOL(drm_debug);
 
-unsigned int drm_rnodes = 0;	/* 1 to enable experimental render nodes API */
-EXPORT_SYMBOL(drm_rnodes);
-
 unsigned int drm_vblank_offdelay = 5000;    /* Default to 5000 msecs. */
 EXPORT_SYMBOL(drm_vblank_offdelay);
 
@@ -59,13 +56,11 @@ MODULE_AUTHOR(CORE_AUTHOR);
 MODULE_DESCRIPTION(CORE_DESC);
 MODULE_LICENSE("GPL and additional rights");
 MODULE_PARM_DESC(debug, "Enable debug output");
-MODULE_PARM_DESC(rnodes, "Enable experimental render nodes API");
 MODULE_PARM_DESC(vblankoffdelay, "Delay until vblank irq auto-disable [msecs]");
 MODULE_PARM_DESC(timestamp_precision_usec, "Max. error on timestamps [usecs]");
 MODULE_PARM_DESC(timestamp_monotonic, "Use monotonic timestamps");
 
 module_param_named(debug, drm_debug, int, 0600);
-module_param_named(rnodes, drm_rnodes, int, 0600);
 module_param_named(vblankoffdelay, drm_vblank_offdelay, int, 0600);
 module_param_named(timestamp_precision_usec, drm_timestamp_precision, int, 0600);
 module_param_named(timestamp_monotonic, drm_timestamp_monotonic, int, 0600);
@@ -533,7 +528,7 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
 			goto out_unlock;
 	}
 
-	if (drm_core_check_feature(dev, DRIVER_RENDER) && drm_rnodes) {
+	if (drm_core_check_feature(dev, DRIVER_RENDER)) {
 		ret = drm_get_minor(dev, &dev->render, DRM_MINOR_RENDER);
 		if (ret)
 			goto err_control_node;
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 04a7f31..5c91f1f 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1448,7 +1448,6 @@ extern void drm_master_put(struct drm_master **master);
 extern void drm_put_dev(struct drm_device *dev);
 extern void drm_unplug_dev(struct drm_device *dev);
 extern unsigned int drm_debug;
-extern unsigned int drm_rnodes;
 
 extern unsigned int drm_vblank_offdelay;
 extern unsigned int drm_timestamp_precision;
-- 
1.9.0


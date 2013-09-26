Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3IZVzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:55:41 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:60957 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab3IZVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:55:22 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH] gma500: define do_gma_backlight_set only when used
Date: Thu, 26 Sep 2013 23:46:56 +0200
Message-Id: <1380232016-25368-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure static function do_gma_backlight_set() is only defined when
CONFIG_BACKLIGHT_CLASS_DEVICE is defined, as it is never called otherwise.

This fixes the following warning:

  drivers/gpu/drm/gma500/backlight.c:29:13: warning: ‘do_gma_backlight_set’ defined but not used [-Wunused-function]

While at it, remove some end of line spaces.

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: David Airlie <airlied@linux.ie>
---

Hi,

This can be seen with mainline or linux-next with e.g. allmodconfig on x86.

Best regards,

V.

 drivers/gpu/drm/gma500/backlight.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/gma500/backlight.c b/drivers/gpu/drm/gma500/backlight.c
index 143eba3..399731e 100644
--- a/drivers/gpu/drm/gma500/backlight.c
+++ b/drivers/gpu/drm/gma500/backlight.c
@@ -26,13 +26,13 @@
 #include "intel_bios.h"
 #include "power.h"
 
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 static void do_gma_backlight_set(struct drm_device *dev)
 {
-#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	backlight_update_status(dev_priv->backlight_device);
-#endif	
 }
+#endif
 
 void gma_backlight_enable(struct drm_device *dev)
 {
@@ -43,7 +43,7 @@ void gma_backlight_enable(struct drm_device *dev)
 		dev_priv->backlight_device->props.brightness = dev_priv->backlight_level;
 		do_gma_backlight_set(dev);
 	}
-#endif	
+#endif
 }
 
 void gma_backlight_disable(struct drm_device *dev)
@@ -55,7 +55,7 @@ void gma_backlight_disable(struct drm_device *dev)
 		dev_priv->backlight_device->props.brightness = 0;
 		do_gma_backlight_set(dev);
 	}
-#endif	
+#endif
 }
 
 void gma_backlight_set(struct drm_device *dev, int v)
@@ -67,7 +67,7 @@ void gma_backlight_set(struct drm_device *dev, int v)
 		dev_priv->backlight_device->props.brightness = v;
 		do_gma_backlight_set(dev);
 	}
-#endif	
+#endif
 }
 
 int gma_backlight_init(struct drm_device *dev)
-- 
1.8.4.rc3


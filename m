Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab3AOXci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:32:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:46674 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933585Ab3AOWwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 115/171] drm/i915: move NEEDS_FORCE_WAKE to i915_drv.c
Date: Tue, 15 Jan 2013 14:44:40 -0800
Message-Id: <20130115224321.656209345@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit b7d84096d3c45f4e397e913da4ce24ec9a32022e upstream.

It's only used by the main read/write functions, so we can keep it with
them.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_drv.c |    6 ++++++
 drivers/gpu/drm/i915/i915_drv.h |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -993,6 +993,12 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL and additional rights");
 
+/* We give fast paths for the really cool registers */
+#define NEEDS_FORCE_WAKE(dev_priv, reg) \
+       (((dev_priv)->info->gen >= 6) && \
+        ((reg) < 0x40000) &&            \
+        ((reg) != FORCEWAKE))
+
 #define __i915_read(x, y) \
 u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg) { \
 	u##x val = 0; \
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1450,12 +1450,6 @@ void gen6_gt_force_wake_get(struct drm_i
 void gen6_gt_force_wake_put(struct drm_i915_private *dev_priv);
 int __gen6_gt_wait_for_fifo(struct drm_i915_private *dev_priv);
 
-/* We give fast paths for the really cool registers */
-#define NEEDS_FORCE_WAKE(dev_priv, reg) \
-	(((dev_priv)->info->gen >= 6) && \
-	 ((reg) < 0x40000) &&		 \
-	 ((reg) != FORCEWAKE))
-
 #define __i915_read(x, y) \
 	u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg);
 



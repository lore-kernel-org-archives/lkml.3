Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3H2ULp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:11:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55032 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757252Ab3H2ULn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:11:43 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH 3/6] i915_gem: Convert kmem_cache_alloc(...GFP_ZERO) to kmem_cache_zalloc
Date: Thu, 29 Aug 2013 13:11:07 -0700
Message-Id: <d846a338b419b2f3b8f2ac61db01e3faa5b2f832.1377806578.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1377806578.git.joe@perches.com>
References: <cover.1377806578.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper exists, might as well use it instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 8a0eb96..c4acd96 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -214,7 +214,7 @@ i915_gem_get_aperture_ioctl(struct drm_device *dev, void *data,
 void *i915_gem_object_alloc(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	return kmem_cache_alloc(dev_priv->slab, GFP_KERNEL | __GFP_ZERO);
+	return kmem_cache_zalloc(dev_priv->slab, GFP_KERNEL);
 }
 
 void i915_gem_object_free(struct drm_i915_gem_object *obj)
-- 
1.8.1.2.459.gbcd45b4.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935412Ab3FTABu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 20:01:50 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:63285 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3FTABt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 20:01:49 -0400
MIME-Version: 1.0
Date: Thu, 20 Jun 2013 08:01:47 +0800
Message-ID: <CAPgLHd81aZqECw1TrnVUF5iDLVw1-NQQvC43dw8v1bsTzYBQ0w@mail.gmail.com>
Subject: [PATCH -next] drm/i915: fix potential NULL pointer dereference in i915_gem_context_get_hang_stats()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: daniel.vetter@ffwll.ch, airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/i915/i915_gem_context.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_context.c b/drivers/gpu/drm/i915/i915_gem_context.c
index ff47145..f32107e 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -309,7 +309,7 @@ i915_gem_context_get_hang_stats(struct intel_ring_buffer *ring,
 				u32 id)
 {
 	struct drm_i915_private *dev_priv = ring->dev->dev_private;
-	struct drm_i915_file_private *file_priv = file->driver_priv;
+	struct drm_i915_file_private *file_priv;
 	struct i915_hw_context *to;
 
 	if (dev_priv->hw_contexts_disabled)
@@ -321,6 +321,7 @@ i915_gem_context_get_hang_stats(struct intel_ring_buffer *ring,
 	if (file == NULL)
 		return ERR_PTR(-EINVAL);
 
+	file_priv = file->driver_priv;
 	if (id == DEFAULT_CONTEXT_ID)
 		return &file_priv->hang_stats;
 


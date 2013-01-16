Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab3APQIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:08:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36672 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab3APQIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 167/222] drm/i915: fix flags in dma buf exporting
Date: Wed, 16 Jan 2013 13:56:07 -0200
Message-Id: <1358351822-7675-168-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 5b42427fc38ecb9056c4e64deaff36d6d6ba1b67 upstream.

As pointed out by Seung-Woo Kim this should have been
passing flags like nouveau/radeon have.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ herton: adjust for 3.5 (no line break) ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_dmabuf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index aa308e1..5d5493e 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -169,8 +169,7 @@ struct dma_buf *i915_gem_prime_export(struct drm_device *dev,
 {
 	struct drm_i915_gem_object *obj = to_intel_bo(gem_obj);
 
-	return dma_buf_export(obj, &i915_dmabuf_ops,
-						  obj->base.size, 0600);
+	return dma_buf_export(obj, &i915_dmabuf_ops, obj->base.size, flags);
 }
 
 struct drm_gem_object *i915_gem_prime_import(struct drm_device *dev,
-- 
1.7.9.5


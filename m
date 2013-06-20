Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935622Ab3FTDDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:03:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57333 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935522Ab3FTDDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:03:40 -0400
Message-ID: <51C270FA.5010703@infradead.org>
Date: Wed, 19 Jun 2013 20:03:22 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] gpu: fix printk format warning in i915_gem.c
References: <20130619182115.e5786a389561898e8dce178d@canb.auug.org.au>
In-Reply-To: <20130619182115.e5786a389561898e8dce178d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix printk format warning in i915_gem.c:

drivers/gpu/drm/i915/i915_gem.c:3113:3: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'size_t' [-Wformat]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20130619.orig/drivers/gpu/drm/i915/i915_gem.c
+++ linux-next-20130619/drivers/gpu/drm/i915/i915_gem.c
@@ -3110,7 +3110,7 @@ i915_gem_object_bind_to_gtt(struct drm_i
 	 * before evicting everything in a vain attempt to find space.
 	 */
 	if (obj->base.size > gtt_max) {
-		DRM_ERROR("Attempting to bind an object larger than the aperture: object=%zd > %s aperture=%ld\n",
+		DRM_ERROR("Attempting to bind an object larger than the aperture: object=%zd > %s aperture=%zu\n",
 			  obj->base.size,
 			  map_and_fenceable ? "mappable" : "total",
 			  gtt_max);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3CKT0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:26:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37656 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab3CKT0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:26:33 -0400
Date: Mon, 11 Mar 2013 12:26:30 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/i915: clarify reasoning for the access_ok call
Message-ID: <20130311192630.GA18227@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This clarifies the comment above the access_ok check so a missing
VERIFY_READ doesn't alarm anyone.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 2f2daeb..752e399 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -747,7 +747,11 @@ validate_exec_list(struct drm_i915_gem_exec_object2 *exec,
 
 		length = exec[i].relocation_count *
 			sizeof(struct drm_i915_gem_relocation_entry);
-		/* we may also need to update the presumed offsets */
+		/*
+		 * Validate memory range. Since we may need to update the
+		 * presumed offsets, use VERIFY_WRITE. (Writable implies
+		 * readable.)
+		 */
 		if (!access_ok(VERIFY_WRITE, ptr, length))
 			return -EFAULT;
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

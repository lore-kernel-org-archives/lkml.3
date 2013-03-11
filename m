Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3CKTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:25:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47890 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3CKTZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:25:25 -0400
Date: Mon, 11 Mar 2013 12:25:19 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/i915: restrict kernel address leak in debugfs
Message-ID: <20130311192519.GA18185@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masks kernel address info-leak in object dumps with the %pK suffix,
so they cannot be used to target kernel memory corruption attacks if
the kptr_restrict sysctl is set.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index aae3148..7299ea4 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -103,7 +103,7 @@ static const char *cache_level_str(int type)
 static void
 describe_obj(struct seq_file *m, struct drm_i915_gem_object *obj)
 {
-	seq_printf(m, "%p: %s%s %8zdKiB %02x %02x %d %d %d%s%s%s",
+	seq_printf(m, "%pK: %s%s %8zdKiB %02x %02x %d %d %d%s%s%s",
 		   &obj->base,
 		   get_pin_flag(obj),
 		   get_tiling_flag(obj),
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

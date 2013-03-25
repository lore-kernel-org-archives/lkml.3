Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab3CYB0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:26:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34040 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125Ab3CYBQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:08 -0400
Message-Id: <20130325010529.845809197@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 056/104] drm/i915: restrict kernel address leak in debugfs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 2563a4524febe8f4a98e717e02436d1aaf672aa2 upstream.

Masks kernel address info-leak in object dumps with the %pK suffix,
so they cannot be used to target kernel memory corruption attacks if
the kptr_restrict sysctl is set.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: the rest of the format string is different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -122,7 +122,7 @@ static const char *cache_level_str(int t
 static void
 describe_obj(struct seq_file *m, struct drm_i915_gem_object *obj)
 {
-	seq_printf(m, "%p: %s%s %8zd %04x %04x %d %d%s%s%s",
+	seq_printf(m, "%pK: %s%s %8zd %04x %04x %d %d%s%s%s",
 		   &obj->base,
 		   get_pin_flag(obj),
 		   get_tiling_flag(obj),



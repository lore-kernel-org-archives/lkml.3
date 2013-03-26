Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3CZWoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3CZWoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 37/98] drm/i915: restrict kernel address leak in debugfs
Date: Tue, 26 Mar 2013 15:42:26 -0700
Message-Id: <20130326224246.301058008@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 2563a4524febe8f4a98e717e02436d1aaf672aa2 upstream.

Masks kernel address info-leak in object dumps with the %pK suffix,
so they cannot be used to target kernel memory corruption attacks if
the kptr_restrict sysctl is set.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -103,7 +103,7 @@ static const char *cache_level_str(int t
 static void
 describe_obj(struct seq_file *m, struct drm_i915_gem_object *obj)
 {
-	seq_printf(m, "%p: %s%s %8zdKiB %04x %04x %d %d %d%s%s%s",
+	seq_printf(m, "%pK: %s%s %8zdKiB %04x %04x %d %d %d%s%s%s",
 		   &obj->base,
 		   get_pin_flag(obj),
 		   get_tiling_flag(obj),



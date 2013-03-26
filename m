Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106Ab3CZPWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:22:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965075Ab3CZPWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 069/150] drm/i915: restrict kernel address leak in debugfs
Date: Tue, 26 Mar 2013 15:19:28 +0000
Message-Id: <1364311249-14454-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 2563a4524febe8f4a98e717e02436d1aaf672aa2 upstream.

Masks kernel address info-leak in object dumps with the %pK suffix,
so they cannot be used to target kernel memory corruption attacks if
the kptr_restrict sysctl is set.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ luis: adjust format string ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 5ec5222..e6fd143 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -122,7 +122,7 @@ static const char *cache_level_str(int type)
 static void
 describe_obj(struct seq_file *m, struct drm_i915_gem_object *obj)
 {
-	seq_printf(m, "%p: %s%s %8zdKiB %04x %04x %d %d%s%s%s",
+	seq_printf(m, "%pK: %s%s %8zdKiB %04x %04x %d %d%s%s%s",
 		   &obj->base,
 		   get_pin_flag(obj),
 		   get_tiling_flag(obj),
-- 
1.8.1.2


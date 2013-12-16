Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3LPGN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 01:13:28 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:45484 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3LPGN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 01:13:26 -0500
MIME-Version: 1.0
Date: Mon, 16 Dec 2013 14:13:25 +0800
Message-ID: <CAPgLHd-C925=6rEnQMMkPvHu6+w_BHcJ1-CG8PdK37XM9dzf_A@mail.gmail.com>
Subject: [PATCH -next] drm/i915: fix return value check of debugfs_create_file()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: daniel.vetter@ffwll.ch, airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function debugfs_create_file() returns NULL
pointer not ERR_PTR() if debugfs is enabled. The IS_ERR() test in
the return value check should be replaced with NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/i915/i915_debugfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 7008aac..856e18b 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1920,8 +1920,8 @@ static int i915_pipe_crc_create(struct dentry *root, struct drm_minor *minor,
 	info->dev = dev;
 	ent = debugfs_create_file(info->name, S_IRUGO, root, info,
 				  &i915_pipe_crc_fops);
-	if (IS_ERR(ent))
-		return PTR_ERR(ent);
+	if (!ent)
+		return -ENOMEM;
 
 	return drm_add_fake_info_node(minor, ent, info);
 }
@@ -2931,8 +2931,8 @@ static int i915_forcewake_create(struct dentry *root, struct drm_minor *minor)
 				  S_IRUSR,
 				  root, dev,
 				  &i915_forcewake_fops);
-	if (IS_ERR(ent))
-		return PTR_ERR(ent);
+	if (!ent)
+		return -ENOMEM;
 
 	return drm_add_fake_info_node(minor, ent, &i915_forcewake_fops);
 }
@@ -2949,8 +2949,8 @@ static int i915_debugfs_create(struct dentry *root,
 				  S_IRUGO | S_IWUSR,
 				  root, dev,
 				  fops);
-	if (IS_ERR(ent))
-		return PTR_ERR(ent);
+	if (!ent)
+		return -ENOMEM;
 
 	return drm_add_fake_info_node(minor, ent, fops);
 }


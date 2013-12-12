Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3LLOpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:45:47 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:46895 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3LLOpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:45:19 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: Arnd Bergmann <arnd@arndb.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: Implement dummies for debugfs helpers
Date: Thu, 12 Dec 2013 15:44:04 +0100
Message-Id: <1386859444-1693-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case where debugfs support is disabled, define dummy functions to
avoid the need for #ifdefery in drivers.

Based on an earlier patch by Arnd Bergmann.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/drm/drmP.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 1d4a920ef7ff..28beb385380c 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1461,6 +1461,30 @@ extern int drm_debugfs_create_files(const struct drm_info_list *files,
 extern int drm_debugfs_remove_files(const struct drm_info_list *files,
 				    int count, struct drm_minor *minor);
 extern int drm_debugfs_cleanup(struct drm_minor *minor);
+#else
+static inline int drm_debugfs_init(struct drm_minor *minor, int minor_id,
+				   struct dentry *root)
+{
+	return 0;
+}
+
+static inline int drm_debugfs_create_files(const struct drm_info_list *files,
+					   int count, struct dentry *root,
+					   struct drm_minor *minor)
+{
+	return 0;
+}
+
+static inline int drm_debugfs_remove_files(const struct drm_info_list *files,
+					   int count, struct drm_minor *minor)
+{
+	return 0;
+}
+
+static inline int drm_debugfs_cleanup(struct drm_minor *minor)
+{
+	return 0;
+}
 #endif
 
 				/* Info file support */
-- 
1.8.4.2


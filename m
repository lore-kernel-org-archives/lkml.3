Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab3EaWX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:23:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab3EaWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Ben Gamari <bgamari@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 09/15] drm: always provide debugfs function prototypes
Date: Sat,  1 Jun 2013 00:22:46 +0200
Message-Id: <1370038972-2318779-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:OqXP3GBBXb/1eUm1dkeW5iMhWKJ4NpGdAvCnuvNQ4cp
 nTfUcQZnmpq2r6IEZ1h/UWhK9tt6+hyEhyLInmK7Q1PgDrmDmo
 0OTIDAWDulDn3DPNhd0PN69oSYuJ9crAJO42sX79nMPdsnPDDM
 eGum7ypV0p3KCnw7f3Njr/wViZcFgHGSpxpmGtaVU1V0Kvl78N
 4o8dppv7QegYUE+4xi/MhwK+TgKhlwDsrti4sRhqViXe1xoVw9
 mn/4fiy5A3s7uIhCCkHEMwyj3w+wVwxtqhUggBCiYi1OCboMa8
 Q5IYQGehZvvt6C5kO04tEmLJU5+GmqWWJHNHxBaKzJwGPiQ0SG
 fbhEwvTmMmUvHrl5KAbIvS9kHVGhEkCKxIMKi/aOn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is generally considered bad style to enclose function prototypes
in header files in #ifdef. This case illustrates why that is:
The tegra host1x driver calls into the debugfs functions if
CONFIG_DEBUG_FS is enabled, but that code is otherwise already
discarded by the compiler, so leaving the prototype in place
actually makes everything work.

drivers/gpu/host1x/drm/dc.c: In function 'tegra_dc_debugfs_init':
drivers/gpu/host1x/drm/dc.c:1004:2: error: implicit declaration of function 'drm_debugfs_create_files' [-Werror=implicit-function-declaration]
drivers/gpu/host1x/drm/dc.c: In function 'tegra_dc_debugfs_exit': drivers/gpu/host1x/drm/dc.c:1026:2: error: implicit declaration of function 'drm_debugfs_remove_files' [-Werror=implicit-function-declaration]

Cc: Ben Gamari <bgamari@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/drm/drmP.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 63d17ee..8bc105e 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1551,7 +1551,7 @@ extern int drm_proc_init(struct drm_minor *minor, struct proc_dir_entry *root);
 extern int drm_proc_cleanup(struct drm_minor *minor, struct proc_dir_entry *root);
 
 				/* Debugfs support */
-#if defined(CONFIG_DEBUG_FS)
+
 extern int drm_debugfs_init(struct drm_minor *minor, int minor_id,
 			    struct dentry *root);
 extern int drm_debugfs_create_files(struct drm_info_list *files, int count,
@@ -1559,7 +1559,6 @@ extern int drm_debugfs_create_files(struct drm_info_list *files, int count,
 extern int drm_debugfs_remove_files(struct drm_info_list *files, int count,
                                     struct drm_minor *minor);
 extern int drm_debugfs_cleanup(struct drm_minor *minor);
-#endif
 
 				/* Info file support */
 extern int drm_name_info(struct seq_file *m, void *data);
-- 
1.8.1.2


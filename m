Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab3EBPQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61743 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759045Ab3EBPQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Ben Gamari <bgamari@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH, RFC 05/22] drm: always provide debugfs function prototypes
Date: Thu,  2 May 2013 17:16:09 +0200
Message-Id: <1367507786-505303-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ArzecNDMIMlRoE0+VvtwubysMl6hvA/qJH+3hdLdIPb
 81rD7f42SU96/wSy0ZXZUZ6eGQ2gmKd3Sk9WZNRzAGL8EJNjUR
 Ef5oVDNElP8O9XKzZYz6wS8oN5jktCTnRQraL/awakExacGMg3
 GNjtgYYbh5VuYM5edb2JfRq5ALZFjp3aYN5Tq8oIcODdiyev90
 mww3EoA2oDvGLdTmicVy2ljdgb0bwrk3LEivMqVOfK7PExG/TO
 0nYnuHhn3WZcHfpZvOW9Rgyr+SS0vRD0SIjddpx8MZ7yKWfx+0
 SbpXDLSZE1nZAa7m6tuEkTXVr9qUVeX0uAXnVXGmf4aJ9YviWS
 rg5swp2jXd7CUg76S28mWZ56iuRCQWlyg2ngyH7ar
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
index 6119659..f780d62 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1550,7 +1550,7 @@ extern int drm_proc_init(struct drm_minor *minor, struct proc_dir_entry *root);
 extern int drm_proc_cleanup(struct drm_minor *minor, struct proc_dir_entry *root);
 
 				/* Debugfs support */
-#if defined(CONFIG_DEBUG_FS)
+
 extern int drm_debugfs_init(struct drm_minor *minor, int minor_id,
 			    struct dentry *root);
 extern int drm_debugfs_create_files(struct drm_info_list *files, int count,
@@ -1558,7 +1558,6 @@ extern int drm_debugfs_create_files(struct drm_info_list *files, int count,
 extern int drm_debugfs_remove_files(struct drm_info_list *files, int count,
                                     struct drm_minor *minor);
 extern int drm_debugfs_cleanup(struct drm_minor *minor);
-#endif
 
 				/* Info file support */
 extern int drm_name_info(struct seq_file *m, void *data);
-- 
1.8.1.2


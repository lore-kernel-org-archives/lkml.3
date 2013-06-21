Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423776Ab3FUWjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 18:39:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61583 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423636Ab3FUWiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 18:38:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: dri-devel@lists.freedesktop.org
Subject: [PATCH] drm: always provide debugfs function prototypes
Date: Sat, 22 Jun 2013 00:38:16 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, Ben Gamari <bgamari@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306220038.17115.arnd@arndb.de>
X-Provags-ID: V02:K0:XOC8x7fUtgRU7S4wsEJRKcKIT3ewDBaWdVGaIX1BXAg
 RIqJmZ/eBE84DsAdiLFjH+H7xgRvXn7Kbb+7+ppwQt25VRQeUl
 AvNgiXaNYLgaMnlEi8DUVyHWzf2vnV5yrDJJMZMfAuYZZfnfUp
 MRQ0zeQ822Bj0W86o/O5sWjtpl3m1C4auQnr6ZlxHgkU3eBn3l
 FD6Wt9ZIvOLzoMCkY2ro6eXtU7lUWRofkqaI5EFqfjpYbfKaZ6
 pTE3SZJl7FD23h7UYhtnuMF7h9uB/IenhA5OlaBe2TQ/prNcon
 iZCc6ugqoA2/PyKYvTrcw6dttxTdx6sPm+wV7+uiRokshv26+g
 45hSUlh56W16sGc/IuNU=
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Gamari <bgamari@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>

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

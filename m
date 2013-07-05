Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab3GEPlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:41:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65191 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3GEPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:41:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Airlie <airlied@redhat.com>
Subject: [PATCH, re-send] drm: always provide debugfs function prototypes
Date: Fri, 5 Jul 2013 17:41:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        dri-devel@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307051741.38496.arnd@arndb.de>
X-Provags-ID: V02:K0:Td43HHcbsOENrP1Ujznqg2nLzSkf58cYDdEcia42chI
 L1ue6tN03PQVEyGcKNc33+57axcxD5SDr4AkqX0mj+55Jmcvfx
 BkI+jkzg6sSiySO8WIuOoATxmv63tCKnSEEoapc7WrSViWx0IZ
 l6xuEBv88D139dZrb6bnfzi7kCqCg0NJ5ZJu7//nYkq3tZpIMv
 1wWE2pnMP5sNzypKDxBXOqF2RWzVmspM9JfS1ny0Eh3TFlkmJ3
 4ZyZDGNWmsrZQWxQ9OdOSJ5N4npiq1zmhtp8Py95/0AuoX+HPd
 juPNk4g4KD3pR8VMZbjiIQeDequVCOVUyhDDCXYMo+P82zUMGI
 MoEjR+xDgxC3t27M4ME4=
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
Reviewed-by: Thierry Reding <thierry.reding@>
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
diff --git a/include/drm/drm_mm.h b/include/drm/drm_mm.h
index 88591ef..4a7759a 100644
--- a/include/drm/drm_mm.h
+++ b/include/drm/drm_mm.h
@@ -37,9 +37,7 @@
  * Generic range manager structs
  */
 #include <linux/list.h>
-#ifdef CONFIG_DEBUG_FS
 #include <linux/seq_file.h>
-#endif
 
 struct drm_mm_node {
 	struct list_head node_list;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3D1VJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 17:09:28 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43698 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3D1VJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 17:09:27 -0400
Date: Sun, 28 Apr 2013 14:09:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Airlie <airlied@linux.ie>
cc: Dave Airlie <airlied@redhat.com>, Alon Levy <alevy@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [patch] drivers, drm: fix qxl build error when debugfs is disabled
Message-ID: <alpine.DEB.2.02.1304281408440.3194@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error when CONFIG_DEBUG_FS is disabled:

drivers/gpu/drm/qxl/qxl_debugfs.c: In function 'qxl_debugfs_init':
drivers/gpu/drm/qxl/qxl_debugfs.c:76:2: error: implicit declaration of function 'drm_debugfs_create_files'
drivers/gpu/drm/qxl/qxl_debugfs.c: In function 'qxl_debugfs_takedown':
drivers/gpu/drm/qxl/qxl_debugfs.c:84:2: error: implicit declaration of function 'drm_debugfs_remove_files'

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/gpu/drm/qxl/qxl_debugfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_debugfs.c b/drivers/gpu/drm/qxl/qxl_debugfs.c
--- a/drivers/gpu/drm/qxl/qxl_debugfs.c
+++ b/drivers/gpu/drm/qxl/qxl_debugfs.c
@@ -35,6 +35,7 @@
 #include "qxl_object.h"
 
 
+#if defined(CONFIG_DEBUG_FS)
 static int
 qxl_debugfs_irq_received(struct seq_file *m, void *data)
 {
@@ -69,20 +70,25 @@ static struct drm_info_list qxl_debugfs_list[] = {
 	{ "qxl_buffers", qxl_debugfs_buffers_info, 0, NULL },
 };
 #define QXL_DEBUGFS_ENTRIES ARRAY_SIZE(qxl_debugfs_list)
+#endif
 
 int
 qxl_debugfs_init(struct drm_minor *minor)
 {
+#if defined(CONFIG_DEBUG_FS)
 	drm_debugfs_create_files(qxl_debugfs_list, QXL_DEBUGFS_ENTRIES,
 				 minor->debugfs_root, minor);
+#endif
 	return 0;
 }
 
 void
 qxl_debugfs_takedown(struct drm_minor *minor)
 {
+#if defined(CONFIG_DEBUG_FS)
 	drm_debugfs_remove_files(qxl_debugfs_list, QXL_DEBUGFS_ENTRIES,
 				 minor);
+#endif
 }
 
 int qxl_debugfs_add_files(struct qxl_device *qdev,

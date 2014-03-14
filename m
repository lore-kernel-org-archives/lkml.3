Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaCNV4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:56:10 -0400
Received: from mout.gmx.net ([212.227.17.20]:49992 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbaCNV4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:56:08 -0400
From: xypron.glpk@gmx.de
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] Fanotify: make default values visible
Date: Fri, 14 Mar 2014 22:55:12 +0100
Message-Id: <1394834112-1707-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:JPsevr9kRfhS+/YqlFkdJAeYzU7414Qr83MGJn6LLSX5oQC5hbl
 lTUpkO0HpCR/uA1s/4wjBa1YXFcOjTA3McXVAAV0doaAwn5dGjtvEEOWkOG3hlvBgsasigV
 1281wxDq/Otf1zUqc7yyE+C8qqM2yIIAVJVirVvcA8/GP9B2vt6Fe6vTjMV8m0D7C+WuYwl
 YfyFwnD8gCo0aVH4XsyDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

The fanotify API imposes limits on
  number of queue entries
  number of queues
  number of listeners.

Opaque limits lead to unnecessary redefinitions in user coding.
Limits should therefore be visible in includes or should be removed.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c |    4 ----
 include/uapi/linux/fanotify.h      |    5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 287a22c..cf7465e 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -21,10 +21,6 @@
 #include "../fdinfo.h"
 #include "fanotify.h"
 
-#define FANOTIFY_DEFAULT_MAX_EVENTS	16384
-#define FANOTIFY_DEFAULT_MAX_MARKS	8192
-#define FANOTIFY_DEFAULT_MAX_LISTENERS	128
-
 extern const struct fsnotify_ops fanotify_fsnotify_ops;
 
 static struct kmem_cache *fanotify_mark_cache __read_mostly;
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index 030508d..07f73ff 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -3,6 +3,11 @@
 
 #include <linux/types.h>
 
+/* default limits */
+#define FANOTIFY_DEFAULT_MAX_EVENTS 16384
+#define FANOTIFY_DEFAULT_MAX_MARKS  8192
+#define FANOTIFY_DEFAULT_MAX_LISTENERS  128
+
 /* the following events that user-space can register for */
 #define FAN_ACCESS		0x00000001	/* File was accessed */
 #define FAN_MODIFY		0x00000002	/* File was modified */
-- 
1.7.10.4


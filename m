Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaBINMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:12:40 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55232 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaBINMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:12:39 -0500
Date: Sun, 9 Feb 2014 18:42:34 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>, josh@joshtriplett.org
Subject: [PATCH 12/21] fs: Include appropriate header file in notify/fdinfo.c
Message-ID: <265be484f01185add540edcb8d3b4a45cb0d5ffe.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file fs/notify/fdinfo.h because it has
function prototypes of some function defined in fs/notify/fdinfo.c.

This eliminates the following warning in fs/notify/fdinfo.c:
fs/notify/fdinfo.c:103:5: warning: no previous prototype for ‘inotify_show_fdinfo’ [-Wmissing-prototypes]
fs/notify/fdinfo.c:146:5: warning: no previous prototype for ‘fanotify_show_fdinfo’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/notify/fdinfo.c |    1 +
 fs/notify/fdinfo.h |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 238a593..b9b7387 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -14,6 +14,7 @@
 #include <linux/exportfs.h>
 
 #include "inotify/inotify.h"
+#include "fdinfo.h"
 #include "../fs/mount.h"
 
 #if defined(CONFIG_PROC_FS)
diff --git a/fs/notify/fdinfo.h b/fs/notify/fdinfo.h
index 556afda..e8833eb 100644
--- a/fs/notify/fdinfo.h
+++ b/fs/notify/fdinfo.h
@@ -10,11 +10,11 @@ struct file;
 #ifdef CONFIG_PROC_FS
 
 #ifdef CONFIG_INOTIFY_USER
-extern int inotify_show_fdinfo(struct seq_file *m, struct file *f);
+int inotify_show_fdinfo(struct seq_file *m, struct file *f);
 #endif
 
 #ifdef CONFIG_FANOTIFY
-extern int fanotify_show_fdinfo(struct seq_file *m, struct file *f);
+int fanotify_show_fdinfo(struct seq_file *m, struct file *f);
 #endif
 
 #else /* CONFIG_PROC_FS */
-- 
1.7.9.5


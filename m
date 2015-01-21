Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbbAURVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:21:21 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:27762 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753021AbbAURVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:21:03 -0500
Message-Id: <20150121172102.103696082@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 21 Jan 2015 12:19:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 5/5] tracefs: Add directory /sys/kernel/tracing
References: <20150121171953.823177070@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-tracefs-Add-directory-sys-kernel-tracing.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When tracefs is configured, have the directory /sys/kernel/tracing appear
just like /sys/kernel/debug appears when debugfs is configured.

This will give a consistent place for system admins to mount tracefs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/tracefs/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 29632ce2c456..e5d233aa4edd 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/tracefs.h>
 #include <linux/fsnotify.h>
@@ -629,10 +630,16 @@ bool tracefs_initialized(void)
 	return tracefs_registered;
 }
 
+static struct kobject *trace_kobj;
+
 static int __init tracefs_init(void)
 {
 	int retval;
 
+	trace_kobj = kobject_create_and_add("tracing", kernel_kobj);
+	if (!trace_kobj)
+		return -EINVAL;
+
 	retval = register_filesystem(&trace_fs_type);
 	if (!retval)
 		tracefs_registered = true;
-- 
2.1.4



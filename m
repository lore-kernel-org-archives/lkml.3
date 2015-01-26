Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbbAZPLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:11:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:49475 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751885AbbAZPKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:04 -0500
Message-Id: <20150126151001.251148470@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 15/16 v3] tracefs: Add directory /sys/kernel/tracing
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0015-tracefs-Add-directory-sys-kernel-tracing.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When tracefs is configured, have the directory /sys/kernel/tracing appear
just like /sys/kernel/debug appears when debugfs is configured.

This will give a consistent place for system admins to mount tracefs.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/tracefs/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index c31997a303c7..cdbaa42b44a1 100644
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
@@ -547,10 +548,16 @@ bool tracefs_initialized(void)
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



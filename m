Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3LXQd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 11:33:58 -0500
Received: from churchofgit.com ([198.20.106.155]:41940 "EHLO
	www.churchofgit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3LXQd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 11:33:57 -0500
From: Shawn Landden <shawn@churchofgit.com>
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Landden <shawn@churchofgit.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] timerfd: show procfs fdinfo helper
Date: Tue, 24 Dec 2013 16:33:07 +0000
Message-Id: <1387902787-257492-1-git-send-email-shawn@churchofgit.com>
X-Mailer: git-send-email 1.8.5.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| pos:	0
| flags:	02004002
| clockid:	0

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Shawn Landden <shawn@churchofgit.com>
---
 fs/timerfd.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 9293121..e5fa587 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -25,6 +25,7 @@
 #include <linux/syscalls.h>
 #include <linux/compat.h>
 #include <linux/rcupdate.h>
+#include <linux/seq_file.h>
 
 struct timerfd_ctx {
 	union {
@@ -284,7 +285,23 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 	return res;
 }
 
+#ifdef CONFIG_PROC_FS
+static int timerfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct timerfd_ctx *ctx = f->private_data;
+	int clockid;
+
+	clockid = ctx->clockid;
+	seq_printf(m, "clockid:\t%d\n", clockid);
+
+	return 0;
+}
+#endif
+
 static const struct file_operations timerfd_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= timerfd_show_fdinfo,
+#endif
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
-- 
1.8.5.2.297.g3e57c29


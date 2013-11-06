Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab3KFLs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:48:28 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:54351 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab3KFLsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:48:23 -0500
Message-Id: <20131106114813.122982055@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 15:47:49 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 7/7] procfs: Drop legacy show_fdinfo file operation
References: <20131106114742.988532945@openvz.org>
Content-Disposition: inline; filename=0006-procfs-ridof-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All former users of show_fdinfo are converted to sequential
output engine thus we don't need it anymore.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/fd.c       |    5 -----
 include/linux/fs.h |    1 -
 2 files changed, 6 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -59,11 +59,6 @@ static int seq_show(struct seq_file *m,
 
 	if (info->op)
 		return info->op->show(m, v);
-
-	/* Legacy interface */
-	if (info->f_file->f_op->show_fdinfo)
-		return info->f_file->f_op->show_fdinfo(m, info->f_file);
-
 	return 0;
 }
 
Index: linux-2.6.git/include/linux/fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/fs.h
+++ linux-2.6.git/include/linux/fs.h
@@ -1551,7 +1551,6 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
-	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 	struct seq_operations *fdinfo_op;
 };
 


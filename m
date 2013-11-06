Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab3KFLsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:48:24 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:50219 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3KFLsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:48:17 -0500
Message-Id: <20131106114812.474330639@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 15:47:43 +0400
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
Subject: [patch 1/7] seq-file: Export single_ helpers
References: <20131106114742.988532945@openvz.org>
Content-Disposition: inline; filename=0000-seq-export-single
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The single_ helpers will be used in fdinfo output to
eliminate code duplication.

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
 fs/seq_file.c            |    9 ++++++---
 include/linux/seq_file.h |    3 +++
 2 files changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6.git/fs/seq_file.c
===================================================================
--- linux-2.6.git.orig/fs/seq_file.c
+++ linux-2.6.git/fs/seq_file.c
@@ -565,20 +565,23 @@ int seq_bitmap_list(struct seq_file *m,
 }
 EXPORT_SYMBOL(seq_bitmap_list);
 
-static void *single_start(struct seq_file *p, loff_t *pos)
+void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
 }
+EXPORT_SYMBOL(single_start);
 
-static void *single_next(struct seq_file *p, void *v, loff_t *pos)
+void *single_next(struct seq_file *p, void *v, loff_t *pos)
 {
 	++*pos;
 	return NULL;
 }
+EXPORT_SYMBOL(single_next);
 
-static void single_stop(struct seq_file *p, void *v)
+void single_stop(struct seq_file *p, void *v)
 {
 }
+EXPORT_SYMBOL(single_stop);
 
 int single_open(struct file *file, int (*show)(struct seq_file *, void *),
 		void *data)
Index: linux-2.6.git/include/linux/seq_file.h
===================================================================
--- linux-2.6.git.orig/include/linux/seq_file.h
+++ linux-2.6.git/include/linux/seq_file.h
@@ -122,6 +122,9 @@ static inline int seq_nodemask_list(stru
 	return seq_bitmap_list(m, mask->bits, MAX_NUMNODES);
 }
 
+void *single_start(struct seq_file *, loff_t *);
+void *single_next(struct seq_file *, void *, loff_t *);
+void single_stop(struct seq_file *, void *);
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_open_size(struct file *, int (*)(struct seq_file *, void *), void *, size_t);
 int single_release(struct inode *, struct file *);


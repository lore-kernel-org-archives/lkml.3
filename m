Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaGHVrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:47:41 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:64688 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaGHVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:47:40 -0400
Date: Wed, 9 Jul 2014 00:47:38 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: make proc_subdir_lock static
Message-ID: <20140708214738.GA2382@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c  |    2 +-
 fs/proc/internal.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -27,7 +27,7 @@
 
 #include "internal.h"
 
-DEFINE_SPINLOCK(proc_subdir_lock);
+static DEFINE_SPINLOCK(proc_subdir_lock);
 
 static int proc_match(unsigned int len, const char *name, struct proc_dir_entry *de)
 {
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -178,8 +178,6 @@ extern bool proc_fill_cache(struct file *, struct dir_context *, const char *, i
 /*
  * generic.c
  */
-extern spinlock_t proc_subdir_lock;
-
 extern struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int);
 extern struct dentry *proc_lookup_de(struct proc_dir_entry *, struct inode *,
 				     struct dentry *);

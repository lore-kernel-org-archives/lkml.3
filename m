Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaEWJsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:48:01 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:61522 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaEWJn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:43:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 02/13] vfs: export do_splice_direct() to modules
Date: Fri, 23 May 2014 11:43:32 +0200
Message-Id: <1400838223-30844-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Export do_splice_direct() to modules.  Needed by overlay filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h      | 6 ------
 fs/splice.c        | 1 +
 include/linux/fs.h | 3 +++
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 465742407466..873cdf544d54 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -135,12 +135,6 @@ extern ssize_t __kernel_write(struct file *, const char *, size_t, loff_t *);
 extern int rw_verify_area(int, struct file *, const loff_t *, size_t);
 
 /*
- * splice.c
- */
-extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
-		loff_t *opos, size_t len, unsigned int flags);
-
-/*
  * pipe.c
  */
 extern const struct file_operations pipefifo_fops;
diff --git a/fs/splice.c b/fs/splice.c
index 9bc07d2b53cf..fb1094bbe5af 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1319,6 +1319,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 
 	return ret;
 }
+EXPORT_SYMBOL(do_splice_direct);
 
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d38875d70db2..90463dfd77d1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2433,6 +2433,9 @@ extern ssize_t generic_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
 		struct file *out, loff_t *, size_t len, unsigned int flags);
+extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
+		loff_t *opos, size_t len, unsigned int flags);
+
 
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
-- 
1.8.1.4


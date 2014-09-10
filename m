Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaIJO3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:29:33 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:57100 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbaIJO3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:29:16 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org
Subject: [RFC PATCH 12/12] locks: remove i_flock field from struct inode
Date: Wed, 10 Sep 2014 10:28:50 -0400
Message-Id: <1410359330-27564-13-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing uses it anymore. Also add a forward declaration for struct
file_lock to silence some compiler warnings that the removal triggers.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 include/linux/fs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 673aad74cd79..811d844b8ed8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -593,7 +593,6 @@ struct inode {
 	atomic_t		i_readcount; /* struct files open RO */
 #endif
 	const struct file_operations	*i_fop;	/* former ->i_op->default_file_ops */
-	struct file_lock	*i_flock;
 	struct file_lock_context	*i_flctx;
 	struct address_space	i_data;
 #ifdef CONFIG_QUOTA
@@ -855,6 +854,8 @@ static inline struct file *get_file(struct file *f)
 /* legacy typedef, should eventually be removed */
 typedef void *fl_owner_t;
 
+struct file_lock;
+
 struct file_lock_operations {
 	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
 	void (*fl_release_private)(struct file_lock *);
-- 
1.9.3


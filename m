Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBIMqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 07:46:39 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44494 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaBIMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 07:46:38 -0500
Date: Sun, 9 Feb 2014 18:16:33 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
        josh@joshtriplett.org
Subject: [PATCH 01/21] fs: Remove unused function in afs/write.c
Message-ID: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused function in afs/write.c.

This eliminates the following warning in afs/write.c:
fs/afs/write.c:749:5: warning: no previous prototype for ‘afs_page_mkwrite’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/afs/write.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index a890db4..2dd54b9 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -741,24 +741,3 @@ out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
-
-/*
- * notification that a previously read-only page is about to become writable
- * - if it returns an error, the caller will deliver a bus error signal
- */
-int afs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
-{
-	struct afs_vnode *vnode = AFS_FS_I(vma->vm_file->f_mapping->host);
-
-	_enter("{{%x:%u}},{%lx}",
-	       vnode->fid.vid, vnode->fid.vnode, page->index);
-
-	/* wait for the page to be written to the cache before we allow it to
-	 * be modified */
-#ifdef CONFIG_AFS_FSCACHE
-	fscache_wait_on_page_write(vnode->cache, page);
-#endif
-
-	_leave(" = 0");
-	return 0;
-}
-- 
1.7.9.5


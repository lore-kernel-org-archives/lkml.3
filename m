Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbaGRAts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:49:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759324AbaGRAtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:49:46 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 18 Jul 2014 10:48:28 +1000
Subject: [PATCH 4/5] autofs4: remove some unused inline functions.
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Message-ID: <20140718004828.19389.22584.stgit@notabene.brown>
In-Reply-To: <20140718004353.19389.48104.stgit@notabene.brown>
References: <20140718004353.19389.48104.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

{__,}manage_dentry_{set,clear}_{automount,transit}

are 4 unused inline functions.  Discard them.

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/autofs_i.h |   49 -------------------------------------------------
 1 file changed, 49 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 22a280151e45..9e359fb20c0a 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -177,55 +177,6 @@ extern const struct file_operations autofs4_root_operations;
 extern const struct dentry_operations autofs4_dentry_operations;
 
 /* VFS automount flags management functions */
-
-static inline void __managed_dentry_set_automount(struct dentry *dentry)
-{
-	dentry->d_flags |= DCACHE_NEED_AUTOMOUNT;
-}
-
-static inline void managed_dentry_set_automount(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_set_automount(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_clear_automount(struct dentry *dentry)
-{
-	dentry->d_flags &= ~DCACHE_NEED_AUTOMOUNT;
-}
-
-static inline void managed_dentry_clear_automount(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_clear_automount(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_set_transit(struct dentry *dentry)
-{
-	dentry->d_flags |= DCACHE_MANAGE_TRANSIT;
-}
-
-static inline void managed_dentry_set_transit(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_set_transit(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_clear_transit(struct dentry *dentry)
-{
-	dentry->d_flags &= ~DCACHE_MANAGE_TRANSIT;
-}
-
-static inline void managed_dentry_clear_transit(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_clear_transit(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
 static inline void __managed_dentry_set_managed(struct dentry *dentry)
 {
 	dentry->d_flags |= (DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT);



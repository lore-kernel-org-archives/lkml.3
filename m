Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbaGIXl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:41:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbaGIXl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:41:57 -0400
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Date: Thu, 10 Jul 2014 09:41:14 +1000
Subject: [PATCH 1/6] autofs4: remove unused autofs4_ispending()
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140709234114.4525.94513.stgit@notabene.brown>
In-Reply-To: <20140709233541.4525.25151.stgit@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/autofs4/autofs_i.h |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index acf32054edd8..22a280151e45 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -143,20 +143,6 @@ static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
 	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
-/* Does a dentry have some pending activity? */
-static inline int autofs4_ispending(struct dentry *dentry)
-{
-	struct autofs_info *inf = autofs4_dentry_ino(dentry);
-
-	if (inf->flags & AUTOFS_INF_PENDING)
-		return 1;
-
-	if (inf->flags & AUTOFS_INF_EXPIRING)
-		return 1;
-
-	return 0;
-}
-
 struct inode *autofs4_get_inode(struct super_block *, umode_t);
 void autofs4_free_ino(struct autofs_info *);
 



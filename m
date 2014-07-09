Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbaGIXmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:42:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328AbaGIXmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:42:04 -0400
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Date: Thu, 10 Jul 2014 09:41:14 +1000
Subject: [PATCH 2/6] autofs4: remove a redundant assignment
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140709234114.4525.3341.stgit@notabene.brown>
In-Reply-To: <20140709233541.4525.25151.stgit@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'ino' already exists and already
has the correct value.  The d_fsdata of a dentry
is never changed after the d_fsdata is instantiated,
so this new assignment cannot be necessary.

It was introduced in
commit b5b801779d59165c4ecf1009009109545bd1f642
    autofs4: Add d_manage() dentry operation

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/autofs4/expire.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 394e90b02c5e..a7be57e39be7 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -333,7 +333,6 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
 	if (ino->flags & AUTOFS_INF_PENDING)
 		goto out;
 	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
-		struct autofs_info *ino = autofs4_dentry_ino(root);
 		ino->flags |= AUTOFS_INF_EXPIRING;
 		init_completion(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);



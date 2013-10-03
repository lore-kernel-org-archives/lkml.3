Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3JCGSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:18:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41546 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3JCGSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:18:07 -0400
Date: Thu, 03 Oct 2013 07:18:06 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 04/17] do_remount(): pull touch_mnt_namespace() up
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcEg-00088A-8F@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... and don't bother with dropping and regaining vfsmount_lock

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 09a255d..41663dd 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1849,14 +1849,10 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 		br_write_lock(&vfsmount_lock);
 		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
 		mnt->mnt.mnt_flags = mnt_flags;
-		br_write_unlock(&vfsmount_lock);
-	}
-	up_write(&sb->s_umount);
-	if (!err) {
-		br_write_lock(&vfsmount_lock);
 		touch_mnt_namespace(mnt->mnt_ns);
 		br_write_unlock(&vfsmount_lock);
 	}
+	up_write(&sb->s_umount);
 	return err;
 }
 
-- 
1.7.2.5



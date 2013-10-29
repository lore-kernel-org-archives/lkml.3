Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3J2S0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:26:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3J2SFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>, Chris Mason <chris.mason@fusionio.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 16/81] Btrfs: use right root when checking for hash collision
Date: Tue, 29 Oct 2013 11:03:37 -0700
Message-Id: <1383069882-11437-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 4871c1588f92c6c13f4713a7009f25f217055807 upstream.

btrfs_rename was using the root of the old dir instead of the root of the new
dir when checking for a hash collision, so if you tried to move a file into a
subvol it would freak out because it would see the file you are trying to move
in its current root.  This fixes the bug where this would fail

btrfs subvol create test1
btrfs subvol create test2
mv test1 test2.

Thanks to Chris Murphy for catching this,

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4b5398c..60e1296 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7387,7 +7387,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 
 	/* check for collisions, even if the  name isn't there */
-	ret = btrfs_check_dir_item_collision(root, new_dir->i_ino,
+	ret = btrfs_check_dir_item_collision(dest, new_dir->i_ino,
 			     new_dentry->d_name.name,
 			     new_dentry->d_name.len);
 
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055Ab3JPSCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:02:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934140Ab3JPRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Murphy <lists@colorremedies.com>,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 09/50] Btrfs: use right root when checking for hash collision
Date: Wed, 16 Oct 2013 10:44:55 -0700
Message-Id: <20131016174359.516466406@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8036,7 +8036,7 @@ static int btrfs_rename(struct inode *ol
 
 
 	/* check for collisions, even if the  name isn't there */
-	ret = btrfs_check_dir_item_collision(root, new_dir->i_ino,
+	ret = btrfs_check_dir_item_collision(dest, new_dir->i_ino,
 			     new_dentry->d_name.name,
 			     new_dentry->d_name.len);
 



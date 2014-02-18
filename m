Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaBRW5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:57:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaBRWrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.13 02/40] Btrfs: disable snapshot aware defrag for now
Date: Tue, 18 Feb 2014 14:47:03 -0800
Message-Id: <20140218224433.407946577@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 8101c8dbf6243ba517aab58d69bf1bc37d8b7b9c upstream.

It's just broken and it's taking a lot of effort to fix it, so for now just
disable it so people can defrag in peace.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2610,7 +2610,7 @@ static int btrfs_finish_ordered_io(struc
 			EXTENT_DEFRAG, 1, cached_state);
 	if (ret) {
 		u64 last_snapshot = btrfs_root_last_snapshot(&root->root_item);
-		if (last_snapshot >= BTRFS_I(inode)->generation)
+		if (0 && last_snapshot >= BTRFS_I(inode)->generation)
 			/* the inode is shared */
 			new = record_old_file_extents(inode, ordered_extent);
 



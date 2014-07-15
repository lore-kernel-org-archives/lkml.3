Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbaGORIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:08:47 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60061 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaGORCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:19 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 83/94] ext4: fix potential null pointer dereference in ext4_free_inode
Date: Tue, 15 Jul 2014 20:01:38 +0300
Message-Id: <1405443709-15288-83-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Fix potential null pointer dereferencing problem caused by e43bb4e612
("ext4: decrement free clusters/inodes counters when block group declared bad")

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 fs/ext4/ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 0840bf3..5b87fc3 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -338,7 +338,7 @@ out:
 			fatal = err;
 	} else {
 		ext4_error(sb, "bit already cleared for inode %lu", ino);
-		if (!EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
+		if (gdp && !EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
 			int count;
 			count = ext4_free_inodes_count(sb, gdp);
 			percpu_counter_sub(&sbi->s_freeinodes_counter,
-- 
1.7.10.4


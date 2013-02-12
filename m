Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab3BLRV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:21:28 -0500
Received: from mail.tpi.com ([70.99.223.143]:3427 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab3BLRV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:21:26 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH linux-next] befs: befs_get_block(): remove unreachable code
Date: Tue, 12 Feb 2013 10:21:09 -0700
Message-Id: <1360689669-59672-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'sector_t block' is unsigned and can therefore never be '< 0'.

smatch analysis:

fs/befs/linuxvfs.c:131 befs_get_block() warn: unsigned 'block'
 is never less than zero.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/befs/linuxvfs.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 2b3bda8..6a237e7 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -128,13 +128,6 @@ befs_get_block(struct inode *inode, sector_t block,
 	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
 		   inode->i_ino, block);
 
-	if (block < 0) {
-		befs_error(sb, "befs_get_block() was asked for a block "
-			   "number less than zero: block %ld in inode %lu",
-			   block, inode->i_ino);
-		return -EIO;
-	}
-
 	if (create) {
 		befs_error(sb, "befs_get_block() was asked to write to "
 			   "block %ld in inode %lu", block, inode->i_ino);
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaFRWIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:08:14 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44016 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaFRWIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:08:12 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, fabf@skynet.be, kirill.shutemov@linux.intel.com,
        dan.carpenter@oracle.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Check for Null return of function of affs_bread  in function affs_truncate
Date: Wed, 18 Jun 2014 18:08:05 -0400
Message-Id: <1403129285-5038-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 fs/affs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index a7fe57d..f26482d 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -923,6 +923,8 @@ affs_truncate(struct inode *inode)
 
 	while (ext_key) {
 		ext_bh = affs_bread(sb, ext_key);
+		if (!ext_bh)
+			return;
 		size = AFFS_SB(sb)->s_hashsize;
 		if (size > blkcnt - blk)
 			size = blkcnt - blk;
-- 
1.9.1


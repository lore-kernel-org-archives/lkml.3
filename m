Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934843AbaKMViR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:38:17 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64688 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964943AbaKMVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:37 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org (open list:NILFS2 FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 34/56] fs/nilfs2: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:11 +0100
Message-Id: <1415913813-362-35-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from nilfs2 when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/nilfs2/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 2497815..dc63aea 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -164,7 +164,7 @@ const struct file_operations nilfs_file_operations = {
 	.open		= generic_file_open,
 	/* .release	= nilfs_release_file, */
 	.fsync		= nilfs_sync_file,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
 
 const struct inode_operations nilfs_file_inode_operations = {
-- 
1.9.1


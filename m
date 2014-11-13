Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858AbaKMVmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:42:32 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37640 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785AbaKMV3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:40 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org (open list:EXT3 FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 19/56] fs/ext3: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:56 +0100
Message-Id: <1415913813-362-20-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from ext3 when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/ext3/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index a062fa1..e683870 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -62,8 +62,8 @@ const struct file_operations ext3_file_operations = {
 	.open		= dquot_file_open,
 	.release	= ext3_release_file,
 	.fsync		= ext3_sync_file,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 };
 
 const struct inode_operations ext3_file_inode_operations = {
-- 
1.9.1


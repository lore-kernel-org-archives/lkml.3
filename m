Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbaKMV3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:29:13 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64373 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934437AbaKMV3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:10 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org (open list:AFFS FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 07/56] fs/affs: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:44 +0100
Message-Id: <1415913813-362-8-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from affs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/affs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index a7fe57d..8c2752d 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -35,7 +35,7 @@ const struct file_operations affs_file_operations = {
 	.open		= affs_file_open,
 	.release	= affs_file_release,
 	.fsync		= affs_file_fsync,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
 
 const struct inode_operations affs_file_inode_operations = {
-- 
1.9.1


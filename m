Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbaKMVaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:30:46 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57917 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbaKMVam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:42 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Bob Copeland <me@bobcopeland.com>,
        linux-karma-devel@lists.sourceforge.net (open list:OMFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 37/56] fs/omfs: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:14 +0100
Message-Id: <1415913813-362-38-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from omfs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/omfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 902e885..02e8d08 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -343,7 +343,7 @@ const struct file_operations omfs_file_operations = {
 	.write_iter = generic_file_write_iter,
 	.mmap = generic_file_mmap,
 	.fsync = generic_file_fsync,
-	.splice_read = generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
 
 static int omfs_setattr(struct dentry *dentry, struct iattr *attr)
-- 
1.9.1


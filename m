Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828AbaKMVhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:37:50 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49093 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbaKMVak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:40 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net (open list:NTFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 35/56] fs/ntfs: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:12 +0100
Message-Id: <1415913813-362-36-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from ntfs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/ntfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index f5ec1ce..cc5def2 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2216,7 +2216,7 @@ const struct file_operations ntfs_file_ops = {
 						    mounted filesystem. */
 	.mmap		= generic_file_mmap,	 /* Mmap file. */
 	.open		= ntfs_file_open,	 /* Open file. */
-	.splice_read	= generic_file_splice_read /* Zero-copy data send with
+	SPLICE_READ_INIT(generic_file_splice_read) /* Zero-copy data send with
 						    the data source being on
 						    the ntfs partition.  We do
 						    not need to care about the
-- 
1.9.1


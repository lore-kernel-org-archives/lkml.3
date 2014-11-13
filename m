Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934876AbaKMVjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:39:24 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62383 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964912AbaKMVa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:29 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org (open list:JOURNALLING FLASH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 29/56] fs/jffs2: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:06 +0100
Message-Id: <1415913813-362-30-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from jffs2 when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/jffs2/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 64989ca..bb4e88b 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -58,7 +58,7 @@ const struct file_operations jffs2_file_operations =
 	.unlocked_ioctl=jffs2_ioctl,
 	.mmap =		generic_file_readonly_mmap,
 	.fsync =	jffs2_fsync,
-	.splice_read =	generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
 
 /* jffs2_file_inode_operations */
-- 
1.9.1


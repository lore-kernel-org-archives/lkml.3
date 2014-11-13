Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860AbaKMV34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:29:56 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56165 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbaKMV3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:47 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 22/56] fs/fat: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:59 +0100
Message-Id: <1415913813-362-23-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from fat when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/fat/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 85f79a8..2067b5a 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -181,7 +181,7 @@ const struct file_operations fat_file_operations = {
 	.compat_ioctl	= fat_generic_compat_ioctl,
 #endif
 	.fsync		= fat_file_fsync,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
 
 static int fat_cont_expand(struct inode *inode, loff_t size)
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbaKMVpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:45:46 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36485 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934424AbaKMV3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:07 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 06/56] fs/adfs: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:43 +0100
Message-Id: <1415913813-362-7-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from adfs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/adfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/adfs/file.c b/fs/adfs/file.c
index 07c9edc..d7b19ab 100644
--- a/fs/adfs/file.c
+++ b/fs/adfs/file.c
@@ -29,7 +29,7 @@ const struct file_operations adfs_file_operations = {
 	.fsync		= generic_file_fsync,
 	.write		= new_sync_write,
 	.write_iter	= generic_file_write_iter,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
 
 const struct inode_operations adfs_file_inode_operations = {
-- 
1.9.1


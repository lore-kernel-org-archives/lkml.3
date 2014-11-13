Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934817AbaKMVgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:36:05 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48302 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934093AbaKMVaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:52 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 40/56] fs/romfs: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:17 +0100
Message-Id: <1415913813-362-41-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from romfs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/romfs/mmap-nommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/romfs/mmap-nommu.c b/fs/romfs/mmap-nommu.c
index ea06c75..45a3f30 100644
--- a/fs/romfs/mmap-nommu.c
+++ b/fs/romfs/mmap-nommu.c
@@ -74,7 +74,7 @@ const struct file_operations romfs_ro_fops = {
 	.llseek			= generic_file_llseek,
 	.read			= new_sync_read,
 	.read_iter		= generic_file_read_iter,
-	.splice_read		= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 	.mmap			= romfs_mmap,
 	.get_unmapped_area	= romfs_get_unmapped_area,
 };
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964922AbaKMVaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:30:30 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58560 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbaKMVa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:27 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 27/56] fs/hostfs: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:04 +0100
Message-Id: <1415913813-362-28-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from hostfs when the splice-family of syscalls is
not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/hostfs/hostfs_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index fd62cae..e750cc0 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -379,7 +379,7 @@ static int hostfs_fsync(struct file *file, loff_t start, loff_t end,
 static const struct file_operations hostfs_file_fops = {
 	.llseek		= generic_file_llseek,
 	.read		= new_sync_read,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.write		= new_sync_write,
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964940AbaKMVae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:30:34 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33394 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbaKMVab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:31 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net (open list:JFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 30/56] fs/jfs: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:07 +0100
Message-Id: <1415913813-362-31-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from jfs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/jfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 33aa0cc..88df840 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -156,8 +156,8 @@ const struct file_operations jfs_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.fsync		= jfs_fsync,
 	.release	= jfs_release,
 	.unlocked_ioctl = jfs_ioctl,
-- 
1.9.1


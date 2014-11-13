Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934820AbaKMVgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:36:42 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58215 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964972AbaKMVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:46 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Axel Lin <axel.lin@ingics.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 38/56] fs/ramfs: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:15 +0100
Message-Id: <1415913813-362-39-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from ramfs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/ramfs/file-mmu.c   | 4 ++--
 fs/ramfs/file-nommu.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
index 4f56de8..6a80e59 100644
--- a/fs/ramfs/file-mmu.c
+++ b/fs/ramfs/file-mmu.c
@@ -37,8 +37,8 @@ const struct file_operations ramfs_file_operations = {
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.fsync		= noop_fsync,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.llseek		= generic_file_llseek,
 };
 
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index bbafbde..b457303 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -42,8 +42,8 @@ const struct file_operations ramfs_file_operations = {
 	.write			= new_sync_write,
 	.write_iter		= generic_file_write_iter,
 	.fsync			= noop_fsync,
-	.splice_read		= generic_file_splice_read,
-	.splice_write		= iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.llseek			= generic_file_llseek,
 };
 
-- 
1.9.1


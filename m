Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879AbaKMVaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:30:01 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53453 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbaKMV36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:58 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Sergei Antonov <saproj@gmail.com>, Sougata Santra <sougata@tuxera.com>,
        linux-fsdevel@vger.kernel.org (open list:HFSPLUS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 26/56] fs/hfsplus: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:03 +0100
Message-Id: <1415913813-362-27-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from hfsplus when the splice-family of syscalls is
not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/hfsplus/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 0cf786f..8dfd889 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -346,7 +346,7 @@ static const struct file_operations hfsplus_file_operations = {
 	.write		= new_sync_write,
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 	.fsync		= hfsplus_file_fsync,
 	.open		= hfsplus_file_open,
 	.release	= hfsplus_file_release,
-- 
1.9.1


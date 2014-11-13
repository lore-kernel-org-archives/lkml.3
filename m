Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550AbaKMVaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:30:52 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57566 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988AbaKMVat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:49 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Jan Kara <jack@suse.cz>,
        Jeff Mahoney <jeffm@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Fabian Frederick <fabf@skynet.be>,
        reiserfs-devel@vger.kernel.org (open list:REISERFS FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 39/56] fs/reiserfs: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:16 +0100
Message-Id: <1415913813-362-40-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from reiserfs when the splice-family of syscalls is
not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/reiserfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index 751dd3f..b716c59 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -255,8 +255,8 @@ const struct file_operations reiserfs_file_operations = {
 	.fsync = reiserfs_sync_file,
 	.read_iter = generic_file_read_iter,
 	.write_iter = generic_file_write_iter,
-	.splice_read = generic_file_splice_read,
-	.splice_write = iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.llseek = generic_file_llseek,
 };
 
-- 
1.9.1


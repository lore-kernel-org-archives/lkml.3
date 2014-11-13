Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357AbaKMV3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:29:16 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60395 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418AbaKMV3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:11 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org (open list:AFS FILESYSTEM &...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 08/56] fs/afs: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:45 +0100
Message-Id: <1415913813-362-9-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from afs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/afs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 932ce07..d7c7af5 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -36,7 +36,7 @@ const struct file_operations afs_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= afs_file_write,
 	.mmap		= generic_file_readonly_mmap,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 	.fsync		= afs_fsync,
 	.lock		= afs_lock,
 	.flock		= afs_flock,
-- 
1.9.1


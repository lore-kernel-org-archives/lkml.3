Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934531AbaKMV3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:29:34 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46513 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934495AbaKMV32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:28 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 11/56] fs/bfs: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:48 +0100
Message-Id: <1415913813-362-12-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from bfs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/bfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index e7f88ac..74ea687 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -28,7 +28,7 @@ const struct file_operations bfs_file_operations = {
 	.write		= new_sync_write,
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
 
 static int bfs_move_block(unsigned long from, unsigned long to,
-- 
1.9.1


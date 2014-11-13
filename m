Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbaKMVbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:31:42 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40102 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934364AbaKMVbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:38 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 50/56] fs/read_write: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:27 +0100
Message-Id: <1415913813-362-51-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from read_write when the splice-family of syscalls
is not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/read_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 4361261..55dee62 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -32,7 +32,7 @@ const struct file_operations generic_ro_fops = {
 	.read		= new_sync_read,
 	.read_iter	= generic_file_read_iter,
 	.mmap		= generic_file_readonly_mmap,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
 
 EXPORT_SYMBOL(generic_ro_fops);
-- 
1.9.1


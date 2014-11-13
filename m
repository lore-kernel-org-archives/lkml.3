Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574AbaKMVaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:30:55 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64753 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934551AbaKMVax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:53 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 41/56] fs/sysv: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:18 +0100
Message-Id: <1415913813-362-42-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from sysv when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/sysv/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysv/file.c b/fs/sysv/file.c
index b00811c..456194b 100644
--- a/fs/sysv/file.c
+++ b/fs/sysv/file.c
@@ -27,7 +27,7 @@ const struct file_operations sysv_file_operations = {
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.fsync		= generic_file_fsync,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
 
 static int sysv_setattr(struct dentry *dentry, struct iattr *attr)
-- 
1.9.1


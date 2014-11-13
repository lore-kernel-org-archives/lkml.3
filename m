Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804AbaKMVff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:35:35 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57055 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934348AbaKMVbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:09 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Evgeniy Dushistov <dushistov@mail.ru>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 44/56] fs/ufs: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:21 +0100
Message-Id: <1415913813-362-45-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from ufs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/ufs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ufs/file.c b/fs/ufs/file.c
index c84ec01..247308d 100644
--- a/fs/ufs/file.c
+++ b/fs/ufs/file.c
@@ -42,5 +42,5 @@ const struct file_operations ufs_file_operations = {
 	.mmap		= generic_file_mmap,
 	.open           = generic_file_open,
 	.fsync		= generic_file_fsync,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
-- 
1.9.1


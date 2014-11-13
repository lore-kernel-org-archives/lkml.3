Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934745AbaKMVmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:42:03 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36555 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbaKMV3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:45 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net (open list:F2FS FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 21/56] fs/f2fs: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:58 +0100
Message-Id: <1415913813-362-22-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from f2fs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/f2fs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 208f1a9..57c6d40 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -853,6 +853,6 @@ const struct file_operations f2fs_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= f2fs_compat_ioctl,
 #endif
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 };
-- 
1.9.1


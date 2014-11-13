Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827AbaKMV3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:29:47 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58598 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794AbaKMV3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:42 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org (open list:EXT4 FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 20/56] fs/ext4: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:57 +0100
Message-Id: <1415913813-362-21-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from ext4 when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/ext4/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index aca7b24..c9d2962 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -595,8 +595,8 @@ const struct file_operations ext4_file_operations = {
 	.open		= ext4_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.fallocate	= ext4_fallocate,
 };
 
-- 
1.9.1


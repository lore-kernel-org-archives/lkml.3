Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964914AbaKMVmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:42:49 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34375 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934533AbaKMV3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:37 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Boaz Harrosh <bharrosh@panasas.com>,
        Benny Halevy <bhalevy@primarydata.com>,
        osd-dev@open-osd.org (open list:OSD LIBRARY and F...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 17/56] fs/exofs: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:54 +0100
Message-Id: <1415913813-362-18-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from exofs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/exofs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exofs/file.c b/fs/exofs/file.c
index 71bf8e4..23dfb05 100644
--- a/fs/exofs/file.c
+++ b/fs/exofs/file.c
@@ -76,8 +76,8 @@ const struct file_operations exofs_file_operations = {
 	.release	= exofs_release_file,
 	.fsync		= exofs_file_fsync,
 	.flush		= exofs_flush,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 };
 
 const struct inode_operations exofs_file_inode_operations = {
-- 
1.9.1


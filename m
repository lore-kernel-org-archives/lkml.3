Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbaKMVnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:43:40 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41009 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418AbaKMV3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:33 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org (open list:COMMON INTERNET F...),
        samba-technical@lists.samba.org (moderated list:COMMON INTERNET F...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 14/56] fs/cifs: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:51 +0100
Message-Id: <1415913813-362-15-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from cifs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/cifs/cifsfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ac4f260..b2bd0a0 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -902,7 +902,7 @@ const struct file_operations cifs_file_ops = {
 	.fsync = cifs_fsync,
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
-	.splice_read = generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
@@ -921,7 +921,7 @@ const struct file_operations cifs_file_strict_ops = {
 	.fsync = cifs_strict_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_strict_mmap,
-	.splice_read = generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
@@ -941,7 +941,7 @@ const struct file_operations cifs_file_direct_ops = {
 	.fsync = cifs_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
-	.splice_read = generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl  = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
@@ -959,7 +959,7 @@ const struct file_operations cifs_file_nobrl_ops = {
 	.fsync = cifs_fsync,
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
-	.splice_read = generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
@@ -977,7 +977,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
 	.fsync = cifs_strict_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_strict_mmap,
-	.splice_read = generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
@@ -996,7 +996,7 @@ const struct file_operations cifs_file_direct_nobrl_ops = {
 	.fsync = cifs_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
-	.splice_read = generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl  = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
-- 
1.9.1


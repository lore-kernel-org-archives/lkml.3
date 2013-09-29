Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3I2JiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 05:38:21 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34503 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3I2JiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 05:38:17 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vfs: Get rid of duplicate offset checks in p{read,write}*
Date: Sun, 29 Sep 2013 18:37:49 +0900
Message-Id: <1380447470-2811-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current pread/pwrite functions simply checks whether offset is
negative.  Thus we couldn't use these functions for the large
(negative) offsets although some files did allow that.

Checking it correctly requires a file pointer and we already did
the check in rw_verify_area() so just remove the checks.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 fs/read_write.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e3cd280b158c..878f40e50451 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -534,9 +534,6 @@ SYSCALL_DEFINE4(pread64, unsigned int, fd, char __user *, buf,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (pos < 0)
-		return -EINVAL;
-
 	f = fdget(fd);
 	if (f.file) {
 		ret = -ESPIPE;
@@ -554,9 +551,6 @@ SYSCALL_DEFINE4(pwrite64, unsigned int, fd, const char __user *, buf,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (pos < 0)
-		return -EINVAL;
-
 	f = fdget(fd);
 	if (f.file) {
 		ret = -ESPIPE;
@@ -852,9 +846,6 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (pos < 0)
-		return -EINVAL;
-
 	f = fdget(fd);
 	if (f.file) {
 		ret = -ESPIPE;
@@ -876,9 +867,6 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (pos < 0)
-		return -EINVAL;
-
 	f = fdget(fd);
 	if (f.file) {
 		ret = -ESPIPE;
@@ -1002,8 +990,6 @@ COMPAT_SYSCALL_DEFINE4(preadv64, unsigned long, fd,
 	struct fd f;
 	ssize_t ret;
 
-	if (pos < 0)
-		return -EINVAL;
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
@@ -1069,8 +1055,6 @@ COMPAT_SYSCALL_DEFINE4(pwritev64, unsigned long, fd,
 	struct fd f;
 	ssize_t ret;
 
-	if (pos < 0)
-		return -EINVAL;
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
-- 
1.7.9.2


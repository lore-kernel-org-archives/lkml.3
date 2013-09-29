Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab3I2GOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 02:14:48 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42002 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3I2GOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 02:14:45 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] splice: Get rid of duplicate f_mode checks
Date: Sun, 29 Sep 2013 15:14:34 +0900
Message-Id: <1380435278-10927-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The do_splice() function was only called from sys_splice() but it
already checks the f_mode both for in and out.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 fs/splice.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 3b7ee656f3aa..320cc65585b2 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1333,12 +1333,6 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 		if (off_in || off_out)
 			return -ESPIPE;
 
-		if (!(in->f_mode & FMODE_READ))
-			return -EBADF;
-
-		if (!(out->f_mode & FMODE_WRITE))
-			return -EBADF;
-
 		/* Splicing to self would be fun, but... */
 		if (ipipe == opipe)
 			return -EINVAL;
@@ -1358,9 +1352,6 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 			offset = out->f_pos;
 		}
 
-		if (unlikely(!(out->f_mode & FMODE_WRITE)))
-			return -EBADF;
-
 		if (unlikely(out->f_flags & O_APPEND))
 			return -EINVAL;
 
-- 
1.7.9.2


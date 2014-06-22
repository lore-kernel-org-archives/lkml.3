Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaFVSv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 14:51:27 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:51773 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaFVSv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:51:26 -0400
From: Jerry Stralko <gerb.stralko@gmail.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: swetland@google.com, Jerry Stralko <gerb.stralko@gmail.com>
Subject: [PATCH] stagging: android: logger: code cleanup
Date: Sun, 22 Jun 2014 14:51:08 -0400
Message-Id: <1403463068-21850-1-git-send-email-gerb.stralko@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the unlikey macro to the return value of nonseekable_open,
since it always returns successfully.

Fixed up some checkpatch warnings.

Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>
---
 drivers/staging/android/logger.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 2772e01..b98d181 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -110,8 +110,8 @@ static inline struct logger_log *file_get_log(struct file *file)
 		struct logger_reader *reader = file->private_data;
 
 		return reader->log;
-	} else
-		return file->private_data;
+	}
+	return file->private_data;
 }
 
 /*
@@ -159,8 +159,7 @@ static size_t get_user_hdr_len(int ver)
 {
 	if (ver < 2)
 		return sizeof(struct user_logger_entry_compat);
-	else
-		return sizeof(struct logger_entry);
+	return sizeof(struct logger_entry);
 }
 
 static ssize_t copy_header_to_user(int ver, struct logger_entry *entry,
@@ -552,7 +551,7 @@ static int logger_open(struct inode *inode, struct file *file)
 	int ret;
 
 	ret = nonseekable_open(inode, file);
-	if (ret)
+	if (unlikely(ret))
 		return ret;
 
 	log = get_log_from_minor(MINOR(inode->i_rdev));
-- 
1.9.3


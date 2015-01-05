Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbbAEOZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:25:06 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61977 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbbAEOZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:25:01 -0500
From: Guillaume Vercoutere <gvercoutere@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gvercoutere@gmail.com
Subject: [PATCH 1/3] staging: android: Correct coding style in logger.c
Date: Mon,  5 Jan 2015 15:24:06 +0100
Message-Id: <1420467846-6358-1-git-send-email-gvercoutere@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct intent and missing space

Signed-off-by: Guillaume Vercoutere <gvercoutere@gmail.com>
---
 drivers/staging/android/logger.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index a673ffa..59ea1a7 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -63,7 +63,6 @@ struct logger_log {
 
 static LIST_HEAD(log_list);
 
-
 /**
  * struct logger_reader - a logging device open for reading
  * @log:	The associated log
@@ -89,7 +88,6 @@ static size_t logger_offset(struct logger_log *log, size_t n)
 	return n & (log->size - 1);
 }
 
-
 /*
  * file_get_log - Given a file structure, return the associated log
  *
@@ -122,14 +120,15 @@ static inline struct logger_log *file_get_log(struct file *file)
  * the log entry spans the end and beginning of the circular buffer.
  */
 static struct logger_entry *get_entry_header(struct logger_log *log,
-		size_t off, struct logger_entry *scratch)
+					     size_t off,
+					     struct logger_entry *scratch)
 {
 	size_t len = min(sizeof(struct logger_entry), log->size - off);
 
 	if (len != sizeof(struct logger_entry)) {
-		memcpy(((void *) scratch), log->buffer + off, len);
-		memcpy(((void *) scratch) + len, log->buffer,
-			sizeof(struct logger_entry) - len);
+		memcpy(((void *)scratch), log->buffer + off, len);
+		memcpy(((void *)scratch) + len, log->buffer,
+		       sizeof(struct logger_entry) - len);
 		return scratch;
 	}
 
@@ -163,7 +162,7 @@ static size_t get_user_hdr_len(int ver)
 }
 
 static ssize_t copy_header_to_user(int ver, struct logger_entry *entry,
-					 char __user *buf)
+				   char __user *buf)
 {
 	void *hdr;
 	size_t hdr_len;
@@ -213,7 +212,7 @@ static ssize_t do_read_log_to_user(struct logger_log *log,
 	count -= get_user_hdr_len(reader->r_ver);
 	buf += get_user_hdr_len(reader->r_ver);
 	msg_start = logger_offset(log,
-		reader->r_off + sizeof(struct logger_entry));
+				  reader->r_off + sizeof(struct logger_entry));
 
 	/*
 	 * We read from the msg in two disjoint operations. First, we read from
@@ -243,7 +242,7 @@ static ssize_t do_read_log_to_user(struct logger_log *log,
  * 'log->buffer' which contains the first entry readable by 'euid'
  */
 static size_t get_next_entry_by_uid(struct logger_log *log,
-		size_t off, kuid_t euid)
+				    size_t off, kuid_t euid)
 {
 	while (off != log->w_off) {
 		struct logger_entry *entry;
@@ -530,8 +529,9 @@ static int logger_open(struct inode *inode, struct file *file)
 		mutex_unlock(&log->mutex);
 
 		file->private_data = reader;
-	} else
+	} else {
 		file->private_data = log;
+	}
 
 	return 0;
 }
@@ -611,7 +611,7 @@ static long logger_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct logger_log *log = file_get_log(file);
 	struct logger_reader *reader;
 	long ret = -EINVAL;
-	void __user *argp = (void __user *) arg;
+	void __user *argp = (void __user *)arg;
 
 	mutex_lock(&log->mutex);
 
@@ -653,7 +653,7 @@ static long logger_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 		}
 		if (!(in_egroup_p(file_inode(file)->i_gid) ||
-				capable(CAP_SYSLOG))) {
+		      capable(CAP_SYSLOG))) {
 			ret = -EPERM;
 			break;
 		}
@@ -741,12 +741,12 @@ static int __init create_log(char *log_name, int size)
 	ret = misc_register(&log->misc);
 	if (unlikely(ret)) {
 		pr_err("failed to register misc device for log '%s'!\n",
-				log->misc.name);
+		       log->misc.name);
 		goto out_free_misc_name;
 	}
 
 	pr_info("created %luK log '%s'\n",
-		(unsigned long) log->size >> 10, log->misc.name);
+		(unsigned long)log->size >> 10, log->misc.name);
 
 	return 0;
 
@@ -799,7 +799,6 @@ static void __exit logger_exit(void)
 	}
 }
 
-
 device_initcall(logger_init);
 module_exit(logger_exit);
 
-- 
1.7.10.4


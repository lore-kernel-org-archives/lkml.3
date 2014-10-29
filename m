Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaJ2GKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:10:19 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:49034 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaJ2GKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:10:17 -0400
From: Tristan Lelong <tristan.lelong@blunderer.org>
To: gregkh@linuxfoundation.org, waydi1@gmail.com, dan.carpenter@oracle.com,
        viro@zeniv.linux.org.uk, gerb.stralko@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Tristan Lelong <tristan.lelong@blunderer.org>
Subject: [PATCH] Staging: android: logger: Remove uneeded tabs in variable declaration
Date: Tue, 28 Oct 2014 23:09:10 -0700
Message-Id: <1414562950-6555-1-git-send-email-tristan.lelong@blunderer.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes tabs used to align variable names in declaration and assignation.
It replaces them with exactly one space.

Signed-off-by: Tristan Lelong <tristan.lelong@blunderer.org>
---
 drivers/staging/android/logger.c | 49 ++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 28b93d3..ce0b41d 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -50,20 +50,19 @@
  * mutex 'mutex'.
  */
 struct logger_log {
-	unsigned char		*buffer;
-	struct miscdevice	misc;
-	wait_queue_head_t	wq;
-	struct list_head	readers;
-	struct mutex		mutex;
-	size_t			w_off;
-	size_t			head;
-	size_t			size;
-	struct list_head	logs;
+	unsigned char *buffer;
+	struct miscdevice misc;
+	wait_queue_head_t wq;
+	struct list_head readers;
+	struct mutex mutex;
+	size_t w_off;
+	size_t head;
+	size_t size;
+	struct list_head logs;
 };
 
 static LIST_HEAD(log_list);
 
-
 /**
  * struct logger_reader - a logging device open for reading
  * @log:	The associated log
@@ -76,11 +75,11 @@ static LIST_HEAD(log_list);
  * reference counting. The structure is protected by log->mutex.
  */
 struct logger_reader {
-	struct logger_log	*log;
-	struct list_head	list;
-	size_t			r_off;
-	bool			r_all;
-	int			r_ver;
+	struct logger_log *log;
+	struct list_head list;
+	size_t r_off;
+	bool r_all;
+	int r_ver;
 };
 
 /* logger_offset - returns index 'n' into the log via (optimized) modulus */
@@ -170,17 +169,17 @@ static ssize_t copy_header_to_user(int ver, struct logger_entry *entry,
 	struct user_logger_entry_compat v1;
 
 	if (ver < 2) {
-		v1.len      = entry->len;
-		v1.__pad    = 0;
-		v1.pid      = entry->pid;
-		v1.tid      = entry->tid;
-		v1.sec      = entry->sec;
-		v1.nsec     = entry->nsec;
-		hdr         = &v1;
-		hdr_len     = sizeof(struct user_logger_entry_compat);
+		v1.len = entry->len;
+		v1.__pad = 0;
+		v1.pid = entry->pid;
+		v1.tid = entry->tid;
+		v1.sec = entry->sec;
+		v1.nsec = entry->nsec;
+		hdr = &v1;
+		hdr_len = sizeof(struct user_logger_entry_compat);
 	} else {
-		hdr         = entry;
-		hdr_len     = sizeof(struct logger_entry);
+		hdr = entry;
+		hdr_len = sizeof(struct logger_entry);
 	}
 
 	return copy_to_user(buf, hdr, hdr_len);
-- 
2.1.1


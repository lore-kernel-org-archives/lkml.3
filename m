Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3EHKxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:53:09 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:44771 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab3EHKxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:53:07 -0400
Date: Wed, 8 May 2013 18:52:48 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
cc: kernel-team@android.com, nnk@google.com, john.stultz@linaro.org,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        jencce.kernel@gmail.com
Subject: [PATCH] staging: android: logger: use kuid_t instead of uid_t
Message-ID: <alpine.DEB.2.02.1305081846070.29540@M2420>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiong Zhou <jencce.kernel@gmail.com>

Use kuid_t instead of uid_t, to pass the UIDGID_STRICT_TYPE_CHECKS.

Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
---
drivers/staging/android/logger.c |    4 ++--
drivers/staging/android/logger.h |    2 +-
2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index b040200..9bd8747 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -242,7 +242,7 @@ static ssize_t do_read_log_to_user(struct logger_log *log,
  * 'log->buffer' which contains the first entry readable by 'euid'
  */
 static size_t get_next_entry_by_uid(struct logger_log *log,
-		size_t off, uid_t euid)
+		size_t off, kuid_t euid)
 {
 	while (off != log->w_off) {
 		struct logger_entry *entry;
@@ -251,7 +251,7 @@ static size_t get_next_entry_by_uid(struct logger_log *log,
 
 		entry = get_entry_header(log, off, &scratch);
 
-		if (entry->euid == euid)
+		if (uid_eq(entry->euid, euid))
 			return off;
 
 		next_len = sizeof(struct logger_entry) + entry->len;
diff --git a/drivers/staging/android/logger.h b/drivers/staging/android/logger.h
index cc6bbd9..70af7d8 100644
--- a/drivers/staging/android/logger.h
+++ b/drivers/staging/android/logger.h
@@ -66,7 +66,7 @@ struct logger_entry {
 	__s32		tid;
 	__s32		sec;
 	__s32		nsec;
-	uid_t		euid;
+	kuid_t		euid;
 	char		msg[0];
 };
 

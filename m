Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934942AbaGXKAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:00:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934604AbaGXJsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Machek <pavel@ucw.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 097/128] ext4: clarify error count warning messages
Date: Thu, 24 Jul 2014 10:45:46 +0100
Message-Id: <1406195177-8656-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit ae0f78de2c43b6fadd007c231a352b13b5be8ed2 upstream.

Make it clear that values printed are times, and that it is error
since last fsck. Also add note about fsck version required.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 09d4762ffe91..f9659f067147 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2725,10 +2725,11 @@ static void print_daily_error_info(unsigned long arg)
 	es = sbi->s_es;
 
 	if (es->s_error_count)
-		ext4_msg(sb, KERN_NOTICE, "error count: %u",
+		/* fsck newer than v1.41.13 is needed to clean this condition. */
+		ext4_msg(sb, KERN_NOTICE, "error count since last fsck: %u",
 			 le32_to_cpu(es->s_error_count));
 	if (es->s_first_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): initial error at %u: %.*s:%d",
+		printk(KERN_NOTICE "EXT4-fs (%s): initial error at time %u: %.*s:%d",
 		       sb->s_id, le32_to_cpu(es->s_first_error_time),
 		       (int) sizeof(es->s_first_error_func),
 		       es->s_first_error_func,
@@ -2742,7 +2743,7 @@ static void print_daily_error_info(unsigned long arg)
 		printk("\n");
 	}
 	if (es->s_last_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): last error at %u: %.*s:%d",
+		printk(KERN_NOTICE "EXT4-fs (%s): last error at time %u: %.*s:%d",
 		       sb->s_id, le32_to_cpu(es->s_last_error_time),
 		       (int) sizeof(es->s_last_error_func),
 		       es->s_last_error_func,
-- 
1.9.1


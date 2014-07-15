Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbaGORP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:15:27 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61370 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbaGORCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:11 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        stable@vger.kernel.org, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 32/94] ext4: clarify error count warning messages
Date: Tue, 15 Jul 2014 20:00:47 +0300
Message-Id: <1405443709-15288-32-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

Make it clear that values printed are times, and that it is error
since last fsck. Also add note about fsck version required.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Cc: stable@vger.kernel.org
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 fs/ext4/super.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b9b9aab..3423947 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2809,10 +2809,11 @@ static void print_daily_error_info(unsigned long arg)
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
@@ -2826,7 +2827,7 @@ static void print_daily_error_info(unsigned long arg)
 		printk("\n");
 	}
 	if (es->s_last_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): last error at %u: %.*s:%d",
+		printk(KERN_NOTICE "EXT4-fs (%s): last error at time %u: %.*s:%d",
 		       sb->s_id, le32_to_cpu(es->s_last_error_time),
 		       (int) sizeof(es->s_last_error_func),
 		       es->s_last_error_func,
-- 
1.7.10.4


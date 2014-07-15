Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934398AbaGOX0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:26:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760095AbaGOXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
        Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 3.15 50/84] ext4: clarify error count warning messages
Date: Tue, 15 Jul 2014 16:17:47 -0700
Message-Id: <20140715231714.707847021@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit ae0f78de2c43b6fadd007c231a352b13b5be8ed2 upstream.

Make it clear that values printed are times, and that it is error
since last fsck. Also add note about fsck version required.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2798,10 +2798,11 @@ static void print_daily_error_info(unsig
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
@@ -2815,7 +2816,7 @@ static void print_daily_error_info(unsig
 		printk("\n");
 	}
 	if (es->s_last_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): last error at %u: %.*s:%d",
+		printk(KERN_NOTICE "EXT4-fs (%s): last error at time %u: %.*s:%d",
 		       sb->s_id, le32_to_cpu(es->s_last_error_time),
 		       (int) sizeof(es->s_last_error_func),
 		       es->s_last_error_func,



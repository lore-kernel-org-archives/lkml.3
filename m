Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaHDQxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:53:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56671 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbaHDQt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Pavel Machek" <pavel@ucw.cz>,
        "Andreas Dilger" <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.74476308@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 26/94] ext4: clarify error count warning messages
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit ae0f78de2c43b6fadd007c231a352b13b5be8ed2 upstream.

Make it clear that values printed are times, and that it is error
since last fsck. Also add note about fsck version required.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2726,10 +2726,11 @@ static void print_daily_error_info(unsig
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
@@ -2743,7 +2744,7 @@ static void print_daily_error_info(unsig
 		printk("\n");
 	}
 	if (es->s_last_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): last error at %u: %.*s:%d",
+		printk(KERN_NOTICE "EXT4-fs (%s): last error at time %u: %.*s:%d",
 		       sb->s_id, le32_to_cpu(es->s_last_error_time),
 		       (int) sizeof(es->s_last_error_func),
 		       es->s_last_error_func,


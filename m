Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaHOHt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 03:49:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:65014 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaHOHt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:49:58 -0400
From: Chin-Tsung Cheng <chintzung@gmail.com>
To: jack@suse.cz
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chin-Tsung Cheng <chintzung@gmail.com>
Subject: [PATCH] ext3: Count internal journal as bsddf overhead in ext3_statfs
Date: Fri, 15 Aug 2014 15:49:31 +0800
Message-Id: <1408088971-3221-1-git-send-email-chintzung@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The journal blocks of external journal device should not
be counted as overhead.

Signed-off-by: Chin-Tsung Cheng <chintzung@gmail.com>
---
 fs/ext3/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 08cdfe5..622e882 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2828,8 +2828,9 @@ static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf)
 		 */
 		overhead += ngroups * (2 + sbi->s_itb_per_group);
 
-		/* Add the journal blocks as well */
-                overhead += sbi->s_journal->j_maxlen;
+		/* Add the internal journal blocks as well */
+		if (sbi->s_journal && !sbi->journal_bdev)
+			overhead += sbi->s_journal->j_maxlen;
 
 		sbi->s_overhead_last = overhead;
 		smp_wmb();
-- 
1.9.3


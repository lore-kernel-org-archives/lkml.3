Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaHOGol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:44:41 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41798 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaHOGok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:44:40 -0400
From: Chin-Tsung Cheng <chintzung@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chin-Tsung Cheng <chintzung@gmail.com>
Subject: [PATCH v2] ext4: include journal blocks of internal journal in df overhead calcs
Date: Fri, 15 Aug 2014 14:42:51 +0800
Message-Id: <1408084971-1456-1-git-send-email-chintzung@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The journal blocks of external journal device should not
be counted as overhead.

Signed-off-by: Chin-Tsung Cheng <chintzung@gmail.com>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32b43ad..a80b122 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3316,8 +3316,8 @@ int ext4_calculate_overhead(struct super_block *sb)
 			memset(buf, 0, PAGE_SIZE);
 		cond_resched();
 	}
-	/* Add the journal blocks as well */
-	if (sbi->s_journal)
+	/* Add the internal journal blocks as well */
+	if (sbi->s_journal && !sbi->journal_bdev)
 		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
 
 	sbi->s_overhead = overhead;
-- 
1.9.3


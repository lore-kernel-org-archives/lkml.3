Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaGTSZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 14:25:36 -0400
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:39555 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753488AbaGTSYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 14:24:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3876:3877:4321:5007:6114:6261:6642:10004:10026:10848:11026:11658:11914:12114:12296:12438:12517:12519:12555:13311:13357:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: goat65_5db8d7f558d34
X-Filterd-Recvd-Size: 2169
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Teigland <teigland@redhat.com>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] fs.h: Add member argument descriptions to lock_manager_operations
Date: Sun, 20 Jul 2014 11:23:39 -0700
Message-Id: <503fd312498a4908a1a782d615734c45570fd821.1405879494.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1405879494.git.joe@perches.com>
References: <cover.1405879494.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pointer struct members without argument type names
are not very clear.  Add them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/fs.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 65685a7..ede4be8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -839,12 +839,12 @@ struct file_lock_operations {
 };
 
 struct lock_manager_operations {
-	int (*lm_compare_owner)(struct file_lock *, struct file_lock *);
-	unsigned long (*lm_owner_key)(struct file_lock *);
-	void (*lm_notify)(struct file_lock *);	/* unblock callback */
-	int (*lm_grant)(struct file_lock *, struct file_lock *, int);
-	void (*lm_break)(struct file_lock *);
-	int (*lm_change)(struct file_lock **, int);
+	int (*lm_compare_owner)(struct file_lock *fl1, struct file_lock *fl2);
+	unsigned long (*lm_owner_key)(struct file_lock *fl);
+	void (*lm_notify)(struct file_lock *fl);	/* unblock callback */
+	int (*lm_grant)(struct file_lock *fl, struct file_lock *conf, int result);
+	void (*lm_break)(struct file_lock *fl);
+	int (*lm_change)(struct file_lock **fl, int type);
 };
 
 struct lock_manager {
-- 
1.8.1.2.459.gbcd45b4.dirty


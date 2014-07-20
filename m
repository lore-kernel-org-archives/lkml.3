Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaGTSZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 14:25:59 -0400
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:36416 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753333AbaGTSYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 14:24:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3350:3876:3877:4321:5007:6114:6261:6642:10004:10026:10848:11026:11658:11914:12114:12296:12438:12517:12519:12555:13311:13357:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: apple65_5d5a37e339e2e
X-Filterd-Recvd-Size: 1737
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Teigland <teigland@redhat.com>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] fs.h: Add argument names to struct file_lock_operations (*funcs)
Date: Sun, 20 Jul 2014 11:23:38 -0700
Message-Id: <f3739fa3d66b206267cadac326eee3fc09a2fdc6.1405879494.git.joe@perches.com>
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
 include/linux/fs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 05be298..65685a7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -834,8 +834,8 @@ static inline struct file *get_file(struct file *f)
 typedef void *fl_owner_t;
 
 struct file_lock_operations {
-	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
-	void (*fl_release_private)(struct file_lock *);
+	void (*fl_copy_lock)(struct file_lock *dst, struct file_lock *fl);
+	void (*fl_release_private)(struct file_lock *fl);
 };
 
 struct lock_manager_operations {
-- 
1.8.1.2.459.gbcd45b4.dirty


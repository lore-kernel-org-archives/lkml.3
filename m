Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3KFVhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:37:42 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:52449 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab3KFVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:37:39 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, EXT4 <linux-ext4@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] rbtree/test: test rbtree_postorder_for_each_entry_safe()
Date: Wed,  6 Nov 2013 13:37:23 -0800
Message-Id: <1383773843-19981-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <527AA418.7010009@linux.vnet.ibm.com>
References: <527AA418.7010009@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110621-9332-0000-0000-000002113EBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 lib/rbtree_test.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index df6c125..8b3c9dc 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -114,6 +114,16 @@ static int black_path_count(struct rb_node *rb)
 	return count;
 }
 
+static void check_postorder_foreach(int nr_nodes)
+{
+	struct test_node *cur, *n;
+	int count = 0;
+	rbtree_postorder_for_each_entry_safe(cur, n, &root, rb)
+		count++;
+
+	WARN_ON_ONCE(count != nr_nodes);
+}
+
 static void check_postorder(int nr_nodes)
 {
 	struct rb_node *rb;
@@ -148,6 +158,7 @@ static void check(int nr_nodes)
 	WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
 
 	check_postorder(nr_nodes);
+	check_postorder_foreach(nr_nodes);
 }
 
 static void check_augmented(int nr_nodes)
-- 
1.8.4.2


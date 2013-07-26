Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab3GZVOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:14:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38200 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933357Ab3GZVOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:14:24 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 3/5] rbtree_test: add test for postorder iteration
Date: Fri, 26 Jul 2013 14:13:41 -0700
Message-Id: <1374873223-25557-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072621-0320-0000-0000-000000726546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just check that we examine all nodes in the tree for the postorder iteration.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 lib/rbtree_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index 122f02f..31dd4cc 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -114,6 +114,16 @@ static int black_path_count(struct rb_node *rb)
 	return count;
 }
 
+static void check_postorder(int nr_nodes)
+{
+	struct rb_node *rb;
+	int count = 0;
+	for (rb = rb_first_postorder(&root); rb; rb = rb_next_postorder(rb))
+		count++;
+
+	WARN_ON_ONCE(count != nr_nodes);
+}
+
 static void check(int nr_nodes)
 {
 	struct rb_node *rb;
@@ -136,6 +146,8 @@ static void check(int nr_nodes)
 
 	WARN_ON_ONCE(count != nr_nodes);
 	WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
+
+	check_postorder(nr_nodes);
 }
 
 static void check_augmented(int nr_nodes)
-- 
1.8.3.4


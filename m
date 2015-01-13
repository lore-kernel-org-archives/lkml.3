Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbbAMFFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:05:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:3421 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbAMFFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:05:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,747,1413270000"; 
   d="scan'208";a="650217842"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: namespace: Simplify function commit_tree()
Date: Tue, 13 Jan 2015 13:08:06 +0800
Message-Id: <1421125686-23765-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify function commit_tree() in fs/namespace.c, it also improves code
readability.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 fs/namespace.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index cd1e9681a0cf..c2b6f6f676ec 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -846,18 +846,11 @@ static void attach_shadowed(struct mount *mnt,
 static void commit_tree(struct mount *mnt, struct mount *shadows)
 {
 	struct mount *parent = mnt->mnt_parent;
-	struct mount *m;
-	LIST_HEAD(head);
 	struct mnt_namespace *n = parent->mnt_ns;
 
 	BUG_ON(parent == mnt);
-
-	list_add_tail(&head, &mnt->mnt_list);
-	list_for_each_entry(m, &head, mnt_list)
-		m->mnt_ns = n;
-
-	list_splice(&head, n->list.prev);
-
+	mnt->mnt_ns = n;
+	list_add_tail(&mnt->mnt_list, &n->list);
 	attach_shadowed(mnt, parent, shadows);
 	touch_mnt_namespace(n);
 }
-- 
1.7.10.4


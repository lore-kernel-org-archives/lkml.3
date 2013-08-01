Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3HAVxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:53:18 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39333 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3HAVuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:50:32 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/23] cgroup: relocate cgroup_advance_iter()
Date: Thu,  1 Aug 2013 17:49:54 -0400
Message-Id: <1375393801-4817-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375393801-4817-1-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason, cgroup_advance_iter() is standing lonely all away
from its iter comrades.  Relocate it.

This is cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 850ad87..1085439 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2975,30 +2975,6 @@ int cgroup_task_count(const struct cgroup *cgrp)
 }
 
 /*
- * Advance a list_head iterator.  The iterator should be positioned at
- * the start of a css_set
- */
-static void cgroup_advance_iter(struct cgroup *cgrp, struct cgroup_iter *it)
-{
-	struct list_head *l = it->cset_link;
-	struct cgrp_cset_link *link;
-	struct css_set *cset;
-
-	/* Advance to the next non-empty css_set */
-	do {
-		l = l->next;
-		if (l == &cgrp->cset_links) {
-			it->cset_link = NULL;
-			return;
-		}
-		link = list_entry(l, struct cgrp_cset_link, cset_link);
-		cset = link->cset;
-	} while (list_empty(&cset->tasks));
-	it->cset_link = l;
-	it->task = cset->tasks.next;
-}
-
-/*
  * To reduce the fork() overhead for systems that are not actually
  * using their cgroups capability, we don't maintain the lists running
  * through each css_set to its tasks until we see the list actually
@@ -3216,6 +3192,30 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 }
 EXPORT_SYMBOL_GPL(css_next_descendant_post);
 
+/*
+ * Advance a list_head iterator.  The iterator should be positioned at
+ * the start of a css_set
+ */
+static void cgroup_advance_iter(struct cgroup *cgrp, struct cgroup_iter *it)
+{
+	struct list_head *l = it->cset_link;
+	struct cgrp_cset_link *link;
+	struct css_set *cset;
+
+	/* Advance to the next non-empty css_set */
+	do {
+		l = l->next;
+		if (l == &cgrp->cset_links) {
+			it->cset_link = NULL;
+			return;
+		}
+		link = list_entry(l, struct cgrp_cset_link, cset_link);
+		cset = link->cset;
+	} while (list_empty(&cset->tasks));
+	it->cset_link = l;
+	it->task = cset->tasks.next;
+}
+
 void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it)
 	__acquires(css_set_lock)
 {
-- 
1.8.3.1


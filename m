Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab3EFWqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:46:31 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39885 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758756Ab3EFWq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:46:28 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/33] blkcg: implement blkg_for_each_descendant_post()
Date: Mon,  6 May 2013 15:45:42 -0700
Message-Id: <1367880372-28312-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used by blk-throttle hierarchy support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 11f5b92..e15f731 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -303,6 +303,20 @@ struct blkcg_gq *__blkg_lookup(struct blkcg *blkcg, struct request_queue *q,
 					      (p_blkg)->q, false)))
 
 /**
+ * blkg_for_each_descendant_post - post-order walk of a blkg's descendants
+ * @d_blkg: loop cursor pointing to the current descendant
+ * @pos_cgrp: used for iteration
+ * @p_blkg: target blkg to walk descendants of
+ *
+ * Similar to blkg_for_each_descendant_pre() but performs post-order
+ * traversal instead.  Synchronization rules are the same.
+ */
+#define blkg_for_each_descendant_post(d_blkg, pos_cgrp, p_blkg)		\
+	cgroup_for_each_descendant_post((pos_cgrp), (p_blkg)->blkcg->css.cgroup) \
+		if (((d_blkg) = __blkg_lookup(cgroup_to_blkcg(pos_cgrp), \
+					      (p_blkg)->q, false)))
+
+/**
  * blk_get_rl - get request_list to use
  * @q: request_queue of interest
  * @bio: bio which will be attached to the allocated request (may be %NULL)
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab3FMEID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:08:03 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44118 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3FMEFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:05:04 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        koverstreet@google.com, linux-kernel@vger.kernel.org,
        cl@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/11] cgroup: remove now unused css_depth()
Date: Wed, 12 Jun 2013 21:04:48 -0700
Message-Id: <1371096298-24402-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371096298-24402-1-git-send-email-tj@kernel.org>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  1 -
 kernel/cgroup.c        | 12 ------------
 2 files changed, 13 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d0ad379..5830592 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -848,7 +848,6 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 
 /* Get id and depth of css */
 unsigned short css_id(struct cgroup_subsys_state *css);
-unsigned short css_depth(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 
 #else /* !CONFIG_CGROUPS */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3ad2a9c..dc8997a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5230,18 +5230,6 @@ unsigned short css_id(struct cgroup_subsys_state *css)
 }
 EXPORT_SYMBOL_GPL(css_id);
 
-unsigned short css_depth(struct cgroup_subsys_state *css)
-{
-	struct css_id *cssid;
-
-	cssid = rcu_dereference_check(css->id, css_refcnt(css));
-
-	if (cssid)
-		return cssid->depth;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(css_depth);
-
 /**
  *  css_is_ancestor - test "root" css is an ancestor of "child"
  * @child: the css to be tested.
-- 
1.8.2.1


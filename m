Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaCMTu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:50:28 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:42426 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbaCMTuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:50:24 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/11] cgroup: remove NULL checks from [pr_cont_]cgroup_{name|path}()
Date: Thu, 13 Mar 2014 15:50:07 -0400
Message-Id: <1394740213-17626-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394740213-17626-1-git-send-email-tj@kernel.org>
References: <1394740213-17626-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dummy hierarchy is now a fully functional one and dummy_top has a
kernfs_node associated with it.  Drop the NULL checks in
[pr_cont_]cont_{name|path}() which are no longer necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index acbb9a4..9f4f253 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -508,39 +508,23 @@ struct cgroup_subsys_state *seq_css(struct seq_file *seq);
 
 static inline int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen)
 {
-	/* dummy_top doesn't have a kn associated */
-	if (cgrp->kn)
-		return kernfs_name(cgrp->kn, buf, buflen);
-	else
-		return strlcpy(buf, "/", buflen);
+	return kernfs_name(cgrp->kn, buf, buflen);
 }
 
 static inline char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
 					      size_t buflen)
 {
-	/* dummy_top doesn't have a kn associated */
-	if (cgrp->kn)
-		return kernfs_path(cgrp->kn, buf, buflen);
-	strlcpy(buf, "/", buflen);
-	return (buflen <= 2) ? NULL : buf;
+	return kernfs_path(cgrp->kn, buf, buflen);
 }
 
 static inline void pr_cont_cgroup_name(struct cgroup *cgrp)
 {
-	/* dummy_top doesn't have a kn associated */
-	if (cgrp->kn)
-		pr_cont_kernfs_name(cgrp->kn);
-	else
-		pr_cont("/");
+	pr_cont_kernfs_name(cgrp->kn);
 }
 
 static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 {
-	/* dummy_top doesn't have a kn associated */
-	if (cgrp->kn)
-		pr_cont_kernfs_path(cgrp->kn);
-	else
-		pr_cont("/");
+	pr_cont_kernfs_path(cgrp->kn);
 }
 
 char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
-- 
1.8.5.3


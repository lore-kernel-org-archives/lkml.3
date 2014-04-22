Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaDVGam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:30:42 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:53413 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaDVGag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:30:36 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: tj@kernel.org, lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH 1/4] cgroup: introduce helper css_to_id()
Date: Tue, 22 Apr 2014 14:30:27 +0800
Message-Id: <0414ce4418a6f0dd481586ce4059b97800bcc1ca.1398147734.git.nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <cover.1398147734.git.nasa4836@gmail.com>
References: <cover.1398147734.git.nasa4836@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a prepared patch for converting from per-cgroup id to
per-subsystem id.

Some subsystems dereference the per-cgrpu id directly, but this is
implementation-specific, so it should be transparent for subsystems.

Use this accessor instead.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4b38e2d..de31b2a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -754,6 +754,7 @@ struct cgroup_subsys_state *css_next_child(struct cgroup_subsys_state *pos,
 					   struct cgroup_subsys_state *parent);
 
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
+int css_to_id(struct cgroup_subsys_state *css);
 
 /**
  * css_for_each_child - iterate through children of a css
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 930569c..80c1cf3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5153,6 +5153,17 @@ struct cgroup_subsys_state *css_tryget_from_dir(struct dentry *dentry,
 }
 
 /**
+ * css_to_id - get the id of a css
+ * @css: the css of interest
+ *
+ * Return the corresponding id for the @css.
+ */
+int css_to_id(struct cgroup_subsys_state *css)
+{
+	return css->cgroup->id;
+}
+
+/**
  * css_from_id - lookup css by id
  * @id: the cgroup id
  * @ss: cgroup subsys to be looked into
-- 
2.0.0-rc0


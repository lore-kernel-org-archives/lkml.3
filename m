Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaA2ACv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 19:02:51 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:54789 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbaA1X7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:59:53 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] cgroup: warn if "xattr" is specified with "sane_behavior"
Date: Tue, 28 Jan 2014 18:59:38 -0500
Message-Id: <1390953585-16554-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390953585-16554-1-git-send-email-tj@kernel.org>
References: <1390953585-16554-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mount option "xattr" is no longer necessary as it's enabled by default
on kernfs.  Warn if "xattr" is specified with "sane_behavior" so that
the option can be removed in the future.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 2 ++
 kernel/cgroup.c        | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b6c2652..6fe238e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -262,6 +262,8 @@ enum {
 	 * - "release_agent" and "notify_on_release" are removed.
 	 *   Replacement notification mechanism will be implemented.
 	 *
+	 * - "xattr" mount option is deprecated.  kernfs always enables it.
+	 *
 	 * - cpuset: tasks will be kept in empty cpusets when hotplug happens
 	 *   and take masks of ancestors with non-empty cpus/mems, instead of
 	 *   being moved to an ancestor.
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e60a5e3..056bd7d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1265,6 +1265,9 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			pr_err("cgroup: sane_behavior: clone_children is not allowed\n");
 			return -EINVAL;
 		}
+
+		if (opts->flags & CGRP_ROOT_XATTR)
+			pr_warning("cgroup: sane_behavior: xattr is always available, flag unnecessary\n");
 	}
 
 	/*
-- 
1.8.5.3


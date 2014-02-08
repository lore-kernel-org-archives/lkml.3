Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaBHQih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:38:37 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46674 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaBHQie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:38:34 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] cgroup: warn if "xattr" is specified with "sane_behavior"
Date: Sat,  8 Feb 2014 11:38:22 -0500
Message-Id: <1391877509-10855-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391877509-10855-1-git-send-email-tj@kernel.org>
References: <1391877509-10855-1-git-send-email-tj@kernel.org>
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
index 203438e..6b96516 100644
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


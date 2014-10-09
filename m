Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaJIVEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:04:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58945 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaJIVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alban Crequy <alban.crequy@collabora.co.uk>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 005/163] cgroup: reject cgroup names with '\n'
Date: Thu,  9 Oct 2014 14:00:30 -0700
Message-Id: <1412888588-26755-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Crequy <alban.crequy@collabora.co.uk>

commit 71b1fb5c4473a5b1e601d41b109bdfe001ec82e0 upstream.

/proc/<pid>/cgroup contains one cgroup path on each line. If cgroup names are
allowed to contain "\n", applications cannot parse /proc/<pid>/cgroup safely.

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ kamal: backport to 3.13-stable: fixed in cgroup_create() ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b44dd49..8e5e0a9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4350,6 +4350,11 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	struct cgroup_subsys *ss;
 	struct super_block *sb = root->sb;
 
+	/* Do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable.
+	 */
+	if (strchr(dentry->d_name.name, '\n'))
+		return -EINVAL;
+
 	/* allocate the cgroup and its ID, 0 is reserved for the root */
 	cgrp = kzalloc(sizeof(*cgrp), GFP_KERNEL);
 	if (!cgrp)
-- 
1.9.1


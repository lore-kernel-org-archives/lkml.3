Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaGBXqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 19:46:19 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35919 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaGBXqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 19:46:07 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] cgroup: make interface file "cgroup.sane_behavior" legacy-only
Date: Wed,  2 Jul 2014 19:45:45 -0400
Message-Id: <1404344747-7957-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404344747-7957-1-git-send-email-tj@kernel.org>
References: <1404344747-7957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"cgroup.sane_behavior" is added to help distinguishing whether
sane_behavior is in effect or not.  We now have the default hierarchy
where the flag is always in effect and are planning to remove
supporting sane behavior on the legacy hierarchies making this file on
the default hierarchy rather pointless.  Let's make it legacy only and
thus always zero.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e27f4d4..be701d9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2414,9 +2414,7 @@ static int cgroup_release_agent_show(struct seq_file *seq, void *v)
 
 static int cgroup_sane_behavior_show(struct seq_file *seq, void *v)
 {
-	struct cgroup *cgrp = seq_css(seq)->cgroup;
-
-	seq_printf(seq, "%d\n", cgroup_sane_behavior(cgrp));
+	seq_puts(seq, "0\n");
 	return 0;
 }
 
@@ -4016,7 +4014,7 @@ static struct cftype cgroup_base_files[] = {
 	},
 	{
 		.name = "cgroup.sane_behavior",
-		.flags = CFTYPE_ONLY_ON_ROOT,
+		.flags = CFTYPE_INSANE | CFTYPE_ONLY_ON_ROOT,
 		.seq_show = cgroup_sane_behavior_show,
 	},
 	{
-- 
1.9.3


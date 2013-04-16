Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936183Ab3DPUZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:25:21 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:58807 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3DPUZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:25:19 -0400
From: Rami Rosen <ramirose@gmail.com>
To: tj@kernel.org, lizefan@huawei.com, aris@redhat.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        Rami Rosen <ramirose@gmail.com>
Subject: [PATCH] devcg: remove parent_cgroup.
Date: Tue, 16 Apr 2013 23:24:55 +0300
Message-Id: <1366143895-21535-1-git-send-email-ramirose@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In devcgroup_css_alloc(), there is no longer need for parent_cgroup.
bd2953ebbb("devcg: propagate local changes down the hierarchy") made
the variable parent_cgroup redundant. This patch removes parent_cgroup
from devcgroup_css_alloc().

Signed-off-by: Rami Rosen <ramirose@gmail.com>
---
 security/device_cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 994aecc..dd0dc57 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -236,7 +236,6 @@ static void devcgroup_offline(struct cgroup *cgroup)
 static struct cgroup_subsys_state *devcgroup_css_alloc(struct cgroup *cgroup)
 {
 	struct dev_cgroup *dev_cgroup;
-	struct cgroup *parent_cgroup;
 
 	dev_cgroup = kzalloc(sizeof(*dev_cgroup), GFP_KERNEL);
 	if (!dev_cgroup)
@@ -244,7 +243,6 @@ static struct cgroup_subsys_state *devcgroup_css_alloc(struct cgroup *cgroup)
 	INIT_LIST_HEAD(&dev_cgroup->exceptions);
 	INIT_LIST_HEAD(&dev_cgroup->propagate_pending);
 	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;
-	parent_cgroup = cgroup->parent;
 
 	return &dev_cgroup->css;
 }
-- 
1.8.1.4


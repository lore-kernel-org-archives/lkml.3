Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3AZBcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:32:01 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34461 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3AZBbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:31:42 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [PATCH 13/14] cgroup: don't use idr_remove_all()
Date: Fri, 25 Jan 2013 17:31:11 -0800
Message-Id: <1359163872-1949-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359163872-1949-1-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org
Cc: cgroups@vger.kernel.org
---
This patch depends on an earlier idr patch and given the trivial
nature of the patch, I think it would be best to route these together
through -mm.  Please holler if there's any objection.

Thanks.

 kernel/cgroup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4855892..6b18c5c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4567,10 +4567,8 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	offline_css(ss, dummytop);
 	ss->active = 0;
 
-	if (ss->use_id) {
-		idr_remove_all(&ss->idr);
+	if (ss->use_id)
 		idr_destroy(&ss->idr);
-	}
 
 	/* deassign the subsys_id */
 	subsys[ss->subsys_id] = NULL;
-- 
1.8.1


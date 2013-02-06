Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab3BFTtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:49:53 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56772 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab3BFTto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:44 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: [PATCH 14/77] cgroup: don't use idr_remove_all()
Date: Wed,  6 Feb 2013 11:39:46 -0800
Message-Id: <1360179649-22465-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
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
 kernel/cgroup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 776ff75..525c508 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4582,10 +4582,8 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
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


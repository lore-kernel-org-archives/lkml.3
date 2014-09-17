Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaIQKUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:20:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:31980 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaIQKUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:20:12 -0400
Message-ID: <54195FFA.6050600@huawei.com>
Date: Wed, 17 Sep 2014 18:18:34 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] ccgroup: remove redundant code in cgroup_rmdir()
References: <54195FE1.9030607@huawei.com>
In-Reply-To: <54195FE1.9030607@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer clear kn->priv in cgroup_rmdir(), so we don't need
to get an extra refcnt.

Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/cgroup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0ce9d9e..26b8cb9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4841,13 +4841,10 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 	cgrp = cgroup_kn_lock_live(kn);
 	if (!cgrp)
 		return 0;
-	cgroup_get(cgrp);	/* for @kn->priv clearing */
 
 	ret = cgroup_destroy_locked(cgrp);
 
 	cgroup_kn_unlock(kn);
-
-	cgroup_put(cgrp);
 	return ret;
 }
 
-- 
1.8.0.2


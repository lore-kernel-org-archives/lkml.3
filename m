Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3AXGdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:33:36 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:27735 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3AXGd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:33:27 -0500
Message-ID: <5100D562.6050407@huawei.com>
Date: Thu, 24 Jan 2013 14:32:02 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 6/6] cgroup: remove bogus comments in cgroup_diput()
References: <5100D4FE.9080205@huawei.com>
In-Reply-To: <5100D4FE.9080205@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 48ddbe194623ae089cc0576e60363f2d2e85662a
("cgroup: make css->refcnt clearing on cgroup removal optional"),
each css holds a ref on cgroup's dentry, so cgroup_diput() won't be
called until all css' refs go down to 0, which invalids the comments.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f18b0d9..368cff1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -899,12 +899,6 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		struct cgroup *cgrp = dentry->d_fsdata;
 
 		BUG_ON(!(cgroup_is_removed(cgrp)));
-		/* It's possible for external users to be holding css
-		 * reference counts on a cgroup; css_put() needs to
-		 * be able to access the cgroup after decrementing
-		 * the reference count in order to know if it needs to
-		 * queue the cgroup to be handled by the release
-		 * agent */
 		call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
-- 
1.8.0.2

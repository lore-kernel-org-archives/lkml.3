Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3C2Gp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 02:45:29 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:43634 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab3C2GpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 02:45:17 -0400
Message-ID: <5155385A.4040207@huawei.com>
Date: Fri, 29 Mar 2013 14:44:42 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 5/5] cgroup: Kill subsys.active flag
References: <51553813.10004@huawei.com>
In-Reply-To: <51553813.10004@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user was cpuacct.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 1 -
 kernel/cgroup.c        | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 900af59..95c02c0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -458,7 +458,6 @@ struct cgroup_subsys {
 	void (*bind)(struct cgroup *root);
 
 	int subsys_id;
-	int active;
 	int disabled;
 	int early_init;
 	/*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f943..5c46281 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4468,7 +4468,6 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	 * need to invoke fork callbacks here. */
 	BUG_ON(!list_empty(&init_task.tasks));
 
-	ss->active = 1;
 	BUG_ON(online_css(ss, dummytop));
 
 	mutex_unlock(&cgroup_mutex);
@@ -4573,7 +4572,6 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	}
 	write_unlock(&css_set_lock);
 
-	ss->active = 1;
 	ret = online_css(ss, dummytop);
 	if (ret)
 		goto err_unload;
@@ -4614,7 +4612,6 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	mutex_lock(&cgroup_mutex);
 
 	offline_css(ss, dummytop);
-	ss->active = 0;
 
 	if (ss->use_id)
 		idr_destroy(&ss->idr);
-- 
1.8.0.2

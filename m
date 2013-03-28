Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3C1HWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:22:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44251 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3C1HW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:22:28 -0400
Message-ID: <5153EF8D.2080502@huawei.com>
Date: Thu, 28 Mar 2013 15:21:49 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 5/5] cgroup: Remove subsys.active flag
References: <5153EF24.3040608@huawei.com>
In-Reply-To: <5153EF24.3040608@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user was cpuacct.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 1 -
 kernel/cgroup.c        | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7d73905..a236a5b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -457,7 +457,6 @@ struct cgroup_subsys {
 	void (*bind)(struct cgroup *root);
 
 	int subsys_id;
-	int active;
 	int disabled;
 	int early_init;
 	/*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4855892..64dd57d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4415,7 +4415,6 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	 * need to invoke fork callbacks here. */
 	BUG_ON(!list_empty(&init_task.tasks));
 
-	ss->active = 1;
 	BUG_ON(online_css(ss, dummytop));
 
 	mutex_unlock(&cgroup_mutex);
@@ -4523,7 +4522,6 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	}
 	write_unlock(&css_set_lock);
 
-	ss->active = 1;
 	ret = online_css(ss, dummytop);
 	if (ret)
 		goto err_unload;
@@ -4565,7 +4563,6 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	mutex_lock(&cgroup_mutex);
 
 	offline_css(ss, dummytop);
-	ss->active = 0;
 
 	if (ss->use_id) {
 		idr_remove_all(&ss->idr);
-- 
1.8.0.2

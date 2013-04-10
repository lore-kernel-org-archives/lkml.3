Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936394Ab3DJNuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:50:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688Ab3DJNuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:50:00 -0400
Date: Wed, 10 Apr 2013 06:49:43 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-479f614110b889d5783acdaec865ede3cdb96b97@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
In-Reply-To: <5155385A.4040207@huawei.com>
References: <5155385A.4040207@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cgroup: Kill subsys.active flag
Git-Commit-ID: 479f614110b889d5783acdaec865ede3cdb96b97
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:49:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  479f614110b889d5783acdaec865ede3cdb96b97
Gitweb:     http://git.kernel.org/tip/479f614110b889d5783acdaec865ede3cdb96b97
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:44:42 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:22 +0200

cgroup: Kill subsys.active flag

The only user was cpuacct.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5155385A.4040207@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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

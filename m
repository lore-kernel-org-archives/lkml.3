Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab3AOQl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:41:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40719 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab3AOQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:41:25 -0500
Date: Tue, 15 Jan 2013 08:41:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/2] cpuset: drop spurious retval assignment in
 proc_cpuset_show()
Message-ID: <20130115164119.GD2668@htj.dyndns.org>
References: <50F4F2F1.8070107@huawei.com>
 <50F4F314.4040103@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F4F314.4040103@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d127027baf98dce3ca31bec18c2c0e048ceda7c4 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan@huawei.com>
Date: Tue, 15 Jan 2013 14:11:32 +0800

proc_cpuset_show() has a spurious -EINVAL assignment which does
nothing.  Remove it.

This patch doesn't make any functional difference.

tj: Rewrote patch description.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Ditto.  Thanks!

 kernel/cpuset.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1a675e4..16be7c9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2677,7 +2677,6 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 	if (!tsk)
 		goto out_free;
 
-	retval = -EINVAL;
 	rcu_read_lock();
 	css = task_subsys_state(tsk, cpuset_subsys_id);
 	retval = cgroup_path(css->cgroup, buf, PAGE_SIZE);
-- 
1.8.0.2


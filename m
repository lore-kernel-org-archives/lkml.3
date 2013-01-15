Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3AOGMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:12:44 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:47030 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3AOGMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:12:42 -0500
Message-ID: <50F4F314.4040103@huawei.com>
Date: Tue, 15 Jan 2013 14:11:32 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/2] cpuset: return the return value of cgroup_path() to userspace
References: <50F4F2F1.8070107@huawei.com>
In-Reply-To: <50F4F2F1.8070107@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-EINVAL is improper, as we don't accept user inputs.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
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


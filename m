Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab3AXGcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:32:50 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:31763 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3AXGcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:32:43 -0500
Message-ID: <5100D52F.4080703@huawei.com>
Date: Thu, 24 Jan 2013 14:31:11 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 3/6] sched: remove redundant NULL cgroup check in task_group_path()
References: <5100D4FE.9080205@huawei.com>
In-Reply-To: <5100D4FE.9080205@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A task_group won't be online (thus no one can see it) until
cpu_cgroup_css_online(), and at that time tg->css.cgroup has
been initialized, so this NULL check is redundant.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/debug.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2cd3c1b..38df0db 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -110,13 +110,6 @@ static char *task_group_path(struct task_group *tg)
 	if (autogroup_path(tg, group_path, PATH_MAX))
 		return group_path;
 
-	/*
-	 * May be NULL if the underlying cgroup isn't fully-created yet
-	 */
-	if (!tg->css.cgroup) {
-		group_path[0] = '\0';
-		return group_path;
-	}
 	cgroup_path(tg->css.cgroup, group_path, PATH_MAX);
 	return group_path;
 }
-- 
1.8.0.2

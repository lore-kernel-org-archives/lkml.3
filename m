Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3C2Gqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 02:46:35 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:55150 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3C2GqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 02:46:20 -0400
Message-ID: <5155383F.8000005@huawei.com>
Date: Fri, 29 Mar 2013 14:44:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 3/5] cpuacct: Initialize cpuacct subsystem earlier
References: <51553813.10004@huawei.com>
In-Reply-To: <51553813.10004@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize cpuacct before the scheduler is functioning, so when
cpuacct_charge() and cpuacct_account_field() are called, task_ca()
won't return NULL.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/cpuacct.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 0425581..75e46d2 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -292,9 +292,10 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 }
 
 struct cgroup_subsys cpuacct_subsys = {
-	.name = "cpuacct",
-	.css_alloc = cpuacct_css_alloc,
-	.css_free = cpuacct_css_free,
-	.subsys_id = cpuacct_subsys_id,
-	.base_cftypes = files,
+	.name		= "cpuacct",
+	.css_alloc	= cpuacct_css_alloc,
+	.css_free	= cpuacct_css_free,
+	.subsys_id	= cpuacct_subsys_id,
+	.base_cftypes	= files,
+	.early_init	= 1,
 };
-- 
1.8.0.2

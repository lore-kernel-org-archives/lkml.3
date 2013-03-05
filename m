Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3CEIGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:06:11 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:36171 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3CEIGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:06:07 -0500
Message-ID: <5135A748.3050206@huawei.com>
Date: Tue, 5 Mar 2013 16:05:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/9] sched: Remove some dummpy functions
References: <5135A736.8050104@huawei.com>
In-Reply-To: <5135A736.8050104@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one will call those functions if CONFIG_SCHED_DEBUG=n.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/sched.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..2715fbb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -127,18 +127,6 @@ extern void proc_sched_show_task(struct task_struct *p, struct seq_file *m);
 extern void proc_sched_set_task(struct task_struct *p);
 extern void
 print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq);
-#else
-static inline void
-proc_sched_show_task(struct task_struct *p, struct seq_file *m)
-{
-}
-static inline void proc_sched_set_task(struct task_struct *p)
-{
-}
-static inline void
-print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
-{
-}
 #endif
 
 /*
-- 
1.8.0.2

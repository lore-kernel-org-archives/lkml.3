Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbaDQCI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 22:08:56 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:5795 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaDQCIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 22:08:54 -0400
Message-ID: <534F36CE.2000409@huawei.com>
Date: Thu, 17 Apr 2014 10:05:02 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched/deadline: Fix memory leak
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free cpudl->free_cpus allocated in cpudl_init().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: <stable@vger.kernel.org> # 3.14
---
 kernel/sched/cpudeadline.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 5b9bb42..ab001b5 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -210,7 +210,5 @@ int cpudl_init(struct cpudl *cp)
  */
 void cpudl_cleanup(struct cpudl *cp)
 {
-	/*
-	 * nothing to do for the moment
-	 */
+	free_cpumask_var(cp->free_cpus);
 }
-- 
1.8.0.2


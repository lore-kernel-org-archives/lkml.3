Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3CEIGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:06:35 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:36385 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3CEIGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:06:33 -0500
Message-ID: <5135A75F.4070202@huawei.com>
Date: Tue, 5 Mar 2013 16:05:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/9] sched: Remove test_sd_parent()
References: <5135A736.8050104@huawei.com>
In-Reply-To: <5135A736.8050104@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unused.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/sched.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2715fbb..e880d7d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -959,15 +959,6 @@ extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 cpumask_var_t *alloc_sched_domains(unsigned int ndoms);
 void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
 
-/* Test a flag in parent sched domain */
-static inline int test_sd_parent(struct sched_domain *sd, int flag)
-{
-	if (sd->parent && (sd->parent->flags & flag))
-		return 1;
-
-	return 0;
-}
-
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
 unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
 
-- 
1.8.0.2

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaKDQLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:11:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59495 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaKDQLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:11:20 -0500
Date: Tue, 4 Nov 2014 08:10:12 -0800
From: tip-bot for Yao Dongdong <tipbot@zytor.com>
Message-ID: <tip-9f96742a13135e6c609cc99a3a458402af3c8f31@git.kernel.org>
Cc: tglx@linutronix.de, hpa@zytor.com, torvalds@linux-foundation.org,
        mingo@kernel.org, peterz@infradead.org, yaodongdong@huawei.com,
        srikar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Reply-To: peterz@infradead.org, srikar@linux.vnet.ibm.com,
        yaodongdong@huawei.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <1414469286-6023-1-git-send-email-yaodongdong@huawei.com>
References: <1414469286-6023-1-git-send-email-yaodongdong@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Check if we got a shallowest_idle_cpu before searching for least_loaded_cpu
Git-Commit-ID: 9f96742a13135e6c609cc99a3a458402af3c8f31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f96742a13135e6c609cc99a3a458402af3c8f31
Gitweb:     http://git.kernel.org/tip/9f96742a13135e6c609cc99a3a458402af3c8f31
Author:     Yao Dongdong <yaodongdong@huawei.com>
AuthorDate: Tue, 28 Oct 2014 04:08:06 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:51 +0100

sched: Check if we got a shallowest_idle_cpu before searching for least_loaded_cpu

Idle cpu is idler than non-idle cpu, so we needn't search for least_loaded_cpu
after we have found an idle cpu.

Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414469286-6023-1-git-send-email-yaodongdong@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ec32c26d..d03d76d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4641,7 +4641,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 				latest_idle_timestamp = rq->idle_stamp;
 				shallowest_idle_cpu = i;
 			}
-		} else {
+		} else if (shallowest_idle_cpu == -1) {
 			load = weighted_cpuload(i);
 			if (load < min_load || (load == min_load && i == this_cpu)) {
 				min_load = load;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3LRKf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:35:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3LRKeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:34:03 -0500
Date: Wed, 18 Dec 2013 02:33:07 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-82897b4fd3920ffd2456731d4f2ae1406558ef4c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        liwanp@linux.vnet.ibm.com, peterz@infradead.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        liwanp@linux.vnet.ibm.com, peterz@infradead.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, rientjes@google.com
In-Reply-To: <1386833006-6600-3-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386833006-6600-3-git-send-email-liwanp@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Use wrapper function task_faults_idx to calculate index in group_faults
Git-Commit-ID: 82897b4fd3920ffd2456731d4f2ae1406558ef4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:33:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82897b4fd3920ffd2456731d4f2ae1406558ef4c
Gitweb:     http://git.kernel.org/tip/82897b4fd3920ffd2456731d4f2ae1406558ef4c
Author:     Wanpeng Li <liwanp@linux.vnet.ibm.com>
AuthorDate: Thu, 12 Dec 2013 15:23:25 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:24:40 +0100

sched/numa: Use wrapper function task_faults_idx to calculate index in group_faults

Use wrapper function task_faults_idx to calculate index in group_faults.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/r/1386833006-6600-3-git-send-email-liwanp@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ebdb08b..37892d7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -921,7 +921,8 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
 	if (!p->numa_group)
 		return 0;
 
-	return p->numa_group->faults[2*nid] + p->numa_group->faults[2*nid+1];
+	return p->numa_group->faults[task_faults_idx(nid, 0)] +
+		p->numa_group->faults[task_faults_idx(nid, 1)];
 }
 
 /*

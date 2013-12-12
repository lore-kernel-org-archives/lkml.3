Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab3LLHYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:24:06 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56157 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3LLHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:24:02 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v8 3/4] sched/numa: use wrapper function task_faults_idx to calculate index in group_faults
Date: Thu, 12 Dec 2013 15:23:25 +0800
Message-Id: <1386833006-6600-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386833006-6600-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386833006-6600-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121207-3568-0000-0000-000004AD4C42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use wrapper function task_faults_idx to calculate index in group_faults.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c3f6ff9..8a00879 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -935,7 +935,8 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
 	if (!p->numa_group)
 		return 0;
 
-	return p->numa_group->faults[2*nid] + p->numa_group->faults[2*nid+1];
+	return p->numa_group->faults[task_faults_idx(nid, 0)] +
+		p->numa_group->faults[task_faults_idx(nid, 1)];
 }
 
 /*
-- 
1.7.7.6


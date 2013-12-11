Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3LKAuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:50:14 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:41919 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3LKAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:50:11 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v5 0/8] mm: sched: numa: several fixups
Date: Wed, 11 Dec 2013 08:49:53 +0800
Message-Id: <1386723001-25408-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121100-2674-0000-0000-00000BD7F572
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I rebase this patchset against latest mmotm tree since Mel's [PATCH 00/17] 
NUMA balancing segmentation fault fixes and misc followups v4 merged. Several 
patches are dropped in my v5 since one is merged in tip tree and other three 
patches conflict with Mel's series. I have already picked up everybody's Acked-by
or Reviewed-by in v5 and hopefully they can be merged soon. ;-)

Wanpeng Li (8):
  sched/numa: fix set cpupid on page migration twice against thp
  sched/numa: drop sysctl_numa_balancing_settle_count sysctl
  sched/numa: use wrapper function task_node to get node which task is on
  sched/numa: fix set cpupid on page migration twice against normal page
  sched/numa: use wrapper function task_faults_idx to calculate index in group_faults
  sched/numa: fix period_slot recalculation
  sched/numa: fix record hinting faults check
  sched/numa: drop unnecessary variable in task_weight

 include/linux/sched/sysctl.h |    1 -
 kernel/sched/debug.c         |    2 +-
 kernel/sched/fair.c          |   30 +++++++-----------------------
 kernel/sysctl.c              |    7 -------
 mm/migrate.c                 |    4 ----
 5 files changed, 8 insertions(+), 36 deletions(-)

-- 
1.7.7.6


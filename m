Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3LKKQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:16:30 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56472 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3LKKQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:16:26 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v6 0/6] mm: sched: numa: several fixups
Date: Wed, 11 Dec 2013 18:15:55 +0800
Message-Id: <1386756961-3887-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121110-3864-0000-0000-00000B780AF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I rebase this patchset against latest mmotm tree since Mel's [PATCH 00/17]
NUMA balancing segmentation fault fixes and misc followups v4 merged. Several
patches are dropped in my v6 since one is merged in tip tree and other three
patches conflict with Mel's series. I have already picked up everybody's Acked-by
or Reviewed-by in v6 and hopefully they can be merged soon. ;-)

Wanpeng Li (6):
  sched/numa: fix set cpupid on page migration twice against thp
  sched/numa: drop sysctl_numa_balancing_settle_count sysctl
  sched/numa: use wrapper function task_node to get node which task is on
  sched/numa: fix set cpupid on page migration twice against normal page
  sched/numa: use wrapper function task_faults_idx to calculate index in group_faults
  sched/numa: fix period_slot recalculation

 include/linux/sched/sysctl.h |    1 -
 kernel/sched/debug.c         |    2 +-
 kernel/sched/fair.c          |   17 ++++-------------
 kernel/sysctl.c              |    7 -------
 mm/migrate.c                 |    4 ----
 5 files changed, 5 insertions(+), 26 deletions(-)

-- 
1.7.5.4


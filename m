Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3BNFst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:48:49 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55486 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3BNFss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:48:48 -0500
X-AuditID: 9c93016f-b7b1fae000006419-0e-511c7abd261f
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 0/8] correct load_balance()
Date: Thu, 14 Feb 2013 14:48:33 +0900
Message-Id: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 88b8dac0 makes load_balance() consider other cpus in its group.
But, there are some missing parts for this feature to work properly.
This patchset correct these things and make load_balance() robust.

Others are related to LBF_ALL_PINNED. This is fallback functionality
when all tasks can't be moved as cpu affinity. But, currently,
if imbalance is not large enough to task's load, we leave LBF_ALL_PINNED
flag and 'redo' is triggered. This is not our intention, so correct it.

These are based on v3.8-rc7.

Joonsoo Kim (8):
  sched: change position of resched_cpu() in load_balance()
  sched: explicitly cpu_idle_type checking in rebalance_domains()
  sched: don't consider other cpus in our group in case of NEWLY_IDLE
  sched: clean up move_task() and move_one_task()
  sched: move up affinity check to mitigate useless redoing overhead
  sched: rename load_balance_tmpmask to load_balance_cpu_active
  sched: prevent to re-select dst-cpu in load_balance()
  sched: reset lb_env when redo in load_balance()

 kernel/sched/core.c |    9 +++--
 kernel/sched/fair.c |  107 +++++++++++++++++++++++++++++----------------------
 2 files changed, 67 insertions(+), 49 deletions(-)

-- 
1.7.9.5


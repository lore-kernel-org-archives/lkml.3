Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925Ab3CZGA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:00:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59821 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3CZGA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:00:57 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-4c-515139974843
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 0/6] correct load_balance()
Date: Tue, 26 Mar 2013 15:01:34 +0900
Message-Id: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
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

These are based on v3.9-rc4.

Changelog
v1->v2: Changes from Peter's suggestion
 [4/6]: don't include a code to evaluate load value in can_migrate_task()
 [5/6]: rename load_balance_tmpmask to load_balance_mask
 [6/6]: not use one more cpumasks, use env's cpus for prevent to re-select

Joonsoo Kim (6):
  sched: change position of resched_cpu() in load_balance()
  sched: explicitly cpu_idle_type checking in rebalance_domains()
  sched: don't consider other cpus in our group in case of NEWLY_IDLE
  sched: move up affinity check to mitigate useless redoing overhead
  sched: rename load_balance_tmpmask to load_balance_mask
  sched: prevent to re-select dst-cpu in load_balance()

 kernel/sched/core.c |    4 +--
 kernel/sched/fair.c |   67 +++++++++++++++++++++++++++------------------------
 2 files changed, 38 insertions(+), 33 deletions(-)

-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab3BSSOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:14:03 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:36030 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3BSSOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:14:01 -0500
Date: Tue, 19 Feb 2013 10:13:56 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL UPDATED] workqueue core changes for 3.9-rc1
Message-ID: <20130219181356.GP17414@htj.dyndns.org>
References: <20130219173937.GM17414@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219173937.GM17414@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again, Linus.

wq/for-3.8-fixes contained one commit to drop _GPL from
delayed_work_timer_fn() export (a regression which prevents
out-of-kernel users from using delayed_work) which didn't get pushed
out and I forgot to cherry pick it.

Everything else is the same other than one more commit at the top -
1438ade567 ("workqueue: un-GPL function delayed_work_timer_fn()").

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git 

for you to fetch changes up to 1438ade5670b56d5386c220e1ad4b5a824a1e585:

  workqueue: un-GPL function delayed_work_timer_fn() (2013-02-19 10:09:13 -0800)

----------------------------------------------------------------
Konstantin Khlebnikov (1):
      workqueue: un-GPL function delayed_work_timer_fn()

Lai Jiangshan (7):
      workqueue: replace WORK_CPU_NONE/LAST with WORK_CPU_END
      workqueue: make work_busy() test WORK_STRUCT_PENDING first
      workqueue: add delayed_work->wq to simplify reentrancy handling
      workqueue: make work->data point to pool after try_to_grab_pending()
      workqueue: simplify is-work-item-queued-here test
      workqueue: make get_work_pool_id() cheaper
      workqueue: pick cwq instead of pool in __queue_work()

Sasha Levin (1):
      workqueue: use new hashtable implementation

Tejun Heo (28):
      workqueue: consider work function when searching for busy work items
      workqueue: fix find_worker_executing_work() brekage from hashtable conversion
      workqueue: set PF_WQ_WORKER on rescuers
      workqueue: rename kernel/workqueue_sched.h to kernel/workqueue_internal.h
      workqueue: move struct worker definition to workqueue_internal.h
      workqueue: implement current_is_async()
      workqueue: unexport work_cpu()
      workqueue: use std_ prefix for the standard per-cpu pools
      workqueue: make GCWQ_DISASSOCIATED a pool flag
      workqueue: make GCWQ_FREEZING a pool flag
      workqueue: introduce WORK_OFFQ_CPU_NONE
      workqueue: add worker_pool->id
      workqueue: record pool ID instead of CPU in work->data when off-queue
      workqueue: move busy_hash from global_cwq to worker_pool
      workqueue: move global_cwq->cpu to worker_pool
      workqueue: move global_cwq->lock to worker_pool
      workqueue: make hotplug processing per-pool
      workqueue: make freezing/thawing per-pool
      workqueue: replace for_each_worker_pool() with for_each_std_worker_pool()
      workqueue: remove worker_pool->gcwq
      workqueue: remove global_cwq
      workqueue: rename nr_running variables
      workqueue: post global_cwq removal cleanups
      workqueue: cosmetic update in try_to_grab_pending()
      workqueue: move nr_running into worker_pool
      workqueue: fix is_chained_work() regression
      workqueue: reimplement is_chained_work() using current_wq_worker()
      workqueue: rename cpu_workqueue to pool_workqueue

 include/linux/async.h            |    1 +
 include/linux/workqueue.h        |   35 +-
 include/trace/events/workqueue.h |   10 +-
 kernel/async.c                   |   14 +
 kernel/sched/core.c              |    2 +-
 kernel/workqueue.c               | 1530 ++++++++++++++++++--------------------
 kernel/workqueue_internal.h      |   65 ++
 kernel/workqueue_sched.h         |    9 -
 8 files changed, 818 insertions(+), 848 deletions(-)
 create mode 100644 kernel/workqueue_internal.h
 delete mode 100644 kernel/workqueue_sched.h

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaHDN44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:56:56 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:65269 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaHDN4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:56:54 -0400
Date: Mon, 4 Aug 2014 09:56:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] workqueue changes for v3.17-rc1
Message-ID: <20140804135651.GA26230@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Lai has been doing a lot of cleanups of workqueue and kthread_work.
No significant behavior change.  Just a lot of cleanups all over the
place.  Some are a bit invasive but overall nothing too dangerous.

Thanks.

The following changes since commit ebe06187bf2aec10d537ce4595e416035367d703:

  epoll: fix use-after-free in eventpoll_release_file (2014-06-16 17:21:59 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.17

for you to fetch changes up to 95847e1bd34c0de86039408b24a05f07e788061d:

  kthread_work: remove the unused wait_queue_head (2014-07-28 14:16:30 -0400)

----------------------------------------------------------------
Lai Jiangshan (20):
      workqueue: use "pool->cpu < 0" to stand for an unbound pool
      workqueue: remove the empty check in too_many_workers()
      workqueue: use schedule_timeout_interruptible() instead of open code
      workqueue: remove useless WARN_ON_ONCE()
      workqueue: clear leftover flags when detached
      workqueue: sanity check pool->cpu in wq_worker_sleeping()
      workqueue: clear POOL_DISASSOCIATED in rebind_workers()
      workqueue: stronger test in process_one_work()
      workqueue: reuse the already calculated pwq in try_to_grab_pending()
      workqueue: alloc struct worker on its local node
      workqueue: wake regular worker if need_more_worker() when rescuer leave the pool
      workqueue: remove an unneeded UNBOUND test before waking up the next worker
      workqueue: remove @wakeup from worker_set_flags()
      workqueue: unfold start_worker() into create_worker()
      workqueue: move rescuer pool detachment to the end
      workqueue: remove the stale comment in pwq_unbound_release_workfn()
      workqueue: remove the misnamed out_unlock label in get_unbound_pool()
      workqueue: use nr_node_ids instead of wq_numa_tbl_len
      kthread_work: wake up worker only when the worker is idle
      kthread_work: remove the unused wait_queue_head

 include/linux/kthread.h |  13 +---
 kernel/kthread.c        |   2 +-
 kernel/workqueue.c      | 200 +++++++++++++++---------------------------------
 3 files changed, 64 insertions(+), 151 deletions(-)

-- 
tejun

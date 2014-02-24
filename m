Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaBXPkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:40:10 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61792 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaBXPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:08 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>,
        Don Zickus <dzickus@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 00/11] smp: Single IPI cleanups v2
Date: Mon, 24 Feb 2014 16:39:51 +0100
Message-Id: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This version includes:

* Rename __smp_call_function_single to smp_call_function_single() as
  suggested by Christoph.
  
* Acks and reviewed-by added.

* Rebase against -rc4

Thanks.

---
Frederic Weisbecker (6):
  block: Remove useless IPI struct initialization
  smp: Consolidate the various smp_call_function_single() declensions
  smp: Move __smp_call_function_single() below its safe version
  watchdog: Simplify a little the IPI call
  smp: Remove wait argument from __smp_call_function_single()
  smp: Rename __smp_call_function_single() to
    smp_call_function_single_async()

Jan Kara (5):
  block: Stop abusing csd.list for fifo_time
  block: Stop abusing rq->csd.list in blk-softirq
  smp: Iterate functions through llist_for_each_entry_safe()
  smp: Remove unused list_head from csd
  smp: Teach __smp_call_function_single() to check for offline cpus

 block/blk-mq.c            |   2 +-
 block/blk-softirq.c       |  19 ++++---
 block/cfq-iosched.c       |   8 +--
 block/deadline-iosched.c  |   8 +--
 drivers/cpuidle/coupled.c |   2 +-
 include/linux/blkdev.h    |   1 +
 include/linux/elevator.h  |  11 +---
 include/linux/smp.h       |   8 +--
 kernel/sched/core.c       |   2 +-
 kernel/smp.c              | 139 ++++++++++++++++++++++------------------------
 kernel/up.c               |   6 +-
 kernel/watchdog.c         |   3 +-
 net/core/dev.c            |   4 +-
 13 files changed, 98 insertions(+), 115 deletions(-)

-- 
1.8.3.1


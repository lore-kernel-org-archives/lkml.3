Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaBHQSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:18:49 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:33989 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaBHQSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:18:47 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
        Don Zickus <dzickus@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 00/11] smp: Single IPI cleanups
Date: Sat,  8 Feb 2014 17:18:29 +0100
Message-Id: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a batch of cleanups on the generic single IPI code. I've
gathered a few patches from Jan, split up some, and added a few more
so that __smp_call_function_single() becomes less obscure.

Comments?

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	core/ipi-rfc

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      block: Remove useless IPI struct initialization
      smp: Consolidate the various smp_call_function_single() declensions
      smp: Move __smp_call_function_single() below its safe version
      watchdog: Simplify a little the IPI call
      smp: Remove wait argument from __smp_call_function_single()
      smp: Enhance and precise the role & requirements of __smp_call_function_single()

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
 drivers/block/null_blk.c  |   2 +-
 drivers/cpuidle/coupled.c |   2 +-
 include/linux/blkdev.h    |   1 +
 include/linux/elevator.h  |  11 +---
 include/linux/smp.h       |   8 +--
 kernel/sched/core.c       |   2 +-
 kernel/smp.c              | 139 ++++++++++++++++++++++------------------------
 kernel/up.c               |   4 +-
 kernel/watchdog.c         |   3 +-
 net/core/dev.c            |   2 +-
 14 files changed, 97 insertions(+), 114 deletions(-)

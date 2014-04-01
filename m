Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaDATFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:05:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45591 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbaDATFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:05:04 -0400
Date: Tue, 1 Apr 2014 13:05:02 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linuxpatches@star.c10r.facebook.com>
Subject: [GIT PULL] Core block IO bits for 3.15-rc
Message-ID: <20140401190502.GA30970@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-01_06:2014-04-01,2014-04-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.82000525761339e-11 kscore.compositescore=0
 circleOfTrustscore=7.0302659978126 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404010100
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the pull request for the core block IO bits for the 3.15 kernel.
It's a smaller round this time, it contains:

- Various little blk-mq fixes and additions from Christoph and myself.

- Cleanup of the IPI usage from the block layer, and associated helper
  code. From Frederic Weisbecker and Jan Kara.

- Duplicate code cleanup in bio-integrity from Gu Zheng. This will give
  you a merge conflict, but that should be easy to resolve.

- blk-mq notify spinlock fix for RT from Mike Galbraith.

- A blktrace partial accounting bug fix from Roman Pen.

- Missing REQ_SYNC detection fix for blk-mq from Shaohua Li.


Please pull!


  git://git.kernel.dk/linux-block.git for-3.15/core

for you to fetch changes up to 27fbf4e87c16bb3e40730890169a643a494b7c64:

  blk-mq: add REQ_SYNC early (2014-03-21 08:57:58 -0600)

----------------------------------------------------------------
Christoph Hellwig (3):
      blk-mq: remove blk_mq_alloc_rq
      blk-mq: merge blk_mq_insert_request and blk_mq_run_request
      blk-mq: support partial I/O completions

Frederic Weisbecker (6):
      block: Remove useless IPI struct initialization
      smp: Consolidate the various smp_call_function_single() declensions
      smp: Move __smp_call_function_single() below its safe version
      watchdog: Simplify a little the IPI call
      smp: Remove wait argument from __smp_call_function_single()
      smp: Rename __smp_call_function_single() to smp_call_function_single_async()

Gideon Israel Dsouza (1):
      block: Use macros from compiler.h instead of __attribute__((...))

Gu Zheng (1):
      fs/bio-integrity: remove duplicate code

Jan Kara (5):
      block: Stop abusing csd.list for fifo_time
      block: Stop abusing rq->csd.list in blk-softirq
      smp: Iterate functions through llist_for_each_entry_safe()
      smp: Remove unused list_head from csd
      smp: Teach __smp_call_function_single() to check for offline cpus

Jens Axboe (4):
      block: remove old blk_iopoll_enabled variable
      blk-mq: allow blk_mq_init_commands() to return failure
      blk-mq: fix wrong usage of hctx->state vs hctx->flags
      blk-mq: don't dump CPU -> hw queue map on driver load

Mike Galbraith (1):
      rt,blk,mq: Make blk_mq_cpu_notify_lock a raw spinlock

Mikulas Patocka (1):
      bio: don't write "bio: create slab" messages to syslog

Paul E. McKenney (1):
      block: Substitute rcu_access_pointer() for rcu_dereference_raw()

Roman Pen (1):
      blktrace: fix accounting of partially completed requests

Shaohua Li (1):
      blk-mq: add REQ_SYNC early

 block/blk-cgroup.c              |   2 +-
 block/blk-core.c                |   2 +-
 block/blk-exec.c                |   2 +-
 block/blk-flush.c               |   4 +-
 block/blk-ioc.c                 |   2 +-
 block/blk-iopoll.c              |   3 -
 block/blk-mq-cpu.c              |  14 +--
 block/blk-mq-cpumap.c           |  10 --
 block/blk-mq-sysfs.c            |  31 ++++++
 block/blk-mq.c                  | 172 +++++++++++++++------------------
 block/blk-mq.h                  |   3 +-
 block/blk-softirq.c             |  19 ++--
 block/cfq-iosched.c             |   8 +-
 block/deadline-iosched.c        |   8 +-
 block/partitions/atari.h        |   4 +-
 block/partitions/efi.h          |   9 +-
 block/partitions/karma.c        |   3 +-
 drivers/block/virtio_blk.c      |   3 +-
 drivers/cpuidle/coupled.c       |   2 +-
 drivers/scsi/be2iscsi/be_main.c | 206 ++++++++++++----------------------------
 drivers/scsi/ipr.c              |  15 +--
 fs/bio-integrity.c              |  86 ++++++++---------
 fs/bio.c                        |   1 -
 include/linux/blk-iopoll.h      |   2 -
 include/linux/blk-mq.h          |   8 +-
 include/linux/blkdev.h          |   1 +
 include/linux/elevator.h        |  11 +--
 include/linux/smp.h             |   8 +-
 include/trace/events/block.h    |  33 ++++++-
 kernel/sched/core.c             |   2 +-
 kernel/smp.c                    | 139 +++++++++++++--------------
 kernel/sysctl.c                 |  12 ---
 kernel/trace/blktrace.c         |  20 ++--
 kernel/up.c                     |   6 +-
 kernel/watchdog.c               |   3 +-
 net/core/dev.c                  |   4 +-
 36 files changed, 383 insertions(+), 475 deletions(-)

-- 
Jens Axboe


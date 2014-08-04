Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaHDOEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:04:06 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52513 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaHDOEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:04:04 -0400
Date: Mon, 4 Aug 2014 10:04:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] percpu changes for v3.17-rc1
Message-ID: <20140804140400.GB26230@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

* Major reorganization of percpu header files which I think makes
  things a lot more readable and logical than before.

* percpu-refcount is updated so that it requires explicit destruction
  and can be reinitialized if necessary.  This was pulled into the
  block tree to replace the custom percpu refcnting implemented in
  blk-mq.

* In the process, percpu and percpu-refcount got cleaned up a bit.

This pull request contains two stray workqueue commits from Lai.
These are my mistakes.  I mistakenly applied the two to this tree and
then cherry picked them to the workqueue tree but forgot to roll them
back from this one.  I realized this only after percpu-refcount
changes were pulled into the block tree so couldn't fix it up
afterwards.  Sorry.  They shouldn't cause any problem during merge.

Thanks.

The following changes since commit ebe06187bf2aec10d537ce4595e416035367d703:

  epoll: fix use-after-free in eventpoll_release_file (2014-06-16 17:21:59 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.17

for you to fetch changes up to 2d7227828e1475c7b272e55bd70c4cec8eea219a:

  percpu-refcount: implement percpu_ref_reinit() and percpu_ref_is_zero() (2014-06-28 08:10:14 -0400)

----------------------------------------------------------------
Christoph Lameter (1):
      percpu: Use ALIGN macro instead of hand coding alignment calculation

Lai Jiangshan (2):
      workqueue: clear POOL_DISASSOCIATED in rebind_workers()
      workqueue: stronger test in process_one_work()

Tejun Heo (18):
      percpu: disallow archs from overriding SHIFT_PERCPU_PTR()
      percpu: introduce arch_raw_cpu_ptr()
      percpu: include/asm-generic/percpu.h should contain only arch-overridable parts
      percpu: move accessors from include/linux/percpu.h to percpu-defs.h
      percpu: reorganize include/linux/percpu-defs.h
      percpu: only allow sized arch overrides for {raw|this}_cpu_*() ops
      percpu: move generic {raw|this}_cpu_*_N() definitions to include/asm-generic/percpu.h
      percpu: move {raw|this}_cpu_*() definitions to include/linux/percpu-defs.h
      percpu: reorder macros in percpu header files
      percpu: use raw_cpu_*() to define __this_cpu_*()
      percpu: preffity percpu header files
      percpu: invoke __verify_pcpu_ptr() from the generic part of accessors and operations
      percpu-refcount, aio: use percpu_ref_cancel_init() in ioctx_alloc()
      percpu-refcount: one bit is enough for REF_STATUS
      percpu-refcount: add helpers for ->percpu_count accesses
      percpu-refcount: use unsigned long for pcpu_count pointer
      percpu-refcount: require percpu_ref to be exited explicitly
      percpu-refcount: implement percpu_ref_reinit() and percpu_ref_is_zero()

 arch/x86/include/asm/percpu.h    |   3 +-
 drivers/target/target_core_tpg.c |   4 +-
 fs/aio.c                         |   6 +-
 include/asm-generic/percpu.h     | 410 ++++++++++++++++++++----
 include/linux/percpu-defs.h      | 380 +++++++++++++++++++++-
 include/linux/percpu-refcount.h  |  64 ++--
 include/linux/percpu.h           | 673 ---------------------------------------
 kernel/cgroup.c                  |   8 +-
 kernel/workqueue.c               |  19 +-
 lib/percpu-refcount.c            |  86 +++--
 mm/percpu.c                      |   3 +-
 11 files changed, 834 insertions(+), 822 deletions(-)

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaBRWpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:45:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaBRWpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:45:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, lizefan@huawei.com
Subject: [PATCH 3.4 00/24] 3.4.81-stable review
Date: Tue, 18 Feb 2014 14:46:47 -0800
Message-Id: <20140218224550.221535225@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many thanks to Li Zefan for digging up a bunch of these patches, that
work is much appreciated.

This is the start of the stable review cycle for the 3.4.81 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 20 22:45:38 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.81-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.81-rc1

Jeff Layton <jlayton@redhat.com>
    nfs: tear down caches in nfs_init_writepagecache when allocation fails

Dan Rosenberg <drosenberg@vsecurity.com>
    lib/vsprintf.c: kptr_restrict: fix pK-error in SysRq show-all-timers(Q)

Asias He <asias@redhat.com>
    virtio-blk: Use block layer provided spinlock

Seth Forshee <seth.forshee@canonical.com>
    Input: synaptics - handle out of bounds values from the hardware

Bojan Smojver <bojan@rexursive.com>
    PM / Hibernate: Hibernate/thaw fixes/improvements

Avi Kivity <avi@redhat.com>
    KVM: Fix buffer overflow in kvm_set_irq()

Nicholas Bellinger <nab@linux-iscsi.org>
    target/file: Re-enable optional fd_buffered_io=1 operation

Nicholas Bellinger <nab@linux-iscsi.org>
    target/file: Use O_DSYNC by default for FILEIO backends

Jan Kara <jack@suse.cz>
    IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()

Peter Zijlstra <a.p.zijlstra@chello.nl>
    sched/nohz: Fix rq->cpu_load calculations some more

Peter Zijlstra <a.p.zijlstra@chello.nl>
    sched/nohz: Fix rq->cpu_load[] calculations

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Have function graph only trace based on global_ops filters

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Fix synchronization location disabling and freeing ftrace_ops

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Synchronize setting function_trace_op with ftrace_trace_function

Mikulas Patocka <mpatocka@redhat.com>
    dm sysfs: fix a module unload race

Xishi Qiu <qiuxishi@huawei.com>
    mm: setup pageblock_order before it's used by sparsemem

Andrew Morton <akpm@linux-foundation.org>
    mm/page_alloc.c: remove pageblock_default_order()

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: kick any firmware framebuffers before claiming the gtt

Tao Ma <boyu.mt@taobao.com>
    ext4: protect group inode free counting with group lock

Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    printk: Fix scheduling-while-atomic problem in console_cpu_notify()

Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
    x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of spin_lock_irq()

Stephen Smalley <sds@tycho.nsa.gov>
    SELinux: Fix kernel BUG on empty security contexts.


-------------

Diffstat:

 Makefile                                  |   4 +-
 drivers/block/virtio_blk.c                |   9 +--
 drivers/gpu/drm/i915/i915_dma.c           |  37 ++++++++--
 drivers/infiniband/hw/qib/qib_user_sdma.c |   6 +-
 drivers/input/mouse/synaptics.c           |  23 ++++++
 drivers/md/Kconfig                        |   4 ++
 drivers/md/Makefile                       |   1 +
 drivers/md/dm-builtin.c                   |  50 +++++++++++++
 drivers/md/dm-sysfs.c                     |   5 --
 drivers/md/dm.c                           |  26 ++-----
 drivers/md/dm.h                           |  17 ++++-
 drivers/target/target_core_file.c         |  81 ++++++++++-----------
 drivers/target/target_core_file.h         |   2 +-
 fs/buffer.c                               |   6 +-
 fs/ext4/ialloc.c                          |   4 +-
 fs/nfs/write.c                            |  10 ++-
 include/linux/sched.h                     |   1 +
 kernel/power/swap.c                       |  62 +++++++++++------
 kernel/printk.c                           |   1 -
 kernel/sched/core.c                       |  86 +++++++++++++++++++----
 kernel/sched/fair.c                       |   2 +-
 kernel/sched/sched.h                      |   2 +-
 kernel/time/tick-sched.c                  |   1 +
 kernel/trace/ftrace.c                     | 112 +++++++++++++++++++++++++-----
 lib/Makefile                              |   1 +
 lib/vsprintf.c                            |   3 +-
 mm/internal.h                             |   2 +
 mm/page-writeback.c                       |   5 +-
 mm/page_alloc.c                           |  33 ++++-----
 mm/sparse.c                               |   3 +
 security/selinux/ss/services.c            |   4 ++
 virt/kvm/irq_comm.c                       |   1 +
 32 files changed, 426 insertions(+), 178 deletions(-)



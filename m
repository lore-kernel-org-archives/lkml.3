Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3CATqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3CATqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/30] 3.0.68-stable review
Date: Fri,  1 Mar 2013 11:45:21 -0800
Message-Id: <20130301194527.988540148@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.68 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar  3 19:44:54 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.68-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.68-rc1

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: check s->async for poll(), read() and write()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_labpc: set up command4 register *after* command3

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_labpc: correct differential channel sequence for AI commands

Jiri Slaby <jslaby@suse.cz>
    s390/kvm: Fix store status for ACRS/FPRS fix

Jiri Slaby <jslaby@suse.cz>
    dca: check against empty dca_domains list before unregister provider fix

Li Zefan <lizefan@huawei.com>
    cgroup: fix exit() vs rmdir() race

Li Zefan <lizefan@huawei.com>
    cpuset: fix cpuset_print_task_mems_allowed() vs rename() race

Stoney Wang <song-bo.wang@hp.com>
    x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server systems

Kees Cook <keescook@chromium.org>
    x86: Do not leak kernel page mapping locations

Helge Deller <deller@gmx.de>
    unbreak automounter support on 64-bit kernel with 32-bit userspace (v2)

Oleg Nesterov <oleg@redhat.com>
    wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task

Oleg Nesterov <oleg@redhat.com>
    ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL

Oleg Nesterov <oleg@redhat.com>
    ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix length for cross region descriptor

J. Bruce Fields <bfields@redhat.com>
    svcrpc: make svc_age_temp_xprts enqueue under sv_lock

Niu Yawei <yawei.niu@gmail.com>
    ext4: fix race in ext4_mb_add_n_trim()

Dan Carpenter <dan.carpenter@oracle.com>
    media: rc: unlock on error in show_protocols()

Xi Wang <xi.wang@gmail.com>
    sysctl: fix null checking in bin_dn_node_address()

Tejun Heo <tj@kernel.org>
    firewire: add minor number range check to fw_device_init()

Tejun Heo <tj@kernel.org>
    idr: fix a subtle bug in idr_get_next()

Jan Beulich <JBeulich@suse.com>
    xen-blkback: do not leak mode property

Xiaowei.Hu <xiaowei.hu@oracle.com>
    ocfs2: ac->ac_allow_chain_relink=0 won't disable group relink

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Add missing mapped_lun bounds checking during make_mappedlun setup

H. Peter Anvin <hpa@linux.intel.com>
    x86: Make sure we can boot in the case the BDA contains pure garbage

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    doc, kernel-parameters: Document 'console=hvc<n>'

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    doc, xen: Mention 'earlyprintk=xen' in the documentation.

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Call ftrace cleanup module notifier after all other notifiers

Tejun Heo <tj@kernel.org>
    posix-timer: Don't call idr_find() with out-of-range ID

Joerg Roedel <joro@8bytes.org>
    iommu/amd: Initialize device table after dma_ops

Theodore Ts'o <tytso@mit.edu>
    quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format


-------------

Diffstat:

 Documentation/kernel-parameters.txt          |  5 +++
 Makefile                                     |  4 +-
 arch/s390/kvm/kvm-s390.c                     |  2 +-
 arch/x86/kernel/amd_iommu_init.c             | 10 +++--
 arch/x86/kernel/apic/x2apic_phys.c           | 17 +++++---
 arch/x86/kernel/head.c                       | 53 ++++++++++++++---------
 arch/x86/mm/fault.c                          |  9 ++--
 drivers/block/xen-blkback/xenbus.c           | 49 +++++++++++-----------
 drivers/dca/dca-core.c                       |  2 +-
 drivers/firewire/core-device.c               |  4 ++
 drivers/media/rc/rc-main.c                   |  4 +-
 drivers/staging/comedi/comedi_fops.c         |  8 ++--
 drivers/staging/comedi/drivers/ni_labpc.c    | 35 +++++++++-------
 drivers/target/target_core_fabric_configfs.c |  8 ++++
 drivers/vhost/vhost.c                        |  2 +-
 fs/ext4/mballoc.c                            |  6 +--
 fs/ocfs2/suballoc.c                          |  7 ++--
 fs/ocfs2/suballoc.h                          |  2 +-
 include/linux/auto_fs.h                      | 25 ++++-------
 include/linux/quota.h                        |  1 +
 include/linux/sched.h                        | 11 ++++-
 kernel/cgroup.c                              |  8 ++++
 kernel/cpuset.c                              | 12 +++++-
 kernel/posix-timers.c                        |  7 ++++
 kernel/ptrace.c                              | 63 +++++++++++++++++++++++-----
 kernel/sched.c                               |  3 +-
 kernel/signal.c                              | 17 ++++----
 kernel/sysctl_binary.c                       |  3 +-
 kernel/trace/ftrace.c                        | 46 +++++++++++++-------
 lib/idr.c                                    |  9 +++-
 net/sunrpc/svc_xprt.c                        | 15 +------
 31 files changed, 288 insertions(+), 159 deletions(-)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaDXVqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:46:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaDXVpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:45:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/33] 3.14.2-stable review
Date: Thu, 24 Apr 2014 14:48:13 -0700
Message-Id: <20140424214449.423169713@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.2 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Apr 26 21:44:12 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.2-rc1

Oleg Nesterov <oleg@redhat.com>
    exit: call disassociate_ctty() before exit_task_namespaces()

Oleg Nesterov <oleg@redhat.com>
    wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race

Li Zefan <lizefan@huawei.com>
    jffs2: remove from wait queue after schedule()

Li Zefan <lizefan@huawei.com>
    jffs2: avoid soft-lockup in jffs2_reserve_space_gc()

Ajesh Kunhipurayil Vijayan <ajesh@broadcom.com>
    jffs2: Fix crash due to truncation of csize

Kamlakant Patel <kamlakant.patel@broadcom.com>
    jffs2: Fix segmentation fault found in stress test

Dan Carpenter <dan.carpenter@oracle.com>
    fs: NULL dereference in posix_acl_to_xattr()

Eric Whitney <enwlinux@gmail.com>
    ext4: fix premature freeing of partial clusters split across leaf blocks

Eric Whitney <enwlinux@gmail.com>
    ext4: fix partial cluster handling for bigalloc file systems

Eric Whitney <enwlinux@gmail.com>
    ext4: fix error return from ext4_ext_handle_uninitialized_extents()

Josef Bacik <jbacik@fb.com>
    Btrfs: check for an extent_op on the locked ref

Josef Bacik <jbacik@fb.com>
    Btrfs: fix deadlock with nested trans handles

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
    Btrfs: skip submitting barrier for missing device

Mark Tinguely <tinguely@sgi.com>
    xfs: fix directory hash ordering bug

Jan Kara <jack@suse.cz>
    bdi: avoid oops on device removal

Derek Basehore <dbasehore@chromium.org>
    backing_dev: fix hung task on sync

Roberto Sassu <roberto.sassu@polito.it>
    ima: restore the original behavior for sending data with ima template

Claudio Takahasi <claudio.takahasi@openbossa.org>
    Bluetooth: Fix removing Long Term Key

Oleg Nesterov <oleg@redhat.com>
    pid_namespace: pidns_get() should check task_active_pid_ns() != NULL

Alan Stern <stern@rowland.harvard.edu>
    SCSI: sd: don't fail if the device doesn't recognize SYNCHRONIZE CACHE

Peter Hurley <peter@hurleysoftware.com>
    tty: Fix low_latency BUG

Hannes Reinecke <hare@suse.de>
    tty: Set correct tty name in 'active' sysfs attribute

Tejun Heo <tj@kernel.org>
    kernfs: protect lazy kernfs_iattrs allocation with mutex

Richard Cochran <richardcochran@gmail.com>
    kernfs: fix off by one error.

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: fix circular locking dependency in comedi_mmap()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: 8255_pci: initialize MITE data window

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / button: Add ACPI Button event via netlink routine

Mohit Kumar <mohit.kumar@st.com>
    PCI: designware: Fix iATU programming for cfg1, io and mem viewport

Mohit Kumar <mohit.kumar@st.com>
    PCI: designware: Fix RC BAR to be single 64-bit non-prefetchable memory BAR

Neil Horman <nhorman@tuxdriver.com>
    x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets

Jason Wang <jasowang@redhat.com>
    x86, hyperv: Bypass the timer_irq_works() check

Jiri Slaby <jslaby@suse.cz>
    Char: ipmi_bt_sm, fix infinite loop

Mikulas Patocka <mpatocka@redhat.com>
    user namespace: fix incorrect memory barriers


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/x86/kernel/cpu/mshyperv.c            |  6 +++++
 arch/x86/kernel/early-quirks.c            | 15 +++++-------
 drivers/acpi/button.c                     |  4 ++++
 drivers/char/ipmi/ipmi_bt_sm.c            |  2 +-
 drivers/pci/host/pcie-designware.c        |  8 +++----
 drivers/scsi/sd.c                         |  4 ++--
 drivers/staging/comedi/comedi_buf.c       | 37 ++++++++++++++++++++++++++--
 drivers/staging/comedi/comedi_fops.c      | 18 ++++++++++----
 drivers/staging/comedi/comedi_internal.h  |  2 ++
 drivers/staging/comedi/drivers/8255_pci.c | 34 ++++++++++++++++++++++++++
 drivers/tty/ipwireless/tty.c              |  3 ---
 drivers/tty/tty_buffer.c                  | 20 ++++------------
 drivers/tty/tty_io.c                      | 23 +++++++++++++-----
 drivers/usb/gadget/u_serial.c             |  4 ++--
 fs/btrfs/disk-io.c                        |  4 ++++
 fs/btrfs/extent-tree.c                    |  3 ++-
 fs/btrfs/transaction.c                    | 14 ++++-------
 fs/ext4/extents.c                         | 40 +++++++++++++++++++++++++++----
 fs/fs-writeback.c                         | 31 +++++++++++++++++-------
 fs/jffs2/compr_rtime.c                    |  4 ++--
 fs/jffs2/nodelist.h                       |  2 +-
 fs/jffs2/nodemgmt.c                       | 14 +++++++----
 fs/kernfs/dir.c                           |  2 +-
 fs/kernfs/inode.c                         | 14 +++++++----
 fs/posix_acl.c                            |  5 ++--
 fs/xfs/xfs_da_btree.c                     |  2 +-
 include/linux/backing-dev.h               |  2 +-
 include/linux/tty.h                       |  2 +-
 kernel/exit.c                             | 21 +++++++++-------
 kernel/pid_namespace.c                    |  4 +++-
 kernel/user_namespace.c                   | 11 ++++-----
 mm/backing-dev.c                          | 16 +++++++++----
 net/bluetooth/hci_event.c                 |  8 ++++++-
 security/integrity/ima/ima.h              |  2 +-
 security/integrity/ima/ima_fs.c           |  2 ++
 security/integrity/ima/ima_template_lib.c | 10 +++++---
 37 files changed, 280 insertions(+), 117 deletions(-)



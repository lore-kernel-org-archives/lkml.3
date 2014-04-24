Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbaDXWWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:22:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbaDXVqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:46:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/23] 3.10.38-stable review
Date: Thu, 24 Apr 2014 14:48:30 -0700
Message-Id: <20140424214825.933835556@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.38 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Apr 26 21:48:09 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.38-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.38-rc1

Oleg Nesterov <oleg@redhat.com>
    exit: call disassociate_ctty() before exit_task_namespaces()

Oleg Nesterov <oleg@redhat.com>
    wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race

David S. Miller <davem@davemloft.net>
    sparc64: Make sure %pil interrupts are enabled during hypervisor yield.

Dave Kleikamp <dave.kleikamp@oracle.com>
    sparc64: don't treat 64-bit syscall return codes as 32-bit

Paul Gortmaker <paul.gortmaker@windriver.com>
    sparc32: fix build failure for arch_jump_label_transform

Dave Kleikamp <dave.kleikamp@oracle.com>
    Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."

oftedal <oftedal@gmail.com>
    sparc: PCI: Fix incorrect address calculation of PCI Bridge windows on Simba-bridges

Li Zefan <lizefan@huawei.com>
    jffs2: remove from wait queue after schedule()

Li Zefan <lizefan@huawei.com>
    jffs2: avoid soft-lockup in jffs2_reserve_space_gc()

Ajesh Kunhipurayil Vijayan <ajesh@broadcom.com>
    jffs2: Fix crash due to truncation of csize

Kamlakant Patel <kamlakant.patel@broadcom.com>
    jffs2: Fix segmentation fault found in stress test

Eric Whitney <enwlinux@gmail.com>
    ext4: fix partial cluster handling for bigalloc file systems

Eric Whitney <enwlinux@gmail.com>
    ext4: fix error return from ext4_ext_handle_uninitialized_extents()

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
    Btrfs: skip submitting barrier for missing device

Jan Kara <jack@suse.cz>
    bdi: avoid oops on device removal

Derek Basehore <dbasehore@chromium.org>
    backing_dev: fix hung task on sync

Claudio Takahasi <claudio.takahasi@openbossa.org>
    Bluetooth: Fix removing Long Term Key

Oleg Nesterov <oleg@redhat.com>
    pid_namespace: pidns_get() should check task_active_pid_ns() != NULL

Hannes Reinecke <hare@suse.de>
    tty: Set correct tty name in 'active' sysfs attribute

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: 8255_pci: initialize MITE data window

Neil Horman <nhorman@tuxdriver.com>
    x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets

Jiri Slaby <jslaby@suse.cz>
    Char: ipmi_bt_sm, fix infinite loop

Mikulas Patocka <mpatocka@redhat.com>
    user namespace: fix incorrect memory barriers


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/sparc/Kconfig                        |  2 +-
 arch/sparc/include/asm/uaccess_64.h       |  4 ++--
 arch/sparc/kernel/pci.c                   |  4 ++--
 arch/sparc/kernel/process_64.c            |  4 +++-
 arch/sparc/kernel/syscalls.S              |  4 ++--
 arch/x86/kernel/early-quirks.c            | 15 ++++++--------
 drivers/char/ipmi/ipmi_bt_sm.c            |  2 +-
 drivers/staging/comedi/drivers/8255_pci.c | 34 +++++++++++++++++++++++++++++++
 drivers/tty/tty_io.c                      | 23 +++++++++++++++------
 fs/btrfs/disk-io.c                        |  4 ++++
 fs/ext4/extents.c                         | 29 ++++++++++++++++++++++++--
 fs/fs-writeback.c                         | 31 ++++++++++++++++++++--------
 fs/jffs2/compr_rtime.c                    |  4 ++--
 fs/jffs2/nodelist.h                       |  2 +-
 fs/jffs2/nodemgmt.c                       | 14 +++++++++----
 include/linux/backing-dev.h               |  2 +-
 kernel/exit.c                             | 21 +++++++++++--------
 kernel/pid_namespace.c                    |  4 +++-
 kernel/user_namespace.c                   | 11 +++++-----
 mm/backing-dev.c                          | 16 +++++++++++----
 net/bluetooth/hci_event.c                 |  8 +++++++-
 22 files changed, 177 insertions(+), 65 deletions(-)



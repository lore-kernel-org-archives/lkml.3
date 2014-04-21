Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaDUEfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:35:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaDUEei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:34:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.13 00/32] 3.13.11-stable review
Date: Sun, 20 Apr 2014 19:13:17 -0700
Message-Id: <20140421021133.865086647@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----------------

Note, this is the LAST 3.13.y kernel I will be releasing.  It will be
end-of-life after this release, please move to 3.14.y at this time.

----------------

This is the start of the stable review cycle for the 3.13.11 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Apr 23 02:10:46 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.11-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.13.11-rc1

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

Li Zefan <lizefan@huawei.com>
    jffs2: remove from wait queue after schedule()

Li Zefan <lizefan@huawei.com>
    jffs2: avoid soft-lockup in jffs2_reserve_space_gc()

Ajesh Kunhipurayil Vijayan <ajesh@broadcom.com>
    jffs2: Fix crash due to truncation of csize

Kamlakant Patel <kamlakant.patel@broadcom.com>
    jffs2: Fix segmentation fault found in stress test

Eric Whitney <enwlinux@gmail.com>
    ext4: fix premature freeing of partial clusters split across leaf blocks

Eric Whitney <enwlinux@gmail.com>
    ext4: fix partial cluster handling for bigalloc file systems

Eric Whitney <enwlinux@gmail.com>
    ext4: fix error return from ext4_ext_handle_uninitialized_extents()

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

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: 8255_pci: initialize MITE data window

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled

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
 arch/sparc/Kconfig                        |  2 +-
 arch/sparc/kernel/process_64.c            |  4 +++-
 arch/sparc/kernel/syscalls.S              |  4 ++--
 arch/x86/kernel/cpu/mshyperv.c            |  6 +++++
 arch/x86/kernel/early-quirks.c            | 15 +++++-------
 drivers/acpi/button.c                     |  4 ++++
 drivers/char/ipmi/ipmi_bt_sm.c            |  2 +-
 drivers/pci/host/pcie-designware.c        |  8 +++----
 drivers/pci/pci.c                         |  3 +++
 drivers/scsi/sd.c                         |  4 ++--
 drivers/staging/comedi/drivers/8255_pci.c | 34 ++++++++++++++++++++++++++
 drivers/tty/ipwireless/tty.c              |  3 ---
 drivers/tty/tty_buffer.c                  | 20 ++++------------
 drivers/tty/tty_io.c                      | 23 +++++++++++++-----
 drivers/usb/gadget/u_serial.c             |  4 ++--
 fs/btrfs/disk-io.c                        |  4 ++++
 fs/btrfs/transaction.c                    | 14 ++++-------
 fs/ext4/extents.c                         | 40 +++++++++++++++++++++++++++----
 fs/fs-writeback.c                         | 31 +++++++++++++++++-------
 fs/jffs2/compr_rtime.c                    |  4 ++--
 fs/jffs2/nodelist.h                       |  2 +-
 fs/jffs2/nodemgmt.c                       | 14 +++++++----
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
 34 files changed, 222 insertions(+), 107 deletions(-)



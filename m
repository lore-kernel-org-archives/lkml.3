Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab3GSFVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:21:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759222Ab3GSFVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:21:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/38] 3.9.11-stable review
Date: Thu, 18 Jul 2013 22:21:16 -0700
Message-Id: <20130719052047.858393825@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------------
Note, this is the LAST 3.9-stable kernel release that I will be doing.
Please move to the 3.10-stable branch as soon as possible.
---------------

This is the start of the stable review cycle for the 3.9.11 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Jul 21 05:20:01 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.11-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.9.11-rc1

Steve French <smfrench@us.ibm.com>
    Handle big endianness in NTLM (ntlmv2) authentication

Wanpeng Li <liwanp@linux.vnet.ibm.com>
    mm/memory-hotplug: fix lowmem count overflow when offline pages

Michal Hocko <mhocko@suse.cz>
    memcg, kmem: fix reference count handling on the error path

Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()

Theodore Ts'o <tytso@mit.edu>
    ext4: don't allow ext4_free_blocks() to fail due to ENOMEM

Jan Kara <jack@suse.cz>
    ext4: fix overflow when counting used blocks on 32-bit architectures

Jan Kara <jack@suse.cz>
    ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs

Jan Kara <jack@suse.cz>
    ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations

Jan Kara <jack@suse.cz>
    ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()

Josef Bacik <jbacik@fusionio.com>
    Btrfs: only do the tree_mod_log_free_eb if this is our last ref

Josef Bacik <jbacik@fusionio.com>
    Btrfs: fix estale with btrfs send

Bart Van Assche <bart.vanassche@gmail.com>
    timer: Fix jiffies wrap behavior of round_jiffies_common()

Shane Huang <shane.huang@amd.com>
    ahci: remove pmp link online check in FBS EH

Jiang Liu <liuj97@gmail.com>
    PCI: Fix refcount issue in pci_create_root_bus() error recovery path

Xudong Hao <xudong.hao@intel.com>
    PCI: Finish SR-IOV VF setup before adding the device

Paul Clements <paul.clements@steeleye.com>
    nbd: correct disconnect behavior

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: xattr: fix inlined xattr reflink

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PM: Fix corner case in acpi_bus_update_power()

Lv Zheng <lv.zheng@intel.com>
    ACPICA: Do not use extended sleep registers unless HW-reduced bit is set

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan

Axel Lin <axel.lin@ingics.com>
    drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq

Ben Hutchings <ben@decadent.org.uk>
    genirq: Fix can_request_irq() for IRQs without an action

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pcifront: Deal with toolstack missing 'XenbusStateClosing' state.

Laszlo Ersek <lersek@redhat.com>
    xen/time: remove blocked time accounting from xen "clockchip"

Li Zefan <lizefan@huawei.com>
    cgroup: fix umount vs cgroup_event_remove() race

Joachim Eastwood <manabian@gmail.com>
    pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status

Jason Wang <jasowang@redhat.com>
    drivers: hv: switch to use mb() instead of smp_mb()

George Cherian <george.cherian@ti.com>
    usb: host: xhci-plat: release mem region while removing module

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: check for failed dma pool allocation

UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>
    usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed

Al Viro <viro@ZenIV.linux.org.uk>
    ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()

Maarten ter Huurne <maarten@treewalker.org>
    ext4: fix corruption when online resizing a fs with 1K block size

Theodore Ts'o <tytso@mit.edu>
    jbd2: fix theoretical race in jbd2__journal_restart

Theodore Ts'o <tytso@mit.edu>
    jbd2: move superblock checksum calculation to jbd2_write_superblock()

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix duplicate if test

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8723ae: Fix typo in firmware names

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix a deadlock when a file is reopened

Steve French <smfrench@gmail.com>
    CIFS use sensible file nlink values if unprovided


-------------

Diffstat:

 Makefile                                    |  4 ++--
 arch/x86/xen/time.c                         | 17 ++------------
 drivers/acpi/acpica/hwxfsleep.c             |  8 ++++---
 drivers/acpi/device_pm.c                    | 23 ++++++++++++++-----
 drivers/acpi/ec.c                           |  4 ++++
 drivers/ata/libahci.c                       |  3 +--
 drivers/block/nbd.c                         |  7 +++++-
 drivers/dma/pl330.c                         |  4 ++--
 drivers/hv/ring_buffer.c                    | 10 ++++-----
 drivers/hv/vmbus_drv.c                      |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c |  2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |  6 ++---
 drivers/pci/iov.c                           |  5 ++---
 drivers/pci/probe.c                         | 14 +++++++-----
 drivers/pci/xen-pcifront.c                  |  7 +++---
 drivers/pcmcia/at91_cf.c                    |  4 ++--
 drivers/rtc/rtc-rv3029c2.c                  |  2 +-
 drivers/usb/gadget/f_mass_storage.c         |  2 ++
 drivers/usb/host/xhci-mem.c                 |  4 ++++
 drivers/usb/host/xhci-plat.c                |  1 +
 fs/btrfs/ctree.c                            |  3 ++-
 fs/btrfs/send.c                             | 35 +++++++++++++++++++++++++++++
 fs/cifs/cifs_unicode.h                      |  8 +++----
 fs/cifs/cifsencrypt.c                       |  6 ++---
 fs/cifs/file.c                              |  9 ++++----
 fs/cifs/inode.c                             |  5 +++++
 fs/ext3/namei.c                             |  7 ++----
 fs/ext4/extents.c                           |  4 ++--
 fs/ext4/file.c                              | 14 ++++++------
 fs/ext4/inline.c                            |  2 +-
 fs/ext4/inode.c                             |  4 ++--
 fs/ext4/mballoc.c                           | 11 ++++++---
 fs/ext4/namei.c                             |  7 ++----
 fs/ext4/resize.c                            |  4 +---
 fs/jbd2/journal.c                           |  3 ++-
 fs/jbd2/transaction.c                       |  2 +-
 fs/ocfs2/xattr.c                            | 10 +++++++++
 include/linux/nbd.h                         |  1 +
 kernel/cgroup.c                             | 25 ++++++++++++++++-----
 kernel/irq/manage.c                         |  6 ++---
 kernel/timer.c                              |  8 ++++---
 mm/memcontrol.c                             |  8 -------
 mm/page_alloc.c                             |  4 ++++
 43 files changed, 196 insertions(+), 119 deletions(-)



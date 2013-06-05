Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab3FEVMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:12:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395Ab3FEVMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:12:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/44] 3.4.48-stable review
Date: Wed,  5 Jun 2013 14:11:58 -0700
Message-Id: <20130605211221.858177087@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.48 release.
There are 44 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jun  7 21:10:11 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.48-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.48-rc1

Manoj Iyer <manoj.iyer@canonical.com>
    thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR

Johannes Berg <johannes.berg@intel.com>
    mac80211: close AP_VLAN interfaces before unregistering all

Martin Pelikan <pelikan@storkhole.cz>
    x86, um: Correct syscall table type attributes breaking gcc 4.8

Joerg Roedel <joro@8bytes.org>
    iommu/amd: Workaround for ERBT1312

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Re-enable IOMMU event log interrupt after handling.

Wei Liu <wei.liu2@citrix.com>
    xen-netback: remove skb in xen_netbk_alloc_page

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: fix a couple races

Keir Fraser <keir.fraser@citrix.com>
    xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.

Finn Thain <fthain@telegraphics.com.au>
    m68k/mac: Fix unexpected interrupt with CONFIG_EARLY_PRINTK

Vincent Pelletier <plr.vincent@gmail.com>
    libata: make ata_exec_internal_sg honor DMADIR

Chew, Chiau Ee <chiau.ee.chew@intel.com>
    ata_piix: add PCI IDs for Intel BayTail

Wolfgang Frisch <wfpub@roembden.net>
    USB: io_ti: Fix NULL dereference in chase_port()

Jeff Layton <jlayton@redhat.com>
    cifs: fix potential buffer overrun when composing a new options string

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix card_posted check for newer asics

Dave Chinner <dchinner@redhat.com>
    xfs: kill suid/sgid through the truncate path.

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix a thinko in nfs4_try_open_cached

Kees Cook <keescook@chromium.org>
    iscsi-target: fix heap buffer overflow on error

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

Cliff Wickman <cpw@sgi.com>
    mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

Brian Behlendorf <behlendorf1@llnl.gov>
    drivers/block/brd.c: fix brd_lookup_page() race

Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
    mm: mmu_notifier: re-fix freed page still mapped in secondary MMU

Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
    nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary

Imre Deak <imre.deak@intel.com>
    wait: fix false timeouts when using wait_event_timeout()

wang, biao <biao.wang@intel.com>
    klist: del waiter from klist_remove_waiters before wakeup waitting process

Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
    mm compaction: fix of improper cache flush in migration code

Christian Gmeiner <christian.gmeiner@gmail.com>
    drivers/leds/leds-ot200.c: fix error caused by shifted mask

Martin Michlmayr <tbm@cyrius.com>
    Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Joseph Qi <joseph.qi@huawei.com>
    ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()

Ben Hutchings <ben@decadent.org.uk>
    perf: net_dropmonitor: Fix symbol-relative addresses

Ben Hutchings <ben@decadent.org.uk>
    perf: net_dropmonitor: Fix trace parameter order

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix possible overflow for fat_clusters

Jeff Layton <jlayton@redhat.com>
    cifs: only set ops for inodes in I_NEW state

Alan Stern <stern@rowland.harvard.edu>
    USB: UHCI: fix for suspend of virtual HP controller

Alan Stern <stern@rowland.harvard.edu>
    USB: xHCI: override bogus bulk wMaxPacketSize values

Oliver Neukum <oliver@neukum.org>
    USB: reset resume quirk needed by a hub

Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>
    USB: Blacklisted Cinterion's PLxx WWAN Interface

Wang YanQing <udknight@gmail.com>
    TTY: Fix tty miss restart after we turn off flow-control

Dan Carpenter <dan.carpenter@oracle.com>
    USB: cxacru: potential underflow in cxacru_cm_get_array()

Gomella, Andrew (NIH/NHLBI) [F] <andrew.gomella@nih.gov>
    USB: ftdi_sio: Add support for Newport CONEX motor drivers

Dan Williams <dcbw@redhat.com>
    USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

Teppo Kotilainen <qubit303@gmail.com>
    usb: option: Add Telewell TW-LTE 4G

Hema Prathaban <hemaklnce@gmail.com>
    staging: vt6656: use free_netdev instead of kfree

Gregory CLEMENT <gregory.clement@free-electrons.com>
    ARM: plat-orion: Fix num_resources and id for ge10 and ge11

Hans-Christian Egtvedt <egtvedt@samfundet.no>
    avr32: fix relocation check for signed 18-bit offset


-------------

Diffstat:

 Makefile                                       |  4 +-
 arch/arm/mach-kirkwood/ts219-setup.c           |  2 +-
 arch/arm/plat-orion/common.c                   | 12 ++--
 arch/avr32/kernel/module.c                     |  2 +-
 arch/m68k/kernel/head.S                        | 29 ++++++----
 arch/x86/um/sys_call_table_32.c                |  4 +-
 drivers/ata/ata_piix.c                         | 15 +++++
 drivers/ata/libata-core.c                      |  6 ++
 drivers/block/brd.c                            |  4 +-
 drivers/gpu/drm/radeon/radeon_device.c         | 19 +++---
 drivers/iommu/amd_iommu.c                      | 31 ++++++++--
 drivers/iommu/amd_iommu_types.h                |  1 +
 drivers/leds/leds-ot200.c                      | 14 ++---
 drivers/net/xen-netback/netback.c              |  5 +-
 drivers/platform/x86/thinkpad_acpi.c           |  7 +++
 drivers/staging/vt6656/hostap.c                |  2 +-
 drivers/target/iscsi/iscsi_target_parameters.c |  8 +--
 drivers/target/iscsi/iscsi_target_parameters.h |  4 +-
 drivers/tty/n_tty.c                            |  8 +++
 drivers/usb/atm/cxacru.c                       |  3 +-
 drivers/usb/core/quirks.c                      |  3 +
 drivers/usb/host/uhci-hub.c                    |  3 +-
 drivers/usb/host/xhci-mem.c                    | 17 +++---
 drivers/usb/serial/ftdi_sio.c                  |  2 +
 drivers/usb/serial/ftdi_sio_ids.h              |  2 +
 drivers/usb/serial/io_ti.c                     |  3 +
 drivers/usb/serial/option.c                    | 13 +++--
 drivers/xen/events.c                           | 19 ++++--
 fs/cifs/cifs_dfs_ref.c                         |  4 +-
 fs/cifs/inode.c                                |  3 +-
 fs/fat/inode.c                                 | 15 ++++-
 fs/jfs/inode.c                                 |  2 +-
 fs/jfs/jfs_logmgr.c                            |  3 +-
 fs/nfs/nfs4proc.c                              |  2 +-
 fs/nilfs2/inode.c                              | 27 +++++++--
 fs/ocfs2/extent_map.c                          |  2 +-
 fs/xfs/xfs_iops.c                              | 47 ++++++++++-----
 include/linux/wait.h                           | 16 ++++--
 lib/klist.c                                    |  2 +-
 mm/huge_memory.c                               |  7 ++-
 mm/migrate.c                                   |  2 +-
 mm/mmu_notifier.c                              | 80 +++++++++++++-------------
 mm/pagewalk.c                                  | 70 +++++++++++-----------
 net/mac80211/iface.c                           |  9 +++
 tools/perf/scripts/python/net_dropmonitor.py   |  8 +--
 45 files changed, 355 insertions(+), 186 deletions(-)



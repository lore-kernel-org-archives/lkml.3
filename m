Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3FEVDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:03:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585Ab3FEUxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/33] 3.0.81-stable review
Date: Wed,  5 Jun 2013 13:52:38 -0700
Message-Id: <20130605204702.359510786@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.81 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jun  7 20:43:03 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.81-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.81-rc1

Manoj Iyer <manoj.iyer@canonical.com>
    thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR

Johannes Berg <johannes.berg@intel.com>
    mac80211: close AP_VLAN interfaces before unregistering all

Xi Wang <xi.wang@gmail.com>
    ALSA: usb-audio: avoid integer overflow in create_fixed_stream_quirk()

Xi Wang <xi.wang@gmail.com>
    ALSA: usb-audio: fix possible hang and overflow in parse_uac2_sample_rate_range()

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: fix a couple races

Keir Fraser <keir.fraser@citrix.com>
    xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.

Vincent Pelletier <plr.vincent@gmail.com>
    libata: make ata_exec_internal_sg honor DMADIR

Wolfgang Frisch <wfpub@roembden.net>
    USB: io_ti: Fix NULL dereference in chase_port()

Jeff Layton <jlayton@redhat.com>
    cifs: fix potential buffer overrun when composing a new options string

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix card_posted check for newer asics

Richard Weinberger <richard@nod.at>
    um: Serve io_remap_pfn_range()

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

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

Martin Michlmayr <tbm@cyrius.com>
    Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Joseph Qi <joseph.qi@huawei.com>
    ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix possible overflow for fat_clusters

Jeff Layton <jlayton@redhat.com>
    cifs: only set ops for inodes in I_NEW state

Alan Stern <stern@rowland.harvard.edu>
    USB: UHCI: fix for suspend of virtual HP controller

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

 Makefile                               |  4 +-
 arch/arm/mach-kirkwood/ts219-setup.c   |  2 +-
 arch/arm/plat-orion/common.c           | 12 ++---
 arch/avr32/kernel/module.c             |  2 +-
 arch/um/include/asm/pgtable.h          |  2 +
 drivers/ata/libata-core.c              |  6 +++
 drivers/block/brd.c                    |  4 +-
 drivers/gpu/drm/radeon/radeon_device.c | 19 ++++----
 drivers/platform/x86/thinkpad_acpi.c   |  7 +++
 drivers/staging/vt6656/hostap.c        |  2 +-
 drivers/tty/n_tty.c                    |  8 ++++
 drivers/usb/atm/cxacru.c               |  3 +-
 drivers/usb/core/quirks.c              |  3 ++
 drivers/usb/host/uhci-hub.c            |  3 +-
 drivers/usb/serial/ftdi_sio.c          |  2 +
 drivers/usb/serial/ftdi_sio_ids.h      |  2 +
 drivers/usb/serial/io_ti.c             |  3 ++
 drivers/usb/serial/option.c            | 13 ++++--
 drivers/xen/events.c                   | 19 ++++++--
 fs/cifs/cifs_dfs_ref.c                 |  4 +-
 fs/cifs/inode.c                        |  3 +-
 fs/fat/inode.c                         | 15 ++++++-
 fs/jfs/inode.c                         |  2 +-
 fs/jfs/jfs_logmgr.c                    |  3 +-
 fs/nilfs2/inode.c                      | 27 ++++++++++--
 fs/ocfs2/extent_map.c                  |  2 +-
 include/linux/wait.h                   | 16 ++++---
 lib/klist.c                            |  2 +-
 mm/huge_memory.c                       |  7 ++-
 mm/migrate.c                           |  2 +-
 mm/mmu_notifier.c                      | 80 +++++++++++++++++-----------------
 net/mac80211/iface.c                   |  9 ++++
 sound/usb/card.h                       |  1 +
 sound/usb/format.c                     |  6 ++-
 sound/usb/quirks.c                     |  6 ++-
 35 files changed, 208 insertions(+), 93 deletions(-)



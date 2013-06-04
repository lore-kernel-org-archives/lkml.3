Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3FDOHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:07:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46609 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab3FDOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [ 3.5.y.z extended stable ] Linux 3.5.7.14 stable review
Date: Tue,  4 Jun 2013 15:06:16 +0100
Message-Id: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.5.7.14 stable kernel.

This version contains 70 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.5.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.5.y-review

The review period for version 3.5.7.14 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.5.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 arch/arm/mach-kirkwood/ts219-setup.c           |   2 +-
 arch/arm/plat-orion/common.c                   |  12 +-
 arch/avr32/kernel/module.c                     |   2 +-
 drivers/acpi/video_detect.c                    |  45 ++++
 drivers/block/brd.c                            |   4 +-
 drivers/char/random.c                          |  24 +-
 drivers/gpu/drm/radeon/evergreen.c             |   4 +-
 drivers/gpu/drm/radeon/radeon_device.c         |  19 +-
 drivers/gpu/drm/radeon/radeon_ttm.c            |   2 +-
 drivers/gpu/drm/radeon/si.c                    |   6 +-
 drivers/hwmon/abituguru.c                      |  16 +-
 drivers/i2c/busses/i2c-designware-core.c       |  14 +-
 drivers/i2c/busses/i2c-designware-core.h       |   2 +
 drivers/input/touchscreen/egalax_ts.c          |   2 +-
 drivers/leds/leds-ot200.c                      |  14 +-
 drivers/md/dm-bufio.c                          |  26 ++-
 drivers/media/dvb/mantis/mantis_dvb.c          |   6 +-
 drivers/net/ethernet/broadcom/tg3.c            |  32 ++-
 drivers/net/wireless/mwifiex/cfg80211.c        |   3 -
 drivers/net/wireless/mwifiex/main.c            |   1 +
 drivers/net/xen-netback/netback.c              | 311 ++++++++++++++++++++-----
 drivers/net/xen-netfront.c                     |  30 +--
 drivers/rapidio/devices/tsi721.c               |  12 +
 drivers/staging/iio/light/tsl2x7x_core.c       |   9 +-
 drivers/staging/vt6656/hostap.c                |   2 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   8 +-
 drivers/target/iscsi/iscsi_target_parameters.h |   4 +-
 drivers/tty/n_tty.c                            |   8 +
 drivers/usb/atm/cxacru.c                       |   3 +-
 drivers/usb/core/quirks.c                      |   3 +
 drivers/usb/host/uhci-hub.c                    |   3 +-
 drivers/usb/host/xhci-mem.c                    |  17 +-
 drivers/usb/serial/ftdi_sio.c                  |   2 +
 drivers/usb/serial/ftdi_sio_ids.h              |   2 +
 drivers/usb/serial/option.c                    |  13 +-
 fs/btrfs/ioctl.c                               |  10 +-
 fs/cifs/cifs_dfs_ref.c                         |   4 +-
 fs/cifs/inode.c                                |   3 +-
 fs/fat/inode.c                                 |  15 +-
 fs/jfs/inode.c                                 |   2 +-
 fs/jfs/jfs_logmgr.c                            |   3 +-
 fs/nfs/nfs4proc.c                              |   2 +-
 fs/nilfs2/inode.c                              |  27 ++-
 fs/ocfs2/extent_map.c                          |   2 +-
 fs/reiserfs/dir.c                              |   2 +
 fs/reiserfs/inode.c                            |   9 +-
 fs/reiserfs/xattr.c                            |  14 +-
 fs/reiserfs/xattr_acl.c                        |   3 +
 fs/xfs/xfs_iops.c                              |  47 ++--
 include/linux/virtio_console.h                 |   2 +-
 include/linux/wait.h                           |  16 +-
 include/xen/interface/io/netif.h               |  18 ++
 kernel/sched/core.c                            |  35 +--
 mm/huge_memory.c                               |   7 +-
 mm/migrate.c                                   |   2 +-
 mm/mmu_notifier.c                              |  80 +++----
 mm/pagewalk.c                                  |  70 +++---
 net/mac80211/rx.c                              |   3 +
 net/netfilter/ipvs/ip_vs_pe_sip.c              |   6 +-
 net/sunrpc/sched.c                             |  13 +-
 sound/soc/codecs/cs42l52.c                     |   2 +-
 tools/perf/scripts/python/net_dropmonitor.py   |   8 +-
 62 files changed, 766 insertions(+), 302 deletions(-)

Alan Cox (1):
      mantis: fix silly crash case

Alan Stern (2):
      USB: xHCI: override bogus bulk wMaxPacketSize values
      USB: UHCI: fix for suspend of virtual HP controller

Alex Deucher (2):
      drm/radeon: fix typo in cu_per_sh on verde
      drm/radeon: fix card_posted check for newer asics

Alexandre Bounine (1):
      rapidio/tsi721: fix bug in MSI interrupt handling

Amitkumar Karwar (1):
      mwifiex: fix memory leak issue when driver unload

Aneesh Kumar K.V (1):
      mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

Bastian Triller (1):
      ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist

Ben Hutchings (2):
      perf: net_dropmonitor: Fix trace parameter order
      perf: net_dropmonitor: Fix symbol-relative addresses

Brian Behlendorf (1):
      drivers/block/brd.c: fix brd_lookup_page() race

Christian Gmeiner (1):
      drivers/leds/leds-ot200.c: fix error caused by shifted mask

Cliff Wickman (1):
      mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

Corentin Chary (1):
      acpi/video_detect: blacklist samsung x360

Dan Carpenter (1):
      USB: cxacru: potential underflow in cxacru_cm_get_array()

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

Dave Chinner (1):
      xfs: kill suid/sgid through the truncate path.

Dave Kleikamp (1):
      jfs: fix a couple races

Gabriel de Perthuis (1):
      btrfs: don't stop searching after encountering the wrong item

Gomella, Andrew (NIH/NHLBI) [F] (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers

Gregory CLEMENT (1):
      ARM: plat-orion: Fix num_resources and id for ge10 and ge11

Hans Schillstrom (1):
      ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

Hans-Christian Egtvedt (1):
      avr32: fix relocation check for signed 18-bit offset

Heiko Abraham (1):
      Input: egalax_ts - ABS_MT_POSITION_Y not reported well

Hema Prathaban (1):
      staging: vt6656: use free_netdev instead of kfree

Imre Deak (1):
      wait: fix false timeouts when using wait_event_timeout()

Jeff Layton (3):
      cifs: only set ops for inodes in I_NEW state
      sunrpc: clarify comments on rpc_make_runnable
      cifs: fix potential buffer overrun when composing a new options string

Jeff Mahoney (3):
      reiserfs: fix deadlock with nfs racing on create/lookup
      reiserfs: fix problems with chowning setuid file w/ xattrs
      reiserfs: fix spurious multiple-fill in reiserfs_readdir_dentry

Jiri Kosina (1):
      random: fix accounting race condition with lockless irq entropy_count update

Johannes Berg (1):
      mac80211: fix AP-mode frame matching

Josef Ahmad (1):
      i2c: designware: fix RX FIFO overrun

Joseph Qi (1):
      ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()

Kees Cook (1):
      iscsi-target: fix heap buffer overflow on error

Lan Tianyu (1):
      ACPI / video: Add "Asus UL30VT" to ACPI video detect blacklist

Leonid Yegoshin (1):
      mm compaction: fix of improper cache flush in migration code

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Michael S. Tsirkin (1):
      virtio_console: fix uapi header

Mika Westerberg (1):
      i2c: designware: always clear interrupts before enabling them

Mikulas Patocka (1):
      dm bufio: avoid a possible __vmalloc deadlock

Namhyung Kim (1):
      sched/debug: Limit sd->*_idx range on sysctl

Nicolas Schichan (1):
      ASoC: cs42l52: fix default value for MASTERA_VOL.

Niels Ole Salscheider (1):
      drm/radeon: Fix VRAM size calculation for VRAM >= 4GB

Nithin Sujir (1):
      tg3: Skip powering down function 0 on certain serdes devices

OGAWA Hirofumi (1):
      fat: fix possible overflow for fat_clusters

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub

Ryusuke Konishi (1):
      nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G

Trond Myklebust (2):
      SUNRPC: Prevent an rpc_task wakeup race
      NFSv4: Fix a thinko in nfs4_try_open_cached

Wang YanQing (1):
      TTY: Fix tty miss restart after we turn off flow-control

Wei Liu (9):
      xen-netback: remove skb in xen_netbk_alloc_page
      xen-netback: coalesce slots in TX path and fix regressions
      xen-netback: don't disconnect frontend when seeing oversize packet
      xen-netback: remove redundent parameter in netbk_count_requests
      xen-netback: avoid allocating variable size array on stack
      xen-netback: better names for thresholds
      xen-netfront: remove unused variable `extra'
      xen-netfront: frags -> slots in xennet_get_responses
      xen-netfront: frags -> slots in log message

Wei Yongjun (2):
      hwmon: fix error return code in abituguru_probe()
      staging:iio:light:tsl2x7x: fix the error handling in tsl2x7x_probe()

Xiao Guangrong (1):
      mm: mmu_notifier: re-fix freed page still mapped in secondary MMU

libin (1):
      sched/debug: Fix sd->*_idx limit range avoiding overflow

stephen hemminger (1):
      xen-netback: fix sparse warning

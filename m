Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbaBLLq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:46:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaBLLqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:46:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.5.y.z extended stable] Linux 3.5.7.30
Date: Wed, 12 Feb 2014 11:46:50 +0000
Message-Id: <1392205611-21479-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.5.7.30 kernel.

The updated 3.5.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog

The diff from v3.5.7.29 is posted as a follow-up to this email.

The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Documentation/filesystems/proc.txt                |   4 +-
 Makefile                                          |   2 +-
 arch/alpha/lib/csum_partial_copy.c                |   9 +-
 arch/arm/mach-at91/sam9_smc.c                     |   2 +-
 arch/powerpc/kernel/cacheinfo.c                   |   3 +
 arch/powerpc/kvm/e500_tlb.c                       |   2 +-
 arch/s390/kvm/diag.c                              |   2 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c          |  53 ++++++--
 arch/x86/platform/efi/efi.c                       |   2 +-
 arch/x86/xen/platform-pci-unplug.c                |  74 +++++++++++
 drivers/acpi/bus.c                                |   9 ++
 drivers/block/xen-blkfront.c                      |   4 +-
 drivers/edac/e752x_edac.c                         |   4 +-
 drivers/gpu/drm/cirrus/cirrus_mode.c              |   4 +-
 drivers/gpu/drm/radeon/evergreen_cs.c             |   5 +-
 drivers/gpu/drm/radeon/r600.c                     |  13 +-
 drivers/gpu/drm/radeon/r600_cs.c                  |   5 +-
 drivers/gpu/drm/radeon/r600d.h                    |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c          |   4 +
 drivers/gpu/drm/radeon/radeon_i2c.c               |   3 +
 drivers/gpu/drm/radeon/radeon_pm.c                |   6 +-
 drivers/hwmon/coretemp.c                          |   2 +-
 drivers/infiniband/hw/qib/qib_ud.c                |   9 +-
 drivers/input/misc/xen-kbdfront.c                 |   4 +
 drivers/iommu/intel-iommu.c                       |   2 +-
 drivers/md/dm-sysfs.c                             |  10 +-
 drivers/md/dm-thin.c                              |  17 +--
 drivers/md/dm.c                                   |  11 ++
 drivers/md/dm.h                                   |   2 +
 drivers/md/persistent-data/dm-space-map-common.c  |   6 +-
 drivers/md/raid10.c                               |  12 +-
 drivers/md/raid5.c                                |   5 +-
 drivers/media/dvb/frontends/dib8000.c             |  33 +++--
 drivers/mmc/host/atmel-mci.c                      |  13 +-
 drivers/mtd/nand/mxc_nand.c                       |   1 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  13 +-
 drivers/net/ethernet/via/via-rhine.c              |   1 +
 drivers/net/wireless/b43/b43.h                    |   4 +-
 drivers/net/wireless/b43/main.c                   |  27 ++--
 drivers/net/wireless/b43/xmit.c                   |   4 +-
 drivers/net/wireless/b43legacy/main.c             |   1 +
 drivers/net/wireless/mwifiex/scan.c               |   4 +-
 drivers/net/wireless/rtlwifi/core.c               |  11 ++
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h |  14 +++
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c       |  29 +++--
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c       |  19 ++-
 drivers/net/wireless/rtlwifi/wifi.h               |   1 +
 drivers/net/xen-netfront.c                        |   2 +-
 drivers/parport/parport_pc.c                      |  10 +-
 drivers/pci/xen-pcifront.c                        |   4 +
 drivers/platform/x86/hp_accel.c                   |   1 +
 drivers/scsi/bfa/bfad.c                           |   6 +-
 drivers/staging/comedi/drivers/cb_pcidio.c        |  21 ++--
 drivers/staging/rtl8712/usb_intf.c                |   5 +
 drivers/staging/vt6656/baseband.c                 |   3 -
 drivers/target/iscsi/iscsi_target.c               |  34 +++--
 drivers/tty/serial/8250/8250.c                    |   4 +
 drivers/tty/serial/8250/8250_pci.c                |   4 +
 drivers/tty/serial/amba-pl011.c                   |   6 +
 drivers/tty/serial/atmel_serial.c                 |  20 +--
 drivers/usb/core/config.c                         |   7 --
 drivers/usb/core/hub.c                            |  40 ++----
 drivers/usb/host/xhci.c                           |   3 +
 drivers/usb/serial/cypress_m8.h                   |   2 +-
 drivers/usb/serial/ftdi_sio.c                     |  17 ++-
 drivers/usb/serial/option.c                       |  15 +++
 drivers/usb/storage/unusual_devs.h                |   7 ++
 drivers/video/xen-fbfront.c                       |   4 +
 drivers/xen/xenbus/xenbus_probe_frontend.c        |   2 +-
 fs/btrfs/extent-tree.c                            |   2 +-
 fs/dcache.c                                       |   7 +-
 fs/exofs/ore.c                                    |  37 ++++--
 fs/ext4/inode.c                                   |   6 -
 fs/fs-writeback.c                                 |  15 ++-
 fs/fuse/dev.c                                     |  22 +---
 fs/nfs/nfs4proc.c                                 |   4 +-
 fs/nfs/nfs4xdr.c                                  |  47 ++++---
 fs/nilfs2/segment.c                               |  10 +-
 fs/splice.c                                       |  18 +++
 include/linux/audit.h                             |   2 +-
 include/linux/hugetlb.h                           |   6 +
 include/linux/mm.h                                |   5 +-
 include/linux/pipe_fs_i.h                         |   2 +
 include/scsi/osd_ore.h                            |   1 +
 include/xen/platform_pci.h                        |  23 ++++
 lib/decompress_inflate.c                          |   2 +-
 mm/hugetlb.c                                      |  17 +++
 mm/memory-failure.c                               |  16 ++-
 mm/oom_kill.c                                     |   2 +-
 mm/page-writeback.c                               |  55 ++++-----
 mm/slub.c                                         |   8 +-
 mm/swap.c                                         | 143 +++++++++++++---------
 net/compat.c                                      |   9 +-
 net/core/skbuff.c                                 |  32 +----
 net/ipv4/inet_diag.c                              |   4 +-
 net/ipv4/ipmr.c                                   |   7 +-
 net/ipv6/ip6mr.c                                  |   7 +-
 net/sunrpc/clnt.c                                 |   8 +-
 security/selinux/ss/policydb.c                    |  14 ++-
 sound/pci/Kconfig                                 |  12 ++
 sound/pci/rme9652/rme9652.c                       |   2 +-
 sound/soc/codecs/adau1701.c                       |   2 +-
 tools/perf/util/session.c                         |   7 +-
 tools/power/x86/turbostat/turbostat.c             |  11 +-
 104 files changed, 834 insertions(+), 414 deletions(-)

AKASHI Takahiro (1):
      audit: correct a type mismatch in audit_syscall_exit()

Alex Deucher (3):
      drm/radeon: warn users when hw_i2c is enabled (v2)
      drm/radeon: set the full cache bit for fences on r7xx+
      drm/radeon/DCE4+: clear bios scratch dpms bit (v2)

Alex Williamson (1):
      intel-iommu: fix off-by-one in pagetable freeing

Alexandre Courbot (1):
      lib/decompressors: fix "no limit" output buffer length

Amitkumar Karwar (1):
      mwifiex: add missing endian conversion for fw_tsf

Andrea Arcangeli (1):
      mm: hugetlbfs: fix hugetlbfs optimization

Andreas Rohner (1):
      nilfs2: fix segctor bug that causes file system corruption

Andy Grover (1):
      target/iscsi: Fix network portal creation race

Aristeu Rozanski (1):
      e752x_edac: Fix pci_dev usage count

Boaz Harrosh (1):
      ore: Fix wrong math in allocation of per device BIO

Colin Leitner (1):
      USB: ftdi_sio: added CS5 quirk for broken smartcard readers

Dave Young (1):
      x86/efi: Fix off-by-one bug in EFI Boot Services reservation

David Rientjes (1):
      mm, oom: base root bonus on current usage

Dongsheng Yang (1):
      perf kvm: Fix kvm report without guestmount.

Eric W. Biederman (1):
      vfs: In d_path don't call d_dname on a mount point

Hannes Frederic Sowa (1):
      net: avoid reference counter overflows on fib_rules in multicast forwarding

Heiko Carstens (1):
      KVM: s390: fix diagnose code extraction

Ian Abbott (1):
      staging: comedi: 8255_pci: fix for newer PCI-DIO48H

Ira Weiny (1):
      IB/qib: Fix QP check when looping back to/from QP1

Jack Pham (1):
      usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()

Jan Kara (2):
      ext4: fix deadlock when writing in ENOSPC conditions
      writeback: Fix data corruption on NFS

Jean Delvare (1):
      hwmon: (coretemp) Fix truncated name of alarm attributes

Jean-Jacques Hiblot (1):
      ARM: at91: smc: bug fix in sam9_smc_cs_read()

Jianguo Wu (1):
      mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully

Joe Thornber (1):
      dm space map common: make sure new space is used during extend

Johan Hovold (1):
      USB: cypress_m8: fix ring-indicator detection and reporting

Johannes Weiner (1):
      mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirtyable memory

Jon Medhurst (1):
      serial: amba-pl011: use port lock to guard control register access

Josh Triplett (1):
      turbostat: Use GCC's CPUID functions to support PIC

Konrad Rzeszutek Wilk (1):
      xen/pvhvm: If xen_platform_pci=0 is set don't blow up (v4).

Larry Finger (10):
      rtlwifi: rtl8192cu: Fix W=1 build warning
      rtlwifi: rtl8192cu: Add new firmware
      rtlwifi: Set the link state
      rtlwifi: rtl8192c: Add new definitions in the dm_common header
      rtlwifi: rtl8192cu: Fix some code in RF handling
      staging: r8712u: Set device type to wlan
      rtlwifi: rtl8192cu: Add new device ID
      b43: Fix lockdep splat
      b43: Fix unload oops if firmware is not available
      b43legacy: Fix unload oops if firmware is not available

Lars-Peter Clausen (1):
      ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant

Li Zefan (1):
      slub: Fix calculation of cpu slabs

Ludovic Desroches (1):
      mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA

Luis Henriques (1):
      Linux 3.5.7.30

Malcolm Priestley (1):
      staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity on bScanning

Marek Olšák (1):
      drm/radeon: skip colorbuffer checking if COLOR_INFO.FORMAT is set to INVALID

Marek Roszko (1):
      tty/serial: at91: Handle shutdown more safely

Mark Brown (1):
      ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to regulator API

Mauro Carvalho Chehab (1):
      [media] dib8000: make 32 bits read atomic

Michael Grzeschik (1):
      mtd: mxc_nand: remove duplicated ecc_stats counting

Michal Schmidt (1):
      bnx2x: fix DMA unmapping of TSO split BDs

Michel Dänzer (1):
      radeon/pm: Guard access to rdev->pm.power_state array

Mihai Caraman (1):
      KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()

Mike Snitzer (1):
      dm thin: initialize dm_thin_new_mapping returned by get_next_mapping

Mikhail Zolotaryov (1):
      USB: Nokia 502 is an unusual device

Miklos Szeredi (1):
      fuse: fix pipe_buf_operations

Mikulas Patocka (3):
      mm: fix crash when using XFS on loopback
      dm: wait until embedded kobject is released before destroying a device
      alpha: fix broken network checksum

Neal Cardwell (1):
      inet_diag: fix inet_diag_dump_icsk() timewait socket state logic

NeilBrown (4):
      md/raid5: Fix possible confusion when multiple write errors occur.
      md/raid10: fix two bugs in handling of known-bad-blocks.
      md/raid10: fix bug when raid10 recovery fails to recover a block.
      md/raid5: fix long-standing problem with bitmap handling on write failure.

PaX Team (1):
      x86, x32: Correct invalid use of user timespec in the kernel

Paul Mackerras (1):
      powerpc: Make sure "cache" directory is removed when offlining cpu

Rahul Bedarkar (1):
      USB: serial: add support for iBall 3.5G connect usb modem

Richard Weinberger (1):
      net,via-rhine: Fix tx_timeout handling

Robert Richter (1):
      perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Sebastian Andrzej Siewior (1):
      parport: parport_pc: remove double PCI ID for NetMos

Stephen Warren (1):
      serial: 8250: enable UART_BUG_NOMSR for Tegra

Takashi Iwai (4):
      ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]
      ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks
      hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
      drm/cirrus: correct register values for 16bpp

Tetsuo Handa (1):
      SELinux: Fix memory leak upon loading policy

Thomas Pugliese (1):
      usb: core: get config and string descriptors for unauthorized devices

Trond Myklebust (1):
      NFSv4: OPEN must handle the NFS4ERR_IO return code correctly

Vijaya Mohan Guvva (1):
      [SCSI] bfa: Chinook quad port 16G FC HBA claim issue

Wang Shilong (1):
      Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()

Weston Andros Adamson (2):
      sunrpc: Fix infinite loop in RPC state machine
      nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME

Yegor Yefremov (1):
      serial: add support for 200 v3 series Titan card

ZHAO Gang (1):
      b43: fix the wrong assignment of status.freq in b43_rx()

张君 (1):
      usb: option: add new zte 3g modem pids to option driver


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaBMRon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:44:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaBMRoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:44:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.18
Date: Thu, 13 Feb 2014 09:44:32 -0800
Message-Id: <1392313473-25786-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.18 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.17 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Documentation/devicetree/bindings/ata/marvell.txt |   2 +-
 Documentation/filesystems/proc.txt                |   4 +-
 Makefile                                          |   2 +-
 arch/alpha/lib/csum_partial_copy.c                |   9 +-
 arch/arm/boot/dts/armada-370-xp.dtsi              |   4 +-
 arch/arm/net/bpf_jit_32.c                         |   6 +-
 arch/powerpc/kernel/cacheinfo.c                   |   3 +
 arch/powerpc/net/bpf_jit_comp.c                   |   7 +-
 arch/s390/kvm/diag.c                              |   2 +-
 arch/s390/kvm/kvm-s390.c                          |  23 ++-
 arch/s390/kvm/kvm-s390.h                          |   4 +-
 arch/s390/kvm/sigp.c                              |  19 ++-
 arch/s390/net/bpf_jit_comp.c                      |  29 ++--
 arch/sh/kernel/kgdb.c                             |   1 +
 arch/sparc/net/bpf_jit_comp.c                     |  17 +-
 arch/x86/kvm/i8254.c                              |  18 ++
 arch/x86/kvm/lapic.c                              |   3 -
 arch/x86/kvm/x86.c                                |   3 +
 arch/x86/kvm/x86.h                                |   2 +
 arch/x86/net/bpf_jit_comp.c                       |  14 +-
 arch/x86/platform/efi/efi.c                       |   2 +-
 arch/x86/xen/platform-pci-unplug.c                |  74 ++++++++
 arch/xtensa/platforms/xtfpga/setup.c              |  12 +-
 drivers/acpi/bus.c                                |   9 +
 drivers/ata/libata-core.c                         |  27 +++
 drivers/ata/libata-scsi.c                         |  18 +-
 drivers/ata/sata_mv.c                             |  25 +++
 drivers/block/xen-blkfront.c                      |   4 +-
 drivers/char/tpm/tpm_ppi.c                        |   8 +-
 drivers/edac/e752x_edac.c                         |   4 +-
 drivers/gpu/drm/ast/ast_fb.c                      |   5 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c             |   5 +-
 drivers/gpu/drm/cirrus/cirrus_mode.c              |   4 +-
 drivers/gpu/drm/i915/i915_reg.h                   |  18 +-
 drivers/gpu/drm/i915/intel_dp.c                   |  40 +++--
 drivers/gpu/drm/mgag200/mgag200_fb.c              |   5 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c   |   8 +-
 drivers/gpu/drm/radeon/atombios_crtc.c            |   5 +-
 drivers/gpu/drm/radeon/evergreen_cs.c             |   5 +-
 drivers/gpu/drm/radeon/ni.c                       |  16 +-
 drivers/gpu/drm/radeon/nid.h                      |   1 +
 drivers/gpu/drm/radeon/r600.c                     |  13 +-
 drivers/gpu/drm/radeon/r600_cs.c                  |   5 +-
 drivers/gpu/drm/radeon/r600d.h                    |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c          |   4 +
 drivers/gpu/drm/radeon/radeon_i2c.c               |   3 +
 drivers/gpu/drm/radeon/radeon_pm.c                |   6 +-
 drivers/infiniband/hw/qib/qib_ud.c                |   9 +-
 drivers/input/misc/xen-kbdfront.c                 |   4 +
 drivers/iommu/intel-iommu.c                       |   2 +-
 drivers/md/Kconfig                                |   4 +
 drivers/md/Makefile                               |   1 +
 drivers/md/dm-builtin.c                           |  49 ++++++
 drivers/md/dm-sysfs.c                             |   5 +-
 drivers/md/dm-thin-metadata.c                     |  20 +++
 drivers/md/dm-thin-metadata.h                     |   2 +
 drivers/md/dm-thin.c                              |  72 +++++---
 drivers/md/dm.c                                   |  11 +-
 drivers/md/dm.h                                   |  17 ++
 drivers/md/persistent-data/dm-space-map-common.c  |   6 +-
 drivers/md/raid5.c                                |   1 +
 drivers/media/dvb-frontends/dib8000.c             |  33 +++-
 drivers/media/platform/s5p-mfc/s5p_mfc.c          |  28 +---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h   |   9 -
 drivers/media/usb/dvb-usb-v2/anysee.c             |   3 +-
 drivers/mfd/max77686.c                            |   2 +-
 drivers/mmc/host/atmel-mci.c                      |  13 +-
 drivers/mmc/host/sdhci.c                          |  17 +-
 drivers/mtd/nand/mxc_nand.c                       |   1 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  13 +-
 drivers/net/ethernet/via/via-rhine.c              |   1 +
 drivers/net/wireless/b43/b43.h                    |   4 +-
 drivers/net/wireless/b43/main.c                   |  27 +--
 drivers/net/wireless/b43/xmit.c                   |   4 +-
 drivers/net/wireless/b43legacy/main.c             |   1 +
 drivers/net/wireless/mwifiex/scan.c               |   4 +-
 drivers/net/wireless/rtlwifi/core.c               |  11 ++
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c       |  31 ++--
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c       |  19 ++-
 drivers/net/wireless/rtlwifi/wifi.h               |   1 +
 drivers/net/xen-netfront.c                        |  90 +++-------
 drivers/parport/parport_pc.c                      |  10 +-
 drivers/pci/xen-pcifront.c                        |   4 +
 drivers/platform/x86/hp_accel.c                   |   1 +
 drivers/rtc/rtc-cmos.c                            |  52 +++++-
 drivers/rtc/rtc-max8907.c                         |  11 +-
 drivers/scsi/bfa/bfad.c                           |   6 +-
 drivers/staging/rtl8712/usb_intf.c                |   5 +
 drivers/staging/vt6656/baseband.c                 |   3 -
 drivers/target/iscsi/iscsi_target.c               |  34 ++--
 drivers/tty/serial/8250/8250_pci.c                |   4 +
 drivers/usb/core/hub.c                            |  14 +-
 drivers/usb/host/ehci.h                           |  18 +-
 drivers/usb/host/xhci.c                           |   3 +
 drivers/usb/serial/cypress_m8.h                   |   2 +-
 drivers/usb/serial/ftdi_sio.c                     |  17 +-
 drivers/usb/serial/option.c                       |  15 ++
 drivers/usb/serial/pl2303.c                       |  29 +++-
 drivers/usb/storage/unusual_devs.h                |   7 +
 drivers/video/xen-fbfront.c                       |   4 +
 drivers/xen/xenbus/xenbus_probe_frontend.c        |   2 +-
 fs/btrfs/extent-tree.c                            |   2 +-
 fs/btrfs/ioctl.c                                  |   6 +
 fs/exofs/ore.c                                    |  37 ++--
 fs/ext4/inline.c                                  |   8 +-
 fs/fuse/dev.c                                     |  22 +--
 fs/hpfs/alloc.c                                   |  66 +++++++-
 fs/hpfs/hpfs_fn.h                                 |   2 +-
 fs/hpfs/super.c                                   |  32 +++-
 fs/mount.h                                        |   2 +-
 fs/nfs/nfs4client.c                               |  10 +-
 fs/nfs/nfs4proc.c                                 |   4 +-
 fs/nfs/nfs4xdr.c                                  |  47 ++++--
 fs/splice.c                                       |  18 ++
 include/linux/audit.h                             |   2 +-
 include/linux/libata.h                            |   2 +
 include/linux/pipe_fs_i.h                         |   2 +
 include/linux/vmstat.h                            |   3 -
 include/scsi/osd_ore.h                            |   1 +
 include/xen/platform_pci.h                        |  23 +++
 kernel/audit.c                                    |   5 +-
 kernel/trace/ftrace.c                             | 196 +++++++++++++++-------
 mm/mempolicy.c                                    |  19 ++-
 mm/oom_kill.c                                     |   2 +-
 mm/page-writeback.c                               |  57 +++----
 mm/slub.c                                         |   8 +-
 mm/vmscan.c                                       |  59 +++----
 net/core/filter.c                                 |  30 +---
 net/core/skbuff.c                                 |  32 +---
 net/ieee802154/nl-phy.c                           |   6 +-
 net/ipv4/fib_frontend.c                           |   2 +
 net/ipv4/inet_diag.c                              |   4 +-
 net/ipv4/ip_input.c                               |   2 +-
 net/ipv4/ipmr.c                                   |   7 +-
 net/ipv4/tcp_metrics.c                            |  51 +++---
 net/ipv6/ip6_input.c                              |   2 +-
 net/ipv6/ip6_tunnel.c                             |  12 ++
 net/ipv6/ip6mr.c                                  |   7 +-
 net/ipv6/sit.c                                    |  10 ++
 net/sunrpc/clnt.c                                 |  10 +-
 security/selinux/ss/policydb.c                    |  14 +-
 sound/pci/Kconfig                                 |  12 ++
 sound/pci/rme9652/rme9652.c                       |   2 +-
 sound/soc/codecs/adau1701.c                       |   2 +-
 sound/soc/codecs/wm5110.c                         |  48 ++++++
 tools/perf/util/session.c                         |   7 +-
 tools/power/x86/turbostat/Makefile                |   2 +-
 tools/power/x86/turbostat/turbostat.c             |  13 +-
 148 files changed, 1503 insertions(+), 662 deletions(-)

AKASHI Takahiro (1):
      audit: correct a type mismatch in audit_syscall_exit()

Aisheng Dong (1):
      mmc: sdhci: fix lockdep error in tuning routine

Alan Stern (1):
      USB: fix race between hub_disconnect and recursively_mark_NOTATTACHED

Alex Deucher (5):
      drm/radeon: warn users when hw_i2c is enabled (v2)
      drm/radeon: disable ss on DP for DCE3.x
      drm/radeon: fix surface sync in fence on cayman (v2)
      drm/radeon: set the full cache bit for fences on r7xx+
      drm/radeon/DCE4+: clear bios scratch dpms bit (v2)

Alex Williamson (1):
      intel-iommu: fix off-by-one in pagetable freeing

Amitkumar Karwar (1):
      mwifiex: add missing endian conversion for fw_tsf

Andy Adamson (1):
      SUNRPC: don't map EKEYEXPIRED to EACCES in call_refreshresult

Andy Grover (1):
      target/iscsi: Fix network portal creation race

Annie Li (1):
      xen-netfront: fix resource leak in netfront

Antti Palosaari (1):
      [media] anysee: fix non-working E30 Combo Plus DVB-T

Aristeu Rozanski (1):
      e752x_edac: Fix pci_dev usage count

Boaz Harrosh (1):
      ore: Fix wrong math in allocation of per device BIO

Borislav Petkov (1):
      rtc-cmos: Add an alarm disable quirk

Charles Keepax (1):
      ASoC: wm5110: Extend SYSCLK patch file for rev D

Christian Engelmayer (1):
      ieee802154: Fix memory leak in ieee802154_add_iface()

Christoph Paasch (1):
      tcp: metrics: Avoid duplicate entries with the same destination-IP

Colin Leitner (1):
      USB: ftdi_sio: added CS5 quirk for broken smartcard readers

Cong Ding (1):
      KVM: s390: kvm/sigp.c: fix memory leakage

Dave Airlie (1):
      drm: ast,cirrus,mgag200: use drm_can_sleep

Dave Young (1):
      x86/efi: Fix off-by-one bug in EFI Boot Services reservation

David Rientjes (2):
      mm/mempolicy.c: fix mempolicy printing in numa_maps
      mm, oom: base root bonus on current usage

David Sterba (1):
      btrfs: restrict snapshotting to own subvolumes

Dongsheng Yang (1):
      perf kvm: Fix kvm report without guestmount.

Eric Dumazet (1):
      bpf: do not use reciprocal divide

Eric W. Biederman (1):
      vfs: Is mounted should be testing mnt_ns for NULL or error.

Hannes Frederic Sowa (1):
      net: avoid reference counter overflows on fib_rules in multicast forwarding

Heiko Carstens (2):
      KVM: s390: fix diagnose code extraction
      s390/bpf,jit: fix 32 bit divisions, use unsigned divide instructions

Holger Eitzenberger (1):
      net: Fix memory leak if TPROXY used with TCP early demux

Ilia Mirkin (1):
      drm/nouveau/bios: fix offset calculation for BMPv1 bioses

Ira Weiny (1):
      IB/qib: Fix QP check when looping back to/from QP1

Jack Pham (1):
      usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()

Joe Thornber (2):
      dm thin: fix discard support to a previously shared block
      dm space map common: make sure new space is used during extend

Johan Hovold (2):
      USB: pl2303: fix data corruption on termios updates
      USB: cypress_m8: fix ring-indicator detection and reporting

Johannes Weiner (2):
      mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirtyable memory
      mm/page-writeback.c: do not count anon pages as dirtyable memory

Josh Triplett (2):
      turbostat: Don't put unprocessed uapi headers in the include path
      turbostat: Use GCC's CPUID functions to support PIC

Kamal Mostafa (1):
      Linux 3.8.13.18

Konrad Rzeszutek Wilk (1):
      xen/pvhvm: If xen_platform_pci=0 is set don't blow up (v4).

Krzysztof Kozlowski (1):
      mfd: max77686: Fix regmap resource leak on driver remove

Larry Finger (10):
      rtlwifi: rtl8192cu: Fix W=1 build warning
      rtlwifi: rtl8192cu: Add new firmware
      rtlwifi: Set the link state
      rtlwifi: rtl8192cu: Fix duplicate if test
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

Lior Amsalem (1):
      ata: sata_mv: fix disk hotplug for Armada 370/XP SoCs

Ludovic Desroches (1):
      mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA

Maarten Lankhorst (3):
      drm/ast: do not attempt to acquire a reservation while in an interrupt handler
      drm/cirrus: do not attempt to acquire a reservation while in an interrupt handler
      drm/mgag200: do not attempt to acquire a reservation while in an interrupt handler

Malcolm Priestley (1):
      staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity on bScanning

Marcelo Tosatti (1):
      KVM: x86: limit PIT timer frequency

Marek Olšák (1):
      drm/radeon: skip colorbuffer checking if COLOR_INFO.FORMAT is set to INVALID

Marek Szyprowski (1):
      [media] media: s5p_mfc: remove s5p_mfc_get_node_type() function

Mark Brown (1):
      ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to regulator API

Mauro Carvalho Chehab (1):
      [media] dib8000: make 32 bits read atomic

Max Filippov (1):
      xtensa: xtfpga: fix definitions of platform devices

Mel Gorman (1):
      mm: numa: initialise numa balancing after jump label initialisation

Michael Grzeschik (1):
      mtd: mxc_nand: remove duplicated ecc_stats counting

Michal Schmidt (1):
      bnx2x: fix DMA unmapping of TSO split BDs

Michel Dänzer (1):
      radeon/pm: Guard access to rdev->pm.power_state array

Mike Snitzer (2):
      dm thin: initialize dm_thin_new_mapping returned by get_next_mapping
      dm thin: fix set_pool_mode exposed pool operation races

Mikhail Zolotaryov (1):
      USB: Nokia 502 is an unusual device

Miklos Szeredi (1):
      fuse: fix pipe_buf_operations

Mikulas Patocka (4):
      dm: wait until embedded kobject is released before destroying a device
      dm sysfs: fix a module unload race
      alpha: fix broken network checksum
      hpfs: remember free space

Neal Cardwell (1):
      inet_diag: fix inet_diag_dump_icsk() timewait socket state logic

NeilBrown (1):
      md/raid5: fix long-standing problem with bitmap handling on write failure.

Nicolas Dichtel (3):
      sit: fix double free of fb_tunnel_dev on exit
      Revert "ip6tnl: fix use after free of fb_tnl_dev"
      ip6tnl: fix double free of fb_tnl_dev on exit

Oliver Hartkopp (1):
      fib_frontend: fix possible NULL pointer dereference

Paul Mackerras (1):
      powerpc: Make sure "cache" directory is removed when offlining cpu

Peter Chen (1):
      usb: ehci: add freescale imx28 special write register method

Peter Huewe (1):
      tpm/tpm_ppi: Do not compare strcmp(a,b) == -1

Rahul Bedarkar (1):
      USB: serial: add support for iBall 3.5G connect usb modem

Richard Guy Briggs (1):
      audit: reset audit backlog wait time after error recovery

Richard Weinberger (1):
      net,via-rhine: Fix tx_timeout handling

Sebastian Andrzej Siewior (1):
      parport: parport_pc: remove double PCI ID for NetMos

Simon Guinot (2):
      ata: sata_mv: introduce compatible string "marvell, armada-370-sata"
      ARM: mvebu: update the SATA compatible string for Armada 370/XP

Stephen Warren (1):
      rtc: max8907: weekday encoding fixes

Steven Rostedt (1):
      ftrace: Use schedule_on_each_cpu() as a heavy synchronize_sched()

Steven Rostedt (Red Hat) (3):
      ftrace: Check module functions being traced on reload
      ftrace: Fix function graph with loading of modules
      ftrace: Fix synchronization location disabling and freeing ftrace_ops

Takashi Iwai (4):
      ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]
      ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks
      hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
      drm/cirrus: correct register values for 16bpp

Tejun Heo (1):
      libata: disable LPM for some WD SATA-I devices

Tetsuo Handa (1):
      SELinux: Fix memory leak upon loading policy

Theodore Ts'o (1):
      ext4: avoid clearing beyond i_blocks when truncating an inline data file

Thomas Huth (1):
      KVM: s390: Always store status during SIGP STOP_AND_STORE_STATUS

Thomas Petazzoni (1):
      arm: mvebu: fix length of SATA registers area in .dtsi

Todd Previte (1):
      drm/i915: VLV2 - Fix hotplug detect bits

Trond Myklebust (1):
      NFSv4: OPEN must handle the NFS4ERR_IO return code correctly

Vijaya Mohan Guvva (1):
      [SCSI] bfa: Chinook quad port 16G FC HBA claim issue

Wang Shilong (1):
      Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()

Wanlong Gao (1):
      arch/sh/kernel/kgdb.c: add missing #include <linux/sched.h>

Weston Andros Adamson (3):
      sunrpc: Fix infinite loop in RPC state machine
      nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME
      nfs4: fix discover_server_trunking use after free

Yegor Yefremov (1):
      serial: add support for 200 v3 series Titan card

ZHAO Gang (1):
      b43: fix the wrong assignment of status.freq in b43_rx()

张君 (1):
      usb: option: add new zte 3g modem pids to option driver


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3HUUyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:54:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3HUUyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:54:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.7
Date: Wed, 21 Aug 2013 13:54:30 -0700
Message-Id: <1377118471-8005-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.7 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.6 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                           |   2 +-
 arch/Kconfig                                       |   6 +
 arch/arm/Kconfig                                   |   4 +-
 arch/arm/include/asm/a.out-core.h                  |  45 ------
 arch/arm/include/asm/mmu.h                         |   2 +
 arch/arm/include/asm/mmu_context.h                 |  20 ++-
 arch/arm/include/asm/processor.h                   |   4 -
 arch/arm/include/asm/thread_info.h                 |   1 -
 arch/arm/include/uapi/asm/Kbuild                   |   1 -
 arch/arm/include/uapi/asm/a.out.h                  |  34 ----
 arch/arm/kernel/entry-armv.S                       |  99 ++++++------
 arch/arm/kernel/perf_event.c                       |   7 +-
 arch/arm/kernel/traps.c                            |  14 +-
 arch/arm/kernel/vmlinux.lds.S                      |  17 ++
 arch/arm/mach-footbridge/dc21285.c                 |   2 -
 arch/arm/mm/mmu.c                                  |  10 +-
 arch/microblaze/Kconfig                            |   2 +-
 arch/powerpc/Kconfig                               |   2 +-
 arch/s390/include/asm/bitops.h                     |   2 +-
 arch/s390/kvm/kvm-s390.c                           |  21 ++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   4 +-
 arch/x86/kernel/early-quirks.c                     |  14 +-
 arch/x86/kernel/i387.c                             |   2 +-
 drivers/acpi/battery.c                             |   2 +
 drivers/acpi/proc.c                                |  17 +-
 drivers/ata/ata_piix.c                             |   2 +-
 drivers/char/virtio_console.c                      |  70 ++++++---
 drivers/cpuidle/governors/menu.c                   |  98 +-----------
 drivers/firewire/core-cdev.c                       |   3 +
 drivers/firewire/ohci.c                            |  10 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |   1 +
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |   1 +
 drivers/gpu/drm/drm_irq.c                          |   5 +-
 drivers/gpu/drm/i915/i915_dma.c                    |   2 +
 drivers/gpu/drm/i915/i915_drv.h                    |   1 +
 drivers/gpu/drm/i915/i915_reg.h                    |  12 +-
 drivers/gpu/drm/i915/intel_display.c               |  23 ++-
 drivers/gpu/drm/i915/intel_panel.c                 |  11 ++
 drivers/gpu/drm/i915/intel_pm.c                    |   8 +-
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |   1 +
 drivers/gpu/drm/nouveau/nv10_fence.c               |   2 +-
 drivers/gpu/drm/nouveau/nv50_fence.c               |  14 +-
 drivers/gpu/drm/radeon/atom.c                      |   5 +
 drivers/gpu/drm/radeon/atombios_dp.c               |  43 ++++-
 drivers/gpu/drm/radeon/radeon_combios.c            | 159 ++++++-------------
 drivers/hwmon/adt7470.c                            |   2 +-
 drivers/input/mouse/elantech.c                     |  17 +-
 drivers/macintosh/windfarm_rm31.c                  |  18 +--
 drivers/md/raid10.c                                |   8 +-
 drivers/md/raid5.c                                 |  15 +-
 drivers/md/raid5.h                                 |   1 +
 drivers/net/arcnet/arcnet.c                        |   2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c.h         |   3 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  40 ++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c |   3 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   2 +-
 drivers/net/ethernet/realtek/8139cp.c              |  48 +++++-
 drivers/net/usb/smsc75xx.c                         |  12 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   1 +
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  19 ++-
 drivers/net/wireless/iwlwifi/pcie/drv.c            |   1 +
 drivers/net/wireless/mwifiex/sdio.c                |   4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  18 ++-
 drivers/scsi/isci/task.c                           |   9 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  20 ++-
 drivers/scsi/qla2xxx/qla_iocb.c                    |  11 +-
 drivers/scsi/scsi.c                                |   3 +
 drivers/scsi/sd.c                                  |  22 +--
 drivers/spi/spi-davinci.c                          |   2 +-
 drivers/staging/android/logger.c                   |   4 +-
 drivers/staging/comedi/comedi_fops.c               |  32 ++--
 drivers/tty/serial/arc_uart.c                      |   2 +-
 drivers/tty/serial/mxs-auart.c                     |  40 +++--
 drivers/usb/core/hub.c                             |   9 ++
 drivers/usb/dwc3/core.h                            |   4 +-
 drivers/usb/dwc3/gadget.c                          |   1 +
 drivers/usb/host/ehci-hub.c                        |   1 +
 drivers/usb/host/xhci-pci.c                        |   1 -
 drivers/usb/host/xhci-ring.c                       |   2 +-
 drivers/usb/host/xhci.c                            |  13 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |   1 +
 drivers/usb/serial/cp210x.c                        |   4 +
 drivers/usb/serial/ftdi_sio.c                      |  31 +++-
 drivers/usb/serial/ftdi_sio_ids.h                  |  34 +++-
 drivers/usb/serial/mos7840.c                       | 175 ++++++++++++---------
 drivers/usb/serial/option.c                        |  23 +--
 drivers/usb/serial/ti_usb_3410_5052.c              |   2 +-
 drivers/usb/storage/unusual_devs.h                 |   7 +
 fs/btrfs/tree-log.c                                |   5 +-
 fs/cifs/cifsencrypt.c                              |   2 +-
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/connect.c                                  |   7 +-
 fs/cifs/readdir.c                                  |   8 +
 fs/cifs/sess.c                                     |   6 +-
 fs/ext4/extents.c                                  |   2 +-
 fs/ext4/ialloc.c                                   |  10 +-
 fs/ext4/super.c                                    |  20 ++-
 fs/nfsd/vfs.c                                      |   5 +-
 fs/proc/task_mmu.c                                 |   8 +-
 include/linux/firewire.h                           |   1 +
 include/linux/regmap.h                             |   1 +
 include/linux/syscalls.h                           |   5 +
 include/linux/tick.h                               |   6 -
 include/linux/user_namespace.h                     |   1 +
 include/net/ndisc.h                                |   2 +-
 include/uapi/linux/firewire-cdev.h                 |   4 +-
 kernel/fork.c                                      |   6 +
 kernel/sched/fair.c                                |   1 +
 kernel/time/tick-sched.c                           |   4 -
 kernel/user_namespace.c                            |  17 +-
 mm/mempolicy.c                                     |   6 +-
 net/ipv4/sysctl_net_ipv4.c                         |   6 +-
 net/ipv6/ip6mr.c                                   |   5 +
 net/key/af_key.c                                   |   4 +
 net/mac80211/cfg.c                                 |   2 +
 net/mac80211/rx.c                                  |  10 +-
 net/sched/sch_atm.c                                |   1 +
 net/sched/sch_cbq.c                                |   1 +
 net/wireless/nl80211.c                             |   7 +-
 sound/core/compress_offload.c                      |   2 +-
 sound/soc/codecs/max98088.c                        |   2 +-
 sound/usb/6fire/comm.c                             |  38 ++++-
 sound/usb/6fire/comm.h                             |   2 +-
 sound/usb/6fire/pcm.c                              |   2 +-
 sound/usb/endpoint.c                               |  13 +-
 tools/hv/hv_kvp_daemon.c                           |   5 +-
 127 files changed, 1007 insertions(+), 697 deletions(-)

Aaro Koskinen (1):
      powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31)

Alex Deucher (3):
      drm/radeon: fix endian issues with DP handling (v3)
      drm/radeon: improve dac adjust heuristics for legacy pdac
      drm/radeon/atom: initialize more atom interpretor elements to 0

Alexandr \\\"Sky\\\" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Amit Shah (5):
      virtio: console: fix race with port unplug and open/close
      virtio: console: fix race in port_fops_open() and port unplug
      virtio: console: clean up port data immediately at time of unplug
      virtio: console: fix raising SIGIO after port unplug
      virtio: console: return -ENODEV on all read operations after unplug

Andreas Fleig (1):
      ACPI / PM: Fix /proc/acpi/wakeup for devices w/o bus or parent

Anton Blanchard (1):
      powerpc: On POWERNV enable PPC_DENORMALISATION by default

Axel Lin (1):
      serial: arc_uart: Fix module alias

Barry Grussling (1):
      usb: cp210x support SEL C662 Vendor/Device

Ben Widawsky (1):
      drm/i915: fix missed hunk after GT access breakage

Bjørn Mork (1):
      usb: option: add TP-LINK MA260

Catalin Marinas (1):
      ARM: 7790/1: Fix deferred mm switch on VIVT processors

Chen Gang (1):
      cifs: extend the buffer length enought for sprintf() using

Chih-Chung Chang (1):
      ASoC: max98088 - fix element type of the register cache.

Christian Eggers (1):
      spi: spi-davinci: Fix direction in dma_map_single()

Clemens Ladisch (2):
      firewire: fix libdc1394/FlyCap2 iso event regression
      ALSA: usb-audio: do not trust too-big wMaxPacketSize values

Curt Brune (1):
      hwmon: (adt7470) Fix incorrect return code check

Dan Carpenter (3):
      arcnet: cleanup sizeof parameter
      af_key: more info leaks in pfkey messages
      net_sched: info leak in atm_tc_dump_class()

Dan Williams (1):
      usb: serial: option: add Olivetti Olicard 200

Daniil Bolsun (1):
      USB: option: append Petatel NP10T device to GSM modems list

Dave Airlie (1):
      drm/ast: invalidate page tables when pinning a BO

David S. Miller (1):
      net_sched: Fix stack info leak in cbq_dump_wrr().

Dominik Dingel (1):
      KVM: s390: move kvm_guest_enter,exit closer to sie

Egbert Eich (1):
      drm/mgag200: Invalidate page tables when pinning a BO

Eldad Zack (1):
      ALSA: usb-audio: 6fire: return correct XRUN indication

Emmanuel Grumbach (1):
      iwlwifi: add DELL SKU for 5150 HMC

Enrico Mioso (3):
      usb: serial: option: Add ONYX 3G device support
      usb: serial: option: blacklist ONDA MT689DC QMI interface
      usb: serial: option.c: remove ONDA MT825UP product ID fromdriver

Eric Dumazet (2):
      usbnet: do not pretend to support SG/TSO
      atl1c: use custom skb allocator

Eric Sandeen (1):
      ext4: destroy ext4_es_cachep on module unload

Ewan D. Milne (1):
      [SCSI] sd: fix crash when UA received on DIF enabled device

Felipe Balbi (1):
      usb: dwc3: gadget: don't prevent gadget from being probed if we fail

George Cherian (1):
      usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0

H.J. Lu (1):
      x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz

Hannes Frederic Sowa (1):
      ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanup

Harshula Jayasuriya (1):
      nfsd: nfsd_open: when dentry_open returns an error do not propagate as struct file

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_type

Ian Abbott (2):
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
      staging: comedi: fix a race between do_cmd_ioctl() and read/write

Jack Morgenstein (1):
      net/mlx4_core: VFs must ignore the enable_64b_cqe_eqe module param

Jacob Keller (1):
      ixgbe: Fix Tx Hang issue with lldpad on 82598EB

Jani Nikula (2):
      drm/i915: initialize gt_lock early with other spin locks
      drm/i915: do not disable backlight on vgaswitcheroo switch off

Jeff Layton (1):
      cifs: don't instantiate new dentries in readdir for inodes that need to be revalidated immediately

Jeff Skirvin (1):
      [SCSI] isci: Fix a race condition in the SSP task management path

Joe Perches (1):
      ndisc: Add missing inline to ndisc_addr_option_pad

Johan Hovold (6):
      USB: ti_usb_3410_5052: fix dynamic-id matching
      USB: mos7840: fix memory leak in open
      USB: mos7840: fix race in register handling
      USB: mos7840: fix device-type detection
      USB: mos7840: fix race in led handling
      USB: mos7840: fix pointer casts

Johannes Berg (3):
      mac80211: fix ethtool stats for non-station interfaces
      mac80211: fix duplicate retransmission detection
      iwlwifi: mvm: refuse connection to APs with BI < 16

Josef Bacik (1):
      Btrfs: release both paths before logging dir/changed extents

Jussi Kivilinna (1):
      ALSA: 6fire: fix DMA issues with URB transfer_buffer usage

Jóhann B. Guðmundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

K. Y. Srinivasan (1):
      Tools: hv: KVP: Fix a bug in IPV6 subnet enumeration

Kamal Mostafa (1):
      Linux 3.8.13.7

Karlis Ogsts (1):
      staging: android: logger: Correct write offset reset on error

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value

Luiz Angelo Daros de Luca (1):
      usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial adapter

Maarten Lankhorst (1):
      drm/nouveau: fix semaphore dmabuf obj

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards

Martin K. Petersen (1):
      [SCSI] Don't attempt to send extended INQUIRY command if skip_vpd_pages is set

Martin Schwidefsky (1):
      s390/bitops: fix find_next_bit_left

Mateusz Krawczuk (1):
      regmap: Add missing header for !CONFIG_REGMAP stubs

Matteo Delfino (1):
      Input: elantech - fix for newer hardware versions (v7)

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns

Michal Simek (1):
      microblaze: fix clone syscall

Michal Srb (1):
      drm/cirrus: Invalidate page tables when pinning a BO

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary

Michel Dänzer (1):
      drm: Don't pass negative delta to ktime_sub_ns()

Mike Frysinger (1):
      ARM: footbridge: fix overlapping PCI mappings

Neil Horman (2):
      x86/iommu/vt-d: Expand interrupt remapping quirk to cover x58 chipset
      8139cp: Add dma_mapping_error checking

NeilBrown (2):
      md/raid10: remove use-after-free bug.
      md/raid5: fix interaction of 'replace' and 'recovery'.

Oleg Nesterov (3):
      mm: mempolicy: fix mbind_range() && vma_adjust() interaction
      userns: unshare_userns(&cred) should not populate cred on failure
      userns: limit the maximum depth of user_namespace->parent chain

Oleksij Rempel (3):
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings
      ath9k_htc: do some initial hardware configuration
      ath9k_htc: reboot firmware if it was loaded

Ondrej Zary (1):
      drm/radeon: Another card with wrong primary dac adj

Peter Zijlstra (1):
      sched: Ensure update_cfs_shares() is called for parents of continuously-running tasks

Piotr Sarna (1):
      ext4: fix mount/remount error messages for incompatible mount options

Rafael J. Wysocki (3):
      Revert "cpuidle: Quickly notice prediction failure in general case"
      Revert "cpuidle: Quickly notice prediction failure for repeat mode"
      ACPI / PM: Walk physical_node_list under physical_node_lock

Ren Bigcren (1):
      USB: storage: Add MicroVault Flash Drive to unusual_devs

Rick Farina (Zero_Chaos) (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices

Roger Quadros (1):
      USB: EHCI: Fix resume signalling on remote wakeup

Russell King (4):
      ARM: poison the vectors page
      ARM: poison memory between kuser helpers
      ARM: move vector stubs
      ARM: use linker magic for vectors and vector stubs

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.

Saurav Kashyap (1):
      [SCSI] qla2xxx: Properly set the tagging for commands.

Stanislaw Gruszka (1):
      rt2x00: fix stop queue

Stephen Boyd (1):
      perf/arm: Fix armpmu_map_hw_event()

Sumit.Saxena@lsi.com (1):
      [SCSI] megaraid_sas: megaraid_sas driver init fails in kdump kernel

Theodore Ts'o (3):
      ext4: make sure group number is bumped after a inode allocation race
      ext4: fix retry handling in ext4_ext_truncate()
      ext4: allow the mount options nodelalloc and data=journal

Tomasz Moń (1):
      mwifiex: Add missing endian conversion.

Uwe Kleine-König (2):
      serial/mxs-auart: fix race condition in interrupt handler
      serial/mxs-auart: increase time to wait for transmitter to become idle

Ville Syrjälä (1):
      drm/i915: Make data/link N value power of two

Vince Weaver (1):
      perf/x86: Fix intel QPI uncore event definitions

Vinod Koul (1):
      ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION

Will Deacon (1):
      ARM: 7791/1: a.out: remove partial a.out support

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.

Wolfram Sang (1):
      serial: mxs: fix buffer overflow

Yoshihiro YUNOMAE (2):
      virtio/console: Quit from splice_write if pipe->nrbufs is 0
      virtio/console: Add pipe_lock/unlock for splice_write

Youquan Song (1):
      ata: Fix DVD not dectected at some platform with Wellsburg PCH

yonghua zheng (1):
      fs/proc/task_mmu.c: fix buffer overflow in add_page_map()


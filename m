Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935191AbaGRVOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:14:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47729 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422847AbaGRVOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:14:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.13.y.z extended stable] Linux 3.13.11.5
Date: Fri, 18 Jul 2014 14:14:23 -0700
Message-Id: <1405718064-15207-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.13.11.5 kernel.

The updated 3.13.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.13.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.13.y;a=shortlog

The diff from v3.13.11.4 is posted as a follow-up to this email.

The 3.13.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Documentation/sysctl/vm.txt                        |   3 +-
 Documentation/vm/hwpoison.txt                      |   5 +
 Makefile                                           |   2 +-
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts   |   2 +-
 arch/arm/kernel/stacktrace.c                       |  18 +-
 arch/arm/mm/hugetlbpage.c                          |   5 -
 arch/arm64/include/asm/Kbuild                      |   1 -
 arch/arm64/include/asm/dma-mapping.h               |   2 -
 arch/arm64/include/uapi/asm/posix_types.h          |  10 +
 arch/arm64/kernel/entry.S                          |   1 -
 arch/arm64/kernel/ptrace.c                         |  32 ++-
 arch/arm64/mm/hugetlbpage.c                        |   5 -
 arch/ia64/hp/common/sba_iommu.c                    |  64 +++---
 arch/ia64/mm/hugetlbpage.c                         |   5 -
 arch/metag/mm/hugetlbpage.c                        |   5 -
 arch/mips/kernel/irq-msc01.c                       |   2 +-
 arch/mips/kvm/kvm_mips.c                           |   2 +-
 arch/mips/mm/hugetlbpage.c                         |   5 -
 arch/powerpc/include/asm/switch_to.h               |   8 +-
 arch/powerpc/include/asm/systbl.h                  |   2 +-
 arch/powerpc/include/uapi/asm/cputable.h           |   1 +
 arch/powerpc/kernel/cputable.c                     |   3 +-
 arch/powerpc/kernel/entry_64.S                     |   6 -
 arch/powerpc/kernel/legacy_serial.c                |  15 +-
 arch/powerpc/kernel/process.c                      |   8 +-
 arch/powerpc/kernel/setup-common.c                 |  10 +-
 arch/powerpc/mm/hash_utils_64.c                    |  31 ++-
 arch/powerpc/mm/hugetlbpage.c                      |  10 -
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   1 +
 arch/s390/include/asm/lowcore.h                    |  11 +-
 arch/s390/kernel/time.c                            |   2 +-
 arch/s390/mm/hugetlbpage.c                         |   5 -
 arch/sh/mm/hugetlbpage.c                           |   5 -
 arch/sparc/mm/hugetlbpage.c                        |   5 -
 arch/tile/mm/hugetlbpage.c                         |   5 -
 arch/x86/Kconfig                                   |   4 +
 arch/x86/kernel/entry_32.S                         |  15 +-
 arch/x86/kvm/lapic.c                               |  62 ++++--
 arch/x86/mm/hugetlbpage.c                          |  10 -
 arch/x86/syscalls/syscall_64.tbl                   |   6 +-
 block/blk-cgroup.c                                 |   7 +-
 block/blk-cgroup.h                                 |  17 +-
 drivers/acpi/acpica/utstring.c                     |   2 +-
 drivers/acpi/bus.c                                 |   7 +
 drivers/acpi/video_detect.c                        |   8 +
 drivers/ata/ahci.c                                 |   4 +
 drivers/base/dma-contiguous.c                      |  12 +-
 drivers/base/power/opp.c                           |   4 +-
 drivers/block/mtip32xx/mtip32xx.c                  | 123 ++++++++---
 drivers/block/rbd.c                                |  19 +-
 drivers/block/virtio_blk.c                         |   9 +-
 drivers/bluetooth/hci_ldisc.c                      |  24 +-
 drivers/bluetooth/hci_uart.h                       |   1 +
 drivers/extcon/extcon-max77693.c                   |   4 +-
 drivers/extcon/extcon-max8997.c                    |   2 +-
 drivers/firmware/efi/efi-pstore.c                  |   2 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |   2 +
 drivers/gpu/drm/i915/i915_irq.c                    |  18 +-
 drivers/gpu/drm/i915/intel_pm.c                    |   3 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   2 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   4 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c      |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c      |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c      |   2 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |  17 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |  48 ++--
 drivers/gpu/drm/radeon/atombios_dp.c               |  17 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   5 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   2 +-
 drivers/gpu/vga/vga_switcheroo.c                   |   3 +-
 drivers/hid/hid-core.c                             |  12 +-
 drivers/hv/connection.c                            |   4 +-
 drivers/hv/hv_balloon.c                            |  29 ++-
 drivers/hwmon/ina2xx.c                             |   7 +-
 drivers/iio/adc/at91_adc.c                         |  16 +-
 drivers/iio/adc/max1363.c                          |  16 +-
 drivers/iio/magnetometer/ak8975.c                  |   9 +-
 drivers/infiniband/core/user_mad.c                 |  75 ++++---
 drivers/infiniband/hw/cxgb4/cq.c                   |   3 +-
 drivers/infiniband/hw/cxgb4/user.h                 |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c           |   4 +
 drivers/infiniband/hw/mlx5/cq.c                    |  13 +-
 drivers/infiniband/hw/mlx5/srq.c                   |  14 +-
 drivers/infiniband/hw/mlx5/user.h                  |   2 +
 drivers/infiniband/hw/qib/qib_mad.c                |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  61 +++---
 drivers/infiniband/ulp/isert/ib_isert.h            |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   6 +
 drivers/input/mouse/elantech.c                     |  27 ++-
 drivers/md/dm-thin.c                               |   3 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |   2 +
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |   6 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   8 +
 drivers/media/usb/uvc/uvc_video.c                  |  15 +-
 drivers/misc/mei/hw-me.c                           |  26 ++-
 drivers/mtd/nand/fsl_elbc_nand.c                   |  14 ++
 drivers/mtd/nand/omap2.c                           |   2 +-
 drivers/mtd/nand/pxa3xx_nand.c                     |   4 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c          |   4 +-
 drivers/net/wireless/b43/xmit.c                    |  10 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  26 ++-
 drivers/net/wireless/rt2x00/rt2500pci.c            |   7 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |   1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c            |  24 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   2 +
 drivers/pci/quirks.c                               |   1 +
 drivers/rtc/rtc-at91rm9200.c                       |  16 +-
 drivers/scsi/hpsa.c                                |  12 +
 drivers/staging/iio/light/tsl2x7x_core.c           |   8 +-
 drivers/staging/mt29f_spinand/mt29f_spinand.c      |   1 +
 drivers/target/iscsi/iscsi_target.c                |  19 +-
 drivers/target/iscsi/iscsi_target_auth.c           |  10 +
 drivers/target/iscsi/iscsi_target_login.c          |  13 +-
 drivers/target/iscsi/iscsi_target_util.c           |   2 +
 drivers/target/target_core_device.c                |   1 +
 drivers/target/target_core_sbc.c                   |   4 +-
 drivers/target/target_core_spc.c                   |   9 +-
 drivers/target/target_core_transport.c             |  29 ++-
 drivers/usb/dwc3/gadget.c                          |   4 +
 drivers/usb/host/pci-quirks.c                      |  19 +-
 drivers/usb/misc/usbtest.c                         |  10 +
 drivers/usb/serial/qcserial.c                      |  21 ++
 drivers/video/offb.c                               |  11 +-
 drivers/watchdog/ath79_wdt.c                       |  10 +
 drivers/watchdog/kempld_wdt.c                      |   2 +-
 drivers/watchdog/sp805_wdt.c                       |   4 +-
 fs/aio.c                                           |   6 +-
 fs/attr.c                                          |   8 +-
 fs/btrfs/extent_io.c                               |   1 +
 fs/btrfs/ioctl.c                                   |   6 +-
 fs/cifs/cifs_unicode.c                             |   7 +-
 fs/cifs/smb2pdu.c                                  |   7 +-
 fs/eventpoll.c                                     |   4 +-
 fs/ext4/ext4.h                                     |   3 +-
 fs/ext4/inode.c                                    |   6 +-
 fs/ext4/mballoc.c                                  |   2 +-
 fs/ext4/page-io.c                                  |  32 +--
 fs/inode.c                                         |  10 +-
 fs/namei.c                                         |  11 +-
 fs/nfs/inode.c                                     |  26 ++-
 fs/nfs/super.c                                     |   1 +
 fs/nfs/write.c                                     |   4 +-
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nfsd/nfs4xdr.c                                  |   4 +-
 fs/reiserfs/inode.c                                |   8 +-
 fs/ubifs/file.c                                    |   3 +-
 fs/ubifs/shrinker.c                                |   1 -
 fs/xfs/xfs_ioctl.c                                 |   2 +-
 include/linux/capability.h                         |   2 +-
 include/linux/hugetlb.h                            |  13 +-
 include/linux/init_task.h                          |   2 +
 include/linux/irqdesc.h                            |   4 +
 include/linux/mempolicy.h                          |   6 +
 include/linux/mmzone.h                             |   6 +-
 include/linux/page-flags.h                         |  12 +-
 include/linux/pageblock-flags.h                    |  37 +++-
 include/linux/ptrace.h                             |  32 +++
 include/linux/sched.h                              |  12 +
 include/sound/core.h                               |   2 +
 include/target/iscsi/iscsi_transport.h             |   3 +-
 include/target/target_core_backend.h               |   1 +
 include/uapi/sound/compress_offload.h              |   2 +-
 kernel/auditsc.c                                   |  27 ++-
 kernel/capability.c                                |  20 +-
 kernel/exit.c                                      |   1 +
 kernel/fork.c                                      |  17 +-
 kernel/irq/manage.c                                |   4 +-
 kernel/irq/spurious.c                              | 106 ++++++++-
 kernel/kthread.c                                   |   4 +-
 kernel/locking/rtmutex-debug.h                     |   5 +
 kernel/locking/rtmutex.c                           | 243 ++++++++++++++++++---
 kernel/locking/rtmutex.h                           |   5 +
 kernel/sysctl.c                                    |   3 +-
 kernel/watchdog.c                                  |   2 -
 lib/idr.c                                          |   8 +-
 lib/lz4/lz4_decompress.c                           |   6 +-
 lib/lzo/lzo1x_decompress_safe.c                    |  62 ++++--
 mm/Kconfig                                         |   3 +
 mm/hugetlb.c                                       |  71 +++---
 mm/memcontrol.c                                    |   5 +-
 mm/memory-failure.c                                |  73 +++++--
 mm/mempolicy.c                                     |  46 ++--
 mm/page-writeback.c                                |  11 +-
 mm/page_alloc.c                                    |  92 +++++---
 mm/rmap.c                                          |   8 +-
 mm/vmscan.c                                        |  46 +++-
 net/bluetooth/hci_conn.c                           |  11 +-
 net/bluetooth/hci_event.c                          |  11 +-
 net/bluetooth/l2cap_sock.c                         |  10 +-
 net/bluetooth/mgmt.c                               |   7 +-
 net/bluetooth/smp.c                                |   9 +-
 net/ipv6/udp.c                                     |   8 +-
 net/mac80211/debugfs_netdev.c                      |   6 +-
 net/mac80211/ibss.c                                |   1 +
 net/mac80211/sta_info.c                            |   1 +
 net/netfilter/nf_nat_core.c                        |  35 ++-
 net/sunrpc/svc_xprt.c                              |   2 +
 scripts/package/builddeb                           |   6 +-
 scripts/recordmcount.h                             |   4 +-
 security/integrity/evm/evm_main.c                  |  12 +-
 sound/core/control.c                               |  78 ++++---
 sound/core/init.c                                  |   1 +
 sound/pci/hda/hda_intel.c                          |  63 +++++-
 sound/pci/hda/patch_hdmi.c                         |   2 +-
 sound/pci/hda/patch_realtek.c                      |  71 ++++++
 sound/soc/codecs/max98090.c                        |   3 +
 sound/soc/codecs/tlv320aic3x.c                     |   2 +-
 sound/usb/card.c                                   |  13 +-
 sound/usb/endpoint.c                               |  17 +-
 sound/usb/endpoint.h                               |   1 +
 sound/usb/pcm.c                                    |   3 +-
 tools/testing/selftests/powerpc/Makefile           |   2 +-
 tools/testing/selftests/powerpc/tm/Makefile        |  15 ++
 .../testing/selftests/powerpc/tm/tm-resched-dscr.c |  90 ++++++++
 215 files changed, 2227 insertions(+), 843 deletions(-)

Alan Stern (1):
      USB: EHCI: avoid BIOS handover on the HASEE E200

Aleksander Morgado (2):
      usb: qcserial: add Netgear AirCard 341U
      usb: qcserial: add additional Sierra Wireless QMI devices

Alessandro Miceli (2):
      [media] rtl28xxu: add [1b80:d39d] Sveon STV20
      [media] rtl28xxu: add [1b80:d3af] Sveon STV27

Alex Deucher (5):
      vgaswitcheroo: switch the mux to the igp on power down when runpm is enabled
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
      drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
      drm/radeon/atom: fix dithering on certain panels
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi

Alex Elder (1):
      rbd: use reference counts for image requests

Alex Smith (1):
      recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in modules

Andreas Schrägle (1):
      ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Andrzej Zaborowski (1):
      efi-pstore: Fix an overflow on 32-bit builds

Andy Lutomirski (3):
      auditsc: audit_krule mask accesses need bounds checking
      fs,userns: Change inode_capable to capable_wrt_inode_uidgid
      x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Anton Blanchard (1):
      powerpc: 64bit sendfile is capped at 2GB

Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write

Asai Thambi S P (3):
      mtip32xx: Increase timeout for STANDBY IMMEDIATE command
      mtip32xx: Remove dfs_parent after pci unregister
      mtip32xx: Fix ERO and NoSnoop values in PCIe upstream on AMD systems

Bart Van Assche (3):
      IB/srp: Fix a sporadic crash triggered by cable pulling
      IB/umad: Fix error handling
      IB/umad: Fix use-after-free on close

Benjamin Herrenschmidt (3):
      powerpc/serial: Use saner flags when creating legacy ports
      powerpc: Add AT_HWCAP2 to indicate V.CRYPTO category support
      Revert "offb: Add palette hack for little endian"

Benjamin LaHaise (2):
      aio: fix aio request leak when events are reaped by userspace
      aio: fix kernel memory disclosure in io_getevents() introduced in v3.10

Boris BREZILLON (1):
      rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq

Brian Healy (1):
      [media] rtl28xxu: add 1b80:d395 Peak DVB-T USB

Chander Kashyap (1):
      PM / OPP: fix incorrect OPP count handling in of_init_opp_table

ChiaHao (1):
      arm64: Bug fix in stack alignment exception

Chris Mason (1):
      Btrfs: fix double free in find_lock_delalloc_range

Chris Wilson (3):
      drm/i915: Disable FBC by default also on Haswell and later
      drm/i915: Reorder semaphore deadlock check
      drm/i915: Hold the table lock whilst walking the file's idr and counting the objects in debugfs

Christian Borntraeger (1):
      s390/lowcore: reserve 96 bytes for IRB in lowcore

Christoph Hellwig (1):
      nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer

Dan Carpenter (1):
      iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()

David Binderman (1):
      ACPICA: utstring: Check array index bound before use.

David Henningsson (1):
      ALSA: hda - Add quirk for external mic on Lifebook U904

David Rientjes (1):
      mm, pcp: allow restoring percpu_pagelist_fraction default

Dennis Dalessandro (1):
      IB/ipath: Translate legacy diagpkt into newer extended diagpkt

Don Zickus (1):
      kernel/watchdog.c: remove preemption restrictions when restarting lockup detector

Edward Lin (1):
      ACPI / video: Add Dell Inspiron 5737 to the blacklist

Emmanuel Grumbach (1):
      iwlwifi: pcie: try to get ownership several times

Fabio Baltieri (1):
      hwmon: (ina2xx) Cast to s16 on shunt and current regs

Fathi Boudra (1):
      builddeb: use $OBJCOPY variable instead of objcopy

Felipe Balbi (2):
      usb: dwc3: gadget: clear stall when disabling endpoint
      bluetooth: hci_ldisc: fix deadlock condition

Felix Fietkau (1):
      mac80211: fix a memory leak on sta rate selection table

Florian Westphal (1):
      netfilter: nf_nat: fix oops on netns removal

Gabor Juhos (1):
      watchdog: ath79_wdt: avoid spurious restarts on AR934x

Gavin Shan (1):
      powerpc/pseries: Fix overwritten PE state

Greg Kroah-Hartman (3):
      lzo: properly check for overruns
      lz4: ensure length does not wrap
      lz4: fix another possible overrun

H. Peter Anvin (1):
      x86-32, espfix: Remove filter for espfix32 due to race

Hans de Goede (2):
      Input: elantech - deal with clickpads reporting right button events
      Input: elantech - don't set bit 1 of reg_10 when the no_hw_res quirk is set

Huang Rui (1):
      usb: usbtest: fix unlink write error with pattern 1

Hugh Dickins (2):
      mm: fix sleeping function warning from __put_anon_vma
      mm: fix crashes from mbind() merging vmas

Ilya Dryomov (1):
      rbd: handle parent_overlap on writes correctly

J. Bruce Fields (1):
      nfsd4: fix FREE_STATEID lockowner leak

James Hogan (1):
      MIPS: KVM: Allocate at least 16KB for exception handlers

Jan Kara (1):
      ext4: fix zeroing of page during writeback

Jan Vcelak (1):
      [media] rtl28xxu: add USB ID for Genius TVGo DVB-T03

Jason Cooper (1):
      ARM: mvebu: DT: fix OpenBlocks AX3-4 RAM size

Jeff Mahoney (1):
      reiserfs: call truncate_setsize under tailpack mutex

Joe Handzik (1):
      hpsa: add new Smart Array PCI IDs (May 2014)

Johan Hedberg (6):
      Bluetooth: Fix redundant encryption request for reauthentication
      Bluetooth: Fix check for connection encryption
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
      Bluetooth: Fix setting correct authentication information for SMP STK
      Bluetooth: Fix indicating discovery state when canceling inquiry
      Bluetooth: Fix locking of hdev when calling into SMP code

Johannes Weiner (1):
      mm: vmscan: clear kswapd's special reclaim powers before exiting

Jonathan Cameron (1):
      iio:adc:max1363 incorrect resolutions for max11604, max11605, max11610 and max11611.

Joonsoo Kim (1):
      DMA, CMA: fix possible memory leak

Jukka Taimisto (1):
      Bluetooth: Fix L2CAP deadlock

Justin Maggard (1):
      btrfs: fix defrag 32-bit integer overflow

Jérôme Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L

K. Y. Srinivasan (1):
      Drivers: hv: balloon: Ensure pressure reports are posted regularly

Kailang Yang (3):
      ALSA: hda/realtek - Add support of ALC891 codec
      ALSA: hda/realtek - Add more entry for enable HP mute led
      ALSA: hda/realtek - Add more entry for enable HP mute led

Kamal Mostafa (1):
      Linux 3.13.11.5

Kees Cook (1):
      HID: core: fix validation of report id 0

Konstantin Khlebnikov (1):
      epoll: fix use-after-free in eventpoll_release_file

Krzysztof Hałasa (1):
      mac80211: fix IBSS join by initializing last_scan_completed

Krzysztof Kozlowski (2):
      extcon: max77693: Fix two NULL pointer exceptions on missing pdata
      extcon: max8997: Fix NULL pointer exception on missing pdata

Lai Jiangshan (1):
      idr: fix overflow bug during maximum ID calculation at maximum height

Lars-Peter Clausen (5):
      ALSA: control: Protect user controls against concurrent access
      ALSA: control: Fix replacing user controls
      ALSA: control: Don't access controls outside of protected regions
      ALSA: control: Handle numid overflow
      ALSA: control: Make sure that id->index does not overflow

Liam Girdwood (1):
      ASoC: max98090: Fix reset at resume time

Lukas Czerner (1):
      dm thin: update discard_granularity to reflect the thin-pool blocksize

Lv Zheng (1):
      ACPI: Fix conflict between customized DSDT and DSDT local copy

Marcin Kraglak (1):
      Bluetooth: Allow change security level on ATT_CID in slave role

Mario Kleiner (3):
      drm/nv50-/mc: fix kms pageflip events by reordering irq handling order.
      drm/nouveau/kms/nv04-nv40: fix pageflip events via special case.
      drm/nouveau/kms: reference vblank for crtc during pageflip.

Mario Schuknecht (1):
      staging: iio: tsl2x7x_core: fix proximity treshold

Markos Chandras (1):
      MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region

Martin Schwidefsky (1):
      s390/time: cast tv_nsec to u64 prior to shift in update_vsyscall

Mateusz Guzik (1):
      NFS: populate ->net in mount data when remounting

Matthew Dempsky (1):
      ptrace: fix fork event messages across pid namespaces

Maurizio Lombardi (1):
      ext4: fix wrong assert in ext4_mb_normalize_request()

Maxime Ripard (1):
      net: allwinner: emac: Add missing free_irq

Mel Gorman (2):
      mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL
      mm: page_alloc: use word-based accesses for get/set pageblock bitmaps

Mengdong Lin (1):
      ALSA: hda - restore BCLK M/N values when resuming HSW/BDW display controller

Michael Ellerman (2):
      powerpc/mm: Check paca psize is up to date for huge mappings
      powerpc/perf: Ensure all EBB register state is cleared on fork()

Michael Neuling (1):
      powerpc: Don't setup CPUs with bad status

Michal Hocko (1):
      memcg: do not hang on OOM when killed by userspace OOM access to memory reserves

Mike Frysinger (1):
      x86, x32: Use compat shims for io_{setup,submit}

Mike Marciniszyn (1):
      IB/qib: Fix port in pkey change event

Mikulas Patocka (1):
      iscsi-target: fix iscsit_del_np deadlock on unload

Mimi Zohar (1):
      evm: prohibit userspace writing 'security.evm' HMAC value

Ming Lei (1):
      block: virtio_blk: don't hold spin lock during world switch

Namjae Jeon (1):
      ext4: fix data integrity sync in ordered mode

Naoya Horiguchi (3):
      hugetlb: restrict hugepage_migration_support() to x86_64
      mm/memory-failure.c: support use of a dedicated thread to handle SIGBUS(BUS_MCEERR_AO)
      hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned entry

Nicholas Bellinger (7):
      iscsi-target: Reject mutual authentication with reflected CHAP_C
      target: Set CMD_T_ACTIVE bit for Task Management Requests
      target: Use complete_all for se_cmd->t_transport_stop_comp
      iscsi-target: Fix ABORT_TASK + connection reset iscsi_queue_req memory leak
      target: Fix left-over se_lun->lun_sep pointer OOPs
      iscsi-target: Explicily clear login response PDU in exception path
      iscsi-target: Avoid rejecting incorrect ITT for Data-Out

Oleg Nesterov (1):
      introduce for_each_thread() to replace the buggy while_each_thread()

Olivier Langlois (1):
      [media] uvcvideo: Fix clock param realtime setting

Paolo Bonzini (1):
      KVM: lapic: sync highest ISR to hardware apic on EOI

Pavel Shilovsky (1):
      CIFS: Fix memory leaks in SMB2_open

Pekon Gupta (1):
      mtd: eLBC NAND: fix subpage write support

Peter Meerwald (1):
      iio: Fix endianness issue in ak8975_read_axis()

Peter Ujfalusi (1):
      ASoC: tlv320aci3x: Fix custom snd_soc_dapm_put_volsw_aic3x() function

Pierre Ossman (1):
      ALSA: hda - hdmi: call overridden init on resume

Radim Krčmář (1):
      hv: use correct order when freeing monitor_pages

Rafael J. Wysocki (1):
      ACPI / ia64 / sba_iommu: Restore the working initialization ordering

Rafał Miłecki (1):
      b43: fix frequency reported on G-PHY with /new/ firmware

Roland Dreier (1):
      target: Report correct response length for some commands

Russell King (1):
      ARM: stacktrace: avoid listing stacktrace functions in stacktrace

Sagi Grimberg (5):
      Target/iser: Bail from accept_np if np_thread is trying to close
      Target/iser: Fix hangs in connection teardown
      Target/iser: Improve cm events handling
      Target/iser: Wait for proper cleanup before unloading
      Target/iscsi: Fix sendtargets response pdu for iser transport

Sam bobroff (1):
      powerpc: Correct DSCR during TM context switch

Sander Eikelenboom (1):
      ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined

Scott Mayhew (1):
      nfs: Fix cache_validity check in nfs_write_pageuptodate()

Scott Wood (1):
      powerpc: Don't skip ePAPR spin-table CPUs

Stanislaw Gruszka (2):
      rt2x00: disable TKIP on USB
      rt2x00: fix rfkill regression on rt2500pci

Stephen Boyd (1):
      staging/mt29f_spinand: Terminate of match table

Steve French (1):
      [CIFS] fix mount failure with broken pathnames when smb3 mount with mapchars option

Suravee Suthikulpanit (1):
      arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro

Sven Wegener (1):
      ipv6: Fix regression caused by efe4208 in udp_v6_mcast_next()

Takashi Iwai (2):
      [media] ivtv: Fix Oops when no firmware is loaded
      ALSA: usb-audio: Fix races at disconnection and PCM closing

Tejun Heo (1):
      blkcg: fix use-after-free in __blkg_release_rcu() by making blkcg_gq refcnt an atomic_t

Tetsuo Handa (1):
      kthread: fix return value of kthread_create() upon SIGKILL.

Thomas Gleixner (4):
      genirq: Sanitize spurious interrupt detection of threaded irqs
      rtmutex: Handle deadlock detection smarter
      rtmutex: Detect changes in the pi lock chain
      rtmutex: Plug slow unlock race

Thomas Jarosch (1):
      PCI: Add new ID for Intel GPU "spurious interrupt" quirk

Thomas Petazzoni (1):
      mtd: pxa3xx_nand: make the driver work on big-endian systems

Todd Fujinaka (1):
      igb: fix stats for i210 rx_fifo_errors

Tomas Winkler (3):
      mei: me: fix hw ready reset flow
      mei: me: drop harmful wait optimization
      mei: me: read H_CSR after asserting reset

Tony Luck (2):
      mm/memory-failure.c-failure: send right signal code to correct thread
      mm/memory-failure.c: don't let collect_procs() skip over processes for MF_ACTION_REQUIRED

Trond Myklebust (2):
      NFS: Don't declare inode uptodate unless all attributes were checked
      SUNRPC: Fix a module reference leak in svc_handle_xprt

Victor Kamensky (1):
      arm64: ptrace: fix empty registers set in prstatus of aarch32 process core

Ville Syrjälä (1):
      drm/i915: Avoid div-by-zero when pixel_multiplier is zero

Viresh Kumar (1):
      watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()

Wang, Xiaoming (1):
      ALSA: compress: Cancel the optimization of compiler and fix the size of struct for all platform.

Will Deacon (2):
      arm64: ptrace: change fs when passing kernel pointer to regset code
      arm64: uid16: fix __kernel_old_{gid,uid}_t definitions

Yann Droneaud (3):
      IB/mlx5: add missing padding at end of struct mlx5_ib_create_cq
      IB/mlx5: add missing padding at end of struct mlx5_ib_create_srq
      RDMA/cxgb4: Add missing padding at end of struct c4iw_create_cq_resp

gundberg (1):
      watchdog: kempld-wdt: Use the correct value when configuring the prescaler with the watchdog

hujianyang (2):
      UBIFS: fix an mmap and fsync race condition
      UBIFS: Remove incorrect assertion in shrink_tnc()

pekon gupta (1):
      mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in erased-page


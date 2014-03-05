Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaCEOYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:24:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40687 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaCEOYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.11.y.z extended stable] Linux 3.11.10.6 stable review
Date: Wed,  5 Mar 2014 14:22:04 +0000
Message-Id: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.11.10.6 stable kernel.

This version contains 131 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.11.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.11.y-review

The review period for version 3.11.10.6 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.11.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 arch/arm/include/asm/cacheflush.h               |   1 +
 arch/arm/include/asm/pgtable-3level.h           |  15 ++-
 arch/arm/mach-omap2/gpmc.c                      |   4 +-
 arch/arm/mach-tegra/common.c                    |  11 ++
 arch/arm/mm/dma-mapping.c                       |   2 +-
 arch/arm/mm/mm.h                                |   1 +
 arch/arm/mm/mmu.c                               |   7 +-
 arch/arm/mm/proc-v6.S                           |   3 +-
 arch/arm/mm/proc-v7.S                           |   2 +-
 arch/arm64/kernel/stacktrace.c                  |   6 +-
 arch/avr32/Makefile                             |   2 +-
 arch/avr32/boards/mimc200/fram.c                |   1 +
 arch/powerpc/kernel/crash_dump.c                |   8 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c       |  29 +-----
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |  22 ++--
 arch/x86/kernel/cpu/perf_event.c                |   3 +
 arch/x86/kernel/pci-dma.c                       |   4 +-
 arch/x86/kvm/mmu.c                              |   3 +
 arch/x86/kvm/vmx.c                              |   2 +-
 arch/x86/kvm/x86.c                              |   2 +-
 arch/xtensa/include/asm/traps.h                 |  44 +++++---
 arch/xtensa/kernel/entry.S                      |  60 ++++++++---
 drivers/acpi/pci_irq.c                          |   1 +
 drivers/acpi/processor_throttling.c             |  69 ++++++------
 drivers/acpi/video.c                            |   8 +-
 drivers/ata/ahci.c                              |  14 +++
 drivers/ata/libata-pmp.c                        |   7 +-
 drivers/ata/sata_sil.c                          |   1 +
 drivers/base/firmware_class.c                   |   1 +
 drivers/cpufreq/powernow-k8.c                   |  10 +-
 drivers/dma/ioat/dma.c                          |  52 +++++++--
 drivers/dma/ioat/dma.h                          |   1 +
 drivers/dma/ioat/dma_v2.c                       |  11 +-
 drivers/dma/ioat/dma_v3.c                       |   3 +
 drivers/dma/ste_dma40.c                         |   4 +-
 drivers/edac/i7300_edac.c                       |  38 +++----
 drivers/edac/i7core_edac.c                      |   9 +-
 drivers/extcon/extcon-arizona.c                 |  12 ---
 drivers/gpu/drm/i915/intel_display.c            |  14 +++
 drivers/gpu/drm/i915/intel_dp.c                 |  19 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.c         |  21 ++++
 drivers/gpu/drm/i915/intel_ringbuffer.h         |   1 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c |   2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c           |   3 +
 drivers/gpu/drm/radeon/atombios_crtc.c          |  16 ++-
 drivers/gpu/drm/radeon/ni_dpm.c                 |   2 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c    |   3 +-
 drivers/gpu/drm/radeon/radeon_kms.c             |   6 ++
 drivers/gpu/drm/radeon/si_dpm.c                 |   4 +-
 drivers/hwmon/max1668.c                         |   2 +-
 drivers/iio/gyro/Kconfig                        |   2 +-
 drivers/iio/gyro/st_gyro.h                      |   1 -
 drivers/iio/gyro/st_gyro_core.c                 |   9 +-
 drivers/iio/gyro/st_gyro_i2c.c                  |   1 -
 drivers/iio/gyro/st_gyro_spi.c                  |   1 -
 drivers/input/misc/arizona-haptics.c            |  19 ----
 drivers/input/mouse/elantech.c                  |  45 +++++++-
 drivers/input/tablet/wacom_sys.c                |   7 +-
 drivers/iommu/arm-smmu.c                        |  85 ++++++++-------
 drivers/irqchip/irq-metag-ext.c                 |   2 +-
 drivers/irqchip/irq-metag.c                     |   2 +-
 drivers/irqchip/irq-orion.c                     |  22 +++-
 drivers/md/dm-mpath.c                           |   7 +-
 drivers/md/dm-thin-metadata.c                   |  17 +++
 drivers/md/dm-thin-metadata.h                   |   2 +
 drivers/md/dm-thin.c                            |   8 +-
 drivers/mfd/da9055-i2c.c                        |  10 +-
 drivers/misc/mei/client.c                       |   4 +-
 drivers/net/bonding/bond_3ad.c                  |   6 +-
 drivers/net/bonding/bond_3ad.h                  |   1 +
 drivers/net/can/dev.c                           |  15 +--
 drivers/net/can/janz-ican3.c                    |  18 +---
 drivers/net/can/usb/kvaser_usb.c                |   2 +
 drivers/net/can/vcan.c                          |   9 +-
 drivers/net/ethernet/broadcom/tg3.c             |   4 +-
 drivers/net/ethernet/intel/e100.c               |   2 +-
 drivers/net/usb/asix_devices.c                  |   3 +-
 drivers/net/usb/ax88179_178a.c                  |   4 +
 drivers/net/usb/gl620a.c                        |   4 +
 drivers/net/usb/mcs7830.c                       |   5 +-
 drivers/net/usb/net1080.c                       |   4 +
 drivers/net/usb/qmi_wwan.c                      |   9 +-
 drivers/net/usb/rndis_host.c                    |   4 +
 drivers/net/usb/smsc75xx.c                      |   4 +
 drivers/net/usb/smsc95xx.c                      |   4 +
 drivers/net/usb/usbnet.c                        |  25 ++---
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h  |  10 +-
 drivers/net/wireless/rtlwifi/ps.c               |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c     |  18 +++-
 drivers/pci/host/pci-mvebu.c                    |  11 +-
 drivers/pci/pci.c                               |  10 ++
 drivers/scsi/qla2xxx/qla_target.c               |   3 +-
 drivers/staging/android/binder.c                |   3 +-
 drivers/usb/chipidea/udc.c                      |   4 +-
 drivers/usb/gadget/bcm63xx_udc.c                |  58 ++++++-----
 drivers/usb/host/ehci-hcd.c                     |  13 ++-
 drivers/usb/serial/ftdi_sio.c                   |   2 +
 drivers/usb/serial/ftdi_sio_ids.h               |   6 ++
 drivers/usb/serial/option.c                     |   3 +-
 fs/attr.c                                       |   5 -
 fs/bio-integrity.c                              |   2 +-
 fs/btrfs/inode.c                                |   8 +-
 fs/cifs/file.c                                  |  37 ++++++-
 fs/cifs/smb2glob.h                              |   3 +
 fs/cifs/smb2ops.c                               |  14 +--
 fs/cifs/smb2pdu.c                               |   4 +-
 fs/ext4/ext4.h                                  |   2 +
 fs/ext4/extents.c                               |   1 +
 fs/ext4/inode.c                                 |   4 +
 fs/ext4/ioctl.c                                 |   3 +-
 fs/ext4/resize.c                                |  34 +++---
 fs/ext4/super.c                                 |  20 ++--
 fs/jbd2/transaction.c                           |   6 +-
 fs/nfs/blocklayout/blocklayout.h                |   1 +
 fs/nfs/dns_resolve.c                            |   2 +
 fs/nfs/inode.c                                  |  14 ++-
 fs/nfs/internal.h                               |  24 +++++
 fs/nfs/nfs4_fs.h                                |   8 ++
 fs/proc/proc_devtree.c                          |   1 +
 fs/quota/dquot.c                                |  14 ++-
 include/linux/can/skb.h                         |  38 +++++++
 include/linux/ipc_namespace.h                   |   2 -
 include/linux/netdevice.h                       |   7 +-
 include/linux/nfs4.h                            |  10 --
 include/linux/nfs_fs.h                          |  18 ----
 include/linux/skbuff.h                          |  19 ++++
 include/sound/soc-dapm.h                        |   8 ++
 ipc/mq_sysctl.c                                 |  18 ++--
 ipc/mqueue.c                                    |   6 +-
 kernel/cgroup.c                                 |   5 +
 kernel/events/core.c                            |  14 +--
 kernel/sysctl.c                                 |   1 +
 kernel/workqueue.c                              |   7 ++
 net/can/af_can.c                                |   3 +-
 net/can/bcm.c                                   |   4 +-
 net/core/dev.c                                  |  22 ++--
 net/core/fib_rules.c                            |   7 ++
 net/core/netpoll.c                              |   4 +-
 net/core/skbuff.c                               |  25 +++++
 net/core/sock.c                                 |   2 +-
 net/ieee802154/6lowpan.c                        |  20 ++++
 net/ipv4/devinet.c                              |   3 +-
 net/ipv4/ip_forward.c                           |  71 ++++++++++++-
 net/ipv4/route.c                                |   4 +-
 net/ipv4/tcp_output.c                           |  13 ++-
 net/ipv6/ip6_output.c                           |  17 ++-
 net/sched/sch_tbf.c                             |  13 +--
 net/sctp/socket.c                               |  41 ++++++--
 net/sunrpc/xprtsock.c                           |   6 +-
 security/selinux/ss/policydb.c                  |   8 +-
 sound/pci/hda/patch_ca0132.c                    |  68 ++----------
 sound/pci/hda/patch_realtek.c                   |  48 +++++++++
 sound/pci/hda/patch_sigmatel.c                  |  33 ++++++
 sound/soc/codecs/da732x.c                       |  12 +++
 sound/soc/codecs/da9055.c                       |  11 +-
 sound/soc/codecs/max98090.c                     |  20 ++--
 sound/soc/codecs/sta32x.c                       |  76 +++++++-------
 sound/soc/codecs/wm8770.c                       |   4 +-
 sound/soc/codecs/wm8958-dsp2.c                  |   2 +-
 sound/soc/soc-dapm.c                            | 133 ++++++++++++++++++++++--
 sound/soc/txx9/txx9aclc-ac97.c                  |   8 +-
 sound/usb/mixer_maps.c                          |   9 ++
 162 files changed, 1473 insertions(+), 650 deletions(-)

Adam Thomson (1):
      ASoC: da9055: Fix device registration of PMIC and CODEC devices

Aleksander Morgado (1):
      USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Alex Deucher (5):
      drm/radeon: fix minor typos in si_dpm.c
      drm/radeon/si: fix typo in dpm sq ramping setup
      drm/radeon/ni: fix typo in dpm sq ramping setup
      drm/radeon: print the supported atpx function mask
      drm/radeon: disable pll sharing for DP on DCE4.1

Alexander Shiyan (1):
      ASoC: txx9aclc_ac97: Fix kernel crash on probe

Andrew Honig (1):
      kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Andrew Lunn (2):
      irqchip: orion: Fix getting generic chip pointer.
      PCI: mvebu: Use Device ID and revision from underlying endpoint

Ankur Raina (1):
      mfd: Update DA9055 i2c device id name

Anna Schumaker (1):
      NFS: Enabling v4.2 should not recompile nfsd and lockd

Arve Hjønnevåg (1):
      staging: binder: Fix death notifications

Bjorn Helgaas (1):
      PCI: Enable INTx if BIOS left them disabled

Bjørn Mork (1):
      net: qmi_wwan: add Netgear Aircard 340U

Chao Bi (1):
      mei: set client's read_cb to NULL when flow control fails

Charles Keepax (2):
      Input - arizona-haptics: Fix double lock of dapm_mutex
      ASoC: dapm: Add locking to snd_soc_dapm_xxxx_pin functions

Chen Gang (1):
      avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use

Christian König (1):
      drm/radeon: fix missing bo reservation

Christoffer Dall (1):
      ARM: 7950/1: mm: Fix stage-2 device memory attributes

Christoph Hellwig (1):
      fs: fix iversion handling

Clemens Ladisch (1):
      ALSA: usb-audio: work around KEF X300A firmware bug

Dan Carpenter (1):
      jbd2: fix use after free in jbd2_journal_start_reserved()

Dan Williams (1):
      ioat: fix tasklet tear down

Daniel Borkmann (1):
      net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode

Dave Jones (1):
      fs/proc/proc_devtree.c: remove empty /proc/device-tree when no openfirmware exists.

Davidlohr Bueso (1):
      ipc,mqueue: remove limits for the amount of system-wide queues

Denis CIOCCA (1):
      iio:gyro: bug on L3GD20H gyroscope support

Denis V. Lunev (1):
      ata: enable quirk from jmicron JMB350 for JMB394

Dr. Greg Wettstein (1):
      qla2xxx: Fix kernel panic on selective retransmission request

Duan Jiong (1):
      ipv4: fix counter in_slow_tot

Dylan Reid (1):
      ASoC: max98090: sync regcache on entering STANDBY

Emil Goode (2):
      net: asix: add missing flag to struct driver_info
      usbnet: remove generic hard_header_len check

Eric Dumazet (2):
      6lowpan: fix lockdep splats
      net: use __GFP_NORETRY for high order allocations

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules

Eric Whitney (1):
      ext4: fix xfstest generic/299 block validity failures

Florian Fainelli (1):
      usb: gadget: bcm63xx_udc: fix build failure on DMA channel code

Florian Westphal (3):
      net: add and use skb_gso_transport_seglen()
      net: core: introduce netif_skb_dev_features
      net: ip, ipv6: handle gso skbs in forwarding path

Gavin Shan (1):
      powerpc/powernv: Rework EEH reset

Geert Uytterhoeven (1):
      ipv4: Fix runtime WARNING in rtmsg_ifa()

Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature

Hannes Reinecke (1):
      dm mpath: fix stalls when handling invalid ioctls

Hans de Goede (2):
      ACPI / video: Filter the _BCL table for duplicate brightness values
      Input: elantech -  improve clickpad detection

Hsin-Yu Chao (2):
      ALSA: hda/ca0132 - setup/cleanup streams
      ALSA: hda/ca0132 - Fix recording from mode id 0x8

Hui Wang (1):
      ALSA: hda - Enable front audio jacks on one HP desktop model

Ilia Mirkin (2):
      drm/nouveau: set irq_enabled manually
      drm/nv50/disp: use correct register to determine DP display bpp

James Hogan (1):
      irq-metag*: stop set_affinity vectoring to offline cpus

Jan Kara (1):
      quota: Fix race between dqput() and dquot_scan_active()

Jani Nikula (2):
      drm/i915/dp: increase native aux defer retry timeout
      drm/i915/dp: add native aux defer retry limit

Jean Delvare (2):
      i7core_edac: Fix PCI device reference count
      i7300_edac: Fix device reference count

Jeff Layton (1):
      cifs: ensure that uncached writes handle unmapped areas correctly

Jiri Bohac (1):
      bonding: 802.3ad: make aggregator_identifier bond-private

Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID

John Ogness (1):
      tcp: tsq: fix nonagle handling

Kailang Yang (2):
      ALSA: hda/realtek - Add more entry for enable HP mute led
      ALSA: hda/realtek - Add more entry for enable HP mute led

Knut Petersen (1):
      perf: Enforce 1 as lower limit for perf_event_max_sample_rate

Lai Jiangshan (1):
      workqueue: ensure @task is valid across kthread_stop()

Lan Tianyu (1):
      ACPI / processor: Rework processor throttling with work_on_cpu()

Lars-Peter Clausen (2):
      ASoC: sta32x: Fix cache sync
      ASoC: wm8958-dsp: Fix firmware block loading

Laurent Dufour (1):
      powerpc/crashdump : Fix page frame number check in copy_oldmem_page

Levente Kurusa (1):
      ahci: disable NCQ on Samsung pci-e SSDs on macbooks

Linus Walleij (1):
      dma: ste_dma40: don't dereference free:d descriptor

Maciej Żenczykowski (1):
      net: fix 'ip rule' iif/oif device rename

Marcelo Tosatti (2):
      KVM: MMU: handle invalid root_hpa at __direct_map
      KVM: VMX: fix use after free of vmx->loaded_vmcs

Marek Szyprowski (2):
      ARM: dma-mapping: fix GFP_ATOMIC macro usage
      x86: dma-mapping: fix GFP_ATOMIC macro usage

Mark Brown (1):
      ASoC: da732x: Mark DC offset control registers volatile

Matthieu CASTET (1):
      usb: chipidea: need to mask when writting endptflush and endptprime

Max Filippov (1):
      xtensa: introduce spill_registers_kernel macro

Michele Baldessari (1):
      e100: Fix "disabling already-disabled device" warning

Mike Snitzer (2):
      dm thin: avoid metadata commit if a pool's thin devices haven't changed
      dm thin: fix the error path for the thin device constructor

Nicholas Bellinger (1):
      bio-integrity: Fix bio_integrity_verify segment start bug

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()

Oliver Hartkopp (1):
      can: add destructor for self generated skbs

Olivier Langlois (2):
      rtlwifi: rtl8192ce: Fix too long disable of IRQs
      rtlwifi: Fix incorrect return from rtl_ps_enable_nic()

Olivier Sobrie (1):
      can: kvaser_usb: check number of channels returned by HW

Olof Johansson (1):
      ARM64: unwind: Fix PC calculation

Paul Gortmaker (1):
      avr32: fix missing module.h causing build failure in mimc200/fram.c

Pavel Shilovsky (1):
      CIFS: Fix too big maxBuf size for SMB3 mounts

Pekon Gupta (2):
      ARM: OMAP2+: gpmc: fix: DT NAND child nodes not probed when MTD_NAND is built as module
      ARM: OMAP2+: gpmc: fix: DT ONENAND child nodes not probed when MTD_ONENAND is built as module

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
      perf: Fix hotplug splat

Ping Cheng (1):
      Input: wacom - make sure touch_max is set for touch devices

Sabrina Dubroca (1):
      netpoll: fix netconsole IPv6 setup

Sebastian Capella (1):
      PM / hibernate: Fix restore hang in freeze_processes()

Sebastian Hesselbarth (3):
      irqchip: orion: clear bridge cause register on init
      irqchip: orion: use handle_edge_irq on bridge irqs
      irqchip: orion: clear stale interrupts in irq_startup

Srivatsa S. Bhat (1):
      cpufreq: powernow-k8: Initialize per-cpu data-structures properly

Stanislaw Gruszka (2):
      rtl8187: fix regression on MIPS without coherent DMA
      usb: ehci: fix deadlock when threadirqs option is used

Stephen Warren (1):
      ARM: tegra: only run PL310 init on systems with one

Takashi Iwai (4):
      ASoC: sta32x: Fix array access overflow
      ASoC: wm8770: Fix wrong number of enum items
      ALSA: hda - Add a fixup for HP Folio 13 mute LED
      ASoC: sta32x: Fix wrong enum for limiter2 release rate

Tejun Heo (2):
      sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN
      cgroup: update cgroup_enable_task_cg_lists() to grab siglock

Theodore Ts'o (4):
      ext4: don't try to modify s_flags if the the file system is read-only
      ext4: fix online resize with very large inode tables
      ext4: fix online resize with a non-standard blocks per group setting
      ext4: don't leave i_crtime.tv_sec uninitialized

Tomasz Nowicki (1):
      ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()

Tony Breeds (1):
      powerpc/le: Ensure that the 'stop-self' RTAS token is handled correctly

Trond Myklebust (2):
      NFS: Do not set NFS_INO_INVALID_LABEL unless server supports labeled NFS
      SUNRPC: Fix races in xs_nospace()

Ville Syrjälä (2):
      drm/i915: Add intel_ring_cachline_align()
      drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB

Vinayak Kale (1):
      ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Will Deacon (3):
      ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling MMU
      iommu/arm-smmu: really fix page table locking
      iommu/arm-smmu: fix table flushing during initial allocations

Yifan Zhang (1):
      iommu/arm-smmu: fix pud/pmd entry fill sequence

Zheng Liu (1):
      ext4: fix error paths in swap_inode_boot_loader()

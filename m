Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaC1R2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:28:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaC1R2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:28:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.20
Date: Fri, 28 Mar 2014 10:28:24 -0700
Message-Id: <1396027705-28407-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.20 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.19 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                       |   2 +-
 arch/arm/include/asm/assembler.h               |   4 +-
 arch/arm/include/asm/barrier.h                 |  32 +++---
 arch/arm/include/asm/cacheflush.h              |   1 +
 arch/arm/include/asm/spinlock.h                |  15 +--
 arch/arm/lib/memset.S                          | 100 +++++++++----------
 arch/arm/mm/dma-mapping.c                      |   2 +-
 arch/arm/mm/proc-v6.S                          |   3 +-
 arch/arm/mm/proc-v7.S                          |   2 +-
 arch/arm64/include/asm/pgtable.h               |   8 +-
 arch/arm64/kernel/stacktrace.c                 |   6 +-
 arch/avr32/Makefile                            |   2 +-
 arch/avr32/boards/mimc200/fram.c               |   1 +
 arch/powerpc/kernel/crash_dump.c               |   8 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c   |  22 ++--
 arch/x86/kernel/cpu/perf_event.c               |   3 +
 arch/x86/kernel/pci-dma.c                      |   4 +-
 arch/x86/kvm/x86.c                             |   2 +-
 arch/xtensa/include/asm/traps.h                |  35 +++++++
 arch/xtensa/kernel/entry.S                     |  60 ++++++++---
 arch/xtensa/kernel/traps.c                     |  21 +---
 drivers/acpi/pci_irq.c                         |   2 +
 drivers/acpi/processor_throttling.c            |  69 ++++++-------
 drivers/acpi/video.c                           |   8 +-
 drivers/ata/ahci.c                             |  14 +++
 drivers/ata/libata-pmp.c                       |   7 +-
 drivers/ata/sata_sil.c                         |   1 +
 drivers/base/firmware_class.c                  |   1 +
 drivers/block/rbd.c                            |   4 -
 drivers/cpufreq/powernow-k8.c                  |  10 +-
 drivers/dma/ste_dma40.c                        |   4 +-
 drivers/edac/i7300_edac.c                      |  38 +++----
 drivers/edac/i7core_edac.c                     |   9 +-
 drivers/gpu/drm/i915/intel_display.c           |  14 +++
 drivers/gpu/drm/i915/intel_dp.c                |  19 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.c        |  21 ++++
 drivers/gpu/drm/i915/intel_ringbuffer.h        |   1 +
 drivers/gpu/drm/radeon/atombios_crtc.c         |  16 ++-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c   |   3 +-
 drivers/gpu/drm/radeon/radeon_kms.c            |   6 ++
 drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h    |  11 +-
 drivers/hwmon/max1668.c                        |   2 +-
 drivers/input/misc/arizona-haptics.c           |  19 ----
 drivers/md/dm-mpath.c                          |   7 +-
 drivers/md/dm-thin-metadata.c                  |  17 ++++
 drivers/md/dm-thin-metadata.h                  |   2 +
 drivers/md/dm-thin.c                           |   8 +-
 drivers/mfd/da9055-i2c.c                       |  10 +-
 drivers/net/can/usb/kvaser_usb.c               |   2 +
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h |  10 +-
 drivers/net/wireless/rtlwifi/ps.c              |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c    |  18 +++-
 drivers/pci/pci.c                              |  13 +++
 drivers/scsi/qla2xxx/qla_target.c              |   3 +-
 drivers/usb/gadget/bcm63xx_udc.c               |  58 ++++++-----
 drivers/usb/host/ehci-hcd.c                    |  13 ++-
 drivers/usb/host/ehci-hub.c                    |  26 ++++-
 drivers/usb/serial/ftdi_sio.c                  |   3 +
 drivers/usb/serial/ftdi_sio_ids.h              |  12 +++
 drivers/usb/serial/option.c                    |   3 +-
 fs/cifs/file.c                                 |  37 ++++++-
 fs/cifs/smb2glob.h                             |   3 +
 fs/cifs/smb2ops.c                              |  14 +--
 fs/cifs/smb2pdu.c                              |   4 +-
 fs/ext4/ext4.h                                 |   2 +
 fs/ext4/resize.c                               |  32 +++---
 fs/ext4/super.c                                |  20 ++--
 fs/quota/dquot.c                               |  14 ++-
 fs/reiserfs/reiserfs.h                         |   2 -
 fs/xfs/xfs_iops.c                              |  18 ++--
 include/linux/ipc_namespace.h                  |   2 -
 include/linux/kernel.h                         |  13 +++
 include/sound/soc-dapm.h                       |   8 ++
 ipc/mq_sysctl.c                                |  18 ++--
 ipc/mqueue.c                                   |   6 +-
 kernel/cgroup.c                                |  10 +-
 kernel/events/core.c                           |  12 +--
 kernel/workqueue.c                             |   7 ++
 net/sunrpc/xprtsock.c                          |   6 +-
 security/selinux/ss/policydb.c                 |   8 +-
 sound/soc/codecs/da732x.c                      |  12 +++
 sound/soc/codecs/da9055.c                      |  11 +-
 sound/soc/codecs/sta32x.c                      |  76 +++++++-------
 sound/soc/codecs/wm8770.c                      |   4 +-
 sound/soc/codecs/wm8958-dsp2.c                 |   2 +-
 sound/soc/soc-dapm.c                           | 133 +++++++++++++++++++++++--
 sound/usb/mixer_maps.c                         |  19 ++++
 sound/usb/quirks.c                             |  14 +++
 88 files changed, 916 insertions(+), 410 deletions(-)

Adam Thomson (1):
      ASoC: da9055: Fix device registration of PMIC and CODEC devices

Alan Stern (1):
      USB: EHCI: add delay during suspend to prevent erroneous wakeups

Aleksander Morgado (1):
      USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Alex Deucher (2):
      drm/radeon: print the supported atpx function mask
      drm/radeon: disable pll sharing for DP on DCE4.1

Alex Elder (1):
      kernel.h: define u8, s8, u32, etc. limits

Andrew Honig (1):
      kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Bjorn Helgaas (2):
      PCI: Enable INTx if BIOS left them disabled
      PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled

Charles Keepax (2):
      Input - arizona-haptics: Fix double lock of dapm_mutex
      ASoC: dapm: Add locking to snd_soc_dapm_xxxx_pin functions

Chen Gang (1):
      avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use

Christian König (1):
      drm/radeon: fix missing bo reservation

Christoph Hellwig (1):
      xfs: ensure correct timestamp updates from truncate

Clemens Ladisch (1):
      ALSA: usb-audio: work around KEF X300A firmware bug

Davidlohr Bueso (1):
      ipc,mqueue: remove limits for the amount of system-wide queues

Denis V. Lunev (1):
      ata: enable quirk from jmicron JMB350 for JMB394

Dr. Greg Wettstein (1):
      qla2xxx: Fix kernel panic on selective retransmission request

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules

Florian Fainelli (1):
      usb: gadget: bcm63xx_udc: fix build failure on DMA channel code

Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature

Hannes Reinecke (1):
      dm mpath: fix stalls when handling invalid ioctls

Hans de Goede (1):
      ACPI / video: Filter the _BCL table for duplicate brightness values

Ivan Djelic (1):
      ARM: 7668/1: fix memset-related crashes caused by recent GCC (4.7.2) optimizations

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

Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID

Kamal Mostafa (2):
      kernel.h: undef clashing U64_MAX, U32_MAX size limits
      Linux 3.8.13.20

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

Marek Szyprowski (2):
      ARM: dma-mapping: fix GFP_ATOMIC macro usage
      x86: dma-mapping: fix GFP_ATOMIC macro usage

Mark Brown (1):
      ASoC: da732x: Mark DC offset control registers volatile

Max Filippov (3):
      xtensa: move spill_registers to traps.h
      xtensa: clean up stpill_registers
      xtensa: introduce spill_registers_kernel macro

Mike Snitzer (2):
      dm thin: avoid metadata commit if a pool's thin devices haven't changed
      dm thin: fix the error path for the thin device constructor

Nicolas Pitre (1):
      ARM: 7670/1: fix the memset fix

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

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
      perf: Fix hotplug splat

Sebastian Capella (1):
      PM / hibernate: Fix restore hang in freeze_processes()

Srivatsa S. Bhat (1):
      cpufreq: powernow-k8: Initialize per-cpu data-structures properly

Stanislaw Gruszka (2):
      rtl8187: fix regression on MIPS without coherent DMA
      usb: ehci: fix deadlock when threadirqs option is used

Steve Capper (1):
      arm64: mm: Add double logical invert to pte accessors

Takashi Iwai (4):
      ALSA: usb-audio: Add a quirk for Plantronics Gamecom 780
      ASoC: sta32x: Fix array access overflow
      ASoC: wm8770: Fix wrong number of enum items
      ASoC: sta32x: Fix wrong enum for limiter2 release rate

Tejun Heo (3):
      sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN
      cgroup: fix locking in cgroup_cfts_commit()
      cgroup: update cgroup_enable_task_cg_lists() to grab siglock

Theodore Ts'o (4):
      ext4: don't try to modify s_flags if the the file system is read-only
      ext4: fix online resize with very large inode tables
      ext4: fix online resize with a non-standard blocks per group setting
      ext4: don't leave i_crtime.tv_sec uninitialized

Thomas Hellstrom (1):
      drm/vmwgfx: Fix possible integer overflow

Tomasz Nowicki (1):
      ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()

Tony Breeds (1):
      powerpc/le: Ensure that the 'stop-self' RTAS token is handled correctly

Trond Myklebust (1):
      SUNRPC: Fix races in xs_nospace()

Ville Syrjälä (2):
      drm/i915: Add intel_ring_cachline_align()
      drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB

Vinayak Kale (1):
      ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Will Deacon (3):
      ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling MMU
      ARM: barrier: allow options to be passed to memory barrier instructions
      ARM: 7955/1: spinlock: ensure we have a compiler barrier before sev

Алексей Крамаренко (1):
      USB: serial: ftdi_sio: add id for Z3X Box device


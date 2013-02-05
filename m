Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab3BEWHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:07:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3BEWHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:07:33 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: =?UTF-8?q?=5B=203=2E5=2Ey=2Ez=20extended=20stable=20=5D=20Linux=203=2E5=2E7=2E5=20stable=20review?=
Date: Tue,  5 Feb 2013 20:05:49 -0200
Message-Id: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the review cycle for the 3.5.7.5 stable release. This new
release contains 93 patches, which are posted as a response to this
message. They are also available at the following repository:

git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y-review

If there are any problems, or if anything is missing, please answer to
this or to any of the followup patches. Note that any answer should be
made at maximum in 3 days, after that the final release of 3.5.7.5 will be
made.

For more information about the 3.5.y.z extended stable tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Included below are the diffstat and shortlog for this release.

-Herton

-- 
 arch/arm/kernel/head.S                             |    3 +
 arch/arm/mach-at91/setup.c                         |    2 +
 arch/arm/mm/dma-mapping.c                          |   18 ++-
 arch/arm/vfp/entry.S                               |    6 +-
 arch/arm/vfp/vfphw.S                               |    4 +-
 arch/powerpc/kernel/entry_64.S                     |   13 ++
 arch/powerpc/kvm/emulate.c                         |    2 +
 arch/x86/include/asm/efi.h                         |    1 +
 arch/x86/kernel/entry_32.S                         |    1 -
 arch/x86/kernel/msr.c                              |    3 +
 arch/x86/kernel/reboot.c                           |    2 +-
 arch/x86/kernel/setup.c                            |   34 +++--
 arch/x86/platform/efi/efi.c                        |   59 +++++---
 arch/x86/platform/efi/efi_64.c                     |   22 ++-
 drivers/acpi/osl.c                                 |    2 +-
 drivers/acpi/processor_idle.c                      |    4 +
 drivers/ata/ahci.c                                 |   13 +-
 drivers/ata/libata-eh.c                            |    2 +-
 drivers/block/virtio_blk.c                         |    7 +-
 drivers/dma/ioat/dma_v3.c                          |    2 +-
 drivers/edac/edac_pci_sysfs.c                      |    2 +-
 drivers/firmware/dmi_scan.c                        |   80 +++++++---
 drivers/firmware/efivars.c                         |    4 +-
 drivers/firmware/iscsi_ibft_find.c                 |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |    2 +
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   21 +++
 drivers/gpu/drm/i915/i915_reg.h                    |    2 +
 drivers/gpu/drm/i915/intel_pm.c                    |    4 +
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   24 ++-
 drivers/gpu/drm/radeon/radeon_cs.c                 |    6 +-
 drivers/gpu/drm/radeon/radeon_cursor.c             |    3 +-
 drivers/gpu/drm/radeon/radeon_device.c             |    3 +-
 drivers/gpu/drm/radeon/radeon_display.c            |    2 +-
 drivers/i2c/busses/i2c-mxs.c                       |    2 +-
 drivers/idle/intel_idle.c                          |    7 +-
 drivers/iommu/amd_iommu_init.c                     |   34 +++++
 drivers/iommu/intel-iommu.c                        |   21 ++-
 drivers/media/video/gspca/kinect.c                 |    1 +
 drivers/net/can/c_can/c_can.c                      |    4 +-
 drivers/net/can/pch_can.c                          |    2 +-
 drivers/net/can/ti_hecc.c                          |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   33 ++---
 drivers/net/wireless/ath/ath9k/ath9k.h             |    3 -
 drivers/net/wireless/ath/ath9k/debug.c             |    1 -
 drivers/net/wireless/ath/ath9k/debug.h             |    2 -
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    2 +
 drivers/net/wireless/ath/ath9k/hw.h                |    1 +
 drivers/net/wireless/ath/ath9k/main.c              |   19 +--
 drivers/net/wireless/ath/ath9k/recv.c              |   54 ++-----
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    7 +-
 drivers/net/wireless/iwlegacy/common.c             |   35 ++---
 drivers/net/wireless/mwifiex/pcie.c                |    2 +-
 drivers/pci/hotplug/pciehp.h                       |    2 +-
 drivers/pci/hotplug/pciehp_core.c                  |   11 +-
 drivers/pci/hotplug/pciehp_ctrl.c                  |    8 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   11 +-
 drivers/pci/pcie/aer/aerdrv_core.c                 |    1 +
 drivers/pci/pcie/aspm.c                            |    3 +
 drivers/platform/x86/ibm_rtl.c                     |    2 +-
 drivers/platform/x86/samsung-laptop.c              |    4 +
 drivers/scsi/isci/init.c                           |    2 +-
 drivers/staging/vt6656/bssdb.h                     |    1 -
 drivers/staging/vt6656/int.h                       |    1 -
 drivers/staging/vt6656/iocmd.h                     |   33 ++---
 drivers/staging/vt6656/iowpa.h                     |    8 +-
 drivers/staging/wlan-ng/prism2mgmt.c               |    2 +-
 drivers/tty/serial/8250/8250.c                     |   11 ++
 drivers/tty/serial/8250/8250.h                     |    1 +
 drivers/tty/serial/8250/8250_dw.c                  |    2 +-
 drivers/tty/serial/8250/8250_pci.c                 |   38 +++++
 drivers/tty/serial/ifx6x60.c                       |    1 +
 drivers/usb/dwc3/gadget.c                          |    1 +
 drivers/usb/host/uhci-hcd.c                        |   15 +-
 drivers/usb/serial/option.c                        |    9 +-
 drivers/xen/grant-table.c                          |   48 +++---
 fs/cifs/cifs_dfs_ref.c                             |    2 +
 fs/nfs/namespace.c                                 |   20 +++
 fs/nfs/nfs4state.c                                 |   14 +-
 fs/nfs/super.c                                     |   19 +--
 fs/xfs/xfs_aops.c                                  |    2 +-
 fs/xfs/xfs_sync.c                                  |    2 +-
 include/linux/efi.h                                |   24 ++-
 include/linux/module.h                             |   10 +-
 include/linux/sched.h                              |   11 +-
 include/linux/serial_core.h                        |    3 +-
 init/main.c                                        |    4 +-
 kernel/async.c                                     |   27 +++-
 kernel/debug/kdb/kdb_main.c                        |    2 +
 kernel/module.c                                    |  155 +++++++++++++++-----
 kernel/ptrace.c                                    |   72 +++++++--
 kernel/sched/core.c                                |    3 +-
 kernel/signal.c                                    |   19 ++-
 kernel/smp.c                                       |   13 +-
 kernel/trace/ftrace.c                              |    2 +-
 lib/bug.c                                          |    1 +
 net/bluetooth/hci_event.c                          |    2 +-
 net/bluetooth/hidp/core.c                          |    2 +-
 net/mac80211/cfg.c                                 |   12 +-
 net/mac80211/ieee80211_i.h                         |    6 +-
 net/mac80211/offchannel.c                          |   17 +--
 net/mac80211/scan.c                                |   15 +-
 net/mac80211/work.c                                |    4 +-
 security/integrity/evm/evm_crypto.c                |    4 +-
 sound/pci/hda/hda_intel.c                          |   40 +++--
 sound/pci/hda/patch_conexant.c                     |    9 ++
 sound/pci/hda/patch_realtek.c                      |    2 +
 sound/soc/codecs/wm2200.c                          |    3 -
 sound/usb/mixer.c                                  |   17 ++-
 109 files changed, 897 insertions(+), 447 deletions(-)

Alan Cox (2):
      x86/msr: Add capabilities check
      ahci: Add identifiers for ASM106x devices

Alan Stern (1):
      USB: UHCI: fix IRQ race during initialization

Alexander Graf (2):
      virtio-blk: Don't free ida when disk is in use
      KVM: PPC: Emulate dcbf

Anderson Lizardo (1):
      Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Andrew Cooper (1):
      xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS guests.

Avinash Patil (1):
      mwifiex: fix typo in PCIe adapter NULL check

Ben Hutchings (1):
      staging: vt6656: Fix inconsistent structure packing

Betty Dall (1):
      PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_put()

Bian Yu (1):
      [libata] ahci: Fix lack of command retry after a success error handler.

Bjørn Mork (2):
      USB: option: blacklist network interface on ONDA MT8205 4G LTE
      USB: option: add TP-LINK HSUPA Modem MA180

Chris Rattray (1):
      ASoC: wm2200: correct mixer values and text

Chris Wilson (3):
      drm/i915: Invalidate the relocation presumed_offsets along the slow path
      drm/i915: Disable AsyncFlip performance optimisations
      drm/i915: GFX_MODE Flush TLB Invalidate Mode must be '1' for scanline waits

Clemens Ladisch (1):
      ALSA: usb-audio: fix invalid length check for RME and other UAC 2 devices

Colin Ian King (1):
      PCI: Allow pcie_aspm=force even when FADT indicates it is unsupported

Cong Ding (1):
      fs/cifs/cifs_dfs_ref.c: fix potential memory leakage

Dan Carpenter (1):
      EDAC: Test correct variable in ->store function

Daniel Vetter (3):
      iommu/intel: disable DMAR for g4x integrated gfx
      drm/i915: dump UTS_RELEASE into the error_state
      drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled

Dave Chinner (1):
      xfs: fix periodic log flushing

David Henningsson (1):
      ALSA: hda - Fix mute led for another HP machine

Dmitry Kasatkin (1):
      evm: checking if removexattr is not a NULL

Fabio Estevam (1):
      i2c: mxs: Fix type of error code

Felix Fietkau (7):
      ath9k: do not link receive buffers during flush
      ath9k: add a better fix for the rx tasklet vs rx flush race
      ath9k: fix rx flush handling
      ath9k: remove sc->rx.rxbuflock to fix a deadlock
      ath9k: disable the tasklet before taking the PCU lock
      ath9k_hw: fix calibration issues on chainmask that don't include chain 0
      ath9k_hw: fix chain swap setting when setting rx chainmask to 5

H. Peter Anvin (2):
      x86/Sandy Bridge: mark arrays in __init functions as __initconst
      x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI

Hugh Daschbach (1):
      [libata] ahci: Add support for Enmotus Bobcat device.

Ilija Hadzic (2):
      drm/radeon: fix error path in kpage allocation
      drm/radeon: fix a rare case of double kfree

Jacob Schloss (1):
      gspca_kinect: add Kinect for Windows USB id

Jan Kara (1):
      xfs: Fix possible use-after-free with AIO

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: rm9200: remake the BGA as default version

Jerome Glisse (1):
      drm/radeon: fix cursor corruption on DCE6 and newer

Johannes Berg (1):
      mac80211: fix FT roaming

Konrad Rzeszutek Wilk (2):
      ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled
      intel_idle: Don't register CPU notifier if we are not running.

Linus Torvalds (1):
      module: fix missing module_mutex unlock

Matt Fleming (3):
      x86, efi: Set runtime_version to the EFI spec revision
      efi: Make 'efi_enabled' a function to query EFI facilities
      samsung-laptop: Disable on EFI hardware

Matt Wilson (1):
      xen/grant-table: correctly initialize grant table version 1

Maxime Ripard (1):
      tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler

Nathan Zimmer (1):
      efi, x86: Pass a proper identity mapping in efi_call_phys_prelog

Nicolas Pitre (1):
      ARM: 7628/1: head.S: map one extra section for the ATAG/DTB area

Oleg Nesterov (3):
      ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()
      ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
      wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task

Olivier Sobrie (3):
      can: c_can: fix invalid error codes
      can: ti_hecc: fix invalid error codes
      can: pch_can: fix invalid error codes

Piotr Haber (1):
      brcmsmac: increase timer reference count for new timers only

Pratyush Anand (1):
      usb: dwc3: gadget: fix ep->maxburst for ep0

Russell King (1):
      ARM: DMA: Fix struct page iterator in dma_cache_maint() to work with sparsemem

Rusty Russell (4):
      module: fix symbol waiting when module fails before init
      module: wait when loading a module which is currently initializing.
      module: add new state MODULE_STATE_UNFORMED.
      module: put modules in list much earlier.

Shuah Khan (1):
      ioat: Fix DMA memory sync direction correct flag

Stanislaw Gruszka (2):
      mac80211: synchronize scan off/on-channel and PS states
      iwlegacy: fix IBSS cleanup

Stephen Boyd (1):
      ARM: 7627/1: Predicate preempt logic on PREEMP_COUNT not PREEMPT alone

Stephen Hurd (1):
      8250/16?50: Add support for Broadcom TruManage redirected serial port

Steven Rostedt (1):
      ftrace: Be first to run code modification on modules

Sujith Manoharan (1):
      ath9k_htc: Fix memory leak

Suravee Suthikulpanit (1):
      IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround

Szymon Janc (1):
      Bluetooth: Fix sending HCI commands after reset

Takashi Iwai (3):
      ALSA: hda - Add Conexant CX20755/20756/20757 codec IDs
      ALSA: hda - Add a fixup for Packard-Bell desktop with ALC880
      ALSA: hda - Fix non-snoop page handling

Tejun Heo (1):
      async: fix __lowest_in_progress()

Thomas Schlichter (1):
      ACPI / processor: Get power info before updating the C-states

Tiejun Chen (1):
      powerpc/book3e: Disable interrupt after preempt_schedule_irq

Tormod Volden (1):
      staging: wlan-ng: Fix clamping of returned SSID length

Trond Myklebust (3):
      NFS: Fix error reporting in nfs_xdev_mount
      NFS: Don't silently fail setattr() requests on mountpoints
      NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session

Wang YanQing (1):
      smp: Fix SMP function call empty cpu mask race

Yijing Wang (1):
      PCI: pciehp: Use per-slot workqueues to avoid deadlock

Zhenzhong Duan (2):
      drivers/firmware/dmi_scan.c: check dmi version when get system uuid
      drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists

chao bi (1):
      serial:ifx6x60:Delete SPI timer when shut down port

xueminsu (1):
      radeon_display: Use pointer return error codes

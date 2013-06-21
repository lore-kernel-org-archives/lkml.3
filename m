Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161451Ab3FUJYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:24:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48252 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161413Ab3FUJYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:24:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.5.y.z extended stable] Linux 3.5.7.15
Date: Fri, 21 Jun 2013 10:24:15 +0100
Message-Id: <1371806656-7492-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.5.7.15 kernel.

The updated 3.5.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog

The diff from v3.5.7.14 is posted as a follow-up to this email.

The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Makefile                                           |   2 +-
 arch/arm/boot/compressed/Makefile                  |   2 +-
 arch/arm/boot/compressed/head-sa1100.S             |   1 +
 arch/arm/boot/compressed/head-shark.S              |   1 +
 arch/arm/boot/compressed/head.S                    |   1 +
 arch/arm/kernel/topology.c                         |   2 +
 arch/m68k/kernel/head.S                            |  29 +++--
 arch/powerpc/include/asm/exception-64s.h           |   2 +-
 arch/powerpc/kernel/exceptions-64s.S               |   2 +-
 arch/powerpc/kernel/irq.c                          |   2 +-
 arch/powerpc/kernel/process.c                      |   4 +-
 arch/powerpc/kernel/traps.c                        |  10 ++
 arch/powerpc/platforms/pseries/eeh_pseries.c       |  12 +--
 arch/x86/kernel/relocate_kernel_64.S               |   2 +-
 drivers/acpi/video.c                               |  32 ++++++
 drivers/ata/ata_piix.c                             |  14 +++
 drivers/ata/libata-core.c                          |   6 ++
 drivers/block/cciss.c                              |  32 +++---
 drivers/dma/ste_dma40.c                            |   9 +-
 drivers/gpu/drm/drm_irq.c                          |   6 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         |  14 +++
 drivers/gpu/drm/gma500/framebuffer.c               |   4 +-
 drivers/gpu/drm/gma500/psb_intel_display.c         |  14 +++
 drivers/gpu/drm/i915/intel_lvds.c                  |   4 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  12 ++-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   9 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |  11 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  10 +-
 drivers/gpu/drm/radeon/ni.c                        |  10 +-
 drivers/gpu/drm/radeon/r100.c                      |   9 +-
 drivers/gpu/drm/radeon/r300.c                      |   9 +-
 drivers/gpu/drm/radeon/r420.c                      |  10 +-
 drivers/gpu/drm/radeon/r520.c                      |   9 +-
 drivers/gpu/drm/radeon/r600.c                      |  10 +-
 drivers/gpu/drm/radeon/rs400.c                     |   9 +-
 drivers/gpu/drm/radeon/rs600.c                     |   9 +-
 drivers/gpu/drm/radeon/rs690.c                     |   9 +-
 drivers/gpu/drm/radeon/rv515.c                     |   9 +-
 drivers/gpu/drm/radeon/rv770.c                     |  10 +-
 drivers/gpu/drm/radeon/si.c                        |  10 +-
 drivers/hwmon/adm1021.c                            |  58 ++++++++--
 drivers/iommu/amd_iommu.c                          |  31 +++++-
 drivers/iommu/amd_iommu_types.h                    |   1 +
 drivers/md/raid1.c                                 |  34 +++---
 drivers/md/raid10.c                                |  26 +++--
 drivers/net/ethernet/broadcom/tg3.c                |  42 ++++++++
 drivers/net/ethernet/broadcom/tg3.h                |   8 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |  10 +-
 drivers/net/wireless/ath/ath9k/Makefile            |   2 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  10 +-
 drivers/net/wireless/ath/ath9k/init.c              |   7 +-
 drivers/net/wireless/ath/ath9k/rc.h                |   2 +-
 drivers/net/wireless/b43/main.c                    |   2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c         |   2 +-
 drivers/net/xen-netfront.c                         |  17 ++-
 drivers/platform/x86/thinkpad_acpi.c               |   7 ++
 drivers/regulator/palmas-regulator.c               |   2 +-
 drivers/rtc/rtc-twl.c                              |   1 +
 drivers/usb/dwc3/gadget.c                          |  15 ++-
 drivers/usb/host/ehci-sched.c                      |   2 +-
 drivers/usb/host/xhci-mem.c                        |  10 +-
 drivers/usb/host/xhci.c                            |  12 ++-
 drivers/usb/serial/ark3116.c                       |   2 +-
 drivers/usb/serial/cypress_m8.c                    |  18 +++-
 drivers/usb/serial/cypress_m8.h                    |   4 +
 drivers/usb/serial/ftdi_sio.c                      |   2 +-
 drivers/usb/serial/iuu_phoenix.c                   |   4 +-
 drivers/usb/serial/keyspan.c                       |   2 +-
 drivers/usb/serial/mos7720.c                       |  25 +++--
 drivers/usb/serial/mos7840.c                       |  35 ++++--
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/serial/pl2303.c                        |  10 +-
 drivers/usb/serial/qcserial.c                      |   2 +
 drivers/usb/serial/spcp8x5.c                       |  10 +-
 drivers/usb/serial/visor.c                         |   9 ++
 drivers/usb/serial/whiteheat.c                     |   2 +-
 drivers/xen/events.c                               |  19 +++-
 fs/ceph/locks.c                                    |  73 ++++++++-----
 fs/ceph/mds_client.c                               |  90 ++++++++--------
 fs/ceph/super.c                                    |   7 +-
 fs/ceph/super.h                                    |  11 +-
 fs/ext4/super.c                                    |   2 +
 fs/hpfs/file.c                                     |  24 +++--
 fs/hpfs/hpfs_fn.h                                  |   1 +
 fs/hpfs/inode.c                                    |   5 +-
 fs/proc/kmsg.c                                     |  10 +-
 include/linux/ceph/auth.h                          |  18 ++++
 include/linux/cpu.h                                |   4 +
 include/linux/swapops.h                            |   3 +
 include/linux/syslog.h                             |   4 +-
 include/net/bluetooth/hci_core.h                   |   1 +
 include/net/bluetooth/mgmt.h                       |   1 +
 include/xen/interface/io/netif.h                   |   1 +
 kernel/audit.c                                     |   2 +-
 kernel/cpu.c                                       |  55 ++++------
 kernel/printk.c                                    |  91 ++++++++--------
 kernel/sys.c                                       |  29 ++++-
 lib/klist.c                                        |   2 +-
 mm/hugetlb.c                                       |   2 +-
 mm/migrate.c                                       |  23 +++-
 mm/swap_state.c                                    |  18 +++-
 net/bluetooth/hci_core.c                           |   6 +-
 net/bluetooth/mgmt.c                               |  21 ++++
 net/ceph/auth.c                                    | 117 +++++++++++++++++----
 net/ceph/auth_x.c                                  |  24 ++++-
 net/ceph/auth_x.h                                  |   1 +
 net/ceph/messenger.c                               |   3 +-
 net/ceph/mon_client.c                              |   7 +-
 net/ceph/osd_client.c                              |  33 +++---
 net/mac80211/iface.c                               |   9 ++
 net/wireless/sme.c                                 |   3 +
 sound/core/pcm_native.c                            |   4 +-
 sound/usb/mixer.c                                  |   1 +
 sound/usb/quirks-table.h                           |  14 ++-
 114 files changed, 1104 insertions(+), 425 deletions(-)

Adis Hamzić (1):
      radeon: Fix system hang issue when using KMS with older cards

Al Viro (1):
      snd_pcm_link(): fix a leak...

Alan Stern (1):
      USB: revert periodic scheduling bugfix

Alex Deucher (1):
      drm/radeon: don't allow audio on DCE6

Alex Elder (3):
      libceph: register request before unregister linger
      libceph: always reset osds when kicking
      libceph: must hold mutex for reset_changed_osds()

Alex Hung (2):
      ACPI video: ignore BIOS initial backlight value for HP 1000
      ACPI / video: ignore BIOS initial backlight value for HP m4

Alex Lyakas (1):
      md/raid1: consider WRITE as successful only if at least one non-Faulty and non-rebuilding drive completed it.

Arnd Bergmann (2):
      ARM: 7742/1: topology: export cpu_topology
      ARM: 7743/1: compressed/head.S: work around new binutils warning

Ash Willis (1):
      ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6

Ben Mesman (1):
      drm/i915: no lvds quirk for hp t5740

Benjamin Herrenschmidt (1):
      powerpc: Fix missing/delayed calls to irq_work

Bjørn Mork (1):
      USB: option: blacklist network interface on Huawei E1820

Chew, Chiau Ee (1):
      ata_piix: add PCI IDs for Intel BayTail

Christopher Harvey (1):
      drm/mgag200: Add missing write to index before accessing data register

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland/Cakewalk UM-3G support

Daniel Vetter (1):
      drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.

Emmanuel Grumbach (1):
      iwlwifi: dvm: fix zero LQ CMD sending avoidance

Felix Fietkau (1):
      Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity"

Finn Thain (1):
      m68k/mac: Fix unexpected interrupt with CONFIG_EARLY_PRINTK

Gavin Shan (1):
      powerpc/eeh: Don't check RTAS token to get PE addr

George Cherian (1):
      usb: dwc3: gadget: free trb pool only from epnum 2

Guenter Roeck (1):
      hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1617

Gustavo Maciel Dias Vieira (1):
      ACPI video: ignore BIOS backlight value for HP dm4

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled

Jim Schutt (2):
      ceph: add cpu_to_le32() calls when encoding a reconnect capability
      ceph: ceph_pagelist_append might sleep while atomic

Joerg Roedel (1):
      iommu/amd: Workaround for ERBT1312

Johan Hedberg (1):
      Bluetooth: Fix mgmt handling of power on failures

Johan Hovold (12):
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
      USB: visor: fix initialisation of Treo/Kyocera devices
      USB: mos7720: fix DMA to stack
      USB: mos7840: fix DMA to stack
      USB: ark3116: fix control-message timeout
      USB: iuu_phoenix: fix bulk-message timeout
      USB: mos7720: fix message timeouts
      USB: keyspan: fix bogus array index
      USB: mos7720: fix hardware flow control
      USB: whiteheat: fix broken port configuration
      USB: spcp8x5: fix device initialisation at open
      USB: pl2303: fix device initialisation at open

Johannes Berg (2):
      cfg80211: check wdev->netdev in connection work
      mac80211: close AP_VLAN interfaces before unregistering all

Kees Cook (3):
      b43: stop format string leaking into error msgs
      kmsg: honor dmesg_restrict sysctl on /dev/kmsg
      x86: Fix typo in kexec register clearing

Keir Fraser (1):
      xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.

Kishon Vijay Abraham I (1):
      regulator: palmas: Fix "enable_reg" to point to the correct reg for SMPS10

Luis Henriques (1):
      Linux 3.5.7.15

Manoj Iyer (1):
      thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR

Marco Stornelli (1):
      hpfs: drop vmtruncate

Michael Chan (1):
      tg3: Add New 5719 Read DMA workaround

Michael Ellerman (1):
      powerpc: Fix stack overflow crash in resume_kernel when ftracing

Mikulas Patocka (1):
      hpfs: fix warnings when the filesystem fills up

Naoya Horiguchi (1):
      mm: migration: add migrate_entry_wait_huge()

NeilBrown (1):
      md/raid1,raid10: use freeze_array in place of raise_barrier in various places.

Nithin Sujir (2):
      tg3: Add read dma workaround for 5720
      tg3: Wait for boot code to finish after power on

Oleg Nesterov (1):
      audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE

Patrik Jakobsson (3):
      drm/gma500: Increase max resolution for mode setting
      drm/gma500/psb: Unpin framebuffer on crtc disable
      drm/gma500/cdv: Unpin framebuffer on crtc disable

Paul Mackerras (1):
      powerpc: Fix emulation of illegal instructions on PowerNV platform

Rabin Vincent (1):
      dmaengine: ste_dma40: fix pm runtime ref counting

Rafael Aquini (1):
      swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion

Richard Weinberger (1):
      USB: serial: Add Option GTM681W to qcserial device table.

Robert Butora (1):
      USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device

Robin Holt (1):
      reboot: rigrate shutdown/reboot to boot cpu

Sage Weil (6):
      libceph: clear messenger auth_retry flag when we authenticate
      libceph: fix authorizer invalidation
      libceph: add update_authorizer auth method
      libceph: wrap auth ops in wrapper functions
      libceph: wrap auth methods in a mutex
      ceph: fix statvfs fr_size

Sergio Aguirre (1):
      xhci-mem: init list heads at the beginning of init

Srivatsa S. Bhat (1):
      CPU hotplug: provide a generic helper to disable/enable CPU hotplug

Stephen M. Cameron (1):
      cciss: fix broken mutex usage in ioctl

Sujith Manoharan (2):
      ath9k: Disable PowerSave by default
      ath9k: Use minstrel rate control by default

Suravee Suthikulpanit (1):
      iommu/amd: Re-enable IOMMU event log interrupt after handling.

Takashi Iwai (2):
      ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audio iface
      ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270

Theodore Ts'o (1):
      ext4: lock i_mutex when truncating orphan inodes

Tony Camuso (1):
      xhci - correct comp_mode_recovery_timer on return from hibernate

Tony Lindgren (1):
      drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR

Vladimir Murzin (1):
      xhci: fix list access before init

Wei Liu (1):
      xen-netfront: reduce gso_max_size to account for max TCP header

Ying Xue (1):
      USB: ftdi_sio: Quiet sparse noise about using plain integer was NULL pointer

wang, biao (1):
      klist: del waiter from klist_remove_waiters before wakeup waitting process


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161138Ab3FTSlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:41:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44265 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161117Ab3FTSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:41:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.3
Date: Thu, 20 Jun 2013 11:41:06 -0700
Message-Id: <1371753667-26435-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.3 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.2 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                           |  2 +-
 arch/arm/boot/compressed/Makefile                  |  2 +-
 arch/arm/boot/compressed/head-sa1100.S             |  1 +
 arch/arm/boot/compressed/head-shark.S              |  1 +
 arch/arm/boot/compressed/head.S                    |  1 +
 arch/arm/include/asm/percpu.h                      | 11 ++-
 arch/arm/kernel/topology.c                         |  2 +
 arch/powerpc/platforms/pseries/eeh_pseries.c       | 12 ++-
 arch/x86/kernel/relocate_kernel_64.S               |  2 +-
 arch/x86/pci/common.c                              |  5 +-
 arch/x86/xen/smp.c                                 |  8 ++
 drivers/acpi/video.c                               | 32 ++++++++
 drivers/block/cciss.c                              | 32 ++++----
 drivers/block/rbd.c                                | 10 +--
 drivers/cpufreq/acpi-cpufreq.c                     |  4 +-
 drivers/dma/ste_dma40.c                            |  8 +-
 drivers/gpu/drm/drm_irq.c                          |  6 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         | 14 ++++
 drivers/gpu/drm/gma500/psb_intel_display.c         | 14 ++++
 drivers/gpu/drm/i915/intel_lvds.c                  |  4 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  | 12 +--
 drivers/gpu/drm/mgag200/mgag200_mode.c             |  9 ++-
 drivers/gpu/drm/radeon/atombios_encoders.c         | 11 ++-
 drivers/gpu/drm/radeon/evergreen.c                 | 10 ++-
 drivers/gpu/drm/radeon/ni.c                        | 10 ++-
 drivers/gpu/drm/radeon/r100.c                      |  9 ++-
 drivers/gpu/drm/radeon/r300.c                      |  9 ++-
 drivers/gpu/drm/radeon/r420.c                      | 10 ++-
 drivers/gpu/drm/radeon/r520.c                      |  9 ++-
 drivers/gpu/drm/radeon/r600.c                      | 10 ++-
 drivers/gpu/drm/radeon/rs400.c                     |  9 ++-
 drivers/gpu/drm/radeon/rs600.c                     |  9 ++-
 drivers/gpu/drm/radeon/rs690.c                     |  9 ++-
 drivers/gpu/drm/radeon/rv515.c                     |  9 ++-
 drivers/gpu/drm/radeon/rv770.c                     | 10 ++-
 drivers/gpu/drm/radeon/si.c                        | 10 ++-
 drivers/hwmon/adm1021.c                            | 58 ++++++++++++--
 drivers/md/raid1.c                                 | 38 +++++----
 drivers/md/raid10.c                                | 29 ++++---
 drivers/md/raid5.c                                 |  4 +-
 drivers/net/can/usb/kvaser_usb.c                   | 64 ++++++++++-----
 drivers/net/ethernet/broadcom/tg3.c                | 21 +++--
 drivers/net/ethernet/broadcom/tg3.h                |  5 +-
 drivers/net/wireless/ath/ath9k/Kconfig             | 10 ++-
 drivers/net/wireless/ath/ath9k/Makefile            |  2 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   | 10 +--
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |  9 ++-
 drivers/net/wireless/ath/ath9k/init.c              |  7 +-
 drivers/net/wireless/ath/ath9k/rc.h                |  2 +-
 drivers/net/wireless/b43/main.c                    |  2 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c             |  2 +-
 drivers/regulator/palmas-regulator.c               |  2 +-
 drivers/rtc/rtc-twl.c                              |  1 +
 drivers/usb/dwc3/dwc3-pci.c                        |  2 +-
 drivers/usb/dwc3/gadget.c                          | 14 +++-
 drivers/usb/host/ehci-sched.c                      |  2 +-
 drivers/usb/host/xhci-mem.c                        | 10 ++-
 drivers/usb/host/xhci-pci.c                        |  8 ++
 drivers/usb/host/xhci.c                            | 16 +++-
 drivers/usb/host/xhci.h                            |  3 +
 drivers/usb/musb/musb_host.c                       | 18 ++---
 drivers/usb/musb/musb_host.h                       |  1 +
 drivers/usb/serial/ark3116.c                       |  2 +-
 drivers/usb/serial/cypress_m8.c                    | 18 ++++-
 drivers/usb/serial/cypress_m8.h                    |  4 +
 drivers/usb/serial/iuu_phoenix.c                   |  4 +-
 drivers/usb/serial/keyspan.c                       |  2 +-
 drivers/usb/serial/mos7720.c                       | 25 ++++--
 drivers/usb/serial/mos7840.c                       | 35 +++++++--
 drivers/usb/serial/option.c                        | 26 +------
 drivers/usb/serial/qcserial.c                      |  1 +
 drivers/usb/serial/visor.c                         |  9 +++
 drivers/usb/serial/whiteheat.c                     |  2 +-
 drivers/usb/serial/zte_ev.c                        | 58 ++++++++------
 fs/ceph/locks.c                                    | 73 ++++++++++-------
 fs/ceph/mds_client.c                               | 65 +++++++++-------
 fs/ceph/super.c                                    |  7 +-
 fs/ceph/super.h                                    | 11 ++-
 fs/cifs/connect.c                                  |  4 +-
 fs/ecryptfs/file.c                                 |  6 ++
 fs/hpfs/file.c                                     |  4 +
 fs/proc/kmsg.c                                     | 10 +--
 include/linux/cpu.h                                |  4 +
 include/linux/swapops.h                            |  3 +
 include/linux/syslog.h                             |  4 +-
 include/net/bluetooth/hci_core.h                   |  1 +
 include/net/bluetooth/mgmt.h                       |  1 +
 kernel/audit.c                                     |  2 +-
 kernel/cpu.c                                       | 55 ++++++-------
 kernel/printk.c                                    | 91 ++++++++++++----------
 kernel/sys.c                                       | 29 ++++++-
 mm/hugetlb.c                                       |  2 +-
 mm/migrate.c                                       | 23 ++++--
 mm/page_alloc.c                                    |  6 +-
 mm/swap_state.c                                    | 18 ++++-
 net/bluetooth/hci_core.c                           |  6 +-
 net/bluetooth/l2cap_core.c                         | 70 ++++++++++++-----
 net/bluetooth/mgmt.c                               | 21 +++++
 net/ceph/osd_client.c                              |  2 +-
 net/mac80211/iface.c                               |  9 +++
 net/wireless/sme.c                                 |  3 +
 sound/usb/mixer.c                                  |  1 +
 sound/usb/quirks-table.h                           | 14 +++-
 103 files changed, 949 insertions(+), 448 deletions(-)

Adis Hamzić (1):
      radeon: Fix system hang issue when using KMS with older cards

Alan Stern (1):
      USB: revert periodic scheduling bugfix

Alex Deucher (1):
      drm/radeon: don't allow audio on DCE6

Alex Elder (2):
      libceph: must hold mutex for reset_changed_osds()
      rbd: don't destroy ceph_opts in rbd_add()

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

Bjørn Mork (1):
      USB: option: blacklist network interface on Huawei E1820

Christopher Harvey (1):
      drm/mgag200: Add missing write to index before accessing data register

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland/Cakewalk UM-3G support

Dan Williams (1):
      USB: option,zte_ev: move most ZTE CDMA devices to zte_ev

Daniel Vetter (1):
      drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.

Emmanuel Grumbach (1):
      iwlwifi: dvm: fix zero LQ CMD sending avoidance

Felix Fietkau (1):
      Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity"

Gabor Juhos (1):
      ath9k: use correct OTP register offsets for AR9550

Gavin Shan (1):
      powerpc/eeh: Don't check RTAS token to get PE addr

George Cherian (1):
      usb: dwc3: gadget: free trb pool only from epnum 2

Guenter Roeck (1):
      hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1617

Gustavo Maciel Dias Vieira (1):
      ACPI video: ignore BIOS backlight value for HP dm4

H. Peter Anvin (1):
      md/raid1,5,10: Disable WRITE SAME until a recovery strategy is in place

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled

Jeff Layton (1):
      cifs: fix off-by-one bug in build_unc_path_to_root

Jim Schutt (2):
      ceph: add cpu_to_le32() calls when encoding a reconnect capability
      ceph: ceph_pagelist_append might sleep while atomic

Johan Hedberg (2):
      Bluetooth: Fix missing length checks for L2CAP signalling PDUs
      Bluetooth: Fix mgmt handling of power on failures

Johan Hovold (12):
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
      USB: visor: fix initialisation of Treo/Kyocera devices
      USB: mos7720: fix DMA to stack
      USB: mos7840: fix DMA to stack
      USB: ark3116: fix control-message timeout
      USB: iuu_phoenix: fix bulk-message timeout
      USB: mos7720: fix message timeouts
      USB: zte_ev: fix control-message timeouts
      USB: zte_ev: fix broken open
      USB: keyspan: fix bogus array index
      USB: mos7720: fix hardware flow control
      USB: whiteheat: fix broken port configuration

Johannes Berg (2):
      cfg80211: check wdev->netdev in connection work
      mac80211: close AP_VLAN interfaces before unregistering all

Jonas Peterson (1):
      net: can: kvaser_usb: fix reception on "USBcan Pro" and "USBcan R" type hardware.

Kamal Mostafa (1):
      Linux 3.8.13.3

Kees Cook (3):
      b43: stop format string leaking into error msgs
      x86: Fix typo in kexec register clearing
      kmsg: honor dmesg_restrict sysctl on /dev/kmsg

Kishon Vijay Abraham I (1):
      regulator: palmas: Fix "enable_reg" to point to the correct reg for SMPS10

Konrad Rzeszutek Wilk (1):
      xen/smp: Fixup NOHZ per cpu data when onlining an offline CPU.

Matt Fleming (1):
      x86/PCI: Map PCI setup data with ioremap() so it can be in highmem

Mikulas Patocka (1):
      hpfs: fix warnings when the filesystem fills up

Naoya Horiguchi (1):
      mm: migration: add migrate_entry_wait_huge()

NeilBrown (1):
      md/raid1,raid10: use freeze_array in place of raise_barrier in various places.

Nithin Sujir (1):
      tg3: Add read dma workaround for 5720

Oleg Nesterov (1):
      audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE

Patrik Jakobsson (2):
      drm/gma500/psb: Unpin framebuffer on crtc disable
      drm/gma500/cdv: Unpin framebuffer on crtc disable

Paul Taysom (1):
      ecryptfs: fixed msync to flush data

Peter Chen (1):
      usb: dwc3: pci: PHY should be deleted later than dwc3 core

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

Ross Lagerwall (1):
      acpi-cpufreq: set current frequency based on target P-State

Sage Weil (1):
      ceph: fix statvfs fr_size

Sarah Sharp (1):
      xhci: Disable D3cold for buggy TI redrivers.

Sergio Aguirre (1):
      xhci-mem: init list heads at the beginning of init

Srivatsa S. Bhat (1):
      CPU hotplug: provide a generic helper to disable/enable CPU hotplug

Stephen M. Cameron (1):
      cciss: fix broken mutex usage in ioctl

Sujith Manoharan (2):
      ath9k: Disable PowerSave by default
      ath9k: Use minstrel rate control by default

Takashi Iwai (2):
      ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audio iface
      ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270

Tomasz Stanislawski (1):
      mm/page_alloc.c: fix watermark check in __zone_watermark_ok()

Tony Camuso (1):
      xhci - correct comp_mode_recovery_timer on return from hibernate

Tony Lindgren (1):
      drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree

Tyler Hicks (1):
      eCryptfs: Check return of filemap_write_and_wait during fsync

Virupax Sadashivpetimath (1):
      usb: musb: make use_sg flag URB specific

Vladimir Murzin (1):
      xhci: fix list access before init

Will Deacon (1):
      ARM: 7747/1: pcpu: ensure __my_cpu_offset cannot be re-ordered across barrier()


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3FDQ4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:56:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48198 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3FDQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:56:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [ 3.8.y.z extended stable ] Linux 3.8.13.2 stable review
Date: Tue,  4 Jun 2013 09:54:44 -0700
Message-Id: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.2 stable kernel.

This version contains 75 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.2 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 arch/arm/boot/dts/at91sam9260.dtsi                |  2 +-
 arch/arm/boot/dts/at91sam9g25ek.dts               |  9 +++
 arch/arm/boot/dts/at91sam9g35ek.dts               |  9 +++
 arch/arm/boot/dts/at91sam9x25ek.dts               | 16 +++-
 arch/arm/boot/dts/at91sam9x35ek.dts               |  9 +++
 arch/arm/boot/dts/at91sam9x5ek.dtsi               |  5 --
 arch/arm/crypto/aes-armv4.S                       | 64 +++++-----------
 arch/arm/crypto/sha1-armv4-large.S                | 26 +++----
 arch/arm64/kernel/traps.c                         | 12 ++-
 arch/avr32/kernel/module.c                        |  2 +-
 arch/m68k/kernel/head.S                           | 29 ++++---
 arch/powerpc/kernel/entry_32.S                    |  2 +-
 arch/powerpc/platforms/pseries/Kconfig            |  2 +
 arch/x86/kernel/i387.c                            | 14 ++--
 drivers/acpi/video_detect.c                       |  8 ++
 drivers/ata/ata_piix.c                            | 15 ++++
 drivers/ata/libata-core.c                         |  6 ++
 drivers/block/brd.c                               |  4 +-
 drivers/block/drbd/drbd_main.c                    |  1 +
 drivers/block/drbd/drbd_receiver.c                |  5 +-
 drivers/char/random.c                             | 54 +++++++------
 drivers/crypto/caam/caamalg.c                     |  4 +-
 drivers/gpu/drm/i915/i915_drv.c                   | 49 +++++++++---
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c   |  4 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c |  2 -
 drivers/gpu/drm/radeon/evergreen.c                |  4 +-
 drivers/gpu/drm/radeon/radeon_device.c            | 19 +++--
 drivers/gpu/drm/radeon/radeon_ttm.c               |  2 +-
 drivers/gpu/drm/radeon/si.c                       |  6 +-
 drivers/hwmon/abituguru.c                         | 16 ++--
 drivers/i2c/busses/i2c-designware-core.c          | 14 +++-
 drivers/i2c/busses/i2c-designware-core.h          |  2 +
 drivers/infiniband/ulp/srpt/ib_srpt.c             | 32 ++++++--
 drivers/infiniband/ulp/srpt/ib_srpt.h             |  1 +
 drivers/input/touchscreen/egalax_ts.c             |  2 +-
 drivers/leds/leds-ot200.c                         | 14 ++--
 drivers/net/wireless/ath/ath9k/ar9003_calib.c     | 92 +++++++++++++----------
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h  |  2 +-
 drivers/net/wireless/ath/ath9k/hw.h               |  1 +
 drivers/rapidio/devices/tsi721.c                  | 12 +++
 drivers/staging/vt6656/hostap.c                   |  2 +-
 drivers/staging/vt6656/iwctl.c                    |  6 ++
 drivers/target/iscsi/iscsi_target_parameters.c    |  8 +-
 drivers/target/iscsi/iscsi_target_parameters.h    |  4 +-
 drivers/tty/n_tty.c                               |  8 ++
 drivers/usb/atm/cxacru.c                          |  3 +-
 drivers/usb/chipidea/Kconfig                      |  2 +-
 drivers/usb/core/quirks.c                         |  3 +
 drivers/usb/host/ohci-hcd.c                       | 34 +++++----
 drivers/usb/host/uhci-hub.c                       |  3 +-
 drivers/usb/host/uhci-q.c                         |  2 +-
 drivers/usb/host/xhci-mem.c                       | 17 +++--
 drivers/usb/serial/ftdi_sio.c                     |  2 +
 drivers/usb/serial/ftdi_sio_ids.h                 |  2 +
 drivers/usb/serial/option.c                       | 13 +++-
 fs/cifs/cifs_dfs_ref.c                            |  4 +-
 fs/cifs/inode.c                                   |  3 +-
 fs/fat/inode.c                                    | 15 +++-
 fs/nfs/nfs4proc.c                                 |  2 +-
 fs/nilfs2/inode.c                                 | 27 ++++++-
 fs/ocfs2/extent_map.c                             |  2 +-
 fs/xfs/xfs_iops.c                                 | 47 ++++++++----
 include/linux/cgroup.h                            |  2 +-
 include/linux/huge_mm.h                           |  2 +-
 include/linux/rmap.h                              |  2 +-
 include/linux/wait.h                              | 16 ++--
 include/uapi/linux/virtio_console.h               |  2 +-
 kernel/cgroup.c                                   |  9 +--
 mm/huge_memory.c                                  | 13 +++-
 mm/memcontrol.c                                   | 14 +++-
 mm/migrate.c                                      |  2 +-
 mm/mmap.c                                         |  4 +-
 mm/mmu_notifier.c                                 | 80 ++++++++++----------
 mm/mremap.c                                       |  2 +-
 mm/pagewalk.c                                     | 70 ++++++++---------
 mm/rmap.c                                         |  6 +-
 net/mac80211/rx.c                                 |  3 +
 net/sunrpc/sched.c                                |  8 +-
 net/wireless/core.c                               | 16 ++--
 sound/soc/codecs/cs42l52.c                        |  2 +-
 sound/soc/codecs/wm5110.c                         |  2 +-
 tools/perf/scripts/python/net_dropmonitor.py      |  8 +-
 82 files changed, 652 insertions(+), 392 deletions(-)

Alan Stern (4):
      USB: xHCI: override bogus bulk wMaxPacketSize values
      USB: UHCI: fix for suspend of virtual HP controller
      USB: fix latency in uhci-hcd and ohci-hcd
      USB: OHCI: fix logic for scheduling isochronous URBs

Alex Deucher (2):
      drm/radeon: fix typo in cu_per_sh on verde
      drm/radeon: fix card_posted check for newer asics

Alexandre Bounine (1):
      rapidio/tsi721: fix bug in MSI interrupt handling

Aneesh Kumar K.V (1):
      mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

Ard Biesheuvel (1):
      ARM: 7723/1: crypto: sha1-armv4-large.S: fix SP handling

Bastian Triller (1):
      ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist

Ben Hutchings (2):
      perf: net_dropmonitor: Fix trace parameter order
      perf: net_dropmonitor: Fix symbol-relative addresses

Ben Skeggs (2):
      drm/nouveau/bios: fix thinko in ZM_MASK_ADD opcode
      drm/nvc0/ce: disable ce1 on a number of chipsets

Boris BREZILLON (1):
      ARM: at91/dt: fix macb pinctrl_macb_rmii_mii_alt definition

Brian Behlendorf (1):
      drivers/block/brd.c: fix brd_lookup_page() race

Charles Keepax (1):
      ASoC: wm5110: Correct DSP4R Mixer control name

Chew, Chiau Ee (1):
      ata_piix: add PCI IDs for Intel BayTail

Christian Gmeiner (1):
      drivers/leds/leds-ot200.c: fix error caused by shifted mask

Cliff Wickman (1):
      mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

Dan Carpenter (1):
      USB: cxacru: potential underflow in cxacru_cm_get_array()

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

Dave Chinner (1):
      xfs: kill suid/sgid through the truncate path.

Dave Martin (1):
      ARM: 7626/1: arm/crypto: Make asm SHA-1 and AES code Thumb-2 compatible

David Rientjes (1):
      usb, chipidea: fix link error when USB_EHCI_HCD is a module

Finn Thain (1):
      m68k/mac: Fix unexpected interrupt with CONFIG_EARLY_PRINTK

Gomella, Andrew (NIH/NHLBI) [F] (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers

Hans-Christian Egtvedt (1):
      avr32: fix relocation check for signed 18-bit offset

Heiko Abraham (1):
      Input: egalax_ts - ABS_MT_POSITION_Y not reported well

Hema Prathaban (1):
      staging: vt6656: use free_netdev instead of kfree

Horia Geanta (1):
      crypto: caam - fix inconsistent assoc dma mapping direction

Imre Deak (1):
      wait: fix false timeouts when using wait_event_timeout()

Jarod Wilson (1):
      drivers/char/random.c: fix priming of last_data

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91/trivial: fix model name for SAM9X25-EK

Jeff Layton (2):
      cifs: only set ops for inodes in I_NEW state
      cifs: fix potential buffer overrun when composing a new options string

Jesse Barnes (1):
      drm/i915: add more VLV IDs

Jiri Kosina (1):
      random: fix accounting race condition with lockless irq entropy_count update

Johannes Berg (2):
      cfg80211: fix wiphy_register error path
      mac80211: fix AP-mode frame matching

Johannes Weiner (1):
      mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge

Josef Ahmad (1):
      i2c: designware: fix RX FIFO overrun

Joseph Qi (1):
      ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()

Kees Cook (1):
      iscsi-target: fix heap buffer overflow on error

Konstantin Khlebnikov (1):
      mm/rmap: rename anon_vma_unlock() => anon_vma_unlock_write()

Lars Ellenberg (1):
      drbd: fix memory leak

Leonid Yegoshin (1):
      mm compaction: fix of improper cache flush in migration code

Malcolm Priestley (1):
      staging: vt6656: [bug] Fix missing spin lock in iwctl_siwpower.

Mark Rutland (1):
      arm64: don't kill the kernel on a bad esr from el0

Michael S. Tsirkin (1):
      virtio_console: fix uapi header

Mika Westerberg (1):
      i2c: designware: always clear interrupts before enabling them

Nicholas Bellinger (1):
      ib_srpt: Call target_sess_cmd_list_set_waiting during shutdown_session

Nicolas Ferre (1):
      ARM: at91/dt: fix macb node declaration

Nicolas Schichan (1):
      ASoC: cs42l52: fix default value for MASTERA_VOL.

Niels Ole Salscheider (1):
      drm/radeon: Fix VRAM size calculation for VRAM >= 4GB

OGAWA Hirofumi (1):
      fat: fix possible overflow for fat_clusters

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub

Pekka Riikonen (1):
      x86: Allow FPU to be used at interrupt time even with eagerfpu

Philipp Reisner (2):
      drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set
      drbd: fix for deadlock when using automatic split-brain-recovery

Priyanka Jain (1):
      powerpc/32bit:Store temporary result in r0 instead of r8

Rodrigo Vivi (1):
      drm/i915: Adding more reserved PCI IDs for Haswell.

Ryusuke Konishi (1):
      nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface

Srivatsa S. Bhat (1):
      powerpc/pseries: Always enable CONFIG_HOTPLUG_CPU on PSERIES SMP

Sujith Manoharan (2):
      ath9k_hw: Use helper routines to simplify ar9003_hw_init_cal()
      ath9k_hw: Enable manual peak calibration for AR9485

Tejun Heo (1):
      cgroup: fix a subtle bug in descendant pre-order walk

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G

Trond Myklebust (2):
      SUNRPC: Prevent an rpc_task wakeup race
      NFSv4: Fix a thinko in nfs4_try_open_cached

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR

Wang YanQing (1):
      TTY: Fix tty miss restart after we turn off flow-control

Wei Yongjun (1):
      hwmon: fix error return code in abituguru_probe()

Xiao Guangrong (1):
      mm: mmu_notifier: re-fix freed page still mapped in secondary MMU

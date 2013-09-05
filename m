Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab3IER1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:27:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60004 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3IER1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:27:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.8
Date: Thu,  5 Sep 2013 10:27:15 -0700
Message-Id: <1378402036-28674-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.8 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.7 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                    |   2 +-
 arch/arm/boot/dts/at91sam9n12ek.dts         |   4 +-
 arch/arm/include/asm/tlb.h                  |  34 +++-------
 arch/arm/kernel/entry-armv.S                |   3 +
 arch/arm/kernel/perf_event.c                |   3 +
 arch/arm/kernel/traps.c                     |  23 ++++---
 arch/arm/mach-davinci/board-dm355-leopard.c |   1 +
 arch/arm/mach-davinci/board-dm644x-evm.c    |   1 +
 arch/arm/mach-davinci/board-dm646x-evm.c    |   1 +
 arch/arm/mach-davinci/board-neuros-osd2.c   |   1 +
 arch/arm/mm/Kconfig                         |  37 ++++++++++
 arch/arm64/include/asm/tlb.h                |   7 +-
 arch/arm64/kernel/perf_event.c              |  10 ++-
 arch/ia64/include/asm/tlb.h                 |  50 ++++----------
 arch/m68k/emu/natfeat.c                     |  23 +++++--
 arch/m68k/include/asm/div64.h               |   9 +--
 arch/s390/include/asm/tlb.h                 |   8 ++-
 arch/sh/include/asm/tlb.h                   |   6 +-
 arch/um/include/asm/tlb.h                   |   6 +-
 arch/x86/kernel/sys_x86_64.c                |   2 +-
 arch/x86/mm/mmap.c                          |   6 +-
 drivers/ata/libata-pmp.c                    |  12 ++--
 drivers/ata/sata_fsl.c                      |   5 +-
 drivers/block/rbd.c                         |   2 +-
 drivers/bluetooth/ath3k.c                   |  10 +++
 drivers/bluetooth/btusb.c                   |   5 ++
 drivers/gpu/drm/i915/i915_dma.c             |   9 +--
 drivers/gpu/drm/i915/i915_drv.c             |  48 ++++++-------
 drivers/gpu/drm/i915/i915_drv.h             |   4 +-
 drivers/gpu/drm/i915/i915_irq.c             |   3 +-
 drivers/gpu/drm/i915/i915_reg.h             |   2 +
 drivers/gpu/drm/i915/intel_display.c        | 102 ++++++++++++++++++----------
 drivers/gpu/drm/i915/intel_fb.c             |   2 +-
 drivers/gpu/drm/i915/intel_panel.c          |   2 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c     |  12 ++++
 drivers/md/raid1.c                          |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c     |   2 +-
 drivers/net/wireless/hostap/hostap_ioctl.c  |   4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c    |  16 ++---
 drivers/net/wireless/iwlegacy/common.c      |   1 +
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |   5 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c   |  10 +--
 drivers/net/wireless/zd1201.c               |   4 +-
 drivers/of/fdt.c                            |   2 +
 drivers/platform/olpc/olpc-ec.c             |   2 +-
 drivers/s390/scsi/zfcp_erp.c                |  29 ++++++--
 drivers/s390/scsi/zfcp_qdio.c               |   8 +--
 drivers/usb/core/quirks.c                   |   6 ++
 drivers/usb/host/ehci-sched.c               |  13 ++--
 drivers/usb/misc/adutux.c                   |   2 +-
 drivers/usb/serial/keyspan.c                |   2 +-
 drivers/usb/serial/mos7720.c                |  21 ++++--
 drivers/usb/serial/mos7840.c                |   2 +-
 drivers/usb/serial/ti_usb_3410_5052.c       |   9 +--
 drivers/usb/serial/usb_wwan.c               |  20 +++---
 drivers/xen/events.c                        |  13 +++-
 fs/bio.c                                    |  32 ++++++---
 fs/exec.c                                   |   4 +-
 fs/exofs/ore.c                              |   2 +-
 fs/exofs/ore_raid.c                         |   2 +-
 fs/ext4/ext4_jbd2.c                         |   8 +--
 fs/nilfs2/segbuf.c                          |   5 +-
 include/asm-generic/tlb.h                   |  19 +-----
 include/linux/bio.h                         |  17 ++++-
 include/linux/mm_types.h                    |   1 +
 include/linux/wait.h                        |  57 ++++++++++++++++
 mm/bounce.c                                 |   2 +-
 mm/hugetlb.c                                |   2 +-
 mm/memory.c                                 |  42 ++++++------
 mm/mmap.c                                   |   4 +-
 net/mac80211/mlme.c                         |   2 +-
 net/mac80211/pm.c                           |   2 +-
 net/wireless/core.c                         |  74 +++++++++++---------
 net/wireless/core.h                         |   3 +
 net/wireless/rdev-ops.h                     |   7 +-
 net/wireless/sysfs.c                        |  25 +++++--
 sound/pci/hda/patch_realtek.c               |   1 +
 sound/soc/codecs/cs42l52.c                  |   2 +-
 sound/soc/tegra/tegra30_i2s.c               |   2 +-
 sound/usb/6fire/midi.c                      |  16 ++++-
 sound/usb/6fire/midi.h                      |   6 +-
 sound/usb/6fire/pcm.c                       |  41 ++++++++++-
 sound/usb/6fire/pcm.h                       |   2 +-
 83 files changed, 650 insertions(+), 358 deletions(-)

AceLan Kao (2):
      Bluetooth: Add support for Atheros [0cf3:3121]
      Bluetooth: Add support for Atheros [0cf3:e003]

Alan Stern (1):
      USB: EHCI: accept very late isochronous URBs

Andreas Schwab (1):
      m68k: Truncate base in do_div()

Anthony Foiani (1):
      sata_fsl: save irqs while coalescing

Ben Widawsky (1):
      drm/i915: Move num_pipes to intel info

Brian Austin (1):
      ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume

Chris Wilson (2):
      drm/i915: Don't deref pipe->cpu_transcoder in the hangcheck code
      drm/i915: Invalidate TLBs for the rings after a reset

Chris Wright (1):
      mac80211: fix infinite loop in ieee80211_determine_chantype

Dan Carpenter (1):
      Hostap: copying wrong data prism2_ioctl_giwaplist()

Daniel Drake (1):
      drivers/platform/olpc/olpc-ec.c: initialise earlier

David Vrabel (2):
      xen/events: initialize local per-cpu mask for all possible events
      xen/events: mask events when changing their VCPU binding

Emmanuel Grumbach (1):
      iwlwifi: pcie: disable L1 Active after pci_enable_device

Geert Uytterhoeven (1):
      m68k/atari: ARAnyM - Fix NatFeat module support

Guenter Roeck (1):
      s390: Fix broken build

Jan Kara (1):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()

Johan Hovold (5):
      USB: mos7840: fix big-endian probe
      USB: adutux: fix big-endian device-type reporting
      USB: ti_usb_3410_5052: fix big-endian firmware handling
      USB: mos7720: fix broken control requests
      USB: keyspan: fix null-deref at disconnect and release

Johannes Berg (1):
      cfg80211: fix P2P GO interface teardown

Jussi Kivilinna (1):
      zd1201: do not use stack as URB transfer_buffer

Kamal Mostafa (1):
      Linux 3.8.13.8

Kent Overstreet (1):
      block: Add bio_for_each_segment_all()

Linus Torvalds (1):
      Fix TLB gather virtual address range invalidation corner cases

Martin Peschke (2):
      [SCSI] zfcp: fix lock imbalance by reworking request queue locking
      [SCSI] zfcp: fix schedule-inside-lock in scsi_device list loops

Matt Burtch (1):
      USB-Serial: Fix error handling of usb_wwan

Nicolas Ferre (1):
      ARM: at91/DT: fix at91sam9n12ek memory node

Nicolas Pitre (1):
      ARM: 7816/1: CONFIG_KUSER_HELPERS: fix help text

Noguchi Kazutosi (1):
      Bluetooth: Add support for Foxconn/Hon Hai [0489:e04d]

Oliver Neukum (1):
      usb: add two quirky touchscreen

Peter Zijlstra (1):
      arch, mm: Remove tlb_fast_mode()

Radu Caragea (1):
      x86 get_unmapped_area: Access mmap_legacy_base through mm_struct member

Roland Dreier (1):
      [SCSI] sg: Fix user memory corruption when SG_IO is interrupted by a signal

Russell King (1):
      ARM: allow kuser helpers to be removed from the vector page

Sekhar Nori (1):
      ARM: davinci: nand: specify ecc strength

Stanislaw Gruszka (4):
      cfg80211/mac80211: disconnect on suspend
      iwl4965: set power mode early
      iwl4965: reset firmware after rfkill off
      iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL

Stephane Grosjean (1):
      can: pcan_usb: fix wrong memcpy() bytes length

Stephen Warren (1):
      ASoC: tegra: fix Tegra30 I2S capture parameter setup

Sujith Manoharan (1):
      Bluetooth: ath3k: Add support for ID 0x13d3/0x3402

Takashi Iwai (1):
      ALSA: hda - Add a fixup for Gateway LT27

Terry Suereth (1):
      libata: apply behavioral quirks to sil3826 PMP

Thomas Loo (1):
      Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]

Torsten Schenk (2):
      ALSA: 6fire: make buffers DMA-able (pcm)
      ALSA: 6fire: make buffers DMA-able (midi)

Vineet Gupta (1):
      mm: fix the TLB range flushed when __tlb_remove_page() runs out of slots

Vyacheslav Dubeyko (2):
      nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
      nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection

Will Deacon (3):
      ARM: 7809/1: perf: fix event validation for software group leaders
      arm64: perf: fix array out of bounds access in armpmu_map_hw_event()
      arm64: perf: fix event validation for software group leaders

Wladislav Wiebe (1):
      of: fdt: fix memory initialization for expanded DT


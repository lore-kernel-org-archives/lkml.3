Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab3IBIyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:54:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab3IBIys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:54:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [ 3.5.y.z extended stable ] Linux 3.5.7.21 stable review
Date: Mon,  2 Sep 2013 09:53:45 +0100
Message-Id: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.5.7.21 stable kernel.

This version contains 58 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.5.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.5.y-review

The review period for version 3.5.7.21 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.5.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 arch/alpha/Makefile                           |  2 +-
 arch/arm/boot/dts/at91sam9n12ek.dts           |  4 +-
 arch/arm/kernel/perf_event.c                  | 10 +++-
 arch/arm/mach-davinci/board-dm355-leopard.c   |  1 +
 arch/arm/mach-davinci/board-dm644x-evm.c      |  1 +
 arch/arm/mach-davinci/board-dm646x-evm.c      |  1 +
 arch/arm/mach-davinci/board-neuros-osd2.c     |  1 +
 arch/arm/mm/Kconfig                           |  9 ++--
 arch/m68k/emu/natfeat.c                       | 23 +++++++--
 arch/m68k/include/asm/div64.h                 |  9 ++--
 arch/microblaze/configs/mmu_defconfig         | 52 +++++++++++++------
 arch/microblaze/configs/nommu_defconfig       | 73 ++++++++++++++++-----------
 arch/mips/Kconfig                             |  2 +-
 arch/mips/include/asm/io.h                    |  5 ++
 arch/mips/include/asm/page.h                  | 15 +++---
 arch/powerpc/Kconfig                          |  1 +
 arch/powerpc/include/asm/page.h               | 10 ++++
 arch/powerpc/kernel/lparcfg.c                 | 23 ++++-----
 arch/x86/kernel/sys_x86_64.c                  |  2 +-
 arch/x86/mm/mmap.c                            |  6 ++-
 arch/x86/xen/setup.c                          | 22 ++++++++
 arch/xtensa/kernel/Makefile                   |  1 +
 drivers/ata/libata-pmp.c                      | 12 ++---
 drivers/ata/sata_fsl.c                        |  5 +-
 drivers/base/memory.c                         |  2 +
 drivers/bluetooth/ath3k.c                     |  2 +
 drivers/bluetooth/btusb.c                     |  1 +
 drivers/firmware/efivars.c                    | 27 ++++++++++
 drivers/gpu/drm/i915/i915_reg.h               |  2 +
 drivers/gpu/drm/i915/intel_lvds.c             |  8 +--
 drivers/gpu/drm/i915/intel_ringbuffer.c       | 12 +++++
 drivers/net/can/usb/peak_usb/pcan_usb.c       |  2 +-
 drivers/net/wireless/hostap/hostap_ioctl.c    |  4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c      | 16 +++---
 drivers/net/wireless/iwlegacy/common.c        |  1 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c   |  5 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c | 10 ++--
 drivers/net/wireless/zd1201.c                 |  4 +-
 drivers/of/fdt.c                              |  2 +
 drivers/s390/scsi/zfcp_erp.c                  | 29 ++++++++---
 drivers/s390/scsi/zfcp_qdio.c                 |  8 +--
 drivers/tty/hvc/hvsi_lib.c                    |  4 +-
 drivers/tty/serial/mxs-auart.c                |  2 +-
 drivers/usb/core/quirks.c                     |  6 +++
 drivers/usb/misc/adutux.c                     |  2 +-
 drivers/usb/serial/keyspan.c                  |  2 +-
 drivers/usb/serial/mos7720.c                  | 21 +++++---
 drivers/usb/serial/mos7840.c                  |  2 +-
 drivers/usb/serial/ti_usb_3410_5052.c         |  9 ++--
 drivers/usb/serial/usb_wwan.c                 | 20 ++++----
 drivers/usb/wusbcore/wa-xfer.c                |  9 +++-
 drivers/xen/events.c                          |  2 +-
 fs/ext4/ext4_jbd2.c                           |  8 +--
 fs/jfs/jfs_dtree.c                            | 31 +++++++++---
 fs/nilfs2/segbuf.c                            |  5 +-
 fs/proc/task_mmu.c                            |  8 +--
 include/linux/mm_types.h                      |  1 +
 include/linux/wait.h                          | 58 +++++++++++++++++++++
 kernel/workqueue.c                            | 25 +++++++--
 mm/nommu.c                                    | 10 ++++
 net/key/af_key.c                              |  1 +
 sound/oss/Kconfig                             |  1 +
 sound/soc/codecs/cs42l52.c                    |  2 +-
 sound/usb/6fire/midi.c                        | 16 +++++-
 sound/usb/6fire/midi.h                        |  6 +--
 sound/usb/6fire/pcm.c                         | 41 ++++++++++++++-
 sound/usb/6fire/pcm.h                         |  2 +-
 sound/usb/mixer.c                             |  7 ++-
 68 files changed, 532 insertions(+), 194 deletions(-)

AceLan Kao (1):
      Bluetooth: Add support for Atheros [0cf3:3121]

Andreas Schwab (1):
      m68k: Truncate base in do_div()

Anthony Foiani (1):
      sata_fsl: save irqs while coalescing

Benjamin Herrenschmidt (1):
      powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hypervisor

Brian Austin (1):
      ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume

Chris Wilson (1):
      drm/i915: Invalidate TLBs for the rings after a reset

Dan Carpenter (1):
      Hostap: copying wrong data prism2_ioctl_giwaplist()

Daniel Vetter (1):
      drm/i915/lvds: ditch ->prepare special case

Dave Kleikamp (1):
      jfs: fix readdir cookie incompatibility with NFSv4

David Vrabel (2):
      xen/events: initialize local per-cpu mask for all possible events
      x86/xen: do not identity map UNUSABLE regions in the machine E820

Emmanuel Grumbach (1):
      iwlwifi: pcie: disable L1 Active after pci_enable_device

Eugene Surovegin (1):
      powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.

Geert Uytterhoeven (1):
      m68k/atari: ARAnyM - Fix NatFeat module support

Jan Kara (1):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()

Johan Hovold (5):
      USB: mos7840: fix big-endian probe
      USB: adutux: fix big-endian device-type reporting
      USB: ti_usb_3410_5052: fix big-endian firmware handling
      USB: mos7720: fix broken control requests
      USB: keyspan: fix null-deref at disconnect and release

Jussi Kivilinna (1):
      zd1201: do not use stack as URB transfer_buffer

Lai Jiangshan (1):
      workqueue: fix possible stall on try_to_grab_pending() of a delayed work item

Linus Torvalds (1):
      vm: add no-mmu vm_iomap_memory() stub

Markos Chandras (1):
      MIPS: Expose missing pci_io{map,unmap} declarations

Martin Peschke (2):
      [SCSI] zfcp: fix lock imbalance by reworking request queue locking
      [SCSI] zfcp: fix schedule-inside-lock in scsi_device list loops

Matt Burtch (1):
      USB-Serial: Fix error handling of usb_wwan

Matt Fleming (1):
      efivars: explicitly calculate length of VariableName

Max Filippov (1):
      xtensa: fix linker script transformation for .text.unlikely

Michal Simek (1):
      microblaze: Update microblaze defconfigs

Nicolas Dichtel (1):
      af_key: initialize satype in key_notify_policy_flush()

Nicolas Ferre (1):
      ARM: at91/DT: fix at91sam9n12ek memory node

Nicolas Pitre (1):
      ARM: 7816/1: CONFIG_KUSER_HELPERS: fix help text

Oliver Neukum (1):
      usb: add two quirky touchscreen

Paul Bolle (1):
      sound: Fix make allmodconfig on MIPS correctly

Paul Mackerras (1):
      powerpc: Work around gcc miscompilation of __pa() on 64-bit

Radu Caragea (1):
      x86 get_unmapped_area: Access mmap_legacy_base through mm_struct member

Ralf Baechle (1):
      MIPS: Rewrite pfn_valid to work in modules, too.

Russ Anderson (1):
      drivers/base/memory.c: fix show_mem_removable() to handle missing sections

Sekhar Nori (1):
      ARM: davinci: nand: specify ecc strength

Stanislaw Gruszka (3):
      iwl4965: set power mode early
      iwl4965: reset firmware after rfkill off
      iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL

Stephane Grosjean (1):
      can: pcan_usb: fix wrong memcpy() bytes length

Stephen Boyd (1):
      ARM: 7810/1: perf: Fix array out of bounds access in armpmu_map_hw_event()

Takashi Iwai (1):
      sound: Fix make allmodconfig on MIPS

Terry Suereth (1):
      libata: apply behavioral quirks to sil3826 PMP

Thomas Pugliese (1):
      wusbcore: fix kernel panic when disconnecting a wireless USB->serial device

Torstein Hegge (1):
      ALSA: usb: Parse UAC2 extension unit like for UAC1

Torsten Schenk (2):
      ALSA: 6fire: make buffers DMA-able (pcm)
      ALSA: 6fire: make buffers DMA-able (midi)

Vyacheslav Dubeyko (2):
      nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
      nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection

Will Deacon (2):
      ARM: 7809/1: perf: fix event validation for software group leaders
      alpha: makefile: don't enforce small data model for kernel builds

Wladislav Wiebe (1):
      of: fdt: fix memory initialization for expanded DT

Wolfram Sang (1):
      serial: mxs: fix buffer overflow

yonghua zheng (1):
      fs/proc/task_mmu.c: fix buffer overflow in add_page_map()

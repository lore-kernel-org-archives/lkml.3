Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaATMmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:42:51 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:44642 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbaATMmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:42:45 -0500
Date: Mon, 20 Jan 2014 13:42:41 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.14
Message-ID: <alpine.DEB.2.02.1401201337170.16448@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

for you to fetch changes up to 56931d73697c99ecf7aba6ae86c94d3a2d15d596:

  m68k/mac: Make SCC reset work more reliably (2014-01-19 11:53:22 +0100)

Summary:
  - Zorro bus cleanups and UAPI revival
  - Bootinfo cleanups and UAPI revival
  - Kexec support
  - Memory size reductions and bug fixes for multi-platform kernels
  - Polled interrupt support for Atari EtherNAT, EtherNEC and NetUSBee
  - Machine-specific random_get_entropy()
  - Defconfig updates and cleanups

Thanks for pulling!

----------------------------------------------------------------
Finn Thain (1):
      m68k/mac: Make SCC reset work more reliably

Geert Uytterhoeven (44):
      m68k: Mark functions only called from setup_arch() __init
      m68k/sun3: Dynamically allocate the table to track IOMMU use
      m68k/mac: Fix comment about iop_*_present flags setup timing
      m68k/defconfig: Make NFS_V4 modular instead of builtin
      m68k/setup: Use pr_*() and __func__ instead of plain printk()
      Documentation/zorro.txt: Update path to arch-specific header files
      zorro: Do not allocate zorro_autocon[] statically
      zorro: Don't fill in dummy names in zorro_name_device()
      zorro: Refactor conditional handling of Zorro device name database
      zorro: Let the driver core handle device enumeration
      zorro: ZTWO_VADDR() should return "void __iomem *"
      zorro/UAPI: Disintegrate include/linux/zorro*.h
      zorro/UAPI: Use proper types (endianness/size) in <linux/zorro.h>
      block/z2ram: Remove duplicate external declarations
      m68k: The bootinfo is located right after the kernel
      m68k: head.S - Correct date and spelling
      m68k: Drop remainings and API of BOOTINFO_COMPAT_1_0
      m68k/mac: Move struct mac_booter_data to <asm/macintosh.h>
      m68k/vme: Remove unused mvme_bdid_ptr
      m68k/UAPI: Disintegrate arch/m68k/include/asm/bootinfo.h
      m68k/UAPI: Move generic definitions to <asm/bootinfo.h>
      m68k/UAPI: Move Amiga model/chipset definitions to <asm/bootinfo-amiga.h>
      m68k/UAPI: Move Apollo model definitions to <asm/bootinfo-apollo.h>
      m68k/UAPI: Move HP300 model definitions to <asm/bootinfo-hp300.h>
      m68k/UAPI: Move Macintosh model definitions to <asm/bootinfo-mac.h>
      m68k/UAPI: Move VME Board ID definition to <asm/bootinfo-vme.h>
      m68k/UAPI: Use proper types (endianness/size) in <asm/bootinfo*.h>
      m68k: Remove superfluous inclusions of <asm/bootinfo.h>
      m68k/atari: Call paging_init() before nf_init()
      m68k: Add infrastructure for machine-specific random_get_entropy()
      m68k/amiga: Provide mach_random_get_entropy()
      m68k/mac: Mark Mac IIsi ADB driver BROKEN
      m68k: Add kexec support
      m68k: Add support to export bootinfo in procfs
      m68k/defconfig: Use ext4 for ext2/ext3 file systems
      m68k/amiga,atari: Fix specifying multiple debug= parameters
      m68k/atari: Hide RTC_PORT() macro from rtc-cmos
      m68k/defconfig: Disable /sbin/hotplug fork-bomb by default
      m68k/mm: Check for mm != NULL in do_page_fault() debug code
      m68k: Convert arch/m68k/mm/fault.c to pr_*()
      m68k: Convert arch/m68k/kernel/traps.c to pr_*()
      m68k/mm: kmap spelling/grammar fixes
      m68k/defconfig: Enable EARLY_PRINTK
      m68k: Update defconfigs for v3.13-rc1

Michael Schmitz (1):
      m68k/irq - Use polled IRQ flag for MFP timer cascaded interrupts

 Documentation/zorro.txt                      |    5 +-
 arch/m68k/Kconfig                            |   24 ++
 arch/m68k/amiga/chipram.c                    |    2 +-
 arch/m68k/amiga/config.c                     |   63 +++--
 arch/m68k/amiga/platform.c                   |    9 +-
 arch/m68k/apollo/config.c                    |   26 +-
 arch/m68k/atari/ataints.c                    |    3 +
 arch/m68k/atari/config.c                     |   10 +-
 arch/m68k/atari/debug.c                      |    5 +-
 arch/m68k/bvme6000/config.c                  |    6 +-
 arch/m68k/configs/amiga_defconfig            |   50 +++-
 arch/m68k/configs/apollo_defconfig           |   49 +++-
 arch/m68k/configs/atari_defconfig            |   50 +++-
 arch/m68k/configs/bvme6000_defconfig         |   48 +++-
 arch/m68k/configs/hp300_defconfig            |   49 +++-
 arch/m68k/configs/mac_defconfig              |   51 +++-
 arch/m68k/configs/multi_defconfig            |   53 +++-
 arch/m68k/configs/mvme147_defconfig          |   48 +++-
 arch/m68k/configs/mvme16x_defconfig          |   49 +++-
 arch/m68k/configs/q40_defconfig              |   50 +++-
 arch/m68k/configs/sun3_defconfig             |   49 +++-
 arch/m68k/configs/sun3x_defconfig            |   49 +++-
 arch/m68k/emu/natfeat.c                      |    3 +-
 arch/m68k/hp300/config.c                     |   10 +-
 arch/m68k/include/asm/amigahw.h              |   28 +-
 arch/m68k/include/asm/apollohw.h             |   11 +-
 arch/m68k/include/asm/atarihw.h              |    2 +-
 arch/m68k/include/asm/bootinfo.h             |  360 +-------------------------
 arch/m68k/include/asm/hp300hw.h              |   20 +-
 arch/m68k/include/asm/kexec.h                |   29 +++
 arch/m68k/include/asm/macintosh.h            |   83 ++----
 arch/m68k/include/asm/mc146818rtc.h          |   10 +-
 arch/m68k/include/asm/mvme16xhw.h            |   17 --
 arch/m68k/include/asm/setup.h                |    5 +-
 arch/m68k/include/asm/timex.h                |   10 +
 arch/m68k/include/uapi/asm/Kbuild            |    8 +
 arch/m68k/include/uapi/asm/bootinfo-amiga.h  |   63 +++++
 arch/m68k/include/uapi/asm/bootinfo-apollo.h |   28 ++
 arch/m68k/include/uapi/asm/bootinfo-atari.h  |   44 ++++
 arch/m68k/include/uapi/asm/bootinfo-hp300.h  |   50 ++++
 arch/m68k/include/uapi/asm/bootinfo-mac.h    |  119 +++++++++
 arch/m68k/include/uapi/asm/bootinfo-q40.h    |   16 ++
 arch/m68k/include/uapi/asm/bootinfo-vme.h    |   70 +++++
 arch/m68k/include/uapi/asm/bootinfo.h        |  174 +++++++++++++
 arch/m68k/include/uapi/asm/setup.h           |   87 -------
 arch/m68k/kernel/Makefile                    |    3 +
 arch/m68k/kernel/asm-offsets.c               |    3 +
 arch/m68k/kernel/bootinfo_proc.c             |   80 ++++++
 arch/m68k/kernel/head.S                      |   16 +-
 arch/m68k/kernel/machine_kexec.c             |   58 +++++
 arch/m68k/kernel/relocate_kernel.S           |  159 ++++++++++++
 arch/m68k/kernel/setup_mm.c                  |   62 +++--
 arch/m68k/kernel/time.c                      |    4 +
 arch/m68k/kernel/traps.c                     |  232 ++++++++---------
 arch/m68k/mac/config.c                       |   34 +--
 arch/m68k/mac/iop.c                          |    5 +-
 arch/m68k/mac/misc.c                         |    2 -
 arch/m68k/mac/oss.c                          |    1 -
 arch/m68k/mac/psc.c                          |    3 +-
 arch/m68k/mac/via.c                          |    1 -
 arch/m68k/mm/fault.c                         |   26 +-
 arch/m68k/mm/init.c                          |    2 +-
 arch/m68k/mm/kmap.c                          |   10 +-
 arch/m68k/mm/motorola.c                      |    2 +-
 arch/m68k/mvme147/config.c                   |    7 +-
 arch/m68k/mvme16x/config.c                   |   30 ++-
 arch/m68k/q40/config.c                       |    4 +-
 arch/m68k/sun3/dvma.c                        |    6 +-
 arch/m68k/sun3/mmu_emu.c                     |    3 +-
 arch/m68k/sun3/sun3dvma.c                    |    8 +-
 arch/m68k/sun3x/prom.c                       |    1 -
 drivers/block/z2ram.c                        |    7 +-
 drivers/ide/buddha.c                         |    2 +-
 drivers/macintosh/Kconfig                    |    2 +-
 drivers/net/ethernet/8390/hydra.c            |    2 +-
 drivers/net/ethernet/8390/zorro8390.c        |    4 +-
 drivers/net/ethernet/amd/a2065.c             |   13 +-
 drivers/net/ethernet/amd/ariadne.c           |   13 +-
 drivers/net/ethernet/natsemi/macsonic.c      |    1 -
 drivers/parport/parport_mfc3.c               |    2 +-
 drivers/scsi/a2091.c                         |    2 +-
 drivers/scsi/a3000.c                         |    2 +-
 drivers/scsi/a4000t.c                        |    2 +-
 drivers/scsi/gvp11.c                         |    2 +-
 drivers/scsi/zorro7xx.c                      |    2 +-
 drivers/video/amifb.c                        |    2 +-
 drivers/video/cirrusfb.c                     |    4 +-
 drivers/video/macfb.c                        |    1 -
 drivers/video/valkyriefb.c                   |    1 -
 drivers/zorro/Makefile                       |    3 +-
 drivers/zorro/names.c                        |   11 -
 drivers/zorro/proc.c                         |   10 +-
 drivers/zorro/zorro-driver.c                 |   11 +-
 drivers/zorro/zorro-sysfs.c                  |   22 +-
 drivers/zorro/zorro.c                        |   27 +-
 drivers/zorro/zorro.h                        |    5 +
 include/linux/zorro.h                        |  121 ++-------
 include/uapi/linux/Kbuild                    |    2 +
 include/uapi/linux/kexec.h                   |    1 +
 include/uapi/linux/zorro.h                   |  113 ++++++++
 include/{ => uapi}/linux/zorro_ids.h         |    0
 101 files changed, 1992 insertions(+), 1155 deletions(-)
 create mode 100644 arch/m68k/include/asm/kexec.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-amiga.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-apollo.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-atari.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-hp300.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-mac.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-q40.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo-vme.h
 create mode 100644 arch/m68k/include/uapi/asm/bootinfo.h
 create mode 100644 arch/m68k/kernel/bootinfo_proc.c
 create mode 100644 arch/m68k/kernel/machine_kexec.c
 create mode 100644 arch/m68k/kernel/relocate_kernel.S
 create mode 100644 include/uapi/linux/zorro.h
 rename include/{ => uapi}/linux/zorro_ids.h (100%)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

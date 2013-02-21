Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3BUJUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:20:15 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:54722 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3BUJUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:20:09 -0500
Date: Thu, 21 Feb 2013 10:20:01 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.9 merge window
Message-ID: <20130221102001.7780bb7e@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022109-0342-0000-0000-000004439634
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
The most prominent change in this patch set is the software dirty bit
patch for s390. It removes __HAVE_ARCH_PAGE_TEST_AND_CLEAR_DIRTY and
the page_test_and_clear_dirty primitive which makes the common memory
management code a bit less obscure. Heiko fixed most of the PCI related
fallout, more often than not missing GENERIC_HARDIRQS dependencies.
Notable is one of the 3270 patches which adds an export to tty_io to
be able to resize a tty. The rest is the usual bunch of cleanups and
bug fixes.

There is a merge conflict in arch/s390/Kconfig between the current
upstream and the s390 branch. The cause is the Heikos Kconfig sorting
vs the removal of HAVE_IRQ_WORK. The correct merge is the sorted list
without the HAVE_IRQ_WORK select.

Heiko Carstens (18):
      asm-generic/io.h: convert readX defines to functions
      s390/time: rename tod clock access functions
      s390/barrier: convert mb() to define again
      s390/dma: provide dma_cache_sync() function
      s390/dma: remove dma_is_consistent() declaration
      s390/pci: rename pci_probe to s390_pci_probe
      ata: disable ATA for s390
      parport: disable PC-style parallel port support for s390
      s390/mm: provide PAGE_SHARED define
      uio: remove !S390 dependency from Kconfig
      phylib: remove !S390 dependeny from Kconfig
      s390/Kconfig: sort list of arch selected config options
      drivers/net,AT91RM9200: add missing GENERIC_HARDIRQS dependency
      s390/bpf,jit: add vlan tag support
      drivers/media: add missing GENERIC_HARDIRQS dependency
      s390/linker skript: discard exit.data at runtime
      drivers/input: add couple of missing GENERIC_HARDIRQS dependencies
      drivers/gpio: add missing GENERIC_HARDIRQ dependency

Hendrik Brueckner (5):
      s390/perf: cpum_cf: fallback to software sampling events
      iucv: fix kernel panic at reboot
      s390/mm: Fix crst upgrade of mmap with MAP_FIXED
      s390/cleanup: rename SPP to LPP
      s390/module: Add missing R_390_NONE relocation type

Ingo Tuchscherer (1):
      maintainer for s390 zcrypt component changed

Martin Schwidefsky (6):
      s390/3270: readd tty3270_open
      s390/3270: fix initialization order in tty3270_alloc_view
      s390/3270: introduce device notifier
      s390/3270: asynchronous size sensing
      s390/modules: add relocation overflow checking
      s390/mm: implement software dirty bits

Michael Holzheu (2):
      s390/ipl: Implement diag308 loop for zfcpdump
      s390/zcore: Add hsa file

Sebastian Ott (9):
      s390/chsc: cleanup SEI helper functions
      s390/cio: dont abort verification after missing irq
      s390/cio: skip broken paths
      s390/cio: export vpm via sysfs
      s390/cio: handle unknown pgroup state
      s390/scm: use inline dummy functions
      s390/pci: cleanup clp inline assembly
      s390/pci: cleanup clp page allocation
      s390/pci: fix hotplug module init

Stefan Weinhuber (1):
      dasd: fix sysfs cleanup in dasd_generic_remove

 MAINTAINERS                           |    2 +-
 arch/s390/Kconfig                     |  115 ++++---
 arch/s390/appldata/appldata_mem.c     |    2 +-
 arch/s390/appldata/appldata_net_sum.c |    2 +-
 arch/s390/appldata/appldata_os.c      |    2 +-
 arch/s390/hypfs/hypfs_vm.c            |    2 +-
 arch/s390/include/asm/barrier.h       |    9 +-
 arch/s390/include/asm/clp.h           |    2 +-
 arch/s390/include/asm/cpu_mf.h        |    4 +-
 arch/s390/include/asm/dma-mapping.h   |    8 +-
 arch/s390/include/asm/mman.h          |    4 +-
 arch/s390/include/asm/page.h          |   22 --
 arch/s390/include/asm/pci.h           |   11 +-
 arch/s390/include/asm/pgtable.h       |  132 ++++---
 arch/s390/include/asm/sclp.h          |    1 -
 arch/s390/include/asm/setup.h         |   22 +-
 arch/s390/include/asm/timex.h         |   18 +-
 arch/s390/kernel/debug.c              |    2 +-
 arch/s390/kernel/dis.c                |    1 -
 arch/s390/kernel/early.c              |    8 +-
 arch/s390/kernel/entry64.S            |   10 +-
 arch/s390/kernel/ipl.c                |   16 +-
 arch/s390/kernel/module.c             |  143 +++++---
 arch/s390/kernel/nmi.c                |    2 +-
 arch/s390/kernel/perf_cpum_cf.c       |   13 +-
 arch/s390/kernel/smp.c                |   10 +-
 arch/s390/kernel/time.c               |   26 +-
 arch/s390/kernel/vmlinux.lds.S        |    4 +
 arch/s390/kernel/vtime.c              |    2 +-
 arch/s390/kvm/interrupt.c             |    6 +-
 arch/s390/kvm/kvm-s390.c              |    2 +-
 arch/s390/lib/delay.c                 |   16 +-
 arch/s390/lib/uaccess_pt.c            |    2 +-
 arch/s390/mm/mmap.c                   |    9 +-
 arch/s390/mm/pageattr.c               |    2 +-
 arch/s390/mm/vmem.c                   |   24 +-
 arch/s390/net/bpf_jit_comp.c          |   21 ++
 arch/s390/pci/pci.c                   |   35 +-
 arch/s390/pci/pci_clp.c               |   14 +-
 drivers/ata/Kconfig                   |    2 +-
 drivers/gpio/Kconfig                  |    4 +-
 drivers/input/Kconfig                 |    2 +-
 drivers/input/keyboard/Kconfig        |    4 +-
 drivers/input/serio/Kconfig           |    1 +
 drivers/input/touchscreen/Kconfig     |    2 +-
 drivers/media/radio/Kconfig           |    2 +-
 drivers/net/ethernet/cadence/Kconfig  |    1 +
 drivers/net/phy/Kconfig               |    1 -
 drivers/parport/Kconfig               |    2 +-
 drivers/pci/hotplug/s390_pci_hpc.c    |   60 ++--
 drivers/s390/block/dasd.c             |   23 +-
 drivers/s390/block/dasd_3990_erp.c    |    8 +-
 drivers/s390/block/dasd_alias.c       |    4 +-
 drivers/s390/block/dasd_diag.c        |   10 +-
 drivers/s390/block/dasd_eckd.c        |   30 +-
 drivers/s390/block/dasd_eer.c         |    2 +-
 drivers/s390/block/dasd_erp.c         |    4 +-
 drivers/s390/block/dasd_fba.c         |    2 +-
 drivers/s390/block/scm_blk.h          |   41 ++-
 drivers/s390/char/fs3270.c            |   29 +-
 drivers/s390/char/raw3270.c           |  611 ++++++++++++++-------------------
 drivers/s390/char/raw3270.h           |   12 +-
 drivers/s390/char/sclp.c              |    4 +-
 drivers/s390/char/sclp_cmd.c          |   10 +-
 drivers/s390/char/tty3270.c           |  187 +++++++---
 drivers/s390/char/zcore.c             |   64 +++-
 drivers/s390/cio/chsc.c               |   68 ++--
 drivers/s390/cio/chsc.h               |    2 +-
 drivers/s390/cio/cio.c                |    4 +-
 drivers/s390/cio/cmf.c                |    6 +-
 drivers/s390/cio/css.c                |    2 +-
 drivers/s390/cio/device.c             |   10 +
 drivers/s390/cio/device_fsm.c         |    2 +-
 drivers/s390/cio/device_pgid.c        |  123 ++++++-
 drivers/s390/cio/io_sch.h             |    5 +
 drivers/s390/cio/qdio_main.c          |   12 +-
 drivers/s390/net/qeth_core.h          |    2 +-
 drivers/s390/scsi/zfcp_fsf.c          |    2 +-
 drivers/s390/scsi/zfcp_qdio.c         |    2 +-
 drivers/tty/tty_io.c                  |    1 +
 drivers/uio/Kconfig                   |    1 -
 include/asm-generic/io.h              |   20 +-
 include/asm-generic/pgtable.h         |   10 -
 include/linux/page-flags.h            |    8 -
 mm/rmap.c                             |   24 --
 net/iucv/iucv.c                       |    5 +-
 86 files changed, 1222 insertions(+), 935 deletions(-)


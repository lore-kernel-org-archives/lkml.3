Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848Ab3ICJP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:15:59 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:40336 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3ICJP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:15:56 -0400
Date: Tue, 3 Sep 2013 11:15:48 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] s390 updates for 3.12-rc1
Message-ID: <20130903091548.GA3926@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090309-1948-0000-0000-0000062C8F89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the first batch of s390 updates for 3.12.

The most interesting change is that Martin converted s390 to generic hardirqs.
Which means that all current architectures have been converted and that
CONFIG_GENERIC_HARDIRQS can be removed.
Martin prepared a patch for that already (see genirq branch), but the best
time to merge that is probably at the end of the merge window / begin of -rc1.

Another patch converts s390 to software referenced bits instead of relying
on the reference bit in the storage key. Therefore s390 doesn't use storage
keys anymore, except for kvm.

Besides that we have improvements, cleanups and fixes in PCI, DASD and all
over the place.

Thanks,
Heiko

---

Heiko Carstens (6):
      s390: replace remaining strict_strtoul() with kstrtoul()
      s390/mm: remove dead pfmf inline assembly
      s390/sclp: reword cpu capability change message
      s390/bitops: fix inline assembly constraints
      s390/switch_to: fix save_access_regs() / restore_access_regs()
      s390/kprobes: add support for compare and branch instructions

Jingoo Han (1):
      s390: replace strict_strtoul() with kstrtoul()

Martin Schwidefsky (13):
      s390/airq: introduce adapter interrupt vector helper
      s390/pci: cleanup function names
      s390/pci: use adapter interrupt vector helpers
      s390: convert interrupt handling to use generic hardirq
      s390/mm: cleanup page table definitions
      s390/pgtable: skip pgste updates on full flush
      s390/pgtable: add pgste_get helper
      s390/time: clock comparator revalidation
      s390/mm: introduce ptep_flush_lazy helper
      s390/time: return with irqs disabled from psw_idle
      s390/pgtable: fix mprotect for single-threaded KVM guests
      s390/tx: allow program interruption filtering in user space
      s390/mm: implement software referenced bits

Sebastian Ott (9):
      s390/pci/hotplug: convert to be builtin only
      s390/pci: use claim_resource
      s390/pci: add recover sysfs knob
      s390/hibernate: add early resume function
      s390/pci: split lpf
      s390/pci: try harder to modify a function
      s390/pci: update function handle after resume from hibernate
      s390/cio: fix unlocked access of global bitmap
      s390/pci: use virtual memory for iommu bitmap

Stefan Weinhuber (3):
      s390/dasd: cleanup timeout and transport error messages
      s390/dasd: enable raw_track_access reads without direct I/O
      s390/dasd: fix statistics for recovered requests

 arch/s390/Kconfig                   |  11 +
 arch/s390/include/asm/airq.h        |  67 ++++
 arch/s390/include/asm/bitops.h      |  12 +-
 arch/s390/include/asm/cio.h         |   1 +
 arch/s390/include/asm/hardirq.h     |   5 +
 arch/s390/include/asm/hugetlb.h     | 135 ++------
 arch/s390/include/asm/hw_irq.h      |  17 +-
 arch/s390/include/asm/irq.h         |  35 +-
 arch/s390/include/asm/mmu_context.h |   3 +-
 arch/s390/include/asm/page.h        |  19 --
 arch/s390/include/asm/pci.h         |  54 ++-
 arch/s390/include/asm/pci_insn.h    |  12 +-
 arch/s390/include/asm/pci_io.h      |  10 +-
 arch/s390/include/asm/pgtable.h     | 637 +++++++++++++++++++-----------------
 arch/s390/include/asm/serial.h      |   6 +
 arch/s390/include/asm/switch_to.h   |   9 +-
 arch/s390/include/asm/tlb.h         |   3 +-
 arch/s390/include/asm/tlbflush.h    |   6 +-
 arch/s390/kernel/entry.S            |  16 +-
 arch/s390/kernel/entry64.S          |  11 +-
 arch/s390/kernel/irq.c              | 160 ++++-----
 arch/s390/kernel/kprobes.c          |  21 +-
 arch/s390/kernel/nmi.c              |   5 +-
 arch/s390/kernel/process.c          |   1 +
 arch/s390/kernel/ptrace.c           |   8 +-
 arch/s390/kernel/suspend.c          |  11 +
 arch/s390/kernel/swsusp_asm64.S     |   7 +-
 arch/s390/kernel/time.c             |   1 -
 arch/s390/kernel/vdso.c             |   6 +-
 arch/s390/lib/delay.c               |   2 -
 arch/s390/lib/uaccess_pt.c          |  16 +-
 arch/s390/mm/dump_pagetables.c      |  18 +-
 arch/s390/mm/gup.c                  |   6 +-
 arch/s390/mm/hugetlbpage.c          | 124 ++++++-
 arch/s390/mm/pageattr.c             |   2 +-
 arch/s390/mm/pgtable.c              |  83 +++--
 arch/s390/mm/vmem.c                 |  15 +-
 arch/s390/pci/Makefile              |   2 +-
 arch/s390/pci/pci.c                 | 575 +++++++++++++-------------------
 arch/s390/pci/pci_clp.c             | 146 ++++++---
 arch/s390/pci/pci_dma.c             |  16 +-
 arch/s390/pci/pci_event.c           |   2 +-
 arch/s390/pci/pci_insn.c            |  18 +-
 arch/s390/pci/pci_msi.c             | 142 --------
 arch/s390/pci/pci_sysfs.c           |  27 ++
 drivers/pci/hotplug/Kconfig         |   2 +-
 drivers/pci/hotplug/s390_pci_hpc.c  |  63 +---
 drivers/s390/block/dasd_devmap.c    |   8 +-
 drivers/s390/block/dasd_eckd.c      |  54 ++-
 drivers/s390/block/dasd_erp.c       |  14 +-
 drivers/s390/char/sclp_config.c     |   2 +-
 drivers/s390/cio/airq.c             | 174 +++++++++-
 drivers/s390/cio/ccwgroup.c         |   2 +-
 drivers/s390/cio/cio.c              |  46 +--
 drivers/s390/cio/cio.h              |   3 -
 drivers/s390/cio/cmf.c              |   2 +-
 drivers/s390/cio/css.c              |   4 +-
 drivers/s390/cio/css.h              |   2 -
 drivers/s390/cio/device.c           |   2 +-
 drivers/s390/net/qeth_l3_sys.c      |   2 +-
 include/asm-generic/pgtable.h       |   4 -
 mm/rmap.c                           |   3 -
 62 files changed, 1468 insertions(+), 1402 deletions(-)
 create mode 100644 arch/s390/include/asm/serial.h
 delete mode 100644 arch/s390/pci/pci_msi.c


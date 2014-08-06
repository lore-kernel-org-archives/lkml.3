Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaHFJuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 05:50:19 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:59022 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbaHFJuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 05:50:16 -0400
Date: Wed, 6 Aug 2014 11:50:02 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.17 merge window #1
Message-ID: <20140806115002.1a57fe1a@mschwide>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080609-5024-0000-0000-000000E8ABF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Mostly cleanups and bug-fixes, with two exceptions. The first is
lazy flushing of I/O-TLBs for PCI to improve performance, the
second is software dirty bits in the pmd for the madvise-free
implementation.

Christian Borntraeger (2):
      KVM: s390/mm: Fix page table locking vs. split pmd lock
      s390/locking: Reenable optimistic spinning

Fabian Frederick (4):
      s390/dasd: remove unnecessary null test before debugfs_remove
      s390/dasd: Move EXPORT_SYMBOL after function/variable
      s390/dasd: replace pr_warning by pr_warn
      s390/dasd: replace seq_printf by seq_puts

Gerald Schaefer (2):
      s390/pci: fix kmsg component
      s390/pci: introduce lazy IOTLB flushing for DMA unmap

Hendrik Brueckner (1):
      s390/irq: improve displayed interrupt order in /proc/interrupts

Jan Willeke (1):
      s390/seccomp: fix error return for filtered system calls

Martin Schwidefsky (2):
      s390/3215: fix hanging console issue
      s390/mm: implement dirty bits for large segment table entries

Michael Holzheu (1):
      s390/kdump: Return NOTIFY_OK for all actions other than MEM_GOING_OFFLINE

Philipp Hachtmann (1):
      s390/watchdog: Fix module name in Kconfig help text

Sebastian Ott (5):
      s390/qdio: add helpers to manage qdio buffers
      s390/qeth: qdio queue helpers
      s390/qeth: extract qdio buffers from input buffer struct
      s390/qeth: extract qdio buffers from output buffer struct
      s390/zfcp: use qdio buffer helpers

Stefan Haberland (5):
      dasd: use aliases for formatted devices during format
      dasd: fix unresponsive device during format
      dasd: fix list_del corruption during format
      dasd: fix error recovery for alias devices during format
      s390/dasd: fix camel case

 Documentation/kernel-parameters.txt |    7 ++
 arch/s390/Kconfig                   |    1 +
 arch/s390/include/asm/pgtable.h     |  197 +++++++++++++++++++----------------
 arch/s390/include/asm/qdio.h        |    4 +
 arch/s390/include/asm/syscall.h     |    2 +-
 arch/s390/kernel/irq.c              |   95 +++++++++--------
 arch/s390/kernel/setup.c            |    2 +
 arch/s390/mm/hugetlbpage.c          |  103 +++++++++---------
 arch/s390/mm/pgtable.c              |    8 +-
 arch/s390/pci/pci.c                 |    4 +-
 arch/s390/pci/pci_clp.c             |    4 +-
 arch/s390/pci/pci_debug.c           |    4 +-
 arch/s390/pci/pci_dma.c             |   50 ++++++---
 arch/s390/pci/pci_event.c           |    4 +-
 arch/s390/pci/pci_sysfs.c           |    4 +-
 drivers/pci/hotplug/s390_pci_hpc.c  |    4 +-
 drivers/s390/block/dasd.c           |  196 +++++++++++++++++-----------------
 drivers/s390/block/dasd_eckd.c      |   30 ++++--
 drivers/s390/block/dasd_int.h       |    5 +-
 drivers/s390/block/dasd_ioctl.c     |   33 ++++--
 drivers/s390/char/con3215.c         |   32 +++---
 drivers/s390/cio/qdio_setup.c       |   53 ++++++++++
 drivers/s390/net/qeth_core.h        |    8 +-
 drivers/s390/net/qeth_core_main.c   |  161 ++++++++++++++++------------
 drivers/s390/scsi/zfcp_qdio.c       |   49 ++++-----
 drivers/watchdog/Kconfig            |    2 +-
 26 files changed, 619 insertions(+), 443 deletions(-)


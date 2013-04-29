Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab3D2Ig1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:36:27 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:52877 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3D2IgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:36:24 -0400
Date: Mon, 29 Apr 2013 10:24:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.10 merge window #1
Message-ID: <20130429102436.43285856@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042908-5024-0000-0000-000005E59966
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
This is the first batch of s390 patches for the 3.10 merge window.
Included are some performance enhancements: storage key initialization,
zero page cache synonyms, system call micro optimization and the speedup
patches for dasdfmt. Sebastian managed to get rid of the special casing
for the console device in the cio layer. And the usual bunch of bug fixes.

Akinobu Mita (2):
      s390/bitops: remove unnecessary macro definitions in asm/bitops.h
      s390/cio: Use BITS_TO_LONGS() instead of __BITOPS_WORDS()

Alexandru Gheorghiu (2):
      s390/cmm: Removed useless label
      s390/hypfs: Use PTR_RET function

Gerald Schaefer (1):
      s390/pci: return correct dma address for offset > PAGE_SIZE

Heiko Carstens (11):
      s390/dumpstack: fix call chain walking
      s390/mm: speedup storage key initialization
      s390/bitops: get rid of __BITOPS_BARRIER()
      s390/mm,gmap: implement gmap_translate()
      s390/compat: fix compat_sys_statfs() memory corruption
      s390/compat: fix compile error for !COMPAT
      s390/compat: remove ptrace compat definitions from uapi header file
      s390/ptrace: remove empty ifdefs
      s390/uapi: change struct statfs[64] member types to unsigned values
      s390: remove small stack config option
      s390/memory hotplug: prevent offline of active memory increments

Martin Schwidefsky (5):
      s390/mm: protection exception PSW for aborted transaction
      s390/mm: zero page cache synonyms for zEC12
      s390/mm,gmap: segment mapping race
      s390: lowcore stack pointer offsets
      s390: system call path micro optimization

Michael Holzheu (5):
      s390/kdump: Add PM notifier for kdump
      s390/s390dbf.txt: Add doc: Debug views are removed in debug_unregister()
      s390/hibernate: Save and restore absolute zero pages
      s390/signal: Add BEA to compat signal handler parameters
      s390/zcore: Fix HSA copy length for last block

Peter Oberparleiter (2):
      s390/cio: collect format 1 channel-path description data
      s390/cio: make use of newly added format 1 channel-path data

Sebastian Ott (24):
      s390/cio: wait_cons_dev don't use static variable
      s390/cio: ccw_device_force_console don't use static variable
      s390/cio: split subchannel registration
      s390/cio: get rid of static console subchannel
      s390/cio: get rid of static console device
      s390/css: introduce cio_register_early_subchannels
      s390/css: remove unused function definitions
      s390/cio: fix early init counter usage
      s390/css: move subchannel lock allocation
      s390/pci: msi cleanup hash usage
      s390/pci: debug device states
      s390/pci: do not modify function handles
      s390/pci: implement pcibios_add_device
      s390/pci: uninline instruction wrappers
      s390/pci: rename instruction wrappers
      s390/pci: add exception table to load/store instructions
      s390/pci: do not read data after failed load
      s390/pci: return error after failed pci ops
      s390/pci: disable per default
      s390/pci: remove disable_device implementation
      s390/cio: fix irq statistics
      s390/scm_blk: allow more cluster size values
      s390/scm_blk: fix memleak in init function
      s390/pci: use pci_scan_root_bus

Stefan Haberland (2):
      s390/dasd: improve speed of dasdfmt
      s390/dasd: fix hanging device after resume with internal error 13

Stefan Raspl (1):
      s390/dis: use explicit buf len

Stelian Nirlu (1):
      s390/bpf,jit: use kcalloc instead of kmalloc and memset

Syam Sidhardhan (1):
      s390/monreader: Remove redundant NULL check before kfree

Wei Yongjun (1):
      s390/pci: use kmem_cache_zalloc instead of kmem_cache_alloc/memset

Zhang Yanfei (1):
      s390/dasd: remove cast for kzalloc return value

 Documentation/s390/s390dbf.txt       |    3 +-
 arch/s390/Kconfig                    |   13 --
 arch/s390/Makefile                   |   10 -
 arch/s390/hypfs/hypfs_dbfs.c         |    4 +-
 arch/s390/include/asm/bitops.h       |  117 ++++++------
 arch/s390/include/asm/ccwdev.h       |    3 +-
 arch/s390/include/asm/cio.h          |    2 -
 arch/s390/include/asm/compat.h       |   57 ++++--
 arch/s390/include/asm/elf.h          |   23 ++-
 arch/s390/include/asm/pci.h          |    1 +
 arch/s390/include/asm/pci_debug.h    |    9 +-
 arch/s390/include/asm/pci_insn.h     |  203 +-------------------
 arch/s390/include/asm/pci_io.h       |   16 +-
 arch/s390/include/asm/pgtable.h      |    2 +
 arch/s390/include/asm/processor.h    |    3 +-
 arch/s390/include/asm/ptrace.h       |    6 +-
 arch/s390/include/asm/syscall.h      |    1 +
 arch/s390/include/asm/thread_info.h  |    6 +-
 arch/s390/include/uapi/asm/ptrace.h  |   20 --
 arch/s390/include/uapi/asm/statfs.h  |   63 +++----
 arch/s390/kernel/Makefile            |   17 +-
 arch/s390/kernel/asm-offsets.c       |    1 +
 arch/s390/kernel/compat_signal.c     |    2 +
 arch/s390/kernel/dis.c               |    9 +-
 arch/s390/kernel/dumpstack.c         |  236 +++++++++++++++++++++++
 arch/s390/kernel/entry.S             |   39 ++--
 arch/s390/kernel/entry.h             |    1 +
 arch/s390/kernel/entry64.S           |   43 ++---
 arch/s390/kernel/machine_kexec.c     |   30 +++
 arch/s390/kernel/setup.c             |    9 +-
 arch/s390/kernel/smp.c               |   15 +-
 arch/s390/kernel/suspend.c           |   31 +++
 arch/s390/kernel/swsusp_asm64.S      |   29 ++-
 arch/s390/kernel/traps.c             |  250 +-----------------------
 arch/s390/kvm/trace.h                |    2 +-
 arch/s390/mm/cmm.c                   |    8 +-
 arch/s390/mm/fault.c                 |    9 +-
 arch/s390/mm/init.c                  |   10 +-
 arch/s390/mm/pageattr.c              |   24 +--
 arch/s390/mm/pgtable.c               |  235 +++++++++++++++--------
 arch/s390/net/bpf_jit_comp.c         |    3 +-
 arch/s390/pci/Makefile               |    4 +-
 arch/s390/pci/pci.c                  |  153 ++++++---------
 arch/s390/pci/pci_clp.c              |   13 +-
 arch/s390/pci/pci_debug.c            |    7 +-
 arch/s390/pci/pci_dma.c              |    9 +-
 arch/s390/pci/pci_insn.c             |  202 ++++++++++++++++++++
 arch/s390/pci/pci_msi.c              |   10 +-
 drivers/pci/hotplug/s390_pci_hpc.c   |   12 +-
 drivers/s390/block/dasd.c            |  172 +++++++++++++++--
 drivers/s390/block/dasd_devmap.c     |    3 +-
 drivers/s390/block/dasd_eckd.c       |  344 +++++++++++++++++++++++-----------
 drivers/s390/block/dasd_int.h        |   10 +-
 drivers/s390/block/dasd_ioctl.c      |   31 +--
 drivers/s390/block/scm_blk.c         |    3 +-
 drivers/s390/block/scm_blk_cluster.c |    6 +-
 drivers/s390/char/con3215.c          |    4 +-
 drivers/s390/char/monreader.c        |    3 +-
 drivers/s390/char/raw3270.c          |    6 +-
 drivers/s390/char/sclp_cmd.c         |    4 +-
 drivers/s390/char/zcore.c            |    2 +-
 drivers/s390/cio/chp.c               |   22 ++-
 drivers/s390/cio/chp.h               |    2 +
 drivers/s390/cio/chsc.c              |   11 +-
 drivers/s390/cio/cio.c               |  160 +++++-----------
 drivers/s390/cio/cio.h               |   11 +-
 drivers/s390/cio/css.c               |  114 +++++------
 drivers/s390/cio/css.h               |    4 +-
 drivers/s390/cio/device.c            |  139 +++++++-------
 drivers/s390/cio/device.h            |    2 -
 drivers/s390/cio/device_ops.c        |   22 ++-
 drivers/s390/cio/idset.c             |    2 +-
 72 files changed, 1704 insertions(+), 1348 deletions(-)
 create mode 100644 arch/s390/kernel/dumpstack.c
 create mode 100644 arch/s390/pci/pci_insn.c


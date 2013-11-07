Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3KGJxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:53:52 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:53893 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3KGJxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:53:46 -0500
Date: Thu, 7 Nov 2013 10:53:40 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for  the 3.13 merge window
Message-ID: <20131107105340.4b18637a@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110709-0542-0000-0000-000006FC9B2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
The bulk of the s390 patches for the 3.13 merge window.

Heiko spent quite a bit of work to improve the code generation for
the kernel. That includes the exploitation of the interlocked-access
facility for the atomic and bitops implementation and the improvement
for the -march and -mtune compiler settings.

Another important change is the removal of the user_mode=home option,
user processes now always run in primary space. The storage keys are
not initialized at system startup any more, with that the storage key
removal work is complete. For the PCI support the hibernation hooks
have been implemented.

And as usual cleanup and fixes.

Chen Gang (1):
      s390/atomic: use 'unsigned int' instead of 'unsigned long' for atomic_*_mask()

Dominik Dingel (1):
      s390/mm: page_table_realloc returns failure

Gerald Schaefer (1):
      s390/monwriter: fix smatch warning for strcpy()

Heiko Carstens (32):
      s390/bitops: make use of interlocked-access facility 1 instructions
      s390: always set -march compiler option
      s390/kprobes: have more correct if statement in s390_get_insn_slot()
      s390/atomic: implement atomic_sub_return() with atomic_add_return()
      s390/atomic: make use of interlocked-access facility 1 instructions
      s390/dis: move disassembler function prototypes to proper header file
      s390/kprobes: use insn_length helper function
      s390/kprobes: allow kprobes only on known instructions
      s390/qdio: fix atomic_sub() misusage
      s390/atomic: optimize atomic_add() for constant values
      s390/atomic: various small cleanups
      s390/bitops: remove CONFIG_SMP / simplify non-atomic bitops
      s390/bitops: optimize set_bit() for constant values
      s390/bitops: use generic find bit functions / reimplement _left variant
      s390/bitops: use flogr instruction to implement __ffs, ffs, __fls, fls and fls64
      s390/bitops: rename find_first_bit_left() to find_first_bit_inv()
      s390: cleanup and add sanity checks to control register macros
      s390/gup: reduce code duplication between [__]get_user_pages_fast functions
      s390/gup: handle zero nr_pages case correctly
      s390/crashdump: remove unused variable
      s390/ftrace: prepare_ftrace_return() function call order
      s390/compat,signal: change return values to -EFAULT
      s390/cache: get rid of compile warning
      s390/cmm: make copy_from_user() invocation provably correct
      s390/appldata: make copy_from_user() invocations provably correct
      s390: fix handling of runtime instrumentation psw bit
      s390/compat: make psw32_user_bits a constant value again
      s390/percpu: use generic percpu ops for CONFIG_32BIT
      s390/percpu: make use of interlocked-access facility 1 instructions
      s390: add a couple of useful defconfigs
      s390/percpu: remove this_cpu_xor() implementation
      s390: allow to set gcc -mtune flag

Hendrik Brueckner (3):
      s390/s390dbf: add debug_level_enabled() function
      s390/s390dbf: use debug_level_enabled() where applicable
      tty/hvc_iucv: remove redundant NULL check

Ingo Tuchscherer (1):
      s390/crypto: fix aes_s390 crypto module unload problem

Joe Perches (1):
      s390: convert use of typedef ctl_table to struct ctl_table

Martin Schwidefsky (10):
      s390/uaccess: always run the kernel in home space
      s390/bpf,jit: fix prolog oddity
      s390/mm: do not initialize storage keys
      s390/3270: remove unnecessary pointer check
      s390/3270: use diagnose 0x210 for device sensing under z/VM
      s390: fix save and restore of the floating-point-control register
      Update default configuration
      s390/time: fix get_tod_clock_ext inline assembly
      s390/vtime: correct idle time calculation
      s390/mm,tlb: correct tlb flush on page table upgrade

Michael Holzheu (2):
      s390: Remove zfcpdump NR_CPUS dependency
      s390: Remove unused declaration of zfcpdump_prefix_array[]

Peter Oberparleiter (1):
      s390/cio: fix error-prone defines

Sebastian Ott (5):
      s390/pci: implement hibernation hooks
      s390/eadm_sch: improve quiesce handling
      s390/pci: message cleanup
      s390/pci: remove CONFIG_PCI_DEBUG dependancy
      s390/pci: cleanup function information block

Stefan Weinhuber (1):
      s390/dasd: Write to profile data area only if it is available

Steffen Maier (1):
      s390/scm_blk: fix endless loop for requests != REQ_TYPE_FS

Suzuki K. Poulose (2):
      s390/dis: rename structures for unique types
      s390/dis: move common definitions to a header file

 Documentation/s390/s390dbf.txt          |   10 +
 arch/s390/Kconfig                       |   62 ++
 arch/s390/Makefile                      |   22 +-
 arch/s390/appldata/appldata_base.c      |   18 +-
 arch/s390/configs/default_defconfig     |  655 ++++++++++++++++++++
 arch/s390/configs/gcov_defconfig        |  618 +++++++++++++++++++
 arch/s390/configs/performance_defconfig |  610 +++++++++++++++++++
 arch/s390/configs/zfcpdump_defconfig    |   86 +++
 arch/s390/crypto/aes_s390.c             |   15 +-
 arch/s390/defconfig                     |    4 +-
 arch/s390/include/asm/atomic.h          |  190 ++++--
 arch/s390/include/asm/bitops.h          | 1008 +++++++++----------------------
 arch/s390/include/asm/compat.h          |    5 +-
 arch/s390/include/asm/ctl_reg.h         |  112 ++--
 arch/s390/include/asm/debug.h           |    5 +
 arch/s390/include/asm/dis.h             |   52 ++
 arch/s390/include/asm/fcx.h             |   38 +-
 arch/s390/include/asm/ipl.h             |   10 +-
 arch/s390/include/asm/mmu_context.h     |   10 +-
 arch/s390/include/asm/page.h            |    7 +-
 arch/s390/include/asm/pci_debug.h       |    5 -
 arch/s390/include/asm/pci_insn.h        |   15 +-
 arch/s390/include/asm/percpu.h          |  137 +++--
 arch/s390/include/asm/processor.h       |   18 +-
 arch/s390/include/asm/ptrace.h          |    7 +-
 arch/s390/include/asm/setup.h           |    7 -
 arch/s390/include/asm/smp.h             |    1 -
 arch/s390/include/asm/switch_to.h       |  124 ++--
 arch/s390/include/asm/timex.h           |    6 +-
 arch/s390/include/asm/uaccess.h         |   18 +-
 arch/s390/include/uapi/asm/ptrace.h     |    4 +-
 arch/s390/include/uapi/asm/sigcontext.h |    1 +
 arch/s390/kernel/Makefile               |    2 +-
 arch/s390/kernel/bitmap.c               |   54 --
 arch/s390/kernel/cache.c                |    5 +-
 arch/s390/kernel/compat_linux.c         |    4 -
 arch/s390/kernel/compat_linux.h         |    1 +
 arch/s390/kernel/compat_signal.c        |   89 +--
 arch/s390/kernel/crash_dump.c           |   35 +-
 arch/s390/kernel/debug.c                |    2 +-
 arch/s390/kernel/dis.c                  |   81 +--
 arch/s390/kernel/dumpstack.c            |    1 +
 arch/s390/kernel/early.c                |    2 +
 arch/s390/kernel/entry.h                |    1 -
 arch/s390/kernel/ftrace.c               |    9 +-
 arch/s390/kernel/head.S                 |    2 +-
 arch/s390/kernel/ipl.c                  |    4 +-
 arch/s390/kernel/kprobes.c              |   13 +-
 arch/s390/kernel/pgm_check.S            |    2 +-
 arch/s390/kernel/process.c              |   15 +-
 arch/s390/kernel/ptrace.c               |   70 ++-
 arch/s390/kernel/runtime_instr.c        |    2 -
 arch/s390/kernel/setup.c                |   59 +-
 arch/s390/kernel/signal.c               |   49 +-
 arch/s390/kernel/smp.c                  |   21 +-
 arch/s390/kernel/vdso.c                 |    9 +-
 arch/s390/kernel/vtime.c                |    4 +-
 arch/s390/kvm/kvm-s390.c                |   23 +-
 arch/s390/kvm/trace.h                   |    1 +
 arch/s390/lib/Makefile                  |    2 +-
 arch/s390/lib/find.c                    |   77 +++
 arch/s390/lib/uaccess_mvcos.c           |   30 -
 arch/s390/lib/uaccess_pt.c              |    2 -
 arch/s390/lib/uaccess_std.c             |  305 ----------
 arch/s390/math-emu/math.c               |    2 +
 arch/s390/mm/cmm.c                      |   12 +-
 arch/s390/mm/fault.c                    |   46 +-
 arch/s390/mm/gup.c                      |   83 +--
 arch/s390/mm/mmap.c                     |   12 +-
 arch/s390/mm/pageattr.c                 |    4 +-
 arch/s390/mm/pgtable.c                  |   43 +-
 arch/s390/net/bpf_jit_comp.c            |    6 +-
 arch/s390/pci/pci.c                     |  108 ++--
 arch/s390/pci/pci_clp.c                 |   33 +-
 arch/s390/pci/pci_dma.c                 |   18 +-
 arch/s390/pci/pci_event.c               |   35 +-
 drivers/pci/hotplug/s390_pci_hpc.c      |    6 +-
 drivers/s390/block/dasd.c               |    3 +-
 drivers/s390/block/scm_blk.c            |    6 +-
 drivers/s390/block/scm_blk.h            |    2 +-
 drivers/s390/char/monwriter.c           |    2 +-
 drivers/s390/char/raw3270.c             |    4 +-
 drivers/s390/char/zcore.c               |   20 +-
 drivers/s390/cio/airq.c                 |   19 +-
 drivers/s390/cio/eadm_sch.c             |   29 +-
 drivers/s390/cio/eadm_sch.h             |    4 +-
 drivers/s390/cio/qdio_debug.h           |    8 +-
 drivers/s390/cio/qdio_main.c            |    2 +-
 drivers/s390/crypto/zcrypt_debug.h      |   12 +-
 drivers/s390/net/claw.h                 |    8 +-
 drivers/s390/net/ctcm_dbug.c            |    2 +-
 drivers/s390/net/lcs.h                  |    8 +-
 drivers/s390/net/netiucv.c              |    8 +-
 drivers/s390/net/qeth_core_main.c       |    2 +-
 drivers/s390/scsi/zfcp_dbf.h            |    4 +-
 drivers/tty/hvc/hvc_iucv.c              |    3 +-
 96 files changed, 3427 insertions(+), 1983 deletions(-)
 create mode 100644 arch/s390/configs/default_defconfig
 create mode 100644 arch/s390/configs/gcov_defconfig
 create mode 100644 arch/s390/configs/performance_defconfig
 create mode 100644 arch/s390/configs/zfcpdump_defconfig
 create mode 100644 arch/s390/include/asm/dis.h
 delete mode 100644 arch/s390/kernel/bitmap.c
 create mode 100644 arch/s390/lib/find.c
 delete mode 100644 arch/s390/lib/uaccess_std.c


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaLJI5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:57:11 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:59426 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaLJI5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:57:06 -0500
Date: Wed, 10 Dec 2014 09:56:59 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.19 merge window
Message-ID: <20141210095659.0dfbc8c4@mschwide>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121008-0013-0000-0000-00000228AC95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
The most notable change for this pull request is the ftrace rework
from Heiko. It brings a small performance improvement and the ground
work to support a new gcc option to replace the mcount blocks with
a single nop. 

Two new s390 specific system calls are added to emulate user space mmio
for PCI, an artifact of the how PCI memory is accessed.

Two patches for the memory management with changes to common code.
For KVM mm_forbids_zeropage is added which disables the empty zero
page for an mm that is used by a KVM process. And an optimization,
pmdp_get_and_clear_full is added analog to ptep_get_and_clear_full.

Some micro optimization for the cmpxchg and the spinlock code.

And as usual bug fixes and cleanups.

Alexey Ishchuk (1):
      s390/kernel: add system calls for PCI memory access

Christian Borntraeger (1):
      s390/debug: avoid function call for debug_sprintf_*

Dominik Dingel (5):
      s390/mm: recfactor global pgste updates
      mm: introduce mm_forbids_zeropage function
      s390/mm: prevent and break zero page mappings in case of storage keys
      s390/mm: disable KSM for storage key enabled pages
      s390/mm: missing pte for gmap_ipte_notify should trigger a VM_BUG

Frank Blaschka (1):
      s390/io: add ioport_map stubs

Frederic Weisbecker (2):
      s390/idle: convert open coded idle time seqcount
      s390: translate cputime magic constants to macros

Heiko Carstens (9):
      kprobes: introduce weak arch_check_ftrace_location() helper function
      s390/ftrace,kprobes: allow to patch first instruction
      s390/kprobes: make use of NOKPROBE_SYMBOL()
      s390/traps: print interrupt code and instruction length code
      s390/traps: die on translation exceptions
      s390/ftrace: provide working ftrace_return_address()
      s390: remove diag 44 calls from cpu_relax()
      s390/kprobes: fix instruction copy for out of line execution
      s390/idle: add missing irq off lockdep annotation

Hendrik Brueckner (1):
      s390/cpum_sf: Remove initialization of PMU event index

Markus Elfring (1):
      s390/pci: Deletion of unnecessary checks before the function call "debug_unregister"

Martin Schwidefsky (12):
      s390/mm: pmdp_get_and_clear_full optimization
      s390/cmpxchg: use compiler builtins
      s390/pci: add sparse annotations
      s390/mm: use correct unlock function in gmap_ipte_notify
      s390/signal: add sparse annotations
      s390: fix ptrace of user area if the inferior uses vector registers
      s390/sclp_async: add Kconfig option to specify the component id
      s390/simd: clear vector register pointer on fork/clone
      s390/ptrace: always include vector registers in core files
      s390: use local symbol names in entry[64].S
      s390/mm: fix memory leak of ptlock in pmd_free_tlb
      s390/cputime: fix 31-bit compile

Sebastian Ott (7):
      s390/pci: improve irq number check for msix
      s390/irq: use irq 0
      s390/eadm: change timeout value
      s390/scm_block: use mempool to manage aidaw requests
      s390/scm_block: allocate aidaw pages only when necessary
      s390/scm_block: handle multiple requests in one HW request
      s390/scm_block: make the number of reqs per HW req configurable

Stefan Haberland (4):
      s390/dasd: remove unused code
      s390/dasd: fix infinite term I/O loop
      s390/dasd: fix list corruption for sleep_on requests
      s390/dasd: retry partition detection

Thomas Huth (2):
      s390/docs: Fix the documentation of the address spaces
      s390/docs: Remove sections that are not related to s390


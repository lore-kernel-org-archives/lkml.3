Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3IKKuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:50:39 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:48958 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3IKKuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:50:37 -0400
Date: Wed, 11 Sep 2013 12:50:31 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [GIT PULL] more s390 updates for 3.12 merge window
Message-ID: <20130911105031.GA31307@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091110-2966-0000-0000-000008B76818
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive a couple of s390 updates for 3.12.

This includes one bpf/jit bug fix where the jit compiler could sometimes
write generated code out of bounds of the allocated memory area.
The rest of the patches are only cleanups and minor improvements.

Thanks,
Heiko

---

Heiko Carstens (13):
      s390/bpf,jit: fix address randomization
      s390: update defconfig
      s390/dumpstack: convert print_symbol to %pSR
      s390/irq: use hlists for external interrupt handler array
      s390/irq: rework irq subclass handling
      s390: keep Kconfig sorted
      s390/mm: add __releases()/__acquires() annotations to gmap_alloc_table()
      s390/compat signal: add couple of __force annotations
      s390: make various functions static, add declarations to header files
      s390/ftrace: avoid pointer arithmetics with function pointers
      s390/ap_bus: use and-mask instead of a cast
      s390/compat,uid16: use current_cred()
      s390/irq: reduce size of external interrupt handler hash array

Hendrik Brueckner (1):
      s390/perf: Remove print_hex_dump_bytes() debug output

 arch/s390/Kconfig                |  6 +--
 arch/s390/defconfig              | 39 ++++++++++++------
 arch/s390/include/asm/irq.h      | 12 ++++--
 arch/s390/kernel/compat_linux.c  |  9 +++--
 arch/s390/kernel/compat_signal.c | 10 ++---
 arch/s390/kernel/dumpstack.c     | 20 +++++-----
 arch/s390/kernel/entry.h         | 18 +++------
 arch/s390/kernel/ftrace.c        |  5 ++-
 arch/s390/kernel/irq.c           | 85 +++++++++++++++-------------------------
 arch/s390/kernel/machine_kexec.c |  2 +-
 arch/s390/kernel/perf_cpum_cf.c  |  4 +-
 arch/s390/kernel/perf_event.c    |  5 +--
 arch/s390/kernel/runtime_instr.c |  4 +-
 arch/s390/kernel/smp.c           |  2 +-
 arch/s390/kernel/suspend.c       |  1 +
 arch/s390/mm/fault.c             |  2 +-
 arch/s390/mm/maccess.c           |  1 +
 arch/s390/mm/pgtable.c           |  6 ++-
 arch/s390/net/bpf_jit_comp.c     |  2 +-
 arch/s390/oprofile/hwsampler.c   |  6 +--
 drivers/s390/block/dasd_diag.c   |  4 +-
 drivers/s390/char/fs3270.c       |  6 +--
 drivers/s390/char/sclp.c         |  6 +--
 drivers/s390/char/tty3270.c      |  6 +--
 drivers/s390/crypto/ap_bus.c     |  2 +-
 drivers/s390/kvm/kvm_virtio.c    |  2 +-
 26 files changed, 130 insertions(+), 135 deletions(-)


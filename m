Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab3BVVQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 16:16:24 -0500
Received: from mout.gmx.net ([212.227.15.18]:50155 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab3BVVQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 16:16:22 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/myXglnlTmQSaM2yquDSNliHA7ahCR61mUqOIjEo
	UPq7+daDDzI7WH
Date: Fri, 22 Feb 2013 22:16:15 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for 3.9
Message-ID: <20130222211615.GA5979@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.9

for you to fetch changes up to 1dda59b4f3d03fa28d86f3ea235655f0f96aab3e:

  arch/parisc/include/asm: use ARRAY_SIZE macro in mmzone.h (2013-02-20 22:57:49 +0100)

----------------------------------------------------------------
Al Viro (1):
      parisc: fix ptrace breakage

Geert Uytterhoeven (1):
      [PARISC] hpux: Remove obsolete regs parameter from do_execve() in hpux_execve()

Helge Deller (13):
      Merge tag 'parisc-fixes' of git://git.kernel.org/.../jejb/parisc-2.6 into stable-3.8
      parisc: enhance automatic CONFIG_CROSS_COMPILE detection
      parisc: add CONFIG_MLONGCALLS option to enable linkage of huge vmlinux executables
      parisc: led driver requires CONFIG_VM_EVENT_COUNTERS
      parisc: wire up process_vm_readv, process_vm_writev, kcmp and finit_module syscalls
      parisc: fix personality on 32bit kernel
      parisc: correctly wire up mq_* functions for CONFIG_COMPAT case
      parisc: convert msgrcv and msgsnd syscalls to use compat layer
      parisc: fix error return codes for rt_sigaction and rt_sigprocmask
      parisc: fix fallocate syscall
      parisc: switch to available compat_sched_rr_get_interval implementation
      parisc: sendfile and sendfile64 syscall cleanups
      parisc: remove empty lines and unnecessary #ifdef coding in include/asm/signal.h

Joe Perches (1):
      drivers/parisc: Use printf extension %pR for struct resource

John David Anglin (10):
      [PARISC] Purge existing TLB entries in set_pte_at and ptep_set_wrprotect
      parisc: Fix comment describing setup of access rights in entry.S
      parisc: fixes and cleanups in page cache flushing (1/4)
      parisc: fixes and cleanups in page cache flushing (2/4)
      parisc: fixes and cleanups in page cache flushing (3/4)
      parisc: fixes and cleanups in page cache flushing (4/4)
      parisc: disable preemption while flushing D- or I-caches through TMPALIAS region
      parisc: ensure that mmapped shared pages are aligned at SHMLBA addresses
      parisc: always detect multiple physical ranges
      parisc: space register variables need to be in native length (unsigned long)

Julia Lawall (1):
      drivers/parisc/pdc_stable.c: use WARN

Kautuk Consul (1):
      parisc/mm/fault.c: Port OOM changes to do_page_fault

Nikitas Angelinas (1):
      arch/parisc/include/asm: use ARRAY_SIZE macro in mmzone.h

Paul Bolle (1):
      parisc: remove unused compat_rt_sigframe.h header

Peter Zijlstra (1):
      parisc: remove IRQF_DISABLED

Wei Yongjun (1):
      parisc: fix possible memory leak in pat_query_module()

 arch/parisc/Kconfig                          |  21 ++
 arch/parisc/Makefile                         |  13 +-
 arch/parisc/hpux/fs.c                        |   3 +-
 arch/parisc/include/asm/cacheflush.h         |   2 +
 arch/parisc/include/asm/compat.h             |  61 +++++
 arch/parisc/include/asm/compat_rt_sigframe.h |  50 ----
 arch/parisc/include/asm/elf.h                |   2 +-
 arch/parisc/include/asm/floppy.h             |   4 +-
 arch/parisc/include/asm/mmzone.h             |   7 +-
 arch/parisc/include/asm/page.h               |  20 +-
 arch/parisc/include/asm/pgtable.h            |  13 +-
 arch/parisc/include/asm/signal.h             |   4 -
 arch/parisc/include/asm/unistd.h             |   2 +
 arch/parisc/include/uapi/asm/unistd.h        |   6 +-
 arch/parisc/kernel/cache.c                   | 221 +++++++++++++++---
 arch/parisc/kernel/entry.S                   |   4 +-
 arch/parisc/kernel/inventory.c               |   2 +
 arch/parisc/kernel/irq.c                     |   4 +-
 arch/parisc/kernel/pacache.S                 | 335 +++++++++++++++++++++++----
 arch/parisc/kernel/parisc_ksyms.c            |   5 +-
 arch/parisc/kernel/signal.c                  |   2 +-
 arch/parisc/kernel/signal32.c                |  15 +-
 arch/parisc/kernel/sys_parisc.c              |  16 +-
 arch/parisc/kernel/sys_parisc32.c            | 122 ++--------
 arch/parisc/kernel/syscall.S                 |   5 +-
 arch/parisc/kernel/syscall_table.S           |  27 +--
 arch/parisc/mm/fault.c                       |  30 ++-
 drivers/parisc/Kconfig                       |   1 +
 drivers/parisc/dino.c                        |  13 +-
 drivers/parisc/hppb.c                        |   6 +-
 drivers/parisc/pdc_stable.c                  |   6 +-
 drivers/parisc/superio.c                     |   2 +-
 32 files changed, 708 insertions(+), 316 deletions(-)
 delete mode 100644 arch/parisc/include/asm/compat_rt_sigframe.h

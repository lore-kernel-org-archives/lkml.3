Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3BTWwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:52:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37039 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3BTWwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:52:16 -0500
Date: Wed, 20 Feb 2013 22:52:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [git pull] signal.git
Message-ID: <20130220225214.GJ4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* a bunch of signal-related syscalls (both native and compat) unified.
* a bunch of compat syscalls switched to COMPAT_SYSCALL_DEFINE (fixing several
potential problems with missing argument validation, while we are at it)
* a lot of now-pointless wrappers killed
* a couple of architectures (cris and hexagon) forgot to save altstack settings
into sigframe, even though they used the (uninitialized) values in sigreturn;
fixed.
* microblaze fixes for delivery of multiple signals arriving at once
* saner set of helpers for signal delivery introduced, several architectures
switched to using those.

That's the first pile; another one will come a bit later and will contain
SYSCALL_DEFINE-related patches.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (140):
      switch compat_sys_[gs]etitimer(2) to COMPAT_SYSCALL_DEFINE
      sanitize rt_sigaction() situation a bit
      consolidate rt_sigsuspend()
      generic compat_sys_rt_sigprocmask()
      generic compat_sys_rt_sigpending()
      generic compat_sys_rt_sigqueueinfo()
      old sigsuspend variants in kernel/signal.c
      switch compat_sys_rt_sigtimedwait to COMPAT_SYSCALL_DEFINE
      switch compat_sys_sigprocmask to COMPAT_SYSCALL_DEFINE
      switch rt_tgsigqueueinfo to COMPAT_SYSCALL_DEFINE
      switch compat_sys_sched_rr_get_interval to COMPAT_SYSCALL_DEFINE
      consolidate declarations of k_sigaction
      consolidate kernel-side struct sigaction declarations
      generic sys_compat_rt_sigaction()
      generic sys_sigaction() and compat_sys_sigaction()
      switch compat_sys_open* to COMPAT_SYSCALL_DEFINE
      convert futex compat syscalls to COMPAT_SYSCALL_DEFINE
      switch timerfd compat syscalls to COMPAT_SYSCALL_DEFINE
      new helper: get_signal()
      new helper: signal_setup_done()
      new helper: sigsp()
      mips: use sane prototype for sys_rt_sigsuspend()
      take sys_rt_sigsuspend() prototype to linux/syscalls.h
      alpha: remove stray debris left in copy_process()
      arm: switch to generic sigaltstack
      alpha: switch to generic old sigsuspend
      arm: switch to generic old sigsuspend
      arm: switch to generic old sigaction()
      avr32: switch to generic sigaltstack
      blackfin: switch to generic sigaltstack
      cris: switch to generic sigaltstack
      c6x: switch to generic sigaltstack
      cris: don't leave ->uc_stack unitialized - we'll use its contents on sigreturn
      cris: switch to generic old sigsuspend
      cris: switch to generic old sigaction()
      frv: switch to generic sigaltstack
      cris: kill weird arguments of sys_{rt_,}sigreturn()
      frv: switch to generic old sigsuspend
      frv: switch to generic old sigaction()
      h8300: switch to generic sigaltstack
      h8300: kill useless wrappers, fix rt_sigreturn(2)
      h8300: switch to generic old sigsuspend
      hexagon: switch to generic sigaltstack
      h8300: switch to generic old sigaction()
      ia64: switch to generic sigaltstack
      hexagon: don't leave ->uc_stack uninitialized
      m32r: switch to generic sigaltstack
      m68k: switch to generic sigaltstack
      m68k: switch to generic old sigsuspend
      m68k: switch to generic old sigaction()
      microblaze: switch to generic sigaltstack
      microblaze: evict the check for kernel_mode(regs) from do_notify_resume()
      microblaze: fix the horror with restarts of sigreturn()
      microblaze: fix handling of multiple pending signals
      mn10300: switch to generic sigaltstack
      microblaze: remove debris in ptrace.c
      mn10300: switch to generic old sigsuspend
      mn10300: switch to generic old sigaction()
      parisc: switch to generic sigaltstack
      openrisc: switch to generic sigaltstack
      parisc: switch to generic compat rt_sigprocmask()
      parisc: switch to generic compat rt_sigpending()
      parisc: switch to generic compat rt_sigqueueinfo()
      parisc: switch to generic compat sched_rr_get_interval()
      parisc: switch to generic compat rt_sigaction()
      powerpc: switch to generic sigaltstack
      powerpc: switch to generic compat rt_sigprocmask()
      powerpc: switch to generic compat rt_sigpending()
      powerpc: switch to generic compat rt_sigqueueinfo()
      powerpc: switch to generic old sigsuspend
      powerpc: kill pointless wrappers
      powerpc: switch to generic compat rt_sigaction()
      powerpc: switch to generic old sigaction()
      s390: switch to generic sigaltstack
      powerpc: trim the crap from syscalls.h
      s390: switch to generic compat rt_sigprocmask(2)
      s390: switch to generic compat rt_sigpending()
      s390: switch to generic compat rt_sigqueueinfo()
      s390: switch to generic old sigsuspend
      s390: switch to generic compat sched_rr_get_interval()
      s390: switch to generic compat rt_sigaction
      s390: switch to generic old sigaction()
      s390: kill useless wrappers
      sh: switch to generic sigaltstack
      score: switch to generic sigaltstack
      sh: switch to generic old sigsuspend()
      sh: switch to generic old sigaction()
      sparc: switch to generic sigaltstack
      sparc: bury the sys_sigpause() remains
      sparc: switch to generic compat rt_sigprocmask(2)
      sparc: switch to generic compat rt_sigpending()
      sparc: switch to generic compat rt_sigqueueinfo()
      tile: switch to generic sigaltstack
      tile: switch to generic compat rt_sig{procmask,pending}()
      tile: switch to generic compat rt_sigqueueinfo()
      tile: switch to generic compat rt_sigaction()
      amd64: get rid of useless RESTORE_TOP_OF_STACK in stub_execve()
      unicore32: switch to generic sigaltstack
      x86: get rid of pt_regs argument of iopl(2)
      x86: get rid of pt_regs argument in sigreturn variants
      x86: get rid of pt_regs argument in vm86/vm86old
      x86: switch to generic compat rt_sigpending()
      x86: switch to generic compat rt_sigqueueinfo()
      x86,um: switch to generic old sigsuspend()
      x86: switch to generic compat sched_rr_get_interval()
      x86: switch to generic compat rt_sigaction()
      xtensa: switch to generic sigaltstack
      x86: switch to generic old sigaction
      mips: switch to generic sigaltstack
      mips: switch to compat_sys_waitid()
      switch mips to generic rt_sigsuspend(), make it unconditional
      mips: switch to generic compat rt_sigprocmask()
      mips: switch to generic compat rt_sigpending()
      mips: switch to generic compat rt_sigqueueinfo()
      mips: sigsuspend() is essentially the same as rt_sigsuspend() here
      mips: switch to generic compat sched_rr_get_interval()
      mips: switch to generic compat rt_sigaction()
      mips: don't bother with compat_sys_futex() wrappers
      mips: no magic arguments for sysm_pipe()
      mips: take the "zero newsp means inherit the parent's one" to copy_thread()
      mips: switch to generic sys_fork() and sys_clone()
      sparc: switch sys_compat_rt_sigaction() to COMPAT_SYSCALL_DEFINE
      sparc: switch to use of generic old sigaction
      kill sparc32_open()
      sparc: kill sign-extending wrappers for native syscalls
      sparc: COMPAT_SYSCALL_DEFINE does all sign-extension as well as SYSCALL_DEFINE
      sparc: switch to generic old sigsuspend
      arm64: switch to generic sigaltstack
      arm64: switch to generic compat rt_sigprocmask()
      arm64: switch to generic compat rt_sigpending()
      arm64: switch to generic compat rt_sigqueueinfo()
      arm64: switch compat to generic old sigsuspend
      arm64: switch to generic compat rt_sigaction()
      arm64: switch to generic old sigaction() (compat-only)
      make do_sigaltstack() static
      burying unused conditionals
      alpha: pass k_sigaction and siginfo_t using ksignal pointer
      arm: switch to struct ksignal * passing
      sparc: convert to ksignal
      x86: convert to ksignal

Michal Simek (1):
      microblaze: Move restart allowed out of block

Ralf Baechle (2):
      MIPS: sysmips: Use unreachable().
      MIPS: sysmips: Rewrite to use SYSCALL_DEFINE3().

Diffstat:
 arch/Kconfig                            |   29 +++-
 arch/alpha/Kconfig                      |    3 +-
 arch/alpha/include/asm/signal.h         |   11 +-
 arch/alpha/include/asm/unistd.h         |    1 -
 arch/alpha/kernel/process.c             |    1 -
 arch/alpha/kernel/signal.c              |  121 ++++-------
 arch/arm/Kconfig                        |    2 +
 arch/arm/include/asm/signal.h           |   18 +--
 arch/arm/include/asm/unistd.h           |    2 -
 arch/arm/kernel/calls.S                 |    2 +-
 arch/arm/kernel/entry-common.S          |    5 -
 arch/arm/kernel/signal.c                |  160 +++++----------
 arch/arm64/Kconfig                      |    2 +
 arch/arm64/include/asm/syscalls.h       |    2 -
 arch/arm64/include/asm/unistd.h         |    2 -
 arch/arm64/include/asm/unistd32.h       |    4 +-
 arch/arm64/kernel/entry.S               |    5 -
 arch/arm64/kernel/signal.c              |   17 +--
 arch/arm64/kernel/signal32.c            |  220 +--------------------
 arch/arm64/kernel/sys.c                 |    1 -
 arch/arm64/kernel/sys32.S               |    5 -
 arch/avr32/include/asm/signal.h         |   11 +-
 arch/avr32/include/asm/unistd.h         |    2 -
 arch/avr32/kernel/signal.c              |   15 +--
 arch/avr32/kernel/syscall-stubs.S       |    6 -
 arch/avr32/kernel/syscall_table.S       |    2 +-
 arch/blackfin/include/asm/unistd.h      |    2 -
 arch/blackfin/kernel/signal.c           |   12 +-
 arch/c6x/kernel/entry.S                 |   12 -
 arch/cris/Kconfig                       |    2 +
 arch/cris/arch-v10/kernel/signal.c      |   65 +------
 arch/cris/arch-v32/kernel/signal.c      |   68 +------
 arch/cris/include/asm/signal.h          |   19 +--
 arch/cris/include/asm/unistd.h          |    2 -
 arch/frv/Kconfig                        |    2 +
 arch/frv/include/asm/signal.h           |    7 -
 arch/frv/include/asm/unistd.h           |    2 -
 arch/frv/kernel/signal.c                |   55 +-----
 arch/h8300/Kconfig                      |    2 +
 arch/h8300/include/asm/signal.h         |   18 +--
 arch/h8300/include/asm/unistd.h         |    2 -
 arch/h8300/kernel/signal.c              |   72 +------
 arch/h8300/kernel/syscalls.S            |   15 --
 arch/hexagon/kernel/signal.c            |   16 +--
 arch/ia64/include/asm/signal.h          |   10 -
 arch/ia64/include/asm/unistd.h          |    8 -
 arch/ia64/kernel/signal.c               |   19 +--
 arch/m32r/include/asm/signal.h          |   11 +-
 arch/m32r/include/asm/unistd.h          |    2 -
 arch/m32r/kernel/signal.c               |   16 +--
 arch/m68k/Kconfig                       |    2 +
 arch/m68k/include/asm/signal.h          |   19 +--
 arch/m68k/include/asm/unistd.h          |    2 -
 arch/m68k/kernel/signal.c               |   59 +-----
 arch/microblaze/include/asm/unistd.h    |    2 -
 arch/microblaze/kernel/entry-nommu.S    |   21 ++-
 arch/microblaze/kernel/entry.S          |   62 +++---
 arch/microblaze/kernel/ptrace.c         |   23 --
 arch/microblaze/kernel/signal.c         |   26 +---
 arch/mips/Kconfig                       |    1 +
 arch/mips/include/asm/compat.h          |    8 +
 arch/mips/include/asm/signal.h          |    2 +
 arch/mips/include/asm/sim.h             |   24 +-
 arch/mips/include/asm/unistd.h          |    3 +-
 arch/mips/include/uapi/asm/signal.h     |    6 +-
 arch/mips/kernel/linux32.c              |   44 ----
 arch/mips/kernel/process.c              |    3 +-
 arch/mips/kernel/scall32-o32.S          |    4 +-
 arch/mips/kernel/scall64-64.S           |    4 +-
 arch/mips/kernel/scall64-n32.S          |   20 +-
 arch/mips/kernel/scall64-o32.S          |   22 +-
 arch/mips/kernel/signal.c               |   48 +----
 arch/mips/kernel/signal32.c             |  237 +---------------------
 arch/mips/kernel/signal_n32.c           |   59 +-----
 arch/mips/kernel/syscall.c              |   73 +------
 arch/mn10300/Kconfig                    |    2 +
 arch/mn10300/include/asm/signal.h       |   19 +--
 arch/mn10300/include/asm/unistd.h       |    2 -
 arch/mn10300/kernel/signal.c            |   60 +------
 arch/openrisc/kernel/entry.S            |    4 -
 arch/openrisc/kernel/signal.c           |   15 +--
 arch/parisc/include/asm/signal.h        |    6 +-
 arch/parisc/include/asm/unistd.h        |    3 -
 arch/parisc/kernel/entry.S              |   38 ----
 arch/parisc/kernel/signal.c             |   19 +--
 arch/parisc/kernel/signal32.c           |  142 -------------
 arch/parisc/kernel/signal32.h           |   23 --
 arch/parisc/kernel/sys32.h              |   12 -
 arch/parisc/kernel/sys_parisc32.c       |   12 -
 arch/parisc/kernel/syscall_table.S      |   10 +-
 arch/powerpc/Kconfig                    |    3 +
 arch/powerpc/include/asm/signal.h       |    1 +
 arch/powerpc/include/asm/syscalls.h     |   15 --
 arch/powerpc/include/asm/systbl.h       |   63 +++---
 arch/powerpc/include/asm/unistd.h       |    4 -
 arch/powerpc/include/uapi/asm/signal.h  |    6 +-
 arch/powerpc/kernel/ppc32.h             |   26 +---
 arch/powerpc/kernel/signal.c            |    7 -
 arch/powerpc/kernel/signal_32.c         |  253 +-----------------------
 arch/powerpc/kernel/signal_64.c         |   11 +-
 arch/powerpc/kernel/sys_ppc32.c         |  301 ----------------------------
 arch/s390/Kconfig                       |    3 +
 arch/s390/include/asm/signal.h          |   19 +--
 arch/s390/include/asm/unistd.h          |    3 -
 arch/s390/kernel/compat_linux.c         |   80 --------
 arch/s390/kernel/compat_linux.h         |   34 +---
 arch/s390/kernel/compat_signal.c        |  134 +------------
 arch/s390/kernel/compat_wrapper.S       |  144 -------------
 arch/s390/kernel/entry.h                |    4 -
 arch/s390/kernel/signal.c               |   56 +-----
 arch/s390/kernel/syscalls.S             |   46 ++--
 arch/score/include/asm/syscalls.h       |    1 -
 arch/score/kernel/entry.S               |    5 -
 arch/score/kernel/signal.c              |   21 +--
 arch/sh/Kconfig                         |    2 +
 arch/sh/include/asm/syscalls_32.h       |    6 -
 arch/sh/include/asm/unistd.h            |    2 -
 arch/sh/include/uapi/asm/signal.h       |    2 +
 arch/sh/kernel/signal_32.c              |   63 +------
 arch/sh/kernel/signal_64.c              |   62 +------
 arch/sparc/Kconfig                      |    4 +
 arch/sparc/include/asm/compat_signal.h  |    6 -
 arch/sparc/include/asm/signal.h         |    6 +-
 arch/sparc/include/asm/unistd.h         |    3 -
 arch/sparc/include/uapi/asm/signal.h    |    2 +
 arch/sparc/kernel/entry.S               |    8 -
 arch/sparc/kernel/signal32.c            |  202 ++++++-------------
 arch/sparc/kernel/signal_32.c           |  175 ++++++-----------
 arch/sparc/kernel/signal_64.c           |  142 +++++---------
 arch/sparc/kernel/sys32.S               |   86 --------
 arch/sparc/kernel/sys_sparc32.c         |  185 +----------------
 arch/sparc/kernel/sys_sparc_32.c        |   48 +----
 arch/sparc/kernel/syscalls.S            |    6 -
 arch/sparc/kernel/systbls.h             |    4 +-
 arch/sparc/kernel/systbls_32.S          |    2 +-
 arch/sparc/kernel/systbls_64.S          |   84 ++++----
 arch/tile/include/asm/compat.h          |    8 -
 arch/tile/include/asm/syscalls.h        |    2 -
 arch/tile/include/asm/unistd.h          |    1 -
 arch/tile/kernel/compat_signal.c        |  112 +----------
 arch/tile/kernel/signal.c               |   15 +--
 arch/um/kernel/signal.c                 |   10 -
 arch/unicore32/kernel/entry.S           |    5 -
 arch/unicore32/kernel/signal.c          |   12 +-
 arch/x86/Kconfig                        |    4 +-
 arch/x86/ia32/ia32_signal.c             |   50 ++---
 arch/x86/ia32/ia32entry.S               |   12 +-
 arch/x86/ia32/sys_ia32.c                |  171 ----------------
 arch/x86/include/asm/fpu-internal.h     |    5 +-
 arch/x86/include/asm/ia32.h             |   15 --
 arch/x86/include/asm/signal.h           |   24 +--
 arch/x86/include/asm/sys_ia32.h         |   16 +--
 arch/x86/include/asm/syscalls.h         |   13 +-
 arch/x86/include/asm/unistd.h           |    2 -
 arch/x86/include/uapi/asm/signal.h      |    8 +-
 arch/x86/kernel/entry_32.S              |   45 ----
 arch/x86/kernel/entry_64.S              |   34 ++--
 arch/x86/kernel/ioport.c                |    3 +-
 arch/x86/kernel/signal.c                |  184 ++++++------------
 arch/x86/kernel/vm86_32.c               |    8 +-
 arch/x86/syscalls/syscall_32.tbl        |   22 +-
 arch/x86/syscalls/syscall_64.tbl        |    6 +-
 arch/x86/um/Kconfig                     |    3 +-
 arch/x86/um/Makefile                    |    4 +-
 arch/x86/um/shared/sysdep/syscalls_32.h |    5 -
 arch/x86/um/signal.c                    |   15 +--
 arch/x86/um/sys_call_table_32.c         |    4 -
 arch/x86/um/syscalls_32.c               |   38 ----
 arch/xtensa/include/asm/signal.h        |   11 +-
 arch/xtensa/include/asm/syscall.h       |    7 -
 arch/xtensa/include/asm/unistd.h        |    2 -
 arch/xtensa/include/uapi/asm/unistd.h   |    2 +-
 arch/xtensa/kernel/signal.c             |   18 +--
 fs/compat.c                             |   52 +-----
 fs/timerfd.c                            |   85 ++++++--
 include/asm-generic/syscalls.h          |   16 --
 include/asm-generic/unistd.h            |    3 -
 include/linux/compat.h                  |   50 ++++-
 include/linux/sched.h                   |   12 +-
 include/linux/signal.h                  |   52 +++++-
 include/linux/syscalls.h                |   25 ++-
 include/uapi/asm-generic/signal.h       |   10 +-
 include/uapi/asm-generic/unistd.h       |    4 +-
 kernel/compat.c                         |   72 +++-----
 kernel/futex_compat.c                   |   19 +-
 kernel/signal.c                         |  332 +++++++++++++++++++++++++++----
 186 files changed, 1365 insertions(+), 4832 deletions(-)
 delete mode 100644 arch/x86/um/syscalls_32.c

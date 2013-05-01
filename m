Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab3EAEqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 00:46:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57936 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3EAEqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 00:46:11 -0400
Date: Wed, 1 May 2013 05:46:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] signal.git, first pile
Message-ID: <20130501044609.GV4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly about syscall wrappers this time; there will be another pile with
patches in the same general area from various people, but I'd rather push
those after both that and vfs.git pile are in.  Please, pull from

git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (20):
      get rid of duplicate logics in __SC_....[1-6] definitions
      teach SYSCALL_DEFINE<n> how to deal with long long/unsigned long long
      consolidate cond_syscall and SYSCALL_ALIAS declarations
      make HAVE_SYSCALL_WRAPPERS unconditional
      make SYSCALL_DEFINE<n>-generated wrappers do asmlinkage_protect
      switch signalfd{,4}() to COMPAT_SYSCALL_DEFINE
      convert sendfile{,64} to COMPAT_SYSCALL_DEFINE
      switch epoll_pwait to COMPAT_SYSCALL_DEFINE
      switch getrusage() to COMPAT_SYSCALL_DEFINE
      convert vmsplice to COMPAT_SYSCALL_DEFINE
      consolidate compat lookup_dcookie()
      merge compat sys_ipc instances
      get rid of compat_sys_semctl() and friends in case of ARCH_WANT_OLD_COMPAT_IPC
      x86: sys32_kill and sys32_mprotect are pointless
      x86: trim sys_ia32.h
      ppc compat wrappers for add_key(2) and request_key(2) are pointless
      sparc: no need to sign-extend in sync_file_range() wrapper
      make do_mremap() static
      get rid of union semop in sys_semctl(2) arguments
      syscalls.h: slightly reduce the jungles of macros

Diffstat:
 arch/Kconfig                            |    3 -
 arch/alpha/Kconfig                      |    1 -
 arch/alpha/include/asm/linkage.h        |    4 +-
 arch/alpha/include/asm/unistd.h         |   12 --
 arch/arm/include/asm/unistd.h           |    8 --
 arch/arm64/kernel/sys32.S               |    7 --
 arch/avr32/include/asm/unistd.h         |    8 --
 arch/blackfin/include/asm/unistd.h      |    8 --
 arch/cris/include/asm/unistd.h          |    8 --
 arch/frv/include/asm/unistd.h           |   10 --
 arch/h8300/include/asm/linkage.h        |    2 -
 arch/h8300/include/asm/unistd.h         |    7 --
 arch/ia64/include/asm/linkage.h         |    4 +
 arch/ia64/include/asm/unistd.h          |   10 --
 arch/m32r/include/asm/unistd.h          |   10 --
 arch/m68k/include/asm/unistd.h          |    8 --
 arch/microblaze/include/asm/unistd.h    |    8 --
 arch/mips/Kconfig                       |    1 -
 arch/mips/include/asm/linkage.h         |    3 +
 arch/mips/include/asm/unistd.h          |    8 --
 arch/mips/kernel/linux32.c              |  119 ---------------------
 arch/mips/kernel/scall64-n32.S          |    8 +-
 arch/mips/kernel/scall64-o32.S          |    6 +-
 arch/mn10300/include/asm/unistd.h       |   10 --
 arch/parisc/include/asm/unistd.h        |    8 --
 arch/parisc/kernel/sys_parisc32.c       |   41 -------
 arch/parisc/kernel/syscall_table.S      |    8 +-
 arch/powerpc/Kconfig                    |    1 -
 arch/powerpc/include/asm/linkage.h      |   13 +++
 arch/powerpc/include/asm/systbl.h       |   10 +-
 arch/powerpc/include/asm/unistd.h       |    6 -
 arch/powerpc/include/uapi/asm/linkage.h |    6 -
 arch/powerpc/kernel/sys_ppc32.c         |  109 -------------------
 arch/s390/Kconfig                       |    1 -
 arch/s390/include/asm/unistd.h          |    8 --
 arch/s390/kernel/compat_linux.c         |   86 +---------------
 arch/s390/kernel/compat_linux.h         |    5 -
 arch/s390/kernel/compat_wrapper.S       |   64 -----------
 arch/s390/kernel/sys_s390.c             |   14 +--
 arch/s390/kernel/syscalls.S             |   18 ++--
 arch/sh/include/asm/unistd.h            |    8 --
 arch/sparc/Kconfig                      |    1 -
 arch/sparc/include/asm/unistd.h         |    8 --
 arch/sparc/kernel/sys32.S               |    4 -
 arch/sparc/kernel/sys_sparc32.c         |   75 +-------------
 arch/sparc/kernel/sys_sparc_64.c        |    6 +-
 arch/sparc/kernel/systbls_64.S          |    8 +-
 arch/tile/Kconfig                       |    1 -
 arch/tile/kernel/compat.c               |    5 -
 arch/x86/ia32/Makefile                  |    3 -
 arch/x86/ia32/ipc32.c                   |   54 ----------
 arch/x86/ia32/sys_ia32.c                |   37 -------
 arch/x86/include/asm/sys_ia32.h         |   12 --
 arch/x86/include/asm/syscalls.h         |    4 +-
 arch/x86/include/asm/unistd.h           |    8 --
 arch/x86/kernel/tls.c                   |   14 +--
 arch/x86/syscalls/syscall_32.tbl        |   10 +-
 arch/x86/um/tls_32.c                    |    5 +-
 arch/xtensa/include/asm/unistd.h        |    8 --
 fs/aio.c                                |    2 -
 fs/compat.c                             |  121 ---------------------
 fs/dcookies.c                           |   15 ++-
 fs/eventpoll.c                          |   47 ++++++++
 fs/notify/fanotify/fanotify_user.c      |   17 +---
 fs/open.c                               |   52 ++--------
 fs/read_write.c                         |   68 ++++++++----
 fs/read_write.h                         |    2 -
 fs/signalfd.c                           |   31 ++++++
 fs/splice.c                             |   22 ++++
 fs/sync.c                               |   26 +----
 include/asm-generic/unistd.h            |   17 ---
 include/linux/compat.h                  |   51 +++-------
 include/linux/linkage.h                 |   21 ++++
 include/linux/mm.h                      |    3 -
 include/linux/syscalls.h                |  156 +++++++++-------------------
 ipc/compat.c                            |  174 +++++++++++++++++--------------
 ipc/sem.c                               |  123 ++++++++++++++--------
 ipc/syscall.c                           |    6 +-
 kernel/compat.c                         |   19 ----
 kernel/exit.c                           |    5 -
 kernel/fork.c                           |    5 +-
 kernel/sys.c                            |   14 +++
 kernel/sys_ni.c                         |    3 +-
 kernel/uid16.c                          |   55 ++--------
 mm/fadvise.c                            |   18 +---
 mm/nommu.c                              |    3 +-
 mm/readahead.c                          |    9 +--
 87 files changed, 539 insertions(+), 1488 deletions(-)
 create mode 100644 arch/powerpc/include/asm/linkage.h
 delete mode 100644 arch/powerpc/include/uapi/asm/linkage.h
 delete mode 100644 arch/x86/ia32/ipc32.c

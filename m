Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab3EJGTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 02:19:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35400 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3EJGTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 02:19:09 -0400
Date: Fri, 10 May 2013 07:19:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] stray signal.git bits
Message-ID: <20130510061907.GK25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several syscall-related commits that were missing from the original
pull request.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus
Shortlog:
Al Viro (3):
      unify compat fanotify_mark(2), switch to COMPAT_SYSCALL_DEFINE
      unicore32: just use mmap_pgoff()...
      switch compat_sys_sysctl to COMPAT_SYSCALL_DEFINE

Alexander van Heukelum (1):
      x86, vm86: fix VM86 syscalls: use SYSCALL_DEFINEx(...)

Diffstat:
 arch/arm64/include/asm/unistd32.h  |    2 +-
 arch/arm64/kernel/sys32.S          |    7 ------
 arch/mips/kernel/linux32.c         |    7 ------
 arch/mips/kernel/scall64-o32.S     |    2 +-
 arch/parisc/kernel/sys_parisc32.c  |    8 -------
 arch/powerpc/kernel/sys_ppc32.c    |    8 -------
 arch/s390/kernel/compat_wrapper.S  |   13 ------------
 arch/s390/kernel/syscalls.S        |    4 +-
 arch/sparc/kernel/sys32.S          |    9 --------
 arch/sparc/kernel/systbls_64.S     |    2 +-
 arch/unicore32/kernel/sys.c        |   10 +--------
 arch/x86/ia32/sys_ia32.c           |    9 --------
 arch/x86/include/asm/sys_ia32.h    |    3 --
 arch/x86/include/asm/syscalls.h    |    4 +-
 arch/x86/kernel/vm86_32.c          |   38 +++++++++++++----------------------
 arch/x86/syscalls/syscall_32.tbl   |    2 +-
 fs/notify/fanotify/fanotify_user.c |   17 ++++++++++++++++
 include/linux/compat.h             |    2 +
 kernel/sys_ni.c                    |    1 +
 kernel/sysctl_binary.c             |    4 +-
 20 files changed, 45 insertions(+), 107 deletions(-)

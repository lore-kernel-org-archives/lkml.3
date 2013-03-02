Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3CBPMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 10:12:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56939 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3CBPMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 10:12:38 -0500
Date: Sat, 2 Mar 2013 15:12:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [git pull] signal.git fixes
Message-ID: <20130302151237.GA4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes for several regressions introduced in the last signal.git pile,
along with fixing bugs in truncate and ftruncate compat (on just about
anything biarch at least one of those two had been done wrong).

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (4):
      lseek() and truncate() on sparc really need sign extension
      switch lseek to COMPAT_SYSCALL_DEFINE
      fix compat truncate/ftruncate
      [regression] braino in "sparc: convert to ksignal"

Heiko Carstens (1):
      compat: restore timerfd settime and gettime compat syscalls

Diffstat:
 arch/arm64/include/asm/unistd32.h  |    6 +++---
 arch/arm64/kernel/sys32.S          |    5 -----
 arch/mips/kernel/scall64-o32.S     |    4 ++--
 arch/parisc/kernel/sys_parisc32.c  |   10 ----------
 arch/parisc/kernel/syscall_table.S |    6 +++---
 arch/powerpc/include/asm/systbl.h  |    2 +-
 arch/powerpc/kernel/sys_ppc32.c    |   18 ------------------
 arch/s390/kernel/compat_wrapper.S  |   16 ----------------
 arch/s390/kernel/syscalls.S        |    6 +++---
 arch/sparc/kernel/signal32.c       |    2 +-
 arch/sparc/kernel/systbls_64.S     |    6 +++---
 arch/x86/ia32/sys_ia32.c           |    5 -----
 arch/x86/include/asm/sys_ia32.h    |    1 -
 arch/x86/syscalls/syscall_32.tbl   |    6 +++---
 fs/open.c                          |   15 +++++++++++++++
 fs/read_write.c                    |    9 ++++++++-
 fs/timerfd.c                       |   10 +++++-----
 include/linux/compat.h             |    3 +++
 18 files changed, 50 insertions(+), 80 deletions(-)

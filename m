Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab3IEUop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:44:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43100 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab3IEUom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:44:42 -0400
Date: Thu, 05 Sep 2013 16:44:40 -0400 (EDT)
Message-Id: <20130905.164440.1477153216318239054.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 13:44:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several bug fixes (from Kirill Tkhai, Geery Uytterhoeven, and Alexey
Dobriyan) and some support for Fujitsu sparc64x chips (from Allen
Pais).

Please pull, thanks a lot!

The following changes since commit 64ccccf8525fee499625b517c0faadf784c79e93:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-07-31 17:55:12 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to dc76f9ca71ea597dbb0e9c77d1072ddca651f4f3:

  sparc64: Export flush_ptrace_access() (needed by lustre) (2013-09-05 12:12:51 -0700)

----------------------------------------------------------------
Alexey Dobriyan (1):
      sparc: fix PCI device proc file mmap(2)

Allen Pais (2):
      cpu hw caps support for sparc64x
      support sparc64x chip type in cpumap.c

David S. Miller (2):
      esp_scsi: Fix tag state corruption when autosensing.
      sparc64: Fix off by one in trampoline TLB mapping installation loop.

Geert Uytterhoeven (1):
      sparc64: Export flush_ptrace_access() (needed by lustre)

Kirill Tkhai (6):
      sparc64: Fix wrong syscall return value passed to trace_sys_exit()
      sparc32: Fix exit flag passed from traced sys_sigreturn
      sparc64: cleanup: Rename ret_from_syscall to ret_from_fork
      sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
      sparc64: Fix ITLB handler of null page
      sparc64: Remove RWSEM export leftovers

 arch/sparc/include/asm/switch_to_64.h |  4 ++--
 arch/sparc/kernel/cpumap.c            |  1 +
 arch/sparc/kernel/entry.S             |  2 +-
 arch/sparc/kernel/kgdb_64.c           |  4 ++--
 arch/sparc/kernel/ktlb.S              |  3 +--
 arch/sparc/kernel/ptrace_64.c         |  4 +++-
 arch/sparc/kernel/setup_64.c          | 12 ++++++++----
 arch/sparc/kernel/syscalls.S          | 12 ++++++------
 arch/sparc/kernel/trampoline_64.S     |  2 --
 arch/sparc/lib/ksyms.c                |  9 ---------
 drivers/scsi/esp_scsi.c               | 14 ++++++++------
 drivers/scsi/esp_scsi.h               |  1 +
 fs/proc/inode.c                       | 16 ++++++++++++++++
 13 files changed, 49 insertions(+), 35 deletions(-)

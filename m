Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbaBAUX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 15:23:26 -0500
Received: from mout.gmx.net ([212.227.17.20]:60142 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbaBAUXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 15:23:24 -0500
Date: Sat, 1 Feb 2014 21:23:20 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.14
Message-ID: <20140201202320.GA1313@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:LGdtMVrYEaLgIhzCloxxGroPec5uT8EHBCT/LuO7J73wbkTuJjZ
 FicRE1RLozP4r96Y/6ZswhQaqLajxU5FNfsBWRhpBZPyfHwcCZHU1ccqWrfB+KF4izaDb2Y
 8aQxJZ9Z5nJ/krA/D6TYl7L7bOw139+TSSrHZLxmqRLN5frSVH4b9mHVmuEXISyunEHxP5a
 /knrOx2SbieBJ3bG/038w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the latest updates for the parisc architecture from:

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-for-3.14

The three major changes in this patchset is a implementation for flexible
userspace memory maps, cache-flushing fixes (again), and a long-discussed ABI
change to make EWOULDBLOCK the same value as EAGAIN.

parisc has been the only platform where we had EWOULDBLOCK != EAGAIN to keep
HP-UX compatibility.  Since we will probably never implement full HP-UX
support, we prefer to drop this compatibility to make it easier for us with
Linux userspace programs which mostly never checked for both values.  We don't
expect major fall-outs because of this change, and if we face some, we will
simply rebuild the necessary applications in the debian archives.

The change to fs/exec.c only touches code which affects parisc since it's
inside a #ifdef CONFIG_STACK_GROWSUP section (and parisc is the only platform
where the stack grows upwards).

Thanks,
Helge

----------------------------------------------------------------
Guy Martin (1):
      parisc: Make EWOULDBLOCK be equal to EAGAIN on parisc

Helge Deller (5):
      parisc/sti_console: prefer Linux fonts over built-in ROM fonts
      parisc: fix cache-flushing
      parisc: add flexible mmap memory layout support
      parisc: wire up sched_setattr and sched_getattr
      parisc: convert uapi/asm/stat.h to use native types only

 arch/parisc/include/asm/cacheflush.h  |   2 -
 arch/parisc/include/asm/elf.h         |   7 +
 arch/parisc/include/asm/page.h        |   3 +-
 arch/parisc/include/asm/pgtable.h     |   1 +
 arch/parisc/include/asm/processor.h   |   2 +
 arch/parisc/include/asm/thread_info.h |  10 ++
 arch/parisc/include/uapi/asm/errno.h  |   2 +-
 arch/parisc/include/uapi/asm/stat.h   |  40 +++---
 arch/parisc/include/uapi/asm/unistd.h |   4 +-
 arch/parisc/kernel/cache.c            |  14 ++
 arch/parisc/kernel/process.c          |  21 ++-
 arch/parisc/kernel/sys_parisc.c       | 238 ++++++++++++++++++++++++++++------
 arch/parisc/kernel/syscall_table.S    |   2 +
 drivers/video/console/sticore.c       |   2 +-
 fs/exec.c                             |   3 +
 lib/fonts/Kconfig                     |   6 +-
 16 files changed, 284 insertions(+), 73 deletions(-)

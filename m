Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab3EECmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 22:42:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35189 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3EECmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 22:42:09 -0400
Date: Sat, 04 May 2013 22:42:05 -0400 (EDT)
Message-Id: <20130504.224205.2294366573830292333.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 04 May 2013 19:42:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Hibernation support, as well as removal of excess interrupt
   twiddling in MMU context allocation on sparc64 from Kirill Tkhai.

2) Kill references to __ARCH_WANT_UNLOCKED_CTXSW.

3) Sparc32 LEON bug fixes from Daniel Hellstrom and Andreas Larsson.

4) Provide cmpxchg64(), from Geert Uytterhoeven.

5) Device refcount and registry bug fixes from Federico Vaga
   and Wei Yongjun.

Please pull, thanks a lot!

The following changes since commit 150a8dcf109f68f322bf112c7604f2d950303f00:

  Merge tag 'boards-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2013-05-04 12:34:30 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next.git master

for you to fetch changes up to 048c9acca90ca7da42b92745445fe008a48add88:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2013-05-04 18:34:13 -0700)

----------------------------------------------------------------

Andreas Larsson (1):
      sparc32, leon: Do not overwrite previously set irq flow handlers

Daniel Hellstrom (3):
      sparc32,leon: add support for PCI busn resource for GRPCI2
      sparc,leon: support for GRPCI1 PCI host bridge controller
      sparc,leon: updated GRPCI2 config name

David S. Miller (3):
      sparc64: Kill __ARCH_WANT_UNLOCKED_CTXSW
      sparc: Consistently use 'wr' and 'rd' instructions for ASRs.
      Merge git://git.kernel.org/.../davem/sparc

Federico Vaga (1):
      sparc/kernel/vio.c: add put_device() after device_find_child()

Geert Uytterhoeven (1):
      sparc64: Provide cmpxchg64()

Kirill Tkhai (1):
      sparc64: Do not save/restore interrupts in get_new_mmu_context()

Tkhai Kirill (2):
      sparc64: Hibernation support
      sparc64: Do not change num_physpages during initmem freeing

Wei Yongjun (1):
      serial: sunsu: add missing platform_driver_unregister() when module exit

 arch/sparc/Kconfig                      |  20 +-
 arch/sparc/Makefile                     |   1 +
 arch/sparc/include/asm/cmpxchg_64.h     |   1 +
 arch/sparc/include/asm/head_32.h        |   6 +-
 arch/sparc/include/asm/hibernate.h      |  23 +++
 arch/sparc/include/asm/leon_pci.h       |   1 +
 arch/sparc/include/asm/mmu_context_64.h |   2 +-
 arch/sparc/include/asm/processor_64.h   |   3 -
 arch/sparc/kernel/Makefile              |   3 +-
 arch/sparc/kernel/asm-offsets.c         |  15 ++
 arch/sparc/kernel/leon_kernel.c         |  10 +-
 arch/sparc/kernel/leon_pci.c            |   2 +
 arch/sparc/kernel/leon_pci_grpci1.c     | 724 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/sparc/kernel/leon_pci_grpci2.c     |   5 +
 arch/sparc/kernel/leon_pmc.c            |   4 +-
 arch/sparc/kernel/vio.c                 |   1 +
 arch/sparc/mm/init_64.c                 |   7 +-
 arch/sparc/power/Makefile               |   3 +
 arch/sparc/power/hibernate.c            |  42 +++++
 arch/sparc/power/hibernate_asm.S        | 131 +++++++++++++
 drivers/tty/serial/sunsu.c              |   1 +
 21 files changed, 986 insertions(+), 19 deletions(-)
 create mode 100644 arch/sparc/include/asm/hibernate.h
 create mode 100644 arch/sparc/kernel/leon_pci_grpci1.c
 create mode 100644 arch/sparc/power/Makefile
 create mode 100644 arch/sparc/power/hibernate.c
 create mode 100644 arch/sparc/power/hibernate_asm.S

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaFYGNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:13:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:45714 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbaFYGNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:13:38 -0400
Message-ID: <1403676803.4587.204.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2014 16:13:23 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a handful or two of powerpc fixes and simple/trivial
cleanups. A bunch of them fix ftrace with the new ABI v2 in
Little Endian, the rest is a scattering of fairly simple things.

Cheers,
Ben.

The following changes since commit 68986c9f0f4552c34c248501eb0c690553866d6e:

  Revert "offb: Add palette hack for little endian" (2014-06-16 19:45:45 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 6663a4fa6711050036562ddfd2086edf735fae21:

  powerpc: Don't skip ePAPR spin-table CPUs (2014-06-25 13:10:49 +1000)

----------------------------------------------------------------
Benjamin Herrenschmidt (1):
      powerpc: Remove __arch_swab*

Catalin Marinas (1):
      powerpc/kmemleak: Do not scan the DART table

Gavin Shan (1):
      powerpc/kerenl: Enable EEH for IO accessors

Laurent Dufour (1):
      powerpc/module: Fix TOC symbol CRC

Michael Ellerman (9):
      powerpc: Remove ancient DEBUG_SIG code
      powerpc: Add ppc_global_function_entry()
      powerpc/ftrace: Fix typo in mask of opcode
      powerpc/ftrace: Fix inverted check of create_branch()
      powerpc/ftrace: Fix nop of modules on 64bit LE (ABIv2)
      powerpc/ftrace: Use pr_fmt() to namespace error messages
      powerpc/kprobes: Fix jprobes on ABI v2 (LE)
      selftests/powerpc: Use the test harness for the TM DSCR test
      powerpc/powernv: Remove OPAL v1 takeover

Rasmus Villemoes (1):
      powerpc/macintosh/smu.c: Fix closing brace followed by if

Rickard Strandqvist (1):
      powerpc/cell: cbe_thermal.c: Cleaning up a variable is of the wrong type

Scott Wood (1):
      powerpc: Don't skip ePAPR spin-table CPUs

 arch/powerpc/Kconfig.debug                         |   1 -
 arch/powerpc/include/asm/code-patching.h           |  11 ++
 arch/powerpc/include/asm/opal.h                    |  29 ---
 arch/powerpc/include/asm/swab.h                    |  43 -----
 arch/powerpc/kernel/ftrace.c                       |  52 +++--
 arch/powerpc/kernel/iomap.c                        |  20 +-
 arch/powerpc/kernel/kprobes.c                      |   9 +-
 arch/powerpc/kernel/module_64.c                    |  11 +-
 arch/powerpc/kernel/prom.c                         |   7 -
 arch/powerpc/kernel/prom_init.c                    | 211 ---------------------
 arch/powerpc/kernel/prom_init_check.sh             |   4 +-
 arch/powerpc/kernel/setup-common.c                 |  10 +-
 arch/powerpc/kernel/signal_32.c                    |   9 -
 arch/powerpc/kernel/signal_64.c                    |   9 -
 arch/powerpc/platforms/cell/cbe_thermal.c          |   2 +-
 arch/powerpc/platforms/powernv/Makefile            |   2 +-
 arch/powerpc/platforms/powernv/opal-takeover.S     | 140 --------------
 arch/powerpc/sysdev/dart_iommu.c                   |   5 +
 drivers/macintosh/smu.c                            |   3 +-
 tools/testing/selftests/powerpc/tm/Makefile        |   2 +-
 .../testing/selftests/powerpc/tm/tm-resched-dscr.c |  14 +-
 21 files changed, 93 insertions(+), 501 deletions(-)
 delete mode 100644 arch/powerpc/platforms/powernv/opal-takeover.S



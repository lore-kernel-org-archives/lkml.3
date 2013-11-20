Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3KTXKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:10:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:43675 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab3KTXKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:10:32 -0500
Message-ID: <1384989013.26969.115.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 21 Nov 2013 10:10:13 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

With my previous pull request I mentioned some remaining Little Endian
patches, notably support for our new ABI, which I was sitting on making
sure it was all finalized.

The toolchain folks confirmed it now, the new ABI is stable and merged
with gcc, so we are all good. Oh and we actually missed the actual
Kconfig switch for LE so here it is, along with a couple more bug fixes.

I have more fixes but not related to LE so I'll send them as a separate
pull request tomorrow, let's get this one out of the way.

Note that this supports running user space binaries using the new ABI,
but the kernel itself still needs to be built with the old one. We'll
bring fixes for that after -rc1.

Here's Anton log that goes with this series:

<<<
This patch series adds support for the new ABI, LPAR support
for H_SET_MODE and finally adds a kconfig option and defconfig.

ABIv2 support was recently committed to binutils and gcc, and
should be merged into glibc soon. There are a number of
very nice improvements including the removal of function
descriptors. Rusty's kernel patches allow binaries of either
ABI to work, easing the transition.
>>>

Cheers,
Ben.

The following changes since commit 0c4888ef1d8a8b82c29075ce7e257ff795af15c7:

  powerpc: Fix fatal SLB miss when restoring PPR (2013-11-06 14:13:53 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 280270828f108be56f0c486def58acabb070244f:

  powerpc: Wrong DWARF CFI in the kernel vdso for little-endian / ELFv2 (2013-11-21 09:19:23 +1100)

----------------------------------------------------------------
Alistair Popple (1):
      powerpc: Don't use ELFv2 ABI to build the kernel

Anton Blanchard (4):
      powerpc/pseries: Fix endian issues in pseries EEH code
      pseries: Add H_SET_MODE to change exception endianness
      powerpc: Add CONFIG_CPU_LITTLE_ENDIAN kernel config option.
      powerpc: Add pseries_le_defconfig

Rusty Russell (4):
      powerpc: Add TIF_ELF2ABI flag.
      powerpc: Set eflags correctly for ELF ABIv2 core dumps.
      powerpc: ELF2 binaries launched directly.
      powerpc: ELF2 binaries signal handling

Ulrich Weigand (1):
      powerpc: Wrong DWARF CFI in the kernel vdso for little-endian / ELFv2

 arch/powerpc/Makefile                        |   1 +
 arch/powerpc/configs/pseries_le_defconfig    | 352 +++++++++++++++++++++++++++
 arch/powerpc/include/asm/elf.h               |   4 +
 arch/powerpc/include/asm/hvcall.h            |   2 +
 arch/powerpc/include/asm/plpar_wrappers.h    |  26 ++
 arch/powerpc/include/asm/thread_info.h       |   9 +
 arch/powerpc/kernel/process.c                |  50 ++--
 arch/powerpc/kernel/signal_64.c              |  25 +-
 arch/powerpc/kernel/vdso64/sigtramp.S        |  16 +-
 arch/powerpc/platforms/Kconfig.cputype       |  11 +
 arch/powerpc/platforms/pseries/eeh_pseries.c |  21 +-
 arch/powerpc/platforms/pseries/lpar.c        |  17 ++
 arch/powerpc/platforms/pseries/setup.c       |  42 ++++
 13 files changed, 542 insertions(+), 34 deletions(-)
 create mode 100644 arch/powerpc/configs/pseries_le_defconfig




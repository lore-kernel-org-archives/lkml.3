Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaLIWCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:02:03 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:62512 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaLIWCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:02:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: will.deacon@arm.com, thierry.reding@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org
Subject: [GIT PULL] asm-generic: asm/io.h rewrite
Date: Tue, 09 Dec 2014 23:01:03 +0100
Message-ID: <4703362.Atfd0HgCCK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:0qll1MbQ82oR0UXWmgVT+rL2W3JtKWe8y3WHoc6yBlml34+Yr+9
 WX2kghlQkpc9H/Nt3ypPbd6UoW4HD1n4Nqaebf11rLN1+/0zkZE0NAxhcVvUmmtnldiMGvB
 /YQ7Lm0VhzL2PDLIubM1K4HBDIve0KLRtAuNVu+98/EVcyA0XbTx2OfmawLQanC2yZrrJuy
 DC1ZezChkx4Mt0QoSqmJQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git tags/asm-generic-for-linus

for you to fetch changes up to cb61f6769b8836081940ba26249f1b756400c7df:

  ARM64: use GENERIC_PCI_IOMAP (2014-11-19 14:09:07 +0100)

----------------------------------------------------------------
asm-generic: asm/io.h rewrite

While there normally is no reason to have a pull request for asm-generic
but have all changes get merged through whichever tree needs them, I do
have a series for 3.19. There are two sets of patches that change
significant portions of asm/io.h, and this branch contains both in order
to resolve the conflicts:

- Will Deacon has done a set of patches to ensure that all architectures
  define {read,write}{b,w,l,q}_relaxed() functions or get them by
  including asm-generic/io.h. These functions are commonly used on ARM
  specific drivers to avoid expensive L2 cache synchronization implied by
  the normal {read,write}{b,w,l,q}, but we need to define them on all
  architectures in order to share the drivers across architectures and
  to enable CONFIG_COMPILE_TEST configurations for them

- Thierry Reding has done an unrelated set of patches that extends
  the asm-generic/io.h file to the degree necessary to make it useful
  on ARM64 and potentially other architectures.

----------------------------------------------------------------
Arnd Bergmann (5):
      ARM: ixp4xx: Fix build with IXP4XX_INDIRECT_PCI
      Merge branch 'asm-generic-io' of https://github.com/thierryreding/linux into asm-generic
      Merge branch 'io' of git://git.kernel.org/.../will/linux into asm-generic
      sparc: io: remove duplicate relaxed accessors on sparc32
      ARM64: use GENERIC_PCI_IOMAP

Thierry Reding (10):
      ARC: Remove redundant PCI_IOBASE declaration
      ARM: ebsa110: Properly override I/O accessors
      ARM: ixp4xx: Properly override I/O accessors
      Change xlate_dev_{kmem,mem}_ptr() prototypes
      /dev/mem: Use more consistent data types
      asm-generic/io.h: Reconcile I/O accessor overrides
      asm-generic/io.h: Implement generic {read,write}s*()
      ARM: Use include/asm-generic/io.h
      arm64: Use include/asm-generic/io.h
      ARM: sa11x0: Use void __iomem * in MMIO accessors

Will Deacon (16):
      asm-generic: io: implement relaxed accessor macros as conditional wrappers
      microblaze: io: remove dummy relaxed accessor macros
      s390: io: remove dummy relaxed accessor macros for reads
      xtensa: io: remove dummy relaxed accessor macros for reads
      frv: io: implement dummy relaxed accessor macros for writes
      cris: io: implement dummy relaxed accessor macros for writes
      ia64: io: implement dummy relaxed accessor macros for writes
      m32r: io: implement dummy relaxed accessor macros for writes
      m68k: io: implement dummy relaxed accessor macros for writes
      mn10300: io: implement dummy relaxed accessor macros for writes
      parisc: io: implement dummy relaxed accessor macros for writes
      powerpc: io: implement dummy relaxed accessor macros for writes
      sparc: io: implement dummy relaxed accessor macros for writes
      tile: io: implement dummy relaxed accessor macros for writes
      x86: io: implement dummy relaxed accessor macros for writes
      documentation: memory-barriers: clarify relaxed io accessor semantics

 Documentation/memory-barriers.txt       |  13 +-
 arch/arc/include/asm/io.h               |   2 -
 arch/arm/include/asm/io.h               |  89 ++--
 arch/arm/include/asm/memory.h           |   4 +
 arch/arm/mach-ebsa110/include/mach/io.h |  25 +-
 arch/arm/mach-ebsa110/io.c              |  14 +-
 arch/arm/mach-ixp4xx/common.c           |   2 +-
 arch/arm/mach-ixp4xx/include/mach/io.h  |  28 +-
 arch/arm/mach-sa1100/pci-nanoengine.c   |   8 +-
 arch/arm64/Kconfig                      |   2 +-
 arch/arm64/include/asm/io.h             | 122 ++----
 arch/arm64/include/asm/memory.h         |   2 +
 arch/cris/include/asm/io.h              |   3 +
 arch/frv/include/asm/io.h               |   3 +
 arch/ia64/include/asm/io.h              |   4 +
 arch/ia64/include/asm/uaccess.h         |  16 +-
 arch/m32r/include/asm/io.h              |   3 +
 arch/m68k/include/asm/io.h              |   8 +
 arch/m68k/include/asm/io_no.h           |   4 -
 arch/microblaze/include/asm/io.h        |   8 -
 arch/mn10300/include/asm/io.h           |   4 +
 arch/parisc/include/asm/io.h            |  12 +-
 arch/powerpc/include/asm/io.h           |  12 +-
 arch/s390/include/asm/io.h              |  10 +-
 arch/s390/mm/maccess.c                  |   4 +-
 arch/sparc/include/asm/io_32.h          |   4 -
 arch/sparc/include/asm/io_64.h          |  14 +-
 arch/tile/include/asm/io.h              |   4 +
 arch/x86/include/asm/io.h               |   8 +-
 arch/x86/mm/ioremap.c                   |   4 +-
 arch/xtensa/include/asm/io.h            |   7 -
 drivers/char/mem.c                      |  13 +-
 include/asm-generic/io.h                | 751 ++++++++++++++++++++++++++------
 33 files changed, 837 insertions(+), 370 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab3K0CaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:30:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:58321 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab3K0CaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:30:21 -0500
Message-ID: <1385519408.9218.88.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 27 Nov 2013 13:30:08 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few powerpc bug fixes post -rc1. The main thing that caused
problem was that CONFIG_CPU_LITTLE_ENDIAN got turned on with allyesconfig
and such, which is not a very good idea especially since it requires a
newer toolchain than what most people have. So we turned it into a
choice instead that defaults to big endian.

Cheers,
Ben.

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 721cb59e9d95eb7f47ec73711ed35ef85e1ea1ca:

  powerpc/windfarm: Fix XServe G5 fan control Makefile issue (2013-11-27 11:35:47 +1100)

----------------------------------------------------------------
Adam Borowski (1):
      powerpc/85xx: typo in dts: "interupt" (four devices)

Anton Blanchard (1):
      powerpc: allyesconfig should not select CONFIG_CPU_LITTLE_ENDIAN

Benjamin Herrenschmidt (2):
      Merge remote-tracking branch 'scott/master' into merge
      powerpc/windfarm: Fix XServe G5 fan control Makefile issue

Chen Gang (1):
      arch/powerpc/kernel: Use %12.12s instead of %12s to avoid memory overflow

Hari Bathini (1):
      powerpc/kdump: Adding symbols in vmcoreinfo to facilitate dump filtering

LEROY Christophe (1):
      powerpc/8xx: mfspr SPRN_TBRx in lieu of mftb/mftbu is not supported

Michael Neuling (2):
      powerpc: Fix error when cross building TAGS & cscope
      powerpc/signals: Improved mark VSX not saved with small contexts fix

Scott Wood (1):
      powerpc/booke: Only check for hugetlb in flush if vma != NULL

Tiejun Chen (1):
      powerpc/corenet64: compile with CONFIG_E{5,6}500_CPU well

 arch/powerpc/Makefile                     |  7 +++++++
 arch/powerpc/boot/dts/xcalibur1501.dts    |  4 ++--
 arch/powerpc/boot/dts/xpedite5301.dts     |  4 ++--
 arch/powerpc/boot/dts/xpedite5330.dts     |  4 ++--
 arch/powerpc/boot/dts/xpedite5370.dts     |  4 ++--
 arch/powerpc/boot/util.S                  | 14 ++++++++++++++
 arch/powerpc/include/asm/pgalloc-64.h     |  1 +
 arch/powerpc/include/asm/ppc_asm.h        |  2 ++
 arch/powerpc/include/asm/reg.h            |  7 +++++++
 arch/powerpc/include/asm/timex.h          |  8 ++++++++
 arch/powerpc/kernel/machine_kexec.c       | 12 ++++++++++++
 arch/powerpc/kernel/nvram_64.c            |  2 +-
 arch/powerpc/kernel/signal_32.c           | 16 +++++++---------
 arch/powerpc/kernel/signal_64.c           |  6 ++++++
 arch/powerpc/kernel/vdso32/gettimeofday.S |  6 ++++++
 arch/powerpc/mm/hugetlbpage-book3e.c      |  3 +--
 arch/powerpc/mm/tlb_nohash.c              |  2 +-
 arch/powerpc/platforms/Kconfig.cputype    | 20 +++++++++++++++++---
 drivers/macintosh/Makefile                |  1 +
 19 files changed, 99 insertions(+), 24 deletions(-)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaGKFog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 01:44:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:53056 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaGKFof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 01:44:35 -0400
Message-ID: <1405057463.20996.32.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 11 Jul 2014 15:44:23 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few more powerpc fixes for 3.16

There's a small series of 3 patches that fix saving/restoring MMUCR2
when using KVM without which perf goes completely bonkers in the host
system. Another perf fix from Anton that's been rotting away in patchwork
due to my poor eyesight, a couple of compile fixes, a little addition
to the WSP removal by Michael (removing a bit more dead stuff) and
a fix for an embarassing regression with our soft irq masking.

Cheers,
Ben.

The following changes since commit 6663a4fa6711050036562ddfd2086edf735fae21:

  powerpc: Don't skip ePAPR spin-table CPUs (2014-06-25 13:10:49 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to f56029410a13cae3652d1f34788045c40a13ffc7:

  powerpc/perf: Never program book3s PMCs with values >= 0x80000000 (2014-07-11 13:50:47 +1000)

----------------------------------------------------------------
Anton Blanchard (1):
      powerpc/perf: Never program book3s PMCs with values >= 0x80000000

Guenter Roeck (1):
      powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64

Joel Stanley (3):
      powerpc/kvm: Remove redundant save of SIER AND MMCR2
      powerpc/perf: Add PPMU_ARCH_207S define
      powerpc/perf: Clear MMCR2 when enabling PMU

Michael Ellerman (2):
      powerpc/cell: Fix compilation with CONFIG_COREDUMP=n
      powerpc: Clean up MMU_FTRS_A2 and MMU_FTR_TYPE_3E

Preeti U Murthy (1):
      powerpc/powernv: Check for IRQHAPPENED before sleeping

 arch/powerpc/Kconfig                         |  3 ++-
 arch/powerpc/include/asm/mmu.h               | 10 +---------
 arch/powerpc/include/asm/perf_event_server.h |  3 +--
 arch/powerpc/kernel/idle_power7.S            |  2 +-
 arch/powerpc/kvm/book3s_hv_interrupts.S      |  5 -----
 arch/powerpc/mm/mmu_context_nohash.c         | 12 +-----------
 arch/powerpc/perf/core-book3s.c              | 26 ++++++++++++++++++++++----
 arch/powerpc/perf/power8-pmu.c               |  2 +-
 arch/powerpc/platforms/cell/spu_syscalls.c   |  2 ++
 arch/powerpc/platforms/cell/spufs/Makefile   |  3 ++-
 arch/powerpc/platforms/cell/spufs/syscalls.c |  6 ++++--
 11 files changed, 37 insertions(+), 37 deletions(-)



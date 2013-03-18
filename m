Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab3CRFSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:18:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:58471 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3CRFSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:18:02 -0400
Message-ID: <1363583869.21545.2.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 18 Mar 2013 06:17:49 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a few powerpc fixes for 3.9, mostly regressions (though not all
from 3.9 merge window) that we've been hammering into shape over the
last couple of weeks. They fix booting on Cell and G5 among other
things (yes, we've been a bit sloppy with older machines this time
around).

Cheers,
Ben.

The following changes since commit 7c6baa304b841673d3a55ea4fcf9a5cbf7a1674b:

  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-03-11 07:54:29 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to af81d7878c641629f2693ae3fdaf74b4af14dfca:

  powerpc: Rename USER_ESID_BITS* to ESID_BITS* (2013-03-17 12:45:44 +1100)

----------------------------------------------------------------
Aneesh Kumar K.V (3):
      powerpc: Make VSID_BITS* dependency explicit
      powerpc: Update kernel VSID range
      powerpc: Rename USER_ESID_BITS* to ESID_BITS*

Anton Blanchard (1):
      powerpc: Fix -mcmodel=medium breakage in prom_init.c

Benjamin Herrenschmidt (2):
      powerpc: Fix STAB initialization
      powerpc: Fix cputable entry for 970MP rev 1.0

Michael Neuling (1):
      powerpc/ptrace: Fix brk.len used uninitialised

Paul Bolle (1):
      powerpc: Remove last traces of POWER4_ONLY

Stephen Rothwell (1):
      powerpc: Make sure that we alays include CONFIG_BINFMT_ELF

 arch/powerpc/Kconfig                   |    1 +
 arch/powerpc/include/asm/mmu-hash64.h  |  128 ++++++++++++++++----------------
 arch/powerpc/kernel/cputable.c         |    2 +-
 arch/powerpc/kernel/exceptions-64s.S   |   34 ++++++---
 arch/powerpc/kernel/prom_init.c        |   14 ++--
 arch/powerpc/kernel/ptrace.c           |    1 +
 arch/powerpc/kvm/book3s_64_mmu_host.c  |    4 +-
 arch/powerpc/mm/hash_utils_64.c        |   22 ++++--
 arch/powerpc/mm/mmu_context_hash64.c   |   11 +--
 arch/powerpc/mm/pgtable_64.c           |    2 +-
 arch/powerpc/mm/slb_low.S              |   50 ++++++-------
 arch/powerpc/mm/tlb_hash64.c           |    2 +-
 arch/powerpc/platforms/Kconfig.cputype |    6 +-
 13 files changed, 150 insertions(+), 127 deletions(-)



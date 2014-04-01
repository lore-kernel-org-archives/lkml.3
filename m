Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaDARmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:42:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:53474 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaDARmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:42:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,774,1389772800"; 
   d="scan'208";a="484961602"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Fix up asmlinkage
Date: Tue,  1 Apr 2014 19:32:33 +0200
Message-Id: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by Linus, revert the "Add __visible to asmlinkage"
and replace it with explicit __visibles. This is roughly ~200
changes in a tree sweep. I separated the patches
into arch/x86, arch/x86/crypto and else. Right now it's only
x86, the MIPS and ARM ports of LTO will need to do that 
separately.

If you want to pull the changes are here. 

BTW with these patches we're just 3 patches away from a 
(slowly building, not fully optimized, but working) 
LTO build.


The following changes since commit 01d5f3b598b18a5035426c30801adf65822dbd0c:

  Merge branch 'for-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata (2014-03-31 15:27:37 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git tags/asmlinkage-for-linus

for you to fetch changes up to a61d70fece76c881b98a29507dcb0db1dd21abf3:

  asmlinkage: Add explicit __visible to drivers/*, lib/*, kernel/* (2014-04-01 19:20:56 +0200)

----------------------------------------------------------------
Andi Kleen (4):
      Revert "lto: Make asmlinkage __visible"
      asmlinkage, x86: Add explicit __visible to arch/x86/*
      asmlinkage, x86: Add explicit __visible to arch/x86/crypto/*
      asmlinkage: Add explicit __visible to drivers/*, lib/*, kernel/*

 arch/x86/boot/compressed/misc.c            |   2 +-
 arch/x86/crypto/aes_glue.c                 |   4 +-
 arch/x86/crypto/aesni-intel_glue.c         |  34 +++++-----
 arch/x86/crypto/blowfish_glue.c            |   8 +--
 arch/x86/crypto/camellia_aesni_avx2_glue.c |  12 ++--
 arch/x86/crypto/camellia_aesni_avx_glue.c  |  12 ++--
 arch/x86/crypto/camellia_glue.c            |   8 +--
 arch/x86/crypto/cast5_avx_glue.c           |   8 +--
 arch/x86/crypto/cast6_avx_glue.c           |  12 ++--
 arch/x86/crypto/crc32c-intel_glue.c        |   2 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c    |   2 +-
 arch/x86/crypto/salsa20_glue.c             |   6 +-
 arch/x86/crypto/serpent_avx2_glue.c        |  12 ++--
 arch/x86/crypto/serpent_avx_glue.c         |  12 ++--
 arch/x86/crypto/sha1_ssse3_glue.c          |   4 +-
 arch/x86/crypto/sha256_ssse3_glue.c        |   6 +-
 arch/x86/crypto/sha512_ssse3_glue.c        |   6 +-
 arch/x86/crypto/twofish_avx_glue.c         |  12 ++--
 arch/x86/crypto/twofish_glue.c             |   4 +-
 arch/x86/include/asm/crypto/camellia.h     |  20 +++---
 arch/x86/include/asm/crypto/serpent-avx.h  |  12 ++--
 arch/x86/include/asm/crypto/serpent-sse2.h |   8 +--
 arch/x86/include/asm/crypto/twofish.h      |   8 +--
 arch/x86/include/asm/hw_irq.h              | 102 ++++++++++++++---------------
 arch/x86/include/asm/kprobes.h             |   2 +-
 arch/x86/include/asm/kvm_host.h            |   2 +-
 arch/x86/include/asm/processor.h           |   2 +-
 arch/x86/include/asm/setup.h               |   6 +-
 arch/x86/include/asm/special_insns.h       |   2 +-
 arch/x86/include/asm/traps.h               |  56 ++++++++--------
 arch/x86/kernel/acpi/sleep.c               |   2 +-
 arch/x86/kernel/apic/io_apic.c             |   2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |   4 +-
 arch/x86/kernel/cpu/mcheck/threshold.c     |   4 +-
 arch/x86/kernel/head32.c                   |   2 +-
 arch/x86/kernel/head64.c                   |   2 +-
 arch/x86/kernel/process_32.c               |   4 +-
 arch/x86/kernel/process_64.c               |   4 +-
 arch/x86/kernel/smp.c                      |   2 +-
 arch/x86/kernel/traps.c                    |   8 +--
 arch/x86/kernel/vsmp_64.c                  |   6 +-
 arch/x86/kvm/x86.c                         |   2 +-
 arch/x86/lguest/boot.c                     |   4 +-
 arch/x86/math-emu/errors.c                 |  16 ++---
 arch/x86/platform/olpc/olpc-xo1-pm.c       |   2 +-
 arch/x86/power/hibernate_64.c              |   2 +-
 arch/x86/xen/enlighten.c                   |   2 +-
 arch/x86/xen/irq.c                         |   6 +-
 arch/x86/xen/setup.c                       |   2 +-
 drivers/pnp/pnpbios/bioscalls.c            |   2 +-
 include/linux/linkage.h                    |   4 +-
 init/main.c                                |   2 +-
 kernel/context_tracking.c                  |   2 +-
 kernel/locking/lockdep.c                   |   2 +-
 kernel/power/snapshot.c                    |   2 +-
 kernel/printk/printk.c                     |   4 +-
 kernel/sched/core.c                        |  10 +--
 kernel/softirq.c                           |   4 +-
 lib/dump_stack.c                           |   4 +-
 59 files changed, 249 insertions(+), 249 deletions(-)


-Andi


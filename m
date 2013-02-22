Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3BVE56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:57:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50967 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3BVE55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:57:57 -0500
Date: Thu, 21 Feb 2013 20:56:36 -0800
Message-Id: <201302220456.r1M4ua12006362@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/microcode for v3.9-rc1
Cc: Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Feb 2013 20:56:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patchset lets us update the CPU microcode very, very early in
initialization if the BIOS fails to do so (never happens, right?)
This is handy for dealing with things like the Atom erratum where we
have to run without PSE because microcode loading happens too late.

As I mentioned in the x86/mm push request it depends on that
infrastructure but it is otherwise a standalone feature.

----------------------------------------------------------------

The following changes since commit ac2cbab21f318e19bc176a7f38a120cec835220f:

  x86: Don't panic if can not alloc buffer for swiotlb (2013-01-29 19:36:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/microcode

for you to fetch changes up to da76f64e7eb28b718501d15c1b79af560b7ca4ea:

  x86/Kconfig: Make early microcode loading a configuration feature (2013-01-31 13:20:42 -0800)

----------------------------------------------------------------

Fenghua Yu (12):
      x86, doc: Documentation for early microcode loading
      x86/microcode_intel.h: Define functions and macros for early loading ucode
      x86/common.c: Make have_cpuid_p() a global function
      x86/common.c: load ucode in 64 bit or show loading ucode info in 32 bit on AP
      x86/microcode_core_early.c: Define interfaces for early loading ucode
      x86/microcode_intel_lib.c: Early update ucode on Intel's CPU
      x86/tlbflush.h: Define __native_flush_tlb_global_irq_disabled()
      x86/microcode_intel_early.c: Early update ucode on Intel's CPU
      x86/head_32.S: Early update ucode in 32-bit
      x86/head64.c: Early update ucode in 64-bit
      x86/mm/init.c: Copy ucode from initrd image to kernel memory
      x86/Kconfig: Make early microcode loading a configuration feature

 Documentation/x86/early-microcode.txt   |  43 ++
 arch/x86/Kconfig                        |  18 +
 arch/x86/include/asm/microcode.h        |  14 +
 arch/x86/include/asm/microcode_intel.h  |  85 ++++
 arch/x86/include/asm/processor.h        |   8 +
 arch/x86/include/asm/tlbflush.h         |  18 +-
 arch/x86/kernel/Makefile                |   3 +
 arch/x86/kernel/cpu/common.c            |  17 +-
 arch/x86/kernel/head64.c                |   6 +
 arch/x86/kernel/head_32.S               |  11 +
 arch/x86/kernel/microcode_core.c        |   7 +-
 arch/x86/kernel/microcode_core_early.c  |  76 +++
 arch/x86/kernel/microcode_intel.c       | 198 ++------
 arch/x86/kernel/microcode_intel_early.c | 796 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/microcode_intel_lib.c   | 174 +++++++
 arch/x86/mm/init.c                      |  10 +
 16 files changed, 1301 insertions(+), 183 deletions(-)

[full diff omitted due to length]


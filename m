Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab3K1Cpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:45:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758628Ab3K1Cpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:45:31 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        linux-arch@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 0/4] generic early_ioremap support
Date: Wed, 27 Nov 2013 21:44:35 -0500
Message-Id: <1385606679-30446-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series takes the common bits from the x86 early ioremap
implementation and creates a generic library which may be used by
other architectures. The early ioremap interfaces are intended for
situations where boot code needs to make temporary virtual mappings
before the normal ioremap interfaces are available. Typically, this
means before paging_init() has run.

These patches are layered on top of generic fixmap patches which
have been discussed here:

  http://lkml.org/lkml/2013/11/25/474

These patches (and undelying fixmap patches) may be found at:

  git://github.com/mosalter/linux.git (early-ioremap branch)

Mark Salter (4):
  Create generic early_ioremap() support
  x86: use generic early_ioremap
  arm: add early_ioremap support
  arm64: add early_ioremap support

 Documentation/arm64/memory.txt      |   4 +-
 arch/arm/Kconfig                    |  11 ++
 arch/arm/include/asm/Kbuild         |   1 +
 arch/arm/include/asm/fixmap.h       |  18 +++
 arch/arm/include/asm/io.h           |   1 +
 arch/arm/kernel/setup.c             |   3 +
 arch/arm/mm/Makefile                |   1 +
 arch/arm/mm/early_ioremap.c         |  93 ++++++++++++++
 arch/arm/mm/mmu.c                   |   2 +
 arch/arm64/Kconfig                  |   1 +
 arch/arm64/include/asm/Kbuild       |   1 +
 arch/arm64/include/asm/fixmap.h     |  68 ++++++++++
 arch/arm64/include/asm/io.h         |   1 +
 arch/arm64/include/asm/memory.h     |   1 +
 arch/arm64/kernel/early_printk.c    |   8 +-
 arch/arm64/kernel/head.S            |   9 +-
 arch/arm64/kernel/setup.c           |   2 +
 arch/arm64/mm/ioremap.c             |  77 ++++++++++++
 arch/arm64/mm/mmu.c                 |  41 ------
 arch/x86/Kconfig                    |   1 +
 arch/x86/include/asm/Kbuild         |   1 +
 arch/x86/include/asm/fixmap.h       |   6 +
 arch/x86/include/asm/io.h           |  14 +--
 arch/x86/mm/ioremap.c               | 224 +--------------------------------
 arch/x86/mm/pgtable_32.c            |   2 +-
 include/asm-generic/early_ioremap.h |  40 ++++++
 lib/Kconfig                         |   3 +
 lib/Makefile                        |   1 +
 lib/early_ioremap.c                 | 243 ++++++++++++++++++++++++++++++++++++
 29 files changed, 592 insertions(+), 286 deletions(-)
 create mode 100644 arch/arm/mm/early_ioremap.c
 create mode 100644 arch/arm64/include/asm/fixmap.h
 create mode 100644 include/asm-generic/early_ioremap.h
 create mode 100644 lib/early_ioremap.c

-- 
1.8.3.1


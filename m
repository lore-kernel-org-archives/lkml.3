Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaCMC3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 22:29:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbaCMC3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 22:29:50 -0400
Message-ID: <1394677788.5094.89.camel@deneb.redhat.com>
Subject: [GIT PULL] generic early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 12 Mar 2014 22:29:48 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Could you add this series into the -mm tree for v3.15?

The following changes since commit c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-03-04 08:44:32 -0800)

are available in the git repository at:


  git://github.com/mosalter/linux.git tags/for-v3.15

for you to fetch changes up to b27e0658d90c63dc2696eca44f7701a903cb13c5:

  doc/kernel-parameters.txt: add early_ioremap_debug (2014-03-09 12:53:50 -0400)

----------------------------------------------------------------
generic early_ioremap support

----------------------------------------------------------------
Dave Young (1):
      x86/mm: sparse warning fix for early_memremap

Mark Salter (5):
      mm: create generic early_ioremap() support
      x86: use generic early_ioremap
      arm64: initialize pgprot info earlier in boot
      arm64: add early_ioremap support
      doc/kernel-parameters.txt: add early_ioremap_debug

 Documentation/arm64/memory.txt      |   4 +-
 Documentation/kernel-parameters.txt |   5 +
 arch/arm64/Kconfig                  |   1 +
 arch/arm64/include/asm/Kbuild       |   1 +
 arch/arm64/include/asm/fixmap.h     |  67 ++++++++++
 arch/arm64/include/asm/io.h         |   1 +
 arch/arm64/include/asm/memory.h     |   2 +-
 arch/arm64/include/asm/mmu.h        |   1 +
 arch/arm64/kernel/early_printk.c    |   8 +-
 arch/arm64/kernel/head.S            |   9 +-
 arch/arm64/kernel/setup.c           |   4 +
 arch/arm64/mm/ioremap.c             |  85 +++++++++++++
 arch/arm64/mm/mmu.c                 |  44 +------
 arch/x86/Kconfig                    |   1 +
 arch/x86/include/asm/Kbuild         |   1 +
 arch/x86/include/asm/fixmap.h       |   6 +
 arch/x86/include/asm/io.h           |  14 +--
 arch/x86/mm/ioremap.c               | 224 +--------------------------------
 arch/x86/mm/pgtable_32.c            |   2 +-
 include/asm-generic/early_ioremap.h |  42 +++++++
 mm/Kconfig                          |   3 +
 mm/Makefile                         |   1 +
 mm/early_ioremap.c                  | 245 ++++++++++++++++++++++++++++++++++++
 23 files changed, 482 insertions(+), 289 deletions(-)
 create mode 100644 arch/arm64/include/asm/fixmap.h
 create mode 100644 include/asm-generic/early_ioremap.h
 create mode 100644 mm/early_ioremap.c



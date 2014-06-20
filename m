Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965844AbaFTGvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 02:51:09 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:39119 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965642AbaFTGvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 02:51:08 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] UniCore32 update for v3.16-rc1
Cc: gxt@mprc.pku.edu.cn, linux-kernel@vger.kernel.org
Message-Id: <20140620064834.7FBBB1460A58@linuxdev-32>
Date: Fri, 20 Jun 2014 14:48:34 +0800 (CST)
From: guanxuetao@mprc.pku.edu.cn (guanxuetao)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is unicore32 pull request for v3.16-rc1.

This pull request includes bugfixes to make unicore32 successfully build under defconfig,
and some changes for allmodconfig (though not finished).

Please pull tags/for-linus with following updates.

Thanks.

Xuetao Guan

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit 894e552cfaa3389f934dc68180bac692aebcf26b:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security (2014-06-19 07:58:28 -1000)

are available in the git repository at:


  git://github.com/gxt/linux.git tags/for-linus

for you to fetch changes up to d670878e2c9adb86b37e42b0937b2d4825bd2b39:

  unicore32: Remove ARCH_HAS_CPUFREQ config option (2014-06-20 08:22:41 +0800)

- ----------------------------------------------------------------
UniCore32 bug fixes for 3.16-rc1

- ----------------------------------------------------------------
Chen Gang (17):
      arch/unicore32/kernel/ksyms.c: remove several undefined exported symbols
      arch/unicore32/kernel/module.c: use __vmalloc_node_range() instead of __vmalloc_area()
      arch/unicore32/kernel/clock.c: add readl() and writel() for 'PM_' macros
      arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to avoid compiling error
      arch/unicore32/include/asm/ptrace.h: add generic definition for profile_pc()
      arch/unicore32/include/asm/io.h: add readl_relaxed() generic definition
      drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for typo issue
      drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue MIME-Version: 1.0
      arch/unicore32/kernel/ksyms.c: remove 2 export symbols to avoid compiling failure
      arch: unicore32: kernel: ksyms: remove 'bswapsi2' and 'muldi3' to avoid compiling failure
      drivers: scsi: mvsas: fix compiling issue by adding 'MVS_' for "enum pci_interrupt_cause"
      arch/unicore32/kernel/setup.c: add generic 'screen_info' to avoid compiling failure
      unicore32: include: asm: add missing ')' for PAGE_* macros in pgtable.h
      arch:unicore32:mm: add devmem_is_allowed() to support STRICT_DEVMEM
      arch: unicore32: ksyms: export additional find_first_*() to avoid compiling failure
      arch: unicore32: ksyms: export 'pm_power_off' to avoid compiling failure.
      arch: unicore32: ksyms: export '__cpuc_coherent_kern_range' to avoid compiling failure

Guan Xuetao (1):
      UniCore32: Change git tree location information in MAINTAINERS

Stephen Boyd (1):
      unicore32: Remove ARCH_HAS_CPUFREQ config option

 MAINTAINERS                          |  4 +--
 arch/unicore32/Kconfig               |  6 ----
 arch/unicore32/include/asm/io.h      | 27 +++++++++++++++++
 arch/unicore32/include/asm/pgtable.h | 10 +++----
 arch/unicore32/include/asm/ptrace.h  |  1 +
 arch/unicore32/kernel/clock.c        |  8 ++---
 arch/unicore32/kernel/ksyms.c        | 41 ++-----------------------
 arch/unicore32/kernel/ksyms.h        |  2 --
 arch/unicore32/kernel/module.c       | 11 ++-----
 arch/unicore32/kernel/process.c      |  1 +
 arch/unicore32/kernel/setup.c        |  4 +++
 arch/unicore32/mm/alignment.c        |  1 +
 arch/unicore32/mm/proc-syms.c        |  2 ++
 drivers/rtc/rtc-puv3.c               |  4 +--
 drivers/scsi/mvsas/mv_94xx.c         | 10 +++----
 drivers/scsi/mvsas/mv_94xx.h         | 58 ++++++++++++++++++------------------
 16 files changed, 88 insertions(+), 102 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTo9g9AAoJENFylnOm3dTbfb0QAKn6yiN2khPKmbszhnUzqky+
IPNb89O0ZUHpxmLgRv3ZlHnaK3aiXPDvq3gSKGayYOIam5PZtZHpkrUCfc+8eE1o
MONr5ffKQvd8siQDiUZ3pN9W55RfryPvyundt0bH34sszguZC9Lw8h/uGBA/0xM9
snuoFIWZV+5WMcsV+L75ipPG7a3MnWbDphWtvLWhJRKtEIZlXjZVovdw++M9g/Rt
xaIHUdPhpRC9cJgHbZUA6+C1bNQVh/ReyrqLgLWVpfWwsGeytn4DvA7wwCC5ogQy
zDdEZ26X4/hL46avZ7IFlYr2h+XoQdFa2iwxrnEnCMBn0hTDGuS5vbA7OyRqRmUt
smaMfOAFWmlyzSOlKHTh+kQeIVWyY0LUpGk+2g+nemtBvx0m3sSmvFyN9Jkpseap
DLj8YpHTV+mT84wUL5aXaUxLTxP22CxDskCDM03T0+9mLMxHu1R4Pjo4YhXe6KJp
tPWjFw4Fr0c8ziz+AHnqSCb6YgmLuvSQ3nhLDeL4EOFgld/cgq/osjx4nooWGIdq
2gbOeqIqPZLt5YBGlsFsaX7SVua7qjex75nZgxOoK92cHTnyQh4a8CWird+IzGoi
xONZgLa9EWz2pXKXUwST64fuXZJeSTonhgbhUtmEEVcdpQSbQaRioJWyOia760SX
Ab9qQIX1k4njnr4VaVTb
=1bU6
-----END PGP SIGNATURE-----

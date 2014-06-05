Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaFEFcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:32:14 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:55632 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaFEFcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 01:32:12 -0400
To: gxt@mprc.pku.edu.cn, torvalds@linux-foundation.org
Subject: [GIT PULL] UniCore32 update for v3.15-rc8
Cc: linux-kernel@vger.kernel.org
Message-Id: <20140605053032.E84EE146058C@linuxdev-32>
Date: Thu,  5 Jun 2014 13:30:32 +0800 (CST)
From: guanxuetao@mprc.pku.edu.cn (guanxuetao)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is unicore32 pull request for v3.15-rc8.

This pull request includes bugfixes to make unicore32 successfully build under defconfig,
and some changes for allmodconfig (though not finished).

Please pull tags/for-linus with following updates. I hope it works this time.

Thanks for your patience.

Xuetao Guan

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit cae61ba37b4c2672704cbd8a626fbd85be7e67d9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-06-02 18:16:41 -0700)

are available in the git repository at:


  git://github.com/gxt/linux.git tags/for-linus

for you to fetch changes up to 8c76c188d498a85c5b1a1f10840da57129a108a0:

  unicore32: Remove ARCH_HAS_CPUFREQ config option (2014-06-05 08:36:03 +0800)

- ----------------------------------------------------------------
UniCore32 bug fixes for 3.15-rc8

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

Zhichuang SUN (1):
      drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mmap

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
 drivers/video/fbdev/fb-puv3.c        |  2 ++
 17 files changed, 90 insertions(+), 102 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTj/+PAAoJENFylnOm3dTbYiwP+weUjrIiaFoxywEDYcXKqbyj
TlwCeJPLdbcov8hTEcpLm1vEsk9apVh2rQFiarLNnlnytFUbr3SN80DcR5Opsa1I
7VfnkGQSBQhTVs8WBr7rLiQ2j0LPZnmtLw1D7lOamKr/MDHm04IXVd3P3fT+1qVF
Zw01THwbEMRLKvmJoWRmxxVew4NyNmlMHxC/71pE9ogJOpgKOdkyqd4NMi7zUlvy
0/VyxFDdNP0xmFUkA5Wm3UKFcAAFF49qxqVKxxKYnBpWpJ/bX6eOqE0y6hzcFBCi
SuPVpCIYzqm/N1OI17nu8YA8EB5fq/43Xi4Ek0TVY+DfAVIlEyU9vZWbj0B1XfIv
PloCpV3ZJl7wbbHhINpkCpvjB3IABClaJvEurYTP1kEB9bZZN4QnXz/ZYhVjCLTF
Rk4gu7wJ6fiY8OEXZe7v2CJi6CZs/R2ZoDab4UMxVgm/JJei3rQXFzdao3/vBuz8
ugd+guPYnL2acwNr+MSNWSBe4FsKm0WdFARRXEPOE/OKpV63VukYixJMVk9Dcar6
EsGZH4yye7wIQMd/iOtwuuO9+i1kGit0iPhFw88KUWx22T7FXznKJh4obTkd220Q
8uWGX2yXu/iWcumqoYQiXIujn/GxTIU+IB5UGRJ2f0rCvqnz3S9X7QA+6y7KKs+M
hQShpDs+y+pNhasVAVbv
=A/1d
-----END PGP SIGNATURE-----

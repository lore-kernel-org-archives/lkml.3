Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaJMTzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:55:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbaJMTzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:55:13 -0400
Date: Mon, 13 Oct 2014 21:55:09 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bjorn.forsman@gmail.com, computersforpeace@gmail.com, mmarek@suse.cz,
        yamada.m@jp.panasonic.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] kbuild changes for v3.18-rc1
Message-ID: <20141013195509.GA16541@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following for v3.18-rc1:

* Fix for handling dependencies of *-objs targets by Masahiro Yamada
* Lots of cleanups in the kbuild machinery, also by Masahiro
* Fixes for the kconfig build to use an UTF-8 capable ncurses library if
  possible and to build on not-so-standard installs
* Some more minor fixes

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

for you to fetch changes up to 30142230a730263e9989e0174b74c2429e041c8c:

  kbuild: Do not reference *-n variables in the Makefile (2014-10-02 15:31:53 +0200)

----------------------------------------------------------------
Bjørn Forsman (1):
      kconfig/lxdialog: get ncurses CFLAGS with pkg-config

Brian Norris (2):
      kconfig: lxdialog: fix spelling
      kconfig: nconfig: fix multi-byte UTF handling

Masahiro Yamada (12):
      kbuild: handle multi-objs dependency appropriately
      kbuild: handle the dependency of multi-objs hostprogs appropriately
      kbuild: refactor script/kconfig/Makefile
      kbuild: remove redundant clean-files from scripts/kconfig/Makefile
      kbuild: fake the "Entering directory ..." message more simply
      kbuild: use $(Q) for sub-make target
      kbuild: handle C=... and M=... after entering into build directory
      kbuild: remove unnecessary "obj- := dummy.o" trick
      kbuild: remove unnecessary variable initializaions
      kbuild: remove obj-n and lib-n handling
      kbuild: arm: Do not define "comma" twice
      kbuild: simplify build, clean, modbuiltin shorthands

Michal Marek (2):
      kbuild: Make scripts executable
      kbuild: Do not reference *-n variables in the Makefile

 Makefile                                   | 88 ++++++++++++++----------------
 arch/arm/Makefile                          |  2 -
 arch/arm/mach-at91/Makefile                |  3 -
 arch/arm/mach-ebsa110/Makefile             |  3 -
 arch/arm/mach-ep93xx/Makefile              |  3 -
 arch/arm/mach-exynos/Makefile              |  5 --
 arch/arm/mach-footbridge/Makefile          |  3 -
 arch/arm/mach-iop13xx/Makefile             |  5 --
 arch/arm/mach-iop32x/Makefile              |  3 -
 arch/arm/mach-iop33x/Makefile              |  3 -
 arch/arm/mach-ks8695/Makefile              |  3 -
 arch/arm/mach-rpc/Makefile                 |  4 --
 arch/arm/mach-s3c24xx/Makefile             |  5 --
 arch/arm/mach-s3c64xx/Makefile             |  5 --
 arch/arm/mach-s5pv210/Makefile             |  5 --
 arch/arm/mach-sa1100/Makefile              |  3 -
 arch/arm/mach-u300/Makefile                |  3 -
 arch/arm/plat-iop/Makefile                 |  6 --
 arch/arm/plat-omap/Makefile                |  3 -
 arch/arm/plat-samsung/Makefile             |  5 --
 arch/arm64/Makefile                        |  2 -
 drivers/clk/shmobile/Makefile              |  2 -
 drivers/net/wimax/Makefile                 |  4 --
 firmware/Makefile                          |  2 +-
 scripts/Kbuild.include                     |  4 +-
 scripts/Makefile.build                     | 14 ++---
 scripts/Makefile.clean                     |  6 +-
 scripts/Makefile.fwinst                    |  2 +-
 scripts/Makefile.host                      |  6 +-
 scripts/Makefile.lib                       |  9 +++
 scripts/bootgraph.pl                       |  0
 scripts/export_report.pl                   |  0
 scripts/gcc-goto.sh                        |  0
 scripts/gcc-ld                             |  0
 scripts/gcc-version.sh                     |  0
 scripts/gcc-x86_32-has-stack-protector.sh  |  0
 scripts/gcc-x86_64-has-stack-protector.sh  |  0
 scripts/gen_initramfs_list.sh              |  0
 scripts/headers_check.pl                   |  0
 scripts/headers_install.sh                 |  0
 scripts/kconfig/Makefile                   | 38 ++-----------
 scripts/kconfig/lxdialog/check-lxdialog.sh |  6 +-
 scripts/kconfig/lxdialog/dialog.h          |  2 +-
 scripts/kconfig/streamline_config.pl       |  0
 scripts/link-vmlinux.sh                    |  0
 scripts/markup_oops.pl                     |  0
 scripts/mkmakefile                         |  0
 scripts/mksysmap                           |  0
 scripts/package/builddeb                   |  0
 scripts/package/buildtar                   |  0
 scripts/profile2linkerlist.pl              |  0
 scripts/rt-tester/rt-tester.py             |  0
 scripts/selinux/install_policy.sh          |  0
 scripts/tracing/draw_functrace.py          |  0
 scripts/xz_wrap.sh                         |  0
 55 files changed, 76 insertions(+), 181 deletions(-)
 mode change 100644 => 100755 scripts/bootgraph.pl
 mode change 100644 => 100755 scripts/export_report.pl
 mode change 100644 => 100755 scripts/gcc-goto.sh
 mode change 100644 => 100755 scripts/gcc-ld
 mode change 100644 => 100755 scripts/gcc-version.sh
 mode change 100644 => 100755 scripts/gcc-x86_32-has-stack-protector.sh
 mode change 100644 => 100755 scripts/gcc-x86_64-has-stack-protector.sh
 mode change 100644 => 100755 scripts/gen_initramfs_list.sh
 mode change 100644 => 100755 scripts/headers_check.pl
 mode change 100644 => 100755 scripts/headers_install.sh
 mode change 100644 => 100755 scripts/kconfig/lxdialog/check-lxdialog.sh
 mode change 100644 => 100755 scripts/kconfig/streamline_config.pl
 mode change 100644 => 100755 scripts/link-vmlinux.sh
 mode change 100644 => 100755 scripts/markup_oops.pl
 mode change 100644 => 100755 scripts/mkmakefile
 mode change 100644 => 100755 scripts/mksysmap
 mode change 100644 => 100755 scripts/package/builddeb
 mode change 100644 => 100755 scripts/package/buildtar
 mode change 100644 => 100755 scripts/profile2linkerlist.pl
 mode change 100644 => 100755 scripts/rt-tester/rt-tester.py
 mode change 100644 => 100755 scripts/selinux/install_policy.sh
 mode change 100644 => 100755 scripts/tracing/draw_functrace.py
 mode change 100644 => 100755 scripts/xz_wrap.sh

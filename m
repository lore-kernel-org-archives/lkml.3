Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbaFLQKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:10:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbaFLQKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:10:14 -0400
Date: Thu, 12 Jun 2014 18:10:11 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: geert@linux-m68k.org, mmarek@suse.cz, yamada.m@jp.panasonic.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kbuild changes for v3.16-rc1
Message-ID: <20140612161011.GA20009@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kbuild changes for v3.16-rc1:
- cross-compilation fix so that cc-option is testing the right compiler
- Fix for make defconfig all
- Using relative paths to the object and source directory where
  possible, plus fixes for the fallout of the change
- several cleanups in the Makefiles and scripts

The powerpc fix is from today, because it was only discovered recently.
The rest has been in linux-next for some time.

Michal

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

for you to fetch changes up to 699c659b49b5c7cf601fe454683841df16495c3e:

  powerpc: Avoid circular dependency with zImage.% (2014-06-12 10:07:35 +0200)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      Makefile: Fix unrecognized cross-compiler command line options

Masahiro Yamada (7):
      kbuild: move extra gcc checks to scripts/Makefile.extrawarn
      kbuild: support simultaneous "make %config" and "make all"
      kbuild: trivial - remove trailing spaces
      kbuild: trivial - fix comment block indent
      kbuild: do not add "selinux" to subdir- twice
      kbuild: do not create include/linux directory
      kbuild: create include/config directory in scripts/kconfig/Makefile

Michal Marek (7):
      firmware: Simplify directory creation
      firmware: Use $(quote) in the Makefile
      kbuild: Use relative path for $(objtree)
      kbuild: Use relative path when building in the source tree
      kbuild: Use relative path when building in a subdir of the source tree
      um: Fix for relative objtree when generating x86 headers
      powerpc: Avoid circular dependency with zImage.%

 Makefile                             | 89 +++++++++++++++++++++---------------
 arch/powerpc/boot/Makefile           |  4 +-
 arch/um/Makefile                     |  3 +-
 firmware/Makefile                    | 34 +++-----------
 scripts/Makefile                     |  2 +-
 scripts/Makefile.build               | 65 +-------------------------
 scripts/Makefile.extrawarn           | 67 +++++++++++++++++++++++++++
 scripts/Makefile.fwinst              | 26 +++++------
 scripts/Makefile.host                |  2 +-
 scripts/Makefile.lib                 | 10 ++--
 scripts/conmakehash.c                | 12 ++---
 scripts/kconfig/Makefile             |  4 +-
 scripts/kconfig/streamline_config.pl |  2 +-
 scripts/mkcompile_h                  |  4 +-
 scripts/mkmakefile                   | 15 ++----
 scripts/package/builddeb             |  2 +-
 scripts/patch-kernel                 |  4 +-
 17 files changed, 168 insertions(+), 177 deletions(-)
 create mode 100644 scripts/Makefile.extrawarn

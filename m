Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaFLQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:16:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbaFLQQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:16:26 -0400
Date: Thu, 12 Jun 2014 18:16:22 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ben@decadent.org.uk, fathi.boudra@linaro.org, gamerh2o@gmail.com,
        koct9i@gmail.com, nasa4836@gmail.com, peter.senna@gmail.com,
        sboyd@codeaurora.org, wt@penguintechs.org, yamada.m@jp.panasonic.com,
        ydroneaud@opteya.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] kbuild misc changes for v3.16-rc1
Message-ID: <20140612161622.GA20405@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the non-critical part of kbuild for v3.16-rc1:
- make deb-pkg can do s390x and arm64
- New patterns in scripts/tags.sh
- scripts/tags.sh skips userspace tools' sources (which sometimes have
  copies of kernel structures) and symlinks
- Improvements to the objdiff tool
- Two new coccinelle patches
- Other minor fixes

Michal


The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

for you to fetch changes up to 7fa0e6db3cedc9b70d68a4170f1352e2b1aa0f90:

  scripts: objdiff: support directories for the augument of record command (2014-06-10 14:59:33 +0200)

----------------------------------------------------------------
Ben Hutchings (1):
      deb-pkg: Add automatic support for s390x architecture

Fathi Boudra (2):
      builddeb: use $OBJCOPY variable instead of objcopy
      builddeb: add arm64 in the supported architectures

Jianyu Zhan (2):
      scripts/tags.sh: add pattern for DEFINE_HASHTABLE
      scripts/tags.sh: add regular expression replacement pattern for memcg

Konstantin Khlebnikov (1):
      scripts/tags.sh: ignore code of user space tools

Masahiro Yamada (9):
      kbuild: trivial - remove trailing empty lines
      kbuild: trivial - use tabs for code indent where possible
      scripts: objdiff: get the path to .tmp_objdiff more simply
      scripts: objdiff: direct error messages to stderr
      scripts: objdiff: remove unnecessary code
      scripts: objdiff: improve path flexibility for record command
      scripts: objdiff: change the extension of disassembly from .o to .dis
      scripts: objdiff: fix a comment
      scripts: objdiff: support directories for the augument of record command

Peter Senna Tschudin (1):
      coccicheck: Add unneeded return variable test

Stephen Boyd (1):
      coccinelle: Check for missing NULL terminators in of_device_id tables

Warren Turkal (1):
      kbuild: Fix a typo in documentation

Yann Droneaud (1):
      scripts/tags.sh: ignore symlink'ed source files

Zhao, Gang (1):
      .gitignore: ignore Module.symvers in all directories

 .gitignore                              |  4 +-
 Documentation/kbuild/modules.txt        |  2 +-
 scripts/Makefile.asm-generic            |  1 -
 scripts/Makefile.host                   |  1 -
 scripts/basic/fixdep.c                  |  8 ++--
 scripts/checkstack.pl                   |  1 -
 scripts/coccinelle/misc/of_table.cocci  | 62 +++++++++++++++++++++++++++
 scripts/coccinelle/misc/returnvar.cocci | 66 +++++++++++++++++++++++++++++
 scripts/config                          |  1 -
 scripts/docproc.c                       | 56 ++++++++++++-------------
 scripts/dtc/.gitignore                  |  1 -
 scripts/dtc/fstree.c                    |  1 -
 scripts/dtc/libfdt/fdt_empty_tree.c     |  1 -
 scripts/dtc/treesource.c                |  1 -
 scripts/headers.sh                      |  2 -
 scripts/kallsyms.c                      |  2 +-
 scripts/kconfig/Makefile                |  1 -
 scripts/kconfig/check.sh                |  1 -
 scripts/kconfig/conf.c                  |  2 +-
 scripts/kconfig/gconf.c                 |  2 +-
 scripts/kconfig/lxdialog/checklist.c    |  4 +-
 scripts/kconfig/lxdialog/inputbox.c     |  2 +-
 scripts/kconfig/lxdialog/menubox.c      |  4 +-
 scripts/kconfig/lxdialog/util.c         |  2 +-
 scripts/kconfig/mconf.c                 |  3 +-
 scripts/kconfig/menu.c                  |  6 +--
 scripts/kconfig/nconf.c                 |  1 -
 scripts/kconfig/util.c                  |  2 -
 scripts/kconfig/zconf.l                 |  4 +-
 scripts/kconfig/zconf.lex.c_shipped     |  4 +-
 scripts/kconfig/zconf.tab.c_shipped     |  2 +-
 scripts/kconfig/zconf.y                 |  2 +-
 scripts/markup_oops.pl                  |  1 -
 scripts/mksysmap                        |  1 -
 scripts/mod/.gitignore                  |  1 -
 scripts/mod/file2alias.c                | 42 +++++++++----------
 scripts/mod/mk_elfconfig.c              |  1 -
 scripts/mod/modpost.c                   | 30 ++++++-------
 scripts/mod/sumversion.c                |  4 +-
 scripts/objdiff                         | 74 ++++++++++++++++++++-------------
 scripts/package/Makefile                |  1 -
 scripts/package/builddeb                | 10 +++--
 scripts/package/buildtar                |  1 -
 scripts/pnmtologo.c                     |  1 -
 scripts/recordmcount.c                  |  2 -
 scripts/rt-tester/check-all.sh          |  1 -
 scripts/rt-tester/rt-tester.py          |  2 -
 scripts/selinux/install_policy.sh       |  1 -
 scripts/show_delta                      |  1 -
 scripts/tags.sh                         | 29 +++++++++----
 50 files changed, 293 insertions(+), 162 deletions(-)
 create mode 100644 scripts/coccinelle/misc/of_table.cocci
 create mode 100644 scripts/coccinelle/misc/returnvar.cocci

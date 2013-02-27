Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab3B0NtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:49:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab3B0NtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:49:09 -0500
Date: Wed, 27 Feb 2013 14:49:06 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: alan@linux.intel.com, ben@decadent.org.uk, edvx1@systemanalysen.net,
        krzysiek@podlesie.net, mmarek@suse.cz, rkmahefa@gmail.com,
        udknight@gmail.com, yann.morin.1998@free.fr, zhangfei.gao@linaro.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kconfig changes for v3.9-rc1
Message-ID: <20130227134906.GA26296@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kconfig changes for v3.9-rc1. I forgot to send a pull
request in time for the v3.8-rc1 merge window, so the list is a bit
longer this time:

* menuconfig enables extended colors in ncurses if the wide-character
  version is used.
* CONFIG_ prefix can be specified in the environment to make life easier
  for people using kconfig multiple times in a single tree (no
  functional change in the kernel kconfig usage).
* kconfig aborts on OOM.
* inputboxes in menuconfig allow to move the cursor.
* menuconfig has Save/Load buttons now.
* xconfig build fix with new g++ and Qt3.
* nconfig color scheme fix and help text update.
* make oldconfig prints newlines when output is redirected.
* some other minor fixes.


The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

for you to fetch changes up to e3900e74f26fc924c8e9e2a922bd40369b0bb517:

  Merge branch 'kbuild/rc-fixes' into kbuild/kconfig (2013-02-25 21:51:57 +0100)

----------------------------------------------------------------

Alan Cox (1):
      kconfig: Fix malloc handling in conf tools

Ben Hutchings (1):
      kbuild: Fix missing '\n' for NEW symbols in yes "" | make oldconfig >conf.new

Krzysztof Mazur (1):
      menuconfig: fix extended colors ncurses support

Michal Marek (3):
      kconfig: Regenerate lexer
      Merge branch 'yem-kconfig-rc-fixes' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes
      Merge branch 'kbuild/rc-fixes' into kbuild/kconfig

Roland Eggner (3):
      nconf: function keys line, change background color for better readability
      kconfig: nconf: rewrite help texts
      kconfig: nconf: rewrite labels of function keys line

Tiana Rakotovao Andriamahefa (1):
      kconfig: fix a compiliation error when using make xconfig

Wang YanQing (4):
      menuconfig:inputbox: support navigate input position
      kconfig:lxdialog: remove duplicate code
      menuconfig: Add Save/Load buttons
      menuconfig: Get rid of the top-level entries for "Load an Alternate/Save an Alternate"

Yann E. MORIN (6):
      kconfig: remove CONFIG_ from string constants
      kconfig: add a function to get the CONFIG_ prefix
      kconfig: get CONFIG_ prefix from the environment
      Revert "kconfig-language: add to hints"
      scripts/kconfig: ensure we use proper CONFIG_ prefix
      kconfig: document use of CONFIG_ environment variable

Zhangfei Gao (1):
      merge_config.sh: Add option to specify output dir

 Documentation/kbuild/kconfig-language.txt  |   23 --
 Documentation/kbuild/kconfig.txt           |    6 +
 scripts/kconfig/Makefile                   |    3 +
 scripts/kconfig/conf.c                     |    7 +-
 scripts/kconfig/expr.c                     |   10 +-
 scripts/kconfig/gconf.c                    |    2 +-
 scripts/kconfig/lkc.h                      |    8 +
 scripts/kconfig/lxdialog/check-lxdialog.sh |    1 +
 scripts/kconfig/lxdialog/dialog.h          |    1 -
 scripts/kconfig/lxdialog/inputbox.c        |  121 +++++++---
 scripts/kconfig/lxdialog/menubox.c         |   20 +-
 scripts/kconfig/mconf.c                    |   54 +++--
 scripts/kconfig/menu.c                     |    4 +-
 scripts/kconfig/merge_config.sh            |   20 +-
 scripts/kconfig/nconf.c                    |  340 ++++++++++++++--------------
 scripts/kconfig/nconf.gui.c                |    2 +-
 scripts/kconfig/qconf.cc                   |    1 +
 scripts/kconfig/symbol.c                   |   12 +-
 scripts/kconfig/util.c                     |   23 +-
 scripts/kconfig/zconf.l                    |    8 +-
 scripts/kconfig/zconf.lex.c_shipped        |    8 +-
 21 files changed, 391 insertions(+), 283 deletions(-)

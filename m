Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab3EGMs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:48:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067Ab3EGMsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:48:25 -0400
Date: Tue, 7 May 2013 14:48:23 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bpoirier@suse.de, jlec@gentoo.org, john.stultz@linaro.org, mmarek@suse.cz,
        yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kconfig changes for v3.10-rc1
Message-ID: <20130507124814.GA13003@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following kconfig bits for v3.10-rc1:

* use pkg-config to detect curses libraries
* clean up the way curses headers are searched
* Some randconfig fixes, of which one had to be reverted
* KCONFIG_SEED for randconfig debugging
* memuconfig memory leak plugged
* menuconfig > breadcrumbs > navigation
* xconfig compilation fix
* Other minor fixes

Michal

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

Benjamin Poirier (2):
      menuconfig: Fix memory leak introduced by jump keys feature
      menuconfig: Add "breadcrumbs" navigation aid

John Stultz (1):
      merge_config.sh: Avoid creating unnessary source softlinks

Justin Lecher (2):
      menuconfig: optionally use pkg-config to detect ncurses libs
      kconfig: optionally use pkg-config to detect ncurses libs

Michal Marek (1):
      Merge branch 'yem-kconfig-rc-fixes' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/kconfig

Yann E. MORIN (8):
      kconfig/lxdialog: rationalise the include paths where to find {.n}curses{,w}.h
      kconfig: fix randconfig tristate detection
      kconfig: do not override symbols already set
      kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
      kconfig: allow specifying the seed for randconfig
      kconfig: implement KCONFIG_PROBABILITY for randconfig
      Revert "kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG"
      kconfig: fix lists definition for C++

 Documentation/kbuild/kconfig.txt           |   36 +++++++++++++
 scripts/kconfig/Makefile                   |    4 +-
 scripts/kconfig/conf.c                     |   12 ++++-
 scripts/kconfig/confdata.c                 |   59 ++++++++++++++++++++--
 scripts/kconfig/list.h                     |   40 +++++++++++++++
 scripts/kconfig/lxdialog/check-lxdialog.sh |    6 ++-
 scripts/kconfig/lxdialog/dialog.h          |    7 +++
 scripts/kconfig/lxdialog/util.c            |   45 ++++++++++++++++-
 scripts/kconfig/mconf.c                    |   74 +++++++++++++++++++++++++++-
 scripts/kconfig/merge_config.sh            |   10 +++-
 10 files changed, 281 insertions(+), 12 deletions(-)

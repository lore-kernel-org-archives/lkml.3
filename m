Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3GJNzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:55:05 -0400
Received: from ip-78-102-49-28.net.upcbroadband.cz ([78.102.49.28]:64277 "EHLO
	emu.suse.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751434Ab3GJNzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:55:03 -0400
X-Greylist: delayed 930 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2013 09:55:03 EDT
Date: Wed, 10 Jul 2013 15:55:01 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arve@android.com, chauplac@gmail.com, dirk@gouders.net,
        keescook@chromium.org, sedat.dilek@gmail.com, yann.morin.1998@free.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kconfig changes for v3.11-rc1
Message-ID: <20130710135501.GA31038@emu.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kconfig commit for v3.11-rc1:

- dependency solver fix for make defconfig
- randconfig fixes, one of which had to be reverted again
- more user-friendly sorting of search results
- hex and range keywords support longs
- fix for [mn]conf not to rely on particular behavior of the LINES and
  COLS variables
- cleanup of magic constants in kconfig/lxdialog
- [mn]conf formatting fixes
- fix for scripts/config's help text in our-of-tree usage (under a
  different name)

Michal

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

for you to fetch changes up to b57caaaed2bd127fe656e6c145970ed6a05c0125:

  kconfig: allow "hex" and "range" to support longs (2013-06-29 15:30:17 +0200)

----------------------------------------------------------------
Arve Hjønnevåg (1):
      kconfig: Fix defconfig when one choice menu selects options that another choice menu depends on

Clement Chauplannaz (1):
      scripts/config: replace hard-coded script name by a dynamic value

Dirk Gouders (4):
      kconfig/lxdialog: handle newline characters in print_autowrap()
      mconf: use function calls instead of ncurses' variables LINES and COLS
      nconf: use function calls instead of ncurses' variables LINES and COLS
      mconf/nconf: mark empty menus/menuconfigs different from non-empty ones

Kees Cook (1):
      kconfig: allow "hex" and "range" to support longs

Sedat Dilek (2):
      kconfig/lxdialog: Add definitions for mininimum (re)size values
      kconfig/lxdialog: Use new mininimum resize definitions in conf_choice()

Yann E. MORIN (8):
      kconfig/conf: fix randconfig setting multiple symbols in a choice
      kconfig/conf: accept a base-16 seed for randconfig
      kconfig/conf: print the seed used to initialise the RNG for randconfig
      kconfig: sort found symbols by relevance
      kconfig/[mn]conf: make it explicit in the search box that a regexp is possible
      kconfig: loop as long as we changed some symbols in randconfig
      kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
      Revert "kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG"

 Documentation/kbuild/kconfig.txt     | 13 +++++
 scripts/config                       | 12 +++--
 scripts/kconfig/conf.c               |  6 ++-
 scripts/kconfig/confdata.c           | 33 +++++++++---
 scripts/kconfig/expr.h               |  3 ++
 scripts/kconfig/lkc.h                |  3 +-
 scripts/kconfig/lkc_proto.h          |  1 +
 scripts/kconfig/lxdialog/checklist.c |  8 +--
 scripts/kconfig/lxdialog/dialog.h    | 14 +++++
 scripts/kconfig/lxdialog/inputbox.c  |  8 +--
 scripts/kconfig/lxdialog/menubox.c   |  6 +--
 scripts/kconfig/lxdialog/textbox.c   |  6 +--
 scripts/kconfig/lxdialog/util.c      | 46 ++++++++++-------
 scripts/kconfig/lxdialog/yesno.c     |  8 +--
 scripts/kconfig/mconf.c              | 21 ++++----
 scripts/kconfig/menu.c               | 16 ++++++
 scripts/kconfig/nconf.c              | 39 ++++++++------
 scripts/kconfig/nconf.gui.c          | 20 ++++----
 scripts/kconfig/symbol.c             | 99 +++++++++++++++++++++++++++++++-----
 19 files changed, 262 insertions(+), 100 deletions(-)

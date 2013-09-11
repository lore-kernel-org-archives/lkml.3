Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3IKIjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:39:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab3IKIi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:38:56 -0400
Date: Wed, 11 Sep 2013 10:38:52 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: chauplac@gmail.com, keescook@chromium.org, mmarek@suse.cz,
        mpagano@gentoo.org, yann.morin.1998@free.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kconfig updates for v3.12-rc1
Message-ID: <20130911083852.GA28217@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the kconfig part of kbuild for v3.12-rc1:
- post-3.11 search code fixes and micro-optimizations
- CONFIG_MODULES is no longer a special case; this is needed to
  eventually fix the bug that using KCONFIG_ALLCONFIG breaks
  allmodconfig
- long long is used to store hex and int values
- make silentoldconfig no longer warns when a symbol changes from
  tristate to bool (it's a job for make oldconfig)
- scripts/diffconfig updated to work with newer Pythons
- scripts/config does not rely on GNU sed extensions

Michal


The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

for you to fetch changes up to e062781397e5bebc6c1b8dd4bf466136e13ae4c5:

  kconfig: do not allow more than one symbol to have 'option modules' (2013-09-05 11:10:08 +0200)

----------------------------------------------------------------
Clement Chauplannaz (1):
      scripts/config: use sed's POSIX interface

Kees Cook (1):
      kconfig: switch to "long long" for sanity

Michal Marek (1):
      Merge branch 'yem-kconfig-rc-fixes' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/kconfig

Mike Pagano (2):
      diffconfig: Gracefully exit if the default config files are not present
      diffconfig: Update script to support python versions 2.5 through 3.3

Yann E. MORIN (11):
      Documentation/kconfig: more concise and straightforward search explanation
      kconfig: avoid multiple calls to strlen
      kconfig/[mn]conf: shorten title in search-box
      kconfig: minor style fixes in symbol-search code
      kconfig: don't allocate n+1 elements in temporary array
      kconfig: simplify symbol-search code
      kconfig: silence warning when parsing auto.conf when a symbol has changed type
      modules: do not depend on kconfig to set 'modules' option to symbol MODULES
      kconfig: do not special-case 'MODULES' symbol
      kconfig: regenerate bison parser
      kconfig: do not allow more than one symbol to have 'option modules'

 Documentation/kbuild/kconfig-language.txt |   1 +
 Documentation/kbuild/kconfig.txt          |   8 +-
 init/Kconfig                              |   1 +
 scripts/config                            |  44 ++-
 scripts/diffconfig                        |  33 +-
 scripts/kconfig/confdata.c                |  11 +-
 scripts/kconfig/mconf.c                   |   4 +-
 scripts/kconfig/menu.c                    |  11 +-
 scripts/kconfig/nconf.c                   |   4 +-
 scripts/kconfig/symbol.c                  |  68 ++--
 scripts/kconfig/zconf.tab.c_shipped       | 562 ++++++++++++++++--------------
 scripts/kconfig/zconf.y                   |  11 +-
 12 files changed, 413 insertions(+), 345 deletions(-)

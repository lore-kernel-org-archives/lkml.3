Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3FXSMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:12:12 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46651 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3FXSMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:12:09 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [pull request v2] Pull request for branch yem-kconfig-for-next
Date: Mon, 24 Jun 2013 20:11:44 +0200
Message-Id: <cover.1372097219.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Hello Michal, All!
                                                                                                                                                                                      │
Michal, please pull these patches against kconfig that I have accumulated
for 3.11.

Note-whorthy this time:
  - fix values of tristates that are selected by boolean choices (Arve)
  - fix choice randomisation in presence of KCONFIG_ALLCONFIG    (me)
  - fix choice randomisation selecting more than one value in
    a choice (but only if it is conditional)                     (me)
  - fix choice-in-a-choice randomisation not selecting any value
    for the inner-most choice                                    (me)

Also, some code-cleanups and eye-candy:
  - mconf and nconf code cleanups                                (Dirk, Sedat)
  - mconf and nconf eye-candy                                    (Dirk, me)
  - scripts/config script-name in help text                      (Clément)
  - heuristic to sort found symbols by relevance                 (me)
  - more randconfig debugging help                               (me)

Changes v1 -> v2:
  - simplify sorting heuristic (Jean)
  - make it clear in mconf/nconf that the search expression can
    be a regexp (Jean)

Regards,
Yann E. MORIN.


The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-for-next

for you to fetch changes up to 8357b48549e17b3e4e402c7f977b65708922e60f:

  kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG (2013-06-24 20:03:31 +0200)

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

Sedat Dilek (2):
      kconfig/lxdialog: Add definitions for mininimum (re)size values
      kconfig/lxdialog: Use new mininimum resize definitions in conf_choice()

Yann E. MORIN (7):
      kconfig/conf: fix randconfig setting multiple symbols in a choice
      kconfig/conf: accept a base-16 seed for randconfig
      kconfig/conf: print the seed used to initialise the RNG for randconfig
      kconfig: sort found symbols by relevance
      kconfig/[mn]conf: make it explicit in the search box that a regexp is possible
      kconfig: loop as long as we changed some symbols in randconfig
      kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG

 Documentation/kbuild/kconfig.txt     | 13 ++++++
 scripts/config                       | 12 +++--
 scripts/kconfig/conf.c               |  6 ++-
 scripts/kconfig/confdata.c           | 39 ++++++++++++----
 scripts/kconfig/expr.h               |  3 ++
 scripts/kconfig/lkc.h                |  3 +-
 scripts/kconfig/lkc_proto.h          |  1 +
 scripts/kconfig/lxdialog/checklist.c |  8 ++--
 scripts/kconfig/lxdialog/dialog.h    | 14 ++++++
 scripts/kconfig/lxdialog/inputbox.c  |  8 ++--
 scripts/kconfig/lxdialog/menubox.c   |  6 +--
 scripts/kconfig/lxdialog/textbox.c   |  6 +--
 scripts/kconfig/lxdialog/util.c      | 46 +++++++++++--------
 scripts/kconfig/lxdialog/yesno.c     |  8 ++--
 scripts/kconfig/mconf.c              | 21 +++++----
 scripts/kconfig/menu.c               | 16 +++++++
 scripts/kconfig/nconf.c              | 39 +++++++++-------
 scripts/kconfig/nconf.gui.c          | 20 ++++----
 scripts/kconfig/symbol.c             | 89 ++++++++++++++++++++++++++++++++----
 19 files changed, 260 insertions(+), 98 deletions(-)
-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

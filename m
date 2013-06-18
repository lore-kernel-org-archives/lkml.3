Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab3FRWpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:45:21 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:37767 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3FRWpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:18 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [pull request] Pull request for branch yem-kconfig-for-next
Date: Wed, 19 Jun 2013 00:44:56 +0200
Message-Id: <cover.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Hello Michal, All!

These are the patches against kconfig that I have accumulated for 3.11,
and for which I plan to later send a proper pull-request.

Note-whorthy this time:
  - fix values of tristates that are selected by boolean choices (Arve)
  - fix choice randomisation in presence of KCONFIG_ALLCONFIG    (me)
  - fix choice randomisation selecting more than one value in
    a choice (but only if it is conditional)                     (me)
  - fix choice-in-a-choice randomisation not selecting any value
    for the inner-most choice                                    (me)

Also, some code-cleanups and eye-candy:
  - mconf and nconf code cleanups                                (Dirk, Sedat)
  - mconf and nconf eye-candy                                    (Dirk)
  - scripts/config script-name in help text                      (Clément)
  - heuristic to sort found symbols by relevance                 (me)
  - more randconfig debugging help                               (me)

Note: this series is for review before I send an official pull-request.
I want to avoid the debacle [0] [1] of the last kconfig breakage I caused
with my previous kconfig "fix" to randomising choices in presence of
KCONFIG_ALLCONFIG.

I would like to send an official pull-request early next week, so all of
these can land early in -next, so they get some real-life t4esting before
the next merge windows open. So please, please, test this carefully. ;-)

[0] http://marc.info/?t=136684274600002&r=1&w=2
[1] http://marc.info/?t=136696367200003&r=1&w=2

Regards,
Yann E. MORIN.


The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-for-next

for you to fetch changes up to b4e0ac8385fecde0363a2499323f81b4a91e8430:

  kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG (2013-06-18 23:59:02 +0200)

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

Yann E. MORIN (6):
      kconfig/conf: fix randconfig setting multiple symbols in a choice
      kconfig/conf: accept a base-16 seed for randconfig
      kconfig/conf: print the seed used to initialise the RNG for randconfig
      kconfig: sort found symbols by relevance
      kconfig: loop as long as we changed some symbols in randconfig
      kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG

 scripts/config                       |  12 ++--
 scripts/kconfig/conf.c               |   6 +-
 scripts/kconfig/confdata.c           |  39 +++++++++----
 scripts/kconfig/expr.h               |   3 +
 scripts/kconfig/lkc.h                |   3 +-
 scripts/kconfig/lkc_proto.h          |   1 +
 scripts/kconfig/lxdialog/checklist.c |   8 +--
 scripts/kconfig/lxdialog/dialog.h    |  14 +++++
 scripts/kconfig/lxdialog/inputbox.c  |   8 +--
 scripts/kconfig/lxdialog/menubox.c   |   6 +-
 scripts/kconfig/lxdialog/textbox.c   |   6 +-
 scripts/kconfig/lxdialog/util.c      |  46 ++++++++-------
 scripts/kconfig/lxdialog/yesno.c     |   8 +--
 scripts/kconfig/mconf.c              |  19 ++++---
 scripts/kconfig/menu.c               |  16 ++++++
 scripts/kconfig/nconf.c              |  37 +++++++-----
 scripts/kconfig/nconf.gui.c          |  20 ++++---
 scripts/kconfig/symbol.c             | 107 ++++++++++++++++++++++++++++++++---
 18 files changed, 263 insertions(+), 96 deletions(-)
-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

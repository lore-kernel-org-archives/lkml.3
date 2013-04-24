Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab3DXWaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:30:22 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55852 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3DXWaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:30:20 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Benjamin Poirier <bpoirier@suse.de>,
        Peter Korsgaard <jacmet@uclibc.org>
Subject: [pull request v2] Pull request for branch yem-kconfig-for-next
Date: Thu, 25 Apr 2013 00:29:47 +0200
Message-Id: <cover.1366841993.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Michal,

Here is the official pull-request for the kconfig-related changes I've
gathered from the linux-kbuild list, and those I've locally accumulated,
for inclusin in 3.10:

  - memory leak fixed in mconf
  - 3 randconfig fixes (randomising choices, setting tristates,
    already set symbols)
  - randconfig improvements: seed, and probability skew
  - navigation breadcrumbs in mconf


Changes v1 -> v2:
  - restore the previous probabilities per default
  - use different probabilities for booleans and tristates
  - two new fixes for randconfig
  - Cc: lkml this time

Regards,
Yann E. MORIN

----------------------------------------------------------------
The following changes since commit a45c7dfb942b6c198d5cd283f8dcee145241a017:

  merge_config.sh: Avoid creating unnessary source softlinks (2013-04-10 10:55:22 +0200)

are available in the git repository at:

  git://gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-for-next

for you to fetch changes up to e43956e607692f9b1c710311e4a6591ffba1edf0:

  kconfig: implement KCONFIG_PROBABILITY for randconfig (2013-04-25 00:16:30 +0200)

----------------------------------------------------------------
Benjamin Poirier (2):
      menuconfig: Fix memory leak introduced by jump keys feature
      menuconfig: Add "breadcrumbs" navigation aid

Yann E. MORIN (6):
      kconfig/lxdialog: rationalise the include paths where to find {.n}curses{,w}.h
      kconfig: fix randconfig tristate detection
      kconfig: do not override symbols already set
      kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
      kconfig: allow specifying the seed for randconfig
      kconfig: implement KCONFIG_PROBABILITY for randconfig

 Documentation/kbuild/kconfig.txt           |   36 ++++++++++++++
 scripts/kconfig/conf.c                     |   12 ++++-
 scripts/kconfig/confdata.c                 |   66 ++++++++++++++++++++++---
 scripts/kconfig/list.h                     |   40 +++++++++++++++
 scripts/kconfig/lxdialog/check-lxdialog.sh |    4 +-
 scripts/kconfig/lxdialog/dialog.h          |    7 +++
 scripts/kconfig/lxdialog/util.c            |   45 ++++++++++++++++-
 scripts/kconfig/mconf.c                    |   74 +++++++++++++++++++++++++++-
 8 files changed, 271 insertions(+), 13 deletions(-)

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

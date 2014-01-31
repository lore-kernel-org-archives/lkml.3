Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaAaOap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:30:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaAaOao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:30:44 -0500
Date: Fri, 31 Jan 2014 15:32:03 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging wireless driver for 3.14-rc1
Message-ID: <20140131143203.GA6560@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 77d143de75812596a58d126606f42d1214e09dde:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml (2014-01-26 11:06:16 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.14-rc1

for you to fetch changes up to d7216f8f02da54f8f235c5cca562a55b7f52210d:

  staging: r8821ae: Enable build by reverting BROKEN marking (2014-01-27 09:41:05 -0800)

----------------------------------------------------------------
Staging wireless driver for 3.14-rc1

Here's a single staging driver for a wireless chipset that has shown up
in the SteamBox hardware.  It is merged separately from the "main"
staging pull request to sync up with the wireless api changes that came
in from the networking tree.

It's self-contained and works for me and others.  Larry will be
replacing it with a "real" driver for 3.15, but for now this one is
needed.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (5):
      Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver
      Staging: rtl8821ae: rc.c: fix up function prototypes
      Staging: rtl8821ae: removed unused functions and variables
      Staging: rtl8821ae: add TODO file
      Merge branch 'master' into staging-next

Larry Finger (2):
      staging: r8821ae: Fix build problems
      staging: r8821ae: Enable build by reverting BROKEN marking

Stephen Rothwell (1):
      Staging: rtl8812ae: disable due to build errors

 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/rtl8821ae/Kconfig                  |   11 +
 drivers/staging/rtl8821ae/Makefile                 |   35 +
 drivers/staging/rtl8821ae/TODO                     |   10 +
 drivers/staging/rtl8821ae/base.c                   | 1873 +++++++
 drivers/staging/rtl8821ae/base.h                   |  159 +
 .../staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c  | 3976 ++++++++++++++
 .../staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h  |  205 +
 .../staging/rtl8821ae/btcoexist/habtc8723a1ant.c   | 1614 ++++++
 .../staging/rtl8821ae/btcoexist/habtc8723a1ant.h   |  176 +
 .../staging/rtl8821ae/btcoexist/halbt_precomp.h    |   99 +
 .../staging/rtl8821ae/btcoexist/halbtc8192e1ant.c  | 3891 ++++++++++++++
 .../staging/rtl8821ae/btcoexist/halbtc8192e1ant.h  |  226 +
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.c  | 4242 +++++++++++++++
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.h  |  162 +
 .../staging/rtl8821ae/btcoexist/halbtc8723a2ant.c  | 3780 +++++++++++++
 .../staging/rtl8821ae/btcoexist/halbtc8723a2ant.h  |  179 +
 .../staging/rtl8821ae/btcoexist/halbtc8723b1ant.c  | 4104 +++++++++++++++
 .../staging/rtl8821ae/btcoexist/halbtc8723b1ant.h  |  175 +
 .../staging/rtl8821ae/btcoexist/halbtc8723b2ant.c  | 4185 +++++++++++++++
 .../staging/rtl8821ae/btcoexist/halbtc8723b2ant.h  |  145 +
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c | 1181 +++++
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h |  549 ++
 drivers/staging/rtl8821ae/btcoexist/rtl_btc.c      |  236 +
 drivers/staging/rtl8821ae/btcoexist/rtl_btc.h      |   66 +
 drivers/staging/rtl8821ae/cam.c                    |  354 ++
 drivers/staging/rtl8821ae/cam.h                    |   56 +
 drivers/staging/rtl8821ae/compat.h                 |  125 +
 drivers/staging/rtl8821ae/core.c                   | 1464 ++++++
 drivers/staging/rtl8821ae/core.h                   |   43 +
 drivers/staging/rtl8821ae/debug.c                  |  988 ++++
 drivers/staging/rtl8821ae/debug.h                  |  227 +
 drivers/staging/rtl8821ae/efuse.c                  | 1285 +++++
 drivers/staging/rtl8821ae/efuse.h                  |  130 +
 drivers/staging/rtl8821ae/pci.c                    | 2549 +++++++++
 drivers/staging/rtl8821ae/pci.h                    |  353 ++
 drivers/staging/rtl8821ae/ps.c                     | 1025 ++++
 drivers/staging/rtl8821ae/ps.h                     |   55 +
 drivers/staging/rtl8821ae/rc.c                     |  309 ++
 drivers/staging/rtl8821ae/rc.h                     |   47 +
 drivers/staging/rtl8821ae/regd.c                   |  503 ++
 drivers/staging/rtl8821ae/regd.h                   |   75 +
 drivers/staging/rtl8821ae/rtl8821ae/btc.h          |   87 +
 drivers/staging/rtl8821ae/rtl8821ae/def.h          |  442 ++
 drivers/staging/rtl8821ae/rtl8821ae/dm.c           | 3045 +++++++++++
 drivers/staging/rtl8821ae/rtl8821ae/dm.h           |  426 ++
 drivers/staging/rtl8821ae/rtl8821ae/fw.c           | 1349 +++++
 drivers/staging/rtl8821ae/rtl8821ae/fw.h           |  321 ++
 .../staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c   |  519 ++
 .../staging/rtl8821ae/rtl8821ae/hal_bt_coexist.h   |  169 +
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c      | 2069 ++++++++
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.h      |  160 +
 drivers/staging/rtl8821ae/rtl8821ae/hw.c           | 3346 ++++++++++++
 drivers/staging/rtl8821ae/rtl8821ae/hw.h           |   75 +
 drivers/staging/rtl8821ae/rtl8821ae/led.c          |  239 +
 drivers/staging/rtl8821ae/rtl8821ae/led.h          |   40 +
 drivers/staging/rtl8821ae/rtl8821ae/phy.c          | 5525 ++++++++++++++++++++
 drivers/staging/rtl8821ae/rtl8821ae/phy.h          |  258 +
 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.c       |  199 +
 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.h       |  413 ++
 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.c    |  140 +
 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.h    |   71 +
 drivers/staging/rtl8821ae/rtl8821ae/reg.h          | 2427 +++++++++
 drivers/staging/rtl8821ae/rtl8821ae/rf.c           |  464 ++
 drivers/staging/rtl8821ae/rtl8821ae/rf.h           |   46 +
 drivers/staging/rtl8821ae/rtl8821ae/sw.c           |  499 ++
 drivers/staging/rtl8821ae/rtl8821ae/sw.h           |   39 +
 drivers/staging/rtl8821ae/rtl8821ae/table.c        | 4002 ++++++++++++++
 drivers/staging/rtl8821ae/rtl8821ae/table.h        |   62 +
 drivers/staging/rtl8821ae/rtl8821ae/trx.c          | 1050 ++++
 drivers/staging/rtl8821ae/rtl8821ae/trx.h          |  641 +++
 drivers/staging/rtl8821ae/stats.c                  |  283 +
 drivers/staging/rtl8821ae/stats.h                  |   46 +
 drivers/staging/rtl8821ae/wifi.h                   | 2532 +++++++++
 75 files changed, 71854 insertions(+)
 create mode 100644 drivers/staging/rtl8821ae/Kconfig
 create mode 100644 drivers/staging/rtl8821ae/Makefile
 create mode 100644 drivers/staging/rtl8821ae/TODO
 create mode 100644 drivers/staging/rtl8821ae/base.c
 create mode 100644 drivers/staging/rtl8821ae/base.h
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.c
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.h
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbt_precomp.h
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.c
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.c
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.h
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.c
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.h
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/rtl_btc.c
 create mode 100644 drivers/staging/rtl8821ae/btcoexist/rtl_btc.h
 create mode 100644 drivers/staging/rtl8821ae/cam.c
 create mode 100644 drivers/staging/rtl8821ae/cam.h
 create mode 100644 drivers/staging/rtl8821ae/compat.h
 create mode 100644 drivers/staging/rtl8821ae/core.c
 create mode 100644 drivers/staging/rtl8821ae/core.h
 create mode 100644 drivers/staging/rtl8821ae/debug.c
 create mode 100644 drivers/staging/rtl8821ae/debug.h
 create mode 100644 drivers/staging/rtl8821ae/efuse.c
 create mode 100644 drivers/staging/rtl8821ae/efuse.h
 create mode 100644 drivers/staging/rtl8821ae/pci.c
 create mode 100644 drivers/staging/rtl8821ae/pci.h
 create mode 100644 drivers/staging/rtl8821ae/ps.c
 create mode 100644 drivers/staging/rtl8821ae/ps.h
 create mode 100644 drivers/staging/rtl8821ae/rc.c
 create mode 100644 drivers/staging/rtl8821ae/rc.h
 create mode 100644 drivers/staging/rtl8821ae/regd.c
 create mode 100644 drivers/staging/rtl8821ae/regd.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/btc.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/def.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/dm.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/dm.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/fw.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/fw.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hw.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hw.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/led.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/led.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/phy.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/phy.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/reg.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/rf.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/rf.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/sw.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/sw.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/table.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/table.h
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/trx.c
 create mode 100644 drivers/staging/rtl8821ae/rtl8821ae/trx.h
 create mode 100644 drivers/staging/rtl8821ae/stats.c
 create mode 100644 drivers/staging/rtl8821ae/stats.h
 create mode 100644 drivers/staging/rtl8821ae/wifi.h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaIARjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:39:19 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:19311 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaIARjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:39:16 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL 3/4] at91: drivers for 3.18 #1
Date: Mon, 1 Sep 2014 19:38:46 +0200
Message-ID: <1409593127-24049-3-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1409593127-24049-1-git-send-email-nicolas.ferre@atmel.com>
References: <1409593127-24049-1-git-send-email-nicolas.ferre@atmel.com>
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is the big clenup of the poweroff, reset and ram code that was lying in
setup.c previously. The drivers are now moved to their proper locations and used
in AT91 setup code.

As discussed with Arnd and later on a little bit with Olof in Chicago, I
included in this pull-request the "drivers" code and the "cleanup" code that
should go on top of it. The use of these core drivers result in a modification
of the AT91 core code that depends on the "drivers" branch: it seemed easier to
stack these "cleanup" modifications on top of the drivers themselves instead of
having a "cleanup" branch that depends on a "dt" and "drivers" branch...

To summarize, I merged both the at91-3.18-cleanup and at91-3.18-dt branches  in
this one before adding the "drivers" and then code that enables these drivers.

Tell me what you feel while reading this pull-request, I'll be happy to
re-arrange it so it can suit your flow.

Thanks, best regards,

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-drivers

for you to fetch changes up to 405a72c5e78b5c560c8b2711d4000fa5eb063e1b:

  power: reset: at91-poweroff: fix wakeup status register index (2014-09-01 18:40:44 +0200)

----------------------------------------------------------------
First batch of AT91 drivers for 3.18:
- reset, poweroff and ram drivers are moved to their proper
  location instead of being in mach-at91 directory. They now use
  the appropriate frameworks.
- big amount of removal of these machine specific drivers and use
  of the newly created drivers. This lead to an overhaul of the setup.c AT91
  startup code.

----------------------------------------------------------------
Alexandre Belloni (7):
      ARM: at91: Add new binding for sama5d3-ddramc
      memory: add a driver for atmel ram controllers
      ARM: at91: select ATMEL_SDRAMC when using OF
      clk: at91: remove the useless CLK_IGNORE_UNUSED flag
      ARM: at91/dt: sama5d3: define mpddr clock and ramc clocks
      ARM: at91/dt: at91sam9: use ddrck in ramc
      ARM: at91: fix ramc standby function registration

Boris BREZILLON (4):
      ARM: at91: introduce OLD_IRQ_AT91 Kconfig option
      ARM: at91: enclose at91_aic_xx calls in IS_ENABLED(CONFIG_OLD_IRQ_AT91) blocks
      ARM: at91: make use of the new AIC driver for dt enabled boards
      ARM: at91: remove old irq material

Maxime Ripard (18):
      power: reset: Add if statement instead of multiple depends on
      power: reset: Add AT91 reset driver
      power: reset: Add AT91 poweroff driver
      ARM: at91/dt: Declare a second ram controller when relevant
      ARM: at91/dt: sama5d3: Add shutdown controller
      ARM: at91: setup: Switch to pr_fmt
      ARM: at91: Rework ramc mapping code
      ARM: at91: Remove the old-style reset probing
      ARM: at91/soc: Introduce register_devices callback
      ARM: at91: Probe the reset driver
      ARM: at91: Call at91_register_devices in the board files
      ARM: at91: Remove reset code from the machine code
      ARM: at91: Remove poweroff DT probing
      ARM: at91: Register the poweroff driver
      ARM: at91: Remove poweroff code
      ARM: at91/pm: Remove show_reset_status function
      ARM: at91: Remove rstc and shdwnc global base addresses
      ARM: at91: Remove rstc and shdwc headers

Nicolas Ferre (5):
      Merge tag 'at91-dt-for-3.17' of git://git.kernel.org/.../mripard/linux
      Merge branches 'at91-3.18-cleanup' and 'at91-3.18-dt' into at91-3.18-drivers
      Merge tag 'at91-drivers-for-3.17' of git://git.kernel.org/.../mripard/linux
      ARM: at91/power/reset: fix Kconfig "depends on" directive
      power: reset: at91-poweroff: fix wakeup status register index

 .../devicetree/bindings/arm/atmel-at91.txt         |   8 +-
 arch/arm/boot/dts/at91sam9263.dtsi                 |  10 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  10 +-
 arch/arm/boot/dts/at91sam9n12.dtsi                 |   2 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   2 +
 arch/arm/boot/dts/sama5d3.dtsi                     |  14 +-
 arch/arm/mach-at91/Kconfig                         |  25 +-
 arch/arm/mach-at91/Kconfig.non_dt                  |   6 +
 arch/arm/mach-at91/Makefile                        |   5 +-
 arch/arm/mach-at91/at91_rstc.h                     |  53 ----
 arch/arm/mach-at91/at91_shdwc.h                    |  50 ----
 arch/arm/mach-at91/at91sam9260.c                   |  45 +++-
 arch/arm/mach-at91/at91sam9261.c                   |  45 +++-
 arch/arm/mach-at91/at91sam9263.c                   |  45 +++-
 arch/arm/mach-at91/at91sam9_alt_reset.S            |  40 ---
 arch/arm/mach-at91/at91sam9g45.c                   |  49 +++-
 arch/arm/mach-at91/at91sam9g45_reset.S             |  45 ----
 arch/arm/mach-at91/at91sam9rl.c                    |  45 +++-
 arch/arm/mach-at91/board-afeb-9260v1.c             |   2 +
 arch/arm/mach-at91/board-cam60.c                   |   2 +
 arch/arm/mach-at91/board-cpu9krea.c                |   2 +
 arch/arm/mach-at91/board-dt-rm9200.c               |  13 -
 arch/arm/mach-at91/board-dt-sam9.c                 |  13 -
 arch/arm/mach-at91/board-dt-sama5.c                |  13 -
 arch/arm/mach-at91/board-flexibity.c               |   2 +
 arch/arm/mach-at91/board-sam9-l9260.c              |   2 +
 arch/arm/mach-at91/board-sam9260ek.c               |   3 +-
 arch/arm/mach-at91/board-sam9261ek.c               |   3 +-
 arch/arm/mach-at91/board-sam9263ek.c               |   3 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c            |   3 +-
 arch/arm/mach-at91/board-sam9rlek.c                |   3 +-
 arch/arm/mach-at91/board-snapper9260.c             |   2 +
 arch/arm/mach-at91/generic.h                       |  10 +-
 arch/arm/mach-at91/irq.c                           | 270 +--------------------
 arch/arm/mach-at91/pm.c                            | 104 ++------
 arch/arm/mach-at91/setup.c                         | 183 +++-----------
 arch/arm/mach-at91/soc.h                           |   1 +
 drivers/clk/at91/clk-system.c                      |   8 +-
 drivers/memory/Kconfig                             |  10 +
 drivers/memory/Makefile                            |   1 +
 drivers/memory/atmel-sdramc.c                      |  98 ++++++++
 drivers/power/reset/Kconfig                        |  33 ++-
 drivers/power/reset/Makefile                       |   2 +
 drivers/power/reset/at91-poweroff.c                | 156 ++++++++++++
 drivers/power/reset/at91-reset.c                   | 252 +++++++++++++++++++
 45 files changed, 891 insertions(+), 802 deletions(-)
 delete mode 100644 arch/arm/mach-at91/at91_rstc.h
 delete mode 100644 arch/arm/mach-at91/at91_shdwc.h
 delete mode 100644 arch/arm/mach-at91/at91sam9_alt_reset.S
 delete mode 100644 arch/arm/mach-at91/at91sam9g45_reset.S
 create mode 100644 drivers/memory/atmel-sdramc.c
 create mode 100644 drivers/power/reset/at91-poweroff.c
 create mode 100644 drivers/power/reset/at91-reset.c

-- 
Nicolas Ferre

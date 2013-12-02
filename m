Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3LBRBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:01:46 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:29706 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3LBRBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:01:44 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [GIT PULL] at91: cleanup for 3.14 #1 (aka move to CCF)
Date: Mon, 2 Dec 2013 18:01:41 +0100
Message-ID: <1386003701-29760-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is the big move of AT91 to Common Clock Framework for 3.14. I collected
all the material as a "cleanup" topic so that the CCF can be considered as a
base for all our AT91 patches for 3.14.
I prefer to have the sama5d3 use of AT91 CCF included into this pull-request
so that it can be read as an example and clearly states that it has been tested
in real life.
We agreed with Mike to send this work upstream through arm-soc so that we will
be able to stack other patches for 3.14 on top of that work without having to
deal with conflicts.

For merging with the "fixes" pull-request that I sent earlier today, I also
uploaded a little branch for reference:
at91-3.14-next_fixes_cleanup_dt-resolution.
In two words, the clock section of the arch/arm/mach-at91/sama5d3.c file
has to be deleted.

Do not hesitate to ask questions about this material.

Thanks, best regards,

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-cleanup

for you to fetch changes up to b46e837d8ef1f3c777bbf9513e2cdb5d87d6c374:

  ARM: at91/dt: remove old clk material (2013-12-02 15:31:29 +0100)

----------------------------------------------------------------
AT91: Move to Common Clock Framework and sama5d3 implementation
This is the first step to move AT91 to the CCF.
- core CCF and drivers for most of the clocks
- use of CCF for sama5d3 (100% DT-based)

----------------------------------------------------------------
Boris BREZILLON (22):
      ARM: at91: move at91_pmc.h to include/linux/clk/at91_pmc.h
      ARM: at91: add Kconfig options for common clk support
      clk: at91: add PMC base support
      clk: at91: add PMC macro file for dt definitions
      clk: at91: add PMC main clock
      clk: at91: add PMC pll clocks
      clk: at91: add PMC master clock
      clk: at91: add PMC system clocks
      clk: at91: add PMC peripheral clocks
      clk: at91: add PMC programmable clocks
      clk: at91: add PMC utmi clock
      clk: at91: add PMC usb clock
      clk: at91: add PMC smd clock
      dt: binding: add at91 clks dt bindings documentation
      ARM: at91: move pit timer to common clk framework
      ARM: at91: add new compatible strings for pmc driver
      ARM: at91: prepare sama5 dt boards transition to common clk
      ARM: at91: prepare common clk transition for sama5d3 SoC
      ARM: at91/dt: define sama5d3 clocks
      ARM: at91/dt: define sama5d3xek's main clk frequency
      ARM: at91: move sama5d3 SoC to common clk
      ARM: at91/dt: remove old clk material

 .../devicetree/bindings/clock/at91-clock.txt       | 339 +++++++++++++
 arch/arm/boot/dts/sama5d3.dtsi                     | 379 ++++++++++++++-
 arch/arm/boot/dts/sama5d3_can.dtsi                 |  20 +
 arch/arm/boot/dts/sama5d3_emac.dtsi                |  11 +
 arch/arm/boot/dts/sama5d3_gmac.dtsi                |  11 +
 arch/arm/boot/dts/sama5d3_lcd.dtsi                 |  17 +
 arch/arm/boot/dts/sama5d3_mci2.dtsi                |  12 +
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                |  12 +
 arch/arm/boot/dts/sama5d3_uart.dtsi                |  21 +
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |  17 +-
 arch/arm/mach-at91/Kconfig                         |  43 ++
 arch/arm/mach-at91/Kconfig.non_dt                  |   6 +
 arch/arm/mach-at91/Makefile                        |   2 +-
 arch/arm/mach-at91/at91rm9200.c                    |   2 +-
 arch/arm/mach-at91/at91sam9260.c                   |   2 +-
 arch/arm/mach-at91/at91sam9261.c                   |   2 +-
 arch/arm/mach-at91/at91sam9263.c                   |   2 +-
 arch/arm/mach-at91/at91sam926x_time.c              |  14 +-
 arch/arm/mach-at91/at91sam9g45.c                   |   2 +-
 arch/arm/mach-at91/at91sam9n12.c                   |   2 +-
 arch/arm/mach-at91/at91sam9rl.c                    |   2 +-
 arch/arm/mach-at91/at91sam9x5.c                    |   2 +-
 arch/arm/mach-at91/board-dt-sama5.c                |  10 +-
 arch/arm/mach-at91/clock.c                         |   7 +-
 arch/arm/mach-at91/generic.h                       |   3 +-
 arch/arm/mach-at91/pm.c                            |   2 +-
 arch/arm/mach-at91/pm_slowclock.S                  |   2 +-
 arch/arm/mach-at91/sama5d3.c                       | 344 +------------
 arch/arm/mach-at91/setup.c                         |   8 +-
 drivers/clk/Makefile                               |   1 +
 drivers/clk/at91/Makefile                          |  12 +
 drivers/clk/at91/clk-main.c                        | 187 ++++++++
 drivers/clk/at91/clk-master.c                      | 270 +++++++++++
 drivers/clk/at91/clk-peripheral.c                  | 410 ++++++++++++++++
 drivers/clk/at91/clk-pll.c                         | 531 +++++++++++++++++++++
 drivers/clk/at91/clk-plldiv.c                      | 135 ++++++
 drivers/clk/at91/clk-programmable.c                | 366 ++++++++++++++
 drivers/clk/at91/clk-smd.c                         | 171 +++++++
 drivers/clk/at91/clk-system.c                      | 135 ++++++
 drivers/clk/at91/clk-usb.c                         | 398 +++++++++++++++
 drivers/clk/at91/clk-utmi.c                        | 159 ++++++
 drivers/clk/at91/pmc.c                             | 397 +++++++++++++++
 drivers/clk/at91/pmc.h                             | 116 +++++
 drivers/usb/gadget/atmel_usba_udc.c                |   2 +-
 include/dt-bindings/clk/at91.h                     |  22 +
 .../include/mach => include/linux/clk}/at91_pmc.h  |   4 +-
 46 files changed, 4237 insertions(+), 375 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/at91-clock.txt
 create mode 100644 drivers/clk/at91/Makefile
 create mode 100644 drivers/clk/at91/clk-main.c
 create mode 100644 drivers/clk/at91/clk-master.c
 create mode 100644 drivers/clk/at91/clk-peripheral.c
 create mode 100644 drivers/clk/at91/clk-pll.c
 create mode 100644 drivers/clk/at91/clk-plldiv.c
 create mode 100644 drivers/clk/at91/clk-programmable.c
 create mode 100644 drivers/clk/at91/clk-smd.c
 create mode 100644 drivers/clk/at91/clk-system.c
 create mode 100644 drivers/clk/at91/clk-usb.c
 create mode 100644 drivers/clk/at91/clk-utmi.c
 create mode 100644 drivers/clk/at91/pmc.c
 create mode 100644 drivers/clk/at91/pmc.h
 create mode 100644 include/dt-bindings/clk/at91.h
 rename {arch/arm/mach-at91/include/mach => include/linux/clk}/at91_pmc.h (98%)

-- 
Nicolas Ferre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaGGPNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:13:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43563 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaGGPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:13:48 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de, grant.likely@linaro.org,
        matthias.bgg@gmail.com, thierry.reding@gmail.com,
        florian.vaussard@epfl.ch, jic23@kernel.org, jason@lakedaemon.net,
        andrew@lunn.ch, silvio.fricke@gmail.com, heiko.stuebner@bq.com,
        olof@lixom.net, sebastian.hesselbarth@gmail.com, sboyd@codeaurora.org,
        gregory.clement@free-electrons.com, arnd@arndb.de,
        robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        shawn.guo@freescale.com, anders.berg@lsi.com, linus.walleij@linaro.org,
        ak@linux.intel.com, hpa@linux.intel.com, akpm@linux-foundation.org,
        u.kleine-koenig@pengutronix.de, gregkh@linuxfoundation.org,
        fabf@skynet.be, rostedt@goodmis.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v10 0/7] arm: Add basic support for Mediatek Cortex-A7 SoCs
Date: Mon,  7 Jul 2014 17:13:01 +0200
Message-Id: <1404745988-32558-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tenth round for the Mediatek basic support patches.

The main change is the return of IOMEM_ERR_PTR in case of error in
of_io_request_and_map.
The call follows the same logic as devm_ioremap_resource.

For the changes of the of_io_request_and_map patch I deleted the ack from Grant Likely, as the patch changes significantly.
In the case of the dt bindings for the timer I left the ack lines from Soeren and Rob. I hope there is no problem with that.

---
This patch set adds basic support for the Mediatek Cortex-A7 SoCs.
Support is quite basic, as the only component working up to now are the
timers.

The patch series is build against tag v3.16-rc1 from torvalds/master tree.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

Changes for v10:
1. OF address
- return IOMEM_ERR_PTR in case of error

2. clocksource timer
- check for IS_ERR when calling of_io_request_and_map

3. clocksource DT binding
- remove clock-names property


Changes for v9:
- rebase against tip branch


Changes for v8:
1. OF address
- fix style issue

2. clocksource driver
- fix style issue

3. Basic SoC support
- define the clock node as a simple-bus
- delete unused clock-ranges


Changes for v7:
1. OF address
- add of_io_request_and_map

2. Clocksource timer
- use pr_warnings and error handling instead of panic
- fix macro parentheses
- use of_io_request_and_map

3. Others
- rename SoC DT bindings to mediatek.txt
- fixed typos


Changes for v6:
- fix compatible string of the timer
- encapsulate timer setup in function
- add more information to the timer commit message
- add address in timer DTS bindings documentation


Changes for v5:
1. Clocksource timer
- Change the compatible string to mt6577

2. Timer DT bindings
- Change compatible string to mt6577


Changes for v4:
1. Clocksource timer
- use cpu_possible_mask

2. Timer DT bindings
- Delete comments about the frequency of the clocks
- Add clock-names for the input clocks

3. Basic SoC support
- add clock-names for the timer
- rename the label of the clocks nodes


Changes for v3:
1. Clocksource timer
- Set cpu_mask_all and irq in clock_event_device
- Use device private structure for driver specific values

2. Timer DT bindings
- Define order of the clock phandles
- Fix typos

3. Basic SoC support
- DTS: set gic to a15-gic
- DTS: order by physical address
- Remove call to dt_init function


Changes for v2:
1. Clocksource timer
- Delete unused parts for sched_clock_source
- Use irq_request instead of setup_irq
- Remove unused SMP parts
- Fix some style issues
- use of_address_to resource and request_mem_region
- delete use of named clock
- select CLKSRC_MMIO in driver Kconfig

2. DT bindings
- delete named clock bindings

3. Basic SoC support
- Clean-up Kconfig
- Add documentation of the SoC compatible property 
- DTS: rename SoC file to mt6589.dts
- DTS: Delete not present cache controller
- DTS: Add missing GICv2 properties
- DTS: Change clock names
- DTS: Add Aquaris5 board

4. Add earlyprintk
- patch droped until serial driver is available

5. Add support for Aquaris5 mobile phone


Matthias Brugger (7):
  of: Provide function to request and map memory
  clocksource: Add support for the Mediatek SoCs
  dt-bindings: add mtk-timer bindings
  vendor-prefixes: add prefix for Mediatek Inc.
  arm: add basic support for Mediatek MT6589 boards
  dt-bindings: add documentation for Mediatek SoC
  arm: mediatek: add dts for Aquaris5 mobile phone

 Documentation/devicetree/bindings/arm/mediatek.txt |    8 +
 .../bindings/timer/mediatek,mtk-timer.txt          |   17 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm/Kconfig                                   |    2 +
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/dts/mt6589-aquaris5.dts              |   25 ++
 arch/arm/boot/dts/mt6589.dtsi                      |   94 +++++++
 arch/arm/mach-mediatek/Kconfig                     |    6 +
 arch/arm/mach-mediatek/Makefile                    |    1 +
 arch/arm/mach-mediatek/mediatek.c                  |   27 ++
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/mtk_timer.c                    |  261 ++++++++++++++++++++
 drivers/of/address.c                               |   36 +++
 include/linux/io.h                                 |    2 +
 include/linux/of_address.h                         |   11 +
 lib/devres.c                                       |    2 -
 17 files changed, 498 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek.txt
 create mode 100644 Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
 create mode 100644 arch/arm/boot/dts/mt6589-aquaris5.dts
 create mode 100644 arch/arm/boot/dts/mt6589.dtsi
 create mode 100644 arch/arm/mach-mediatek/Kconfig
 create mode 100644 arch/arm/mach-mediatek/Makefile
 create mode 100644 arch/arm/mach-mediatek/mediatek.c
 create mode 100644 drivers/clocksource/mtk_timer.c

-- 
1.7.9.5


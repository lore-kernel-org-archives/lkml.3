Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3EYLId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 07:08:33 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41254 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3EYLIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 07:08:32 -0400
From: Daniel Tang <dt.tangr@gmail.com>
To: linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>
Cc: Daniel Tang <dt.tangr@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
Subject: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
Date: Sat, 25 May 2013 21:08:01 +1000
Message-Id: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes between http://archive.arm.linux.org.uk/lurker/message/20130408.113343.585af217.en.html and v2:
* Added new drivers to support the irqchip and timers on older models.
* Added new device trees to support the other models.

Changes between v2 and v3:
* Clean up keypad driver
* Update copyright messages (2012->2013)
* Added clock driver
* Fix keypad support for classic models
* Fix nspire-classic-timer code to use updated CLOCKSOURCE_OF_DECLARE
* Change CLCD code to use panel capabilities
* Change UART clock to match APB speed
* Support for reset

Changes between v3 and v4:
* Remove redundant clock-names in device tree
* Re-enable bus access to some peripherals on bootup
* Clean up nspire-classic-timer code.
  - Implement a nspire_timer_set_mode function
  - Removed messy IO_MATCHx and CNTL_MATCHx macros
  - Timer starts disabled to begin with
  - Interrupt handling code return IRQ_NONE for spurious interrupts
  - Delete unnessecary shift
* Change clk-nspire to use compatible property to determine IO type
* Change device tree bindings to have appropriate vendor prefixes
* Added device tree binding documentation
* Fix incorrect register addresses for clocks
* Use more specific .caps for CLCD

Daniel Tang (6):
  arm: TI-Nspire platform code
  arm: TI-Nspire device trees
  clk: TI-Nspire clock drivers
  clocksource: TI-Nspire timer support
  input: TI-Nspire keypad support
  irqchip: TI-Nspire irqchip support

 .../devicetree/bindings/clock/nspire-clock.txt     |  24 ++
 .../devicetree/bindings/input/ti,nspire-keypad.txt |  60 ++++
 .../interrupt-controller/lsi,zevio-intc.txt        |  18 ++
 .../devicetree/bindings/timer/lsi,zevio-timer.txt  |  33 +++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/arm/Kconfig                                   |   2 +
 arch/arm/Kconfig.debug                             |  16 ++
 arch/arm/Makefile                                  |   1 +
 arch/arm/boot/dts/Makefile                         |   3 +
 arch/arm/boot/dts/nspire-classic.dtsi              |  74 +++++
 arch/arm/boot/dts/nspire-clp.dts                   |  45 +++
 arch/arm/boot/dts/nspire-cx.dts                    | 112 ++++++++
 arch/arm/boot/dts/nspire-tp.dts                    |  44 +++
 arch/arm/boot/dts/nspire.dtsi                      | 175 ++++++++++++
 arch/arm/include/debug/nspire.S                    |  28 ++
 arch/arm/mach-nspire/Kconfig                       |  15 +
 arch/arm/mach-nspire/Makefile                      |   2 +
 arch/arm/mach-nspire/Makefile.boot                 |   0
 arch/arm/mach-nspire/clcd.c                        | 119 ++++++++
 arch/arm/mach-nspire/clcd.h                        |  14 +
 arch/arm/mach-nspire/mmio.h                        |  23 ++
 arch/arm/mach-nspire/nspire.c                      | 117 ++++++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-nspire.c                           | 155 ++++++++++
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/zevio-timer.c                  | 231 +++++++++++++++
 drivers/input/keyboard/Kconfig                     |  10 +
 drivers/input/keyboard/Makefile                    |   1 +
 drivers/input/keyboard/nspire-keypad.c             | 315 +++++++++++++++++++++
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-zevio.c                        | 177 ++++++++++++
 31 files changed, 1818 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/nspire-clock.txt
 create mode 100644 Documentation/devicetree/bindings/input/ti,nspire-keypad.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/lsi,zevio-intc.txt
 create mode 100644 Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
 create mode 100644 arch/arm/boot/dts/nspire-classic.dtsi
 create mode 100644 arch/arm/boot/dts/nspire-clp.dts
 create mode 100644 arch/arm/boot/dts/nspire-cx.dts
 create mode 100644 arch/arm/boot/dts/nspire-tp.dts
 create mode 100644 arch/arm/boot/dts/nspire.dtsi
 create mode 100644 arch/arm/include/debug/nspire.S
 create mode 100644 arch/arm/mach-nspire/Kconfig
 create mode 100644 arch/arm/mach-nspire/Makefile
 create mode 100644 arch/arm/mach-nspire/Makefile.boot
 create mode 100644 arch/arm/mach-nspire/clcd.c
 create mode 100644 arch/arm/mach-nspire/clcd.h
 create mode 100644 arch/arm/mach-nspire/mmio.h
 create mode 100644 arch/arm/mach-nspire/nspire.c
 create mode 100644 drivers/clk/clk-nspire.c
 create mode 100644 drivers/clocksource/zevio-timer.c
 create mode 100644 drivers/input/keyboard/nspire-keypad.c
 create mode 100644 drivers/irqchip/irq-zevio.c

--
1.8.1.3


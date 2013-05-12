Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999Ab3ELEXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 00:23:23 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40967 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3ELEXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 00:23:22 -0400
From: Daniel Tang <dt.tangr@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: Daniel Tang <dt.tangr@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
Subject: [RFC PATCHv3 0/6] arm: Initial TI-Nspire support
Date: Sun, 12 May 2013 14:22:55 +1000
Message-Id: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com>
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


First time using git send-email, please forgive me if this turns pear shaped.

Daniel Tang (6):
  arm: Initial TI-Nspire support
  arm: Add device trees for TI-Nspire
  clk: Add TI-Nspire clock drivers
  clocksource: Add TI-Nspire timer drivers
  input: Add TI-Nspire keypad driver
  irqchip: Add TI-Nspire irqchip

 arch/arm/Kconfig                           |   2 +
 arch/arm/Kconfig.debug                     |  16 ++
 arch/arm/Makefile                          |   1 +
 arch/arm/boot/dts/Makefile                 |   3 +
 arch/arm/boot/dts/nspire-classic.dtsi      |  75 +++++++
 arch/arm/boot/dts/nspire-clp.dts           |  45 +++++
 arch/arm/boot/dts/nspire-cx.dts            | 112 ++++++++++
 arch/arm/boot/dts/nspire-tp.dts            |  44 ++++
 arch/arm/boot/dts/nspire.dtsi              | 182 +++++++++++++++++
 arch/arm/include/debug/nspire.S            |  28 +++
 arch/arm/mach-nspire/Kconfig               |  15 ++
 arch/arm/mach-nspire/Makefile              |   2 +
 arch/arm/mach-nspire/Makefile.boot         |   0
 arch/arm/mach-nspire/clcd.c                | 117 +++++++++++
 arch/arm/mach-nspire/clcd.h                |  14 ++
 arch/arm/mach-nspire/mmio.h                |  18 ++
 arch/arm/mach-nspire/nspire.c              |  99 +++++++++
 drivers/clk/Makefile                       |   1 +
 drivers/clk/clk-nspire.c                   | 141 +++++++++++++
 drivers/clocksource/Makefile               |   1 +
 drivers/clocksource/nspire-classic-timer.c | 199 ++++++++++++++++++
 drivers/input/keyboard/Kconfig             |  10 +
 drivers/input/keyboard/Makefile            |   1 +
 drivers/input/keyboard/nspire-keypad.c     | 315 +++++++++++++++++++++++++++++
 drivers/irqchip/Makefile                   |   1 +
 drivers/irqchip/irq-nspire-classic.c       | 177 ++++++++++++++++
 26 files changed, 1619 insertions(+)
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
 create mode 100644 drivers/clocksource/nspire-classic-timer.c
 create mode 100644 drivers/input/keyboard/nspire-keypad.c
 create mode 100644 drivers/irqchip/irq-nspire-classic.c

-- 
1.8.1.3


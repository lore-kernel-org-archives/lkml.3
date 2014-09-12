Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaILPn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:43:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55575 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751283AbaILPnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:43:25 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 0/8] Initial support for the Atmel SMART sama5d4
Date: Fri, 12 Sep 2014 17:42:59 +0200
Message-Id: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce support for the Atmel SMART sama5d4.

Note that some drivers will complain that they can't work without DMA and the
probe will fail. This will be solved when the dma driver hits mainline, it is
still under review.

Changes in v2:
 - Documented the Atmel SoC compatibles
 - Documented the new AIC compatible
 - Corrected the compatible for the gigabit ethernet IP
 - Reworked the L2 cache support
 - Removed unnecessary definitions
 - Added back CONFIG_MTD_M25P80 to the defconfig

Alexandre Belloni (4):
  irqchip: atmel-aic5: Add sama5d4 support
  clk: at91: add a driver for the h32mx clock
  ARM: at91: add sama5d4 support to sama5_defconfig
  ARM: at91: document Atmel SMART compatibles

Nicolas Ferre (4):
  ARM: at91: introduce basic SAMA5D4 support
  ARM: at91: SAMA5D4 SoC detection code and low level routines
  ARM: at91: dt: add device tree file for SAMA5D4 SoC
  ARM: at91: dt: add device tree file for SAMA5D4ek board

 .../devicetree/bindings/arm/atmel-at91.txt         |   40 +
 .../devicetree/bindings/clock/at91-clock.txt       |   15 +
 .../bindings/interrupt-controller/atmel,aic.txt    |    2 +-
 arch/arm/Kconfig.debug                             |    4 +
 arch/arm/boot/dts/Makefile                         |    2 +
 arch/arm/boot/dts/at91-sama5d4ek.dts               |  308 +++++
 arch/arm/boot/dts/sama5d4.dtsi                     | 1233 ++++++++++++++++++++
 arch/arm/configs/sama5_defconfig                   |    1 +
 arch/arm/mach-at91/Kconfig                         |   21 +
 arch/arm/mach-at91/Makefile                        |    1 +
 arch/arm/mach-at91/board-dt-sama5.c                |   17 +-
 arch/arm/mach-at91/generic.h                       |    1 +
 arch/arm/mach-at91/include/mach/cpu.h              |   22 +-
 arch/arm/mach-at91/include/mach/debug-macro.S      |    5 +-
 arch/arm/mach-at91/include/mach/hardware.h         |   19 +-
 arch/arm/mach-at91/include/mach/sama5d4.h          |   33 +
 arch/arm/mach-at91/include/mach/uncompress.h       |   21 +-
 arch/arm/mach-at91/sama5d4.c                       |   64 +
 arch/arm/mach-at91/setup.c                         |   97 +-
 arch/arm/mach-at91/soc.h                           |    5 +
 drivers/clk/at91/Makefile                          |    1 +
 drivers/clk/at91/clk-h32mx.c                       |  121 ++
 drivers/clk/at91/pmc.c                             |    6 +
 drivers/clk/at91/pmc.h                             |    5 +
 drivers/irqchip/irq-atmel-aic5.c                   |   10 +
 include/linux/clk/at91_pmc.h                       |    1 +
 26 files changed, 2042 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91-sama5d4ek.dts
 create mode 100644 arch/arm/boot/dts/sama5d4.dtsi
 create mode 100644 arch/arm/mach-at91/include/mach/sama5d4.h
 create mode 100644 arch/arm/mach-at91/sama5d4.c
 create mode 100644 drivers/clk/at91/clk-h32mx.c

-- 
1.9.1


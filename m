Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaLWH7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:59:33 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42117 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbaLWH72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:59:28 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 0/8] ARM: Conexant Digicolor CX92755 SoC support
Date: Tue, 23 Dec 2014 09:58:37 +0200
Message-Id: <cover.1419318109.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds initial support for the Conexant CX92755 SoC. The CX92755 is
one of the Digicolor series of SoCs, all sharing many of the same peripherals.
The code was tested on the CX92755 evaluation kit, AKA Equinox.

Uses attempting to try this code will most likely also want the UART/console
driver available from https://patchwork.kernel.org/patch/5515861/.

Baruch Siach (8):
  ARM: initial support for Conexant Digicolor CX92755 SoC
  ARM: digicolor: add low level debug support
  ARM: digicolor: add minimal device tree description
  ARM: devicetree: document supported Conexant Digicolor SoC
  irqchip: Conexant CX92755 interrupts controller driver
  irqchip: devicetree: document Conexant Digicolor irq binding
  clocksource: driver for Conexant Digicolor SoC timer
  clocksource: devicetree: document Conexant Digicolor timer binding

 .../devicetree/bindings/arm/digicolor.txt          |   6 +
 .../bindings/interrupt-controller/digicolor-ic.txt |  20 +++
 .../devicetree/bindings/timer/digicolor-timer.txt  |  18 +++
 arch/arm/Kconfig                                   |   2 +
 arch/arm/Kconfig.debug                             |  12 +-
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/conexant_equinox.dts             |  67 +++++++++
 arch/arm/boot/dts/cx92755.dtsi                     | 103 ++++++++++++++
 arch/arm/include/debug/digicolor.S                 |  35 +++++
 arch/arm/mach-digicolor/Kconfig                    |   4 +
 arch/arm/mach-digicolor/Makefile                   |   1 +
 arch/arm/mach-digicolor/digicolor.c                |  19 +++
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/timer-digicolor.c              | 155 +++++++++++++++++++++
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-digicolor.c                    | 135 ++++++++++++++++++
 16 files changed, 578 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/digicolor.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
 create mode 100644 Documentation/devicetree/bindings/timer/digicolor-timer.txt
 create mode 100644 arch/arm/boot/dts/conexant_equinox.dts
 create mode 100644 arch/arm/boot/dts/cx92755.dtsi
 create mode 100644 arch/arm/include/debug/digicolor.S
 create mode 100644 arch/arm/mach-digicolor/Kconfig
 create mode 100644 arch/arm/mach-digicolor/Makefile
 create mode 100644 arch/arm/mach-digicolor/digicolor.c
 create mode 100644 drivers/clocksource/timer-digicolor.c
 create mode 100644 drivers/irqchip/irq-digicolor.c

-- 
2.1.3


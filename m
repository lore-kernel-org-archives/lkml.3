Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3JHMYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:24:46 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:55642 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab3JHMYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:24:44 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] ARM: Initial support for Marvell Berlin SoCs
Date: Tue,  8 Oct 2013 14:24:25 +0200
Message-Id: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set add initial support for Marvell Berlin SoCs (88DE3xxx),
e.g. Armada 1000, Armada 1500, Armada 1500-mini. It is based on two
RFCs [1][2] sent earlier.

Currently, initial support just means that the kernel boots on one
CPU, sets up irq, timers, and UART. As Berlin SoCs share some amount
of IP with Marvell PXA/MMP[23] SoCs plus some Synopsys DW IP, I expect
functionality to grow quite quickly.

Compared to last RFC sent, this patch set now depends on ARM's arch-wide
call to of_clk_init [3] plus some fixes already pulled for Synopsys DW
timers [4]. It is based on v3.12-rc4 with those two dependencies pulled
in.

I also prepared a branch for those able to test on a jail-broken GoogleTV
or similar with open boot loader at
https://github.com/shesselba/linux-berlin.git berlin-v1

[1] https://lkml.org/lkml/2013/8/16/626
[2] https://lkml.org/lkml/2013/8/27/608
[3] http://www.spinics.net/lists/arm-kernel/msg276175.html
[4] http://www.spinics.net/lists/arm-kernel/msg277763.html

Sebastian Hesselbarth (8):
  irqchip: add DesignWare APB ICTL interrupt controller
  MAINTAINERS: add ARM Marvell Berlin SoC
  ARM: l2x0: add Marvell Tauros3 compatible
  ARM: add Marvell Berlin SoC familiy to Marvell doc
  ARM: add Marvell Berlin and Armada 1500 to multi_v7_defconfig
  ARM: add Marvell Berlin UART0 lowlevel debug
  ARM: add Armada 1500 and Sony NSZ-GS7 device tree files
  ARM: add initial support for Marvell Berlin SoCs

 Documentation/arm/Marvell/README                   |   29 +++
 Documentation/devicetree/bindings/arm/l2cc.txt     |   22 +-
 .../devicetree/bindings/arm/marvell,berlin.txt     |   23 ++
 .../interrupt-controller/snps,dw-apb-ictl.txt      |   29 +++
 MAINTAINERS                                        |    6 +
 arch/arm/Kconfig                                   |    2 +
 arch/arm/Kconfig.debug                             |   10 +
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/dts/Makefile                         |    2 +
 arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts      |   29 +++
 arch/arm/boot/dts/mv88de3100.dtsi                  |  227 ++++++++++++++++++++
 arch/arm/configs/multi_v7_defconfig                |    2 +
 arch/arm/mach-berlin/Kconfig                       |   24 +++
 arch/arm/mach-berlin/Makefile                      |    1 +
 arch/arm/mach-berlin/berlin.c                      |   39 ++++
 arch/arm/mm/cache-l2x0.c                           |    1 +
 drivers/irqchip/Kconfig                            |    4 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-dw-apb-ictl.c                  |  142 ++++++++++++
 19 files changed, 583 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,berlin.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
 create mode 100644 arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts
 create mode 100644 arch/arm/boot/dts/mv88de3100.dtsi
 create mode 100644 arch/arm/mach-berlin/Kconfig
 create mode 100644 arch/arm/mach-berlin/Makefile
 create mode 100644 arch/arm/mach-berlin/berlin.c
 create mode 100644 drivers/irqchip/irq-dw-apb-ictl.c

---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4


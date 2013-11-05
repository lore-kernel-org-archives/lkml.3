Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3KEO27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:28:59 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:38259 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3KEO2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:28:55 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@kernel.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/9] ARM: Initial support for Marvell Berlin SoCs
Date: Tue,  5 Nov 2013 15:28:34 +0100
Message-Id: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another kernel release, another Berlin SoC patch set...

This patch set add initial support for Marvell Berlin SoCs, e.g.
Armada 1000, Armada 1500, Armada 1500-mini.

Currently, initial support just means that the kernel boots on one
CPU, sets up irq, timers, and UART. As Berlin SoCs share some amount
of IP with Marvell PXA/MMP[23] SoCs plus some Synopsys DW IP, I expect
functionality to grow quite quickly. I do have further patches for
SMP but do not want to stall this patch set even further.

Compared to last version sent, this patch set adds additional support
for the Armada 1500-mini and the Google Chromecast. It is based on
v3.12 and still depends on on ARM's arch-wide call to of_clk_init [3]
plus some fixes for Synopsys DWtimers [4]. 

This patch set is indended for v3.13. I hope to the last Acks required
from Thomas Gleixner and the DT maintainers, rebase on v3.13-rc1 and
send the pull request.

I also prepared a branch for those able to test with open boot loader
on GoogleTV or Chromecast at
https://github.com/shesselba/linux-berlin.git topic/initial

[1] https://lkml.org/lkml/2013/8/16/626
[2] https://lkml.org/lkml/2013/8/27/608
[3] http://www.spinics.net/lists/arm-kernel/msg276175.html
[4] http://www.spinics.net/lists/arm-kernel/msg277763.html

Sebastian Hesselbarth (9):
  irqchip: add DesignWare APB ICTL interrupt controller
  MAINTAINERS: add ARM Marvell Berlin SoC
  ARM: l2x0: add Marvell Tauros3 support
  ARM: add Marvell Berlin SoC familiy to Marvell doc
  ARM: add Marvell Berlin SoCs to multi_v7_defconfig
  ARM: add Marvell Berlin UART0 lowlevel debug
  ARM: add Armada 1500 and Sony NSZ-GS7 device tree files
  ARM: add Armada 1500-mini and Chromecast device tree files
  ARM: add initial support for Marvell Berlin SoCs

 Documentation/arm/Marvell/README                   |   29 +++
 Documentation/devicetree/bindings/arm/l2cc.txt     |   23 +-
 .../devicetree/bindings/arm/marvell,berlin.txt     |   24 +++
 .../interrupt-controller/snps,dw-apb-ictl.txt      |   32 +++
 MAINTAINERS                                        |    6 +
 arch/arm/Kconfig                                   |    2 +
 arch/arm/Kconfig.debug                             |   10 +
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/dts/Makefile                         |    3 +
 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts         |   29 +++
 arch/arm/boot/dts/berlin2.dtsi                     |  227 ++++++++++++++++++++
 arch/arm/boot/dts/berlin2cd-google-chromecast.dts  |   29 +++
 arch/arm/boot/dts/berlin2cd.dtsi                   |  212 ++++++++++++++++++
 arch/arm/configs/multi_v7_defconfig                |    3 +
 arch/arm/include/asm/hardware/cache-l2x0.h         |    1 +
 arch/arm/mach-berlin/Kconfig                       |   30 +++
 arch/arm/mach-berlin/Makefile                      |    1 +
 arch/arm/mach-berlin/berlin.c                      |   39 ++++
 arch/arm/mm/cache-l2x0.c                           |   49 ++++-
 arch/arm/mm/cache-tauros3.h                        |   41 ++++
 drivers/irqchip/Kconfig                            |    4 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-dw-apb-ictl.c                  |  150 +++++++++++++
 23 files changed, 927 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,berlin.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
 create mode 100644 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts
 create mode 100644 arch/arm/boot/dts/berlin2.dtsi
 create mode 100644 arch/arm/boot/dts/berlin2cd-google-chromecast.dts
 create mode 100644 arch/arm/boot/dts/berlin2cd.dtsi
 create mode 100644 arch/arm/mach-berlin/Kconfig
 create mode 100644 arch/arm/mach-berlin/Makefile
 create mode 100644 arch/arm/mach-berlin/berlin.c
 create mode 100644 arch/arm/mm/cache-tauros3.h
 create mode 100644 drivers/irqchip/irq-dw-apb-ictl.c

---
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Landley <rob@landley.net>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@kernel.org>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4


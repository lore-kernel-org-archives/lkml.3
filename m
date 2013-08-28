Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3H1AOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 20:14:44 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:55872 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3H1AOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 20:14:42 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 0/6] ARM: Initial support for Marvell Armada 1500
Date: Wed, 28 Aug 2013 02:14:28 +0200
Message-Id: <1377648874-6714-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second RFC to add initial support for the Marvell Armada 1500
(88DE3100) found on various consumer devices. The changes compared to v1
have been quite fundamental, so I'll also summarize them in this cover letter.

I have addressed the following comments given during v1:
- moved to new mach-berlin subdir to reflect the difference from Armada 370/XP.
- removed redundant map_io hook and reduced DT soc range
- added SoC binding documentation
- added to Marvell SoC documentation
- have extra DEBUG_ Kconfig option for Marvell Berlin SoCs
- build with multi_v7_defconfig
- reorder things alphabetically

Comments I have not addressed:
- left .init_time hook as common arch clock init is currently under
  discussion in a separate patch set (comment added)
- left non-DT l2x0_of_init as I was allowed to choose only one cleanup
  out of the two prerequesites (comment added)

Also, I added copyright credits to the Asus Cube GPL'ed 2.6 kernel
source I was using as datasheet replacement. I have taken virtually
nothing out of it except register offsets, irq numbers, and clock
hierarchy. Actually, I would even put Marvell's direct copyright into
it just because I'd love to see them to continue their community efforts
they have started in the past. Anyway, I am not affiliated with Marvell,
so I cannot just make them resposible for the current, rudimentary SoC
skeleton patches.

This time the patches have been based on linux-next's next-20130827
tag, which better reflects the targeted 1 or 2 merge windows.

Sebastian Hesselbarth (6):
  irqchip: add DesignWare APB ICTL interrupt controller
  ARM: add Marvell Berlin SoC familiy to Marvell doc
  ARM: add Marvell Berlin and Armada 1500 to multi_v7_defconfig
  ARM: add Marvell Berlin UART0 lowlevel debug
  ARM: add Armada 1500 and Sony NSZ-GS7 device tree files
  ARM: add initial support for Marvell Berlin SoCs

 Documentation/arm/Marvell/README                   |   22 ++
 .../devicetree/bindings/arm/marvell,berlin.txt     |   23 ++
 .../interrupt-controller/snps,dw-apb-ictl.txt      |   29 +++
 arch/arm/Kconfig                                   |    2 +
 arch/arm/Kconfig.debug                             |   10 +
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/dts/Makefile                         |    2 +
 arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts      |   29 +++
 arch/arm/boot/dts/mv88de3100.dtsi                  |  222 ++++++++++++++++++++
 arch/arm/configs/multi_v7_defconfig                |    2 +
 arch/arm/mach-berlin/Kconfig                       |   24 ++
 arch/arm/mach-berlin/Makefile                      |    1 +
 arch/arm/mach-berlin/berlin.c                      |   49 +++++
 drivers/irqchip/Kconfig                            |    4 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-dw-apb-ictl.c                  |  142 +++++++++++++
 16 files changed, 563 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,berlin.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
 create mode 100644 arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts
 create mode 100644 arch/arm/boot/dts/mv88de3100.dtsi
 create mode 100644 arch/arm/mach-berlin/Kconfig
 create mode 100644 arch/arm/mach-berlin/Makefile
 create mode 100644 arch/arm/mach-berlin/berlin.c
 create mode 100644 drivers/irqchip/irq-dw-apb-ictl.c

---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.2.5


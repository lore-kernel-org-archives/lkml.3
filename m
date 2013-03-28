Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3C1Kie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:38:34 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:30807 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3C1Kid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:38:33 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [GIT PULL v2] at91: soc for 3.10 #2
Date: Thu, 28 Mar 2013 11:38:29 +0100
Message-ID: <1364467109-11173-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <5152B357.3020500@atmel.com>
References: <5152B357.3020500@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

A pull-request for 3.10 that is dedicated to the introduction of
Atmel's new Cortex-A5 based product: SAMA5D3.
This tag is built on top of the material already provided that resides on your
side in at91/cleanup branch.
The second revision of this pull-request includes a patch from Arnd to modify
The AT91 Kconfig.

Thanks, best regards,

The following changes since commit 9317960fa38ff50ac287904e4c751a169635ecbf:

  ARM: at91: renamme rm9200 dt file (2013-03-13 17:28:14 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-soc

for you to fetch changes up to abac0fd0f6dad6fa01ac8fdfccc796233d0fea30:

  ARM: at91: make ATAGS support conditional on CONFIG_ATAGS (2013-03-28 09:51:39 +0100)

----------------------------------------------------------------
Introduction of new Atmel Cortex-A5: SAMA5D3 family.
- Modify AT91 Kconfig to plit ARMv4/5 and ARMv7 arch
- Modify PMC driver (clocks)
- Core SAMA5 support
- Board file, DT files and defconfig
Add a condition on CONFIG_ATAGS for legacy boards

----------------------------------------------------------------
Arnd Bergmann (1):
      ARM: at91: make ATAGS support conditional on CONFIG_ATAGS

Ludovic Desroches (6):
      ARM: at91: change name template in AT91_SOC_START macro
      ARM: at91: add AT91_SAM9_TIME entry to select at91sam926x_time.c compilation
      ARM: at91: introduce the core type choice to split ARMv4/5 and ARMv7 arch
      ARM: at91: introduce SAMA5 support
      ARM: at91: dt: add device tree files for SAMA5D3 family
      ARM: at91: add defconfig for SAMA5

 arch/arm/boot/dts/Makefile                 |    5 +
 arch/arm/boot/dts/sama5d3.dtsi             | 1031 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/sama5d31ek.dts           |   51 ++
 arch/arm/boot/dts/sama5d33ek.dts           |   44 ++
 arch/arm/boot/dts/sama5d34ek.dts           |   61 ++
 arch/arm/boot/dts/sama5d35ek.dts           |   56 ++
 arch/arm/boot/dts/sama5d3xcm.dtsi          |   91 +++
 arch/arm/boot/dts/sama5d3xdm.dtsi          |   42 ++
 arch/arm/boot/dts/sama5d3xmb.dtsi          |  166 +++++
 arch/arm/configs/sama5_defconfig           |  181 +++++
 arch/arm/mach-at91/Kconfig                 |   62 +-
 arch/arm/mach-at91/Makefile                |    7 +-
 arch/arm/mach-at91/at91rm9200.c            |    2 +-
 arch/arm/mach-at91/at91sam9260.c           |    2 +-
 arch/arm/mach-at91/at91sam9261.c           |    2 +-
 arch/arm/mach-at91/at91sam9263.c           |    2 +-
 arch/arm/mach-at91/at91sam9g45.c           |    2 +-
 arch/arm/mach-at91/at91sam9n12.c           |    2 +-
 arch/arm/mach-at91/at91sam9rl.c            |    2 +-
 arch/arm/mach-at91/at91sam9x5.c            |    2 +-
 arch/arm/mach-at91/board-dt-sama5.c        |   86 +++
 arch/arm/mach-at91/clock.c                 |  109 ++-
 arch/arm/mach-at91/clock.h                 |    2 +
 arch/arm/mach-at91/include/mach/at91_pmc.h |   18 +-
 arch/arm/mach-at91/include/mach/cpu.h      |   20 +
 arch/arm/mach-at91/include/mach/sama5d3.h  |   73 ++
 arch/arm/mach-at91/sama5d3.c               |  377 ++++++++++
 arch/arm/mach-at91/setup.c                 |   27 +
 arch/arm/mach-at91/soc.h                   |    7 +-
 29 files changed, 2488 insertions(+), 44 deletions(-)
 create mode 100644 arch/arm/boot/dts/sama5d3.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d31ek.dts
 create mode 100644 arch/arm/boot/dts/sama5d33ek.dts
 create mode 100644 arch/arm/boot/dts/sama5d34ek.dts
 create mode 100644 arch/arm/boot/dts/sama5d35ek.dts
 create mode 100644 arch/arm/boot/dts/sama5d3xcm.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3xdm.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3xmb.dtsi
 create mode 100644 arch/arm/configs/sama5_defconfig
 create mode 100644 arch/arm/mach-at91/board-dt-sama5.c
 create mode 100644 arch/arm/mach-at91/include/mach/sama5d3.h
 create mode 100644 arch/arm/mach-at91/sama5d3.c

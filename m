Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3C0Iwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:52:53 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:55471 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3C0Iwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:52:49 -0400
Message-ID: <5152B357.3020500@atmel.com>
Date: Wed, 27 Mar 2013 09:52:39 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] at91: soc for 3.10 #2
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

A pull-request for 3.10 that is dedicated to the introduction of
Atmel's new Cortex-A5 based product: SAMA5D3.
This tag is built on top of the material already provided that resides on your
side in at91/cleanup branch.

Thanks, best regards,

The following changes since commit 9317960fa38ff50ac287904e4c751a169635ecbf:

  ARM: at91: renamme rm9200 dt file (2013-03-13 17:28:14 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-soc

for you to fetch changes up to 471c9e786596c4f028c67c7e9de0703b49cab2a9:

  ARM: at91: add defconfig for SAMA5 (2013-03-26 12:18:05 +0100)

----------------------------------------------------------------
Introduction of new Atmel Cortex-A5: SAMA5D3 family.
- Modify AT91 Kconfig to plit ARMv4/5 and ARMv7 arch
- Modify PMC driver (clocks)
- Core SAMA5 support
- Board file, DT files and defconfig

----------------------------------------------------------------
Ludovic Desroches (6):
      ARM: at91: change name template in AT91_SOC_START macro
      ARM: at91: add AT91_SAM9_TIME entry to select at91sam926x_time.c compilation
      ARM: at91: introduce the core type choice to split ARMv4/5 and ARMv7 arch
      ARM: at91: introduce SAMA5 support
      ARM: at91: dt: add device tree files for SAMA5D3 family
      ARM: at91: add defconfig for SAMA5

 arch/arm/boot/dts/Makefile                 |    5 +
 arch/arm/boot/dts/sama5d3.dtsi             | 1031 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/sama5d31ek.dts           |   51 ++
 arch/arm/boot/dts/sama5d33ek.dts           |   44 ++
 arch/arm/boot/dts/sama5d34ek.dts           |   61 +++
 arch/arm/boot/dts/sama5d35ek.dts           |   56 ++
 arch/arm/boot/dts/sama5d3xcm.dtsi          |   91 ++++
 arch/arm/boot/dts/sama5d3xdm.dtsi          |   42 ++
 arch/arm/boot/dts/sama5d3xmb.dtsi          |  166 ++++++
 arch/arm/configs/sama5_defconfig           |  181 ++++++
 arch/arm/mach-at91/Kconfig                 |   59 +-
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
 arch/arm/mach-at91/clock.c                 |  109 +++-
 arch/arm/mach-at91/clock.h                 |    2 +
 arch/arm/mach-at91/include/mach/at91_pmc.h |   18 +-
 arch/arm/mach-at91/include/mach/cpu.h      |   20 +
 arch/arm/mach-at91/include/mach/sama5d3.h  |   73 +++
 arch/arm/mach-at91/sama5d3.c               |  377 +++++++++++++
 arch/arm/mach-at91/setup.c                 |   27 +
 arch/arm/mach-at91/soc.h                   |    7 +-
 29 files changed, 2486 insertions(+), 43 deletions(-)
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


-- 
Nicolas Ferre

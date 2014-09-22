Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaIVNPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:15:38 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:21077 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaIVNPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:15:37 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: soc for 3.18 #2
Date: Mon, 22 Sep 2014 15:15:33 +0200
Message-ID: <1411391733-28891-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is the second SoC pull-request for AT91 and it's dedicated to the addition
of our new SAMA5D4: C-A5+neon+L2CC+vdec (in sort). The AT91 SoC support is now
pretty simple in relation with the enhancements done recently.
The patches go on top of the previous tag at91-soc and has no dependency.

The merge with other AT91 branches can lead to little conflicts that I resolved
for you in the at91-3.18-resolved2 branch that you can take as an example.

Thanks, best regards,

The following changes since commit 5db722eeba0051c68e638114f6720e715b03cd2c:

  ARM: at91: Remove the support for the RSI EWS board (2014-09-19 13:13:23 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-soc2

for you to fetch changes up to 02037a9719fa89b7e5dc25cb22afc06c4eae406e:

  ARM: at91: document Atmel SMART compatibles (2014-09-22 14:42:40 +0200)

----------------------------------------------------------------
Second SoC batch for 3.18:
- introduction of the new SAMA5D4 SoC and associated Evaluation Kit
- low level soc detection and early printk code
- taking advantage of this, documentation of all AT91 SoC DT strings

----------------------------------------------------------------
Alexandre Belloni (3):
      clk: at91: add a driver for the h32mx clock
      ARM: at91: add sama5d4 support to sama5_defconfig
      ARM: at91: document Atmel SMART compatibles

Nicolas Ferre (4):
      ARM: at91: introduce basic SAMA5D4 support
      ARM: at91: SAMA5D4 SoC detection code and low level routines
      ARM: at91: dt: add device tree file for SAMA5D4 SoC
      ARM: at91: dt: add device tree file for SAMA5D4ek board

 .../devicetree/bindings/arm/atmel-at91.txt         |   37 +
 .../devicetree/bindings/clock/at91-clock.txt       |   14 +
 arch/arm/Kconfig.debug                             |    4 +
 arch/arm/boot/dts/Makefile                         |    2 +
 arch/arm/boot/dts/at91-sama5d4ek.dts               |  260 ++++
 arch/arm/boot/dts/sama5d4.dtsi                     | 1240 ++++++++++++++++++++
 arch/arm/configs/sama5_defconfig                   |    1 +
 arch/arm/mach-at91/Kconfig                         |   21 +
 arch/arm/mach-at91/Makefile                        |    1 +
 arch/arm/mach-at91/board-dt-sama5.c                |   16 +-
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
 drivers/clk/at91/clk-h32mx.c                       |  123 ++
 drivers/clk/at91/pmc.c                             |    6 +
 drivers/clk/at91/pmc.h                             |    5 +
 include/linux/clk/at91_pmc.h                       |    1 +
 24 files changed, 1987 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91-sama5d4ek.dts
 create mode 100644 arch/arm/boot/dts/sama5d4.dtsi
 create mode 100644 arch/arm/mach-at91/include/mach/sama5d4.h
 create mode 100644 arch/arm/mach-at91/sama5d4.c
 create mode 100644 drivers/clk/at91/clk-h32mx.c

-- 
Nicolas Ferre

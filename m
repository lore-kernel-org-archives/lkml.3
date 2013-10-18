Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab3JROJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:09:32 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:62874 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab3JROJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:09:31 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <b.zolnierkie@samsung.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: cleanup and preparation for the move to common clk #1
Date: Fri, 18 Oct 2013 16:09:28 +0200
Message-ID: <1382105368-415-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is the first AT91 pull-request for 3.13. I delayed the inclusion of
material for AT91 as I wanted to build this "cleanup" series with the patches
for moving AT91 to common clock framerowk. Now that the (big) series is nearly
finished, I can send you the first patches that are targetted at preparing the
landing...

I plan to build another pull-request for the whole move to common clk framework
early next week, if I manage to get the appropiate tags from Mike and the DT
maintainers.

The work that is beginning here is a big step toward AT91 integratin the
multi-arch movement and removal of a bunch of code that bloats the mach-at91
directory.

Thanks, best regards,

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-cleanup

for you to fetch changes up to 70e389cc7fedc4c279ef28e970658a39adc7dec7:

  MAINTAINERS: Add patterns for DTS files for AT91 (2013-10-16 16:22:56 +0200)

----------------------------------------------------------------
First cleanup series for 3.13
- a little non-urgent fix
- addition of DT files to MAINTAINERS
- more important, the splitting of .dtsi files
  that allows to precisely choose the peripherals
  that are present for a particular SoC.
  It is useful for upcoming move to common cloks.

----------------------------------------------------------------
Bartlomiej Zolnierkiewicz (1):
      ARM: at91: cam60: fix incorrect placement of __initdata tag

Boris BREZILLON (2):
      ARM: at91/dt: split sam9x5 peripheral definitions
      ARM: at91/dt: split sama5d3 peripheral definitions

Mark Brown (1):
      MAINTAINERS: Add patterns for DTS files for AT91

Nicolas Ferre (1):
      ARM: at91: remove init_machine() as default is suitable

 MAINTAINERS                              |   4 +
 arch/arm/boot/dts/at91sam9g25.dtsi       |   2 +
 arch/arm/boot/dts/at91sam9g35.dtsi       |   1 +
 arch/arm/boot/dts/at91sam9x25.dtsi       |  24 +---
 arch/arm/boot/dts/at91sam9x35.dtsi       |   1 +
 arch/arm/boot/dts/at91sam9x5.dtsi        |  67 ----------
 arch/arm/boot/dts/at91sam9x5_macb0.dtsi  |  56 +++++++++
 arch/arm/boot/dts/at91sam9x5_macb1.dtsi  |  44 +++++++
 arch/arm/boot/dts/at91sam9x5_usart3.dtsi |  51 ++++++++
 arch/arm/boot/dts/sama5d3.dtsi           | 203 -------------------------------
 arch/arm/boot/dts/sama5d31.dtsi          |  16 +++
 arch/arm/boot/dts/sama5d31ek.dts         |   3 +-
 arch/arm/boot/dts/sama5d33.dtsi          |  14 +++
 arch/arm/boot/dts/sama5d33ek.dts         |   3 +-
 arch/arm/boot/dts/sama5d34.dtsi          |  16 +++
 arch/arm/boot/dts/sama5d34ek.dts         |   3 +-
 arch/arm/boot/dts/sama5d35.dtsi          |  18 +++
 arch/arm/boot/dts/sama5d35ek.dts         |   3 +-
 arch/arm/boot/dts/sama5d3_can.dtsi       |  54 ++++++++
 arch/arm/boot/dts/sama5d3_emac.dtsi      |  44 +++++++
 arch/arm/boot/dts/sama5d3_gmac.dtsi      |  77 ++++++++++++
 arch/arm/boot/dts/sama5d3_lcd.dtsi       |  55 +++++++++
 arch/arm/boot/dts/sama5d3_mci2.dtsi      |  47 +++++++
 arch/arm/boot/dts/sama5d3_tcb1.dtsi      |  27 ++++
 arch/arm/boot/dts/sama5d3_uart.dtsi      |  53 ++++++++
 arch/arm/boot/dts/sama5d3xcm.dtsi        |   1 -
 arch/arm/mach-at91/board-cam60.c         |   2 +-
 arch/arm/mach-at91/board-dt-rm9200.c     |   7 --
 arch/arm/mach-at91/board-dt-sam9.c       |   7 --
 29 files changed, 592 insertions(+), 311 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9x5_macb0.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_macb1.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_usart3.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d31.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d33.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d34.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d35.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_can.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_emac.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_gmac.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_lcd.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_mci2.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_tcb1.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3_uart.dtsi

-- 
Nicolas Ferre

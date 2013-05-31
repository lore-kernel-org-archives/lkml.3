Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab3EaVR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:17:29 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:46865 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3EaVRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:17:25 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: <b.brezillon@overkiz.com>, <dgilbert@interlog.com>,
        <wenyou.yang@atmel.com>, <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: Device Tree update for 3.11 #1
Date: Fri, 31 May 2013 23:17:19 +0200
Message-ID: <1370035039-17757-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

This is the pull-request for DT update on AT91. As said earlier, and like any
other patches that will be produced for 3.11, it is based on material already
included in arm-soc/at91/cleanup branch.

A little conflict may appear while merging with already-sent pull-request for
the USBA driver ([GIT PULL] at91: USBA DT support for 3.11). I have resolved
the conflict and pushed the result branch as: at91-at91-3.11-driver-usba-dt+resolved

Thanks, best regards,

The following changes since commit b3f442b0eedbc20b5ce3f4a96530588d14901199:

  ARM: at91: udpate defconfigs (2013-05-17 15:05:08 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt

for you to fetch changes up to 028633c238f91dc113520a7ad25d37b2ba9068af:

  ARM: at91/dt: add pinctrl definition for at91 tc blocks (2013-05-31 22:40:37 +0200)

----------------------------------------------------------------
Big DT-centric update for AT91:
- Calao boards update, removal of one board C file and
  associated defconfig, Kconfig Makefile lines
- several Acme boards updates
- addition of watchdog, uart and pinctrl descriptions for
  several products
- modification of RTC compatible string for 9x5 family

----------------------------------------------------------------
Boris BREZILLON (1):
      ARM: at91/dt: add pinctrl definition for at91 tc blocks

Douglas Gilbert (1):
      ARM: at91: add Acme Systems Fox G20 board

Jean-Christophe PLAGNIOL-VILLARD (6):
      ARM: at91: dt: sam9260: add i2c gpio pinctrl
      ARM: at91: dt: usb-a9260: update shutdown controller
      ARM: at91: dt: usb-a9263: update shutdown controller
      ARM: at91: dt: usb-a9263: add dataflash support
      ARM: at91: dt: add Calao USB-A9G20 low power version
      ARM: at91: drop non DT: Calao USB-A96x

Nicolas Ferre (5):
      ARM: at91: at91sam9x5 RTC is not compatible with at91rm9200 one
      ARM: at91/at91-ariag25.dts: add RTC node
      ARM: at91/at91sam9x5.dtsi: add UART0/1 nodes
      ARM: at91/at91-ariag25.dts: UART0/1 nodes are disabled
      ARM: at91: switch Fox G20 board .dts to pre-processor defines

Wenyou Yang (2):
      ARM: at91/dtsi: add the watchdog nodes for at91 SoC
      ARM: at91/dts: add the watchdog nodes for at91 boards

 arch/arm/boot/dts/Makefile                  |   2 +
 arch/arm/boot/dts/at91-ariag25.dts          |  21 +-
 arch/arm/boot/dts/at91-foxg20.dts           | 157 ++++++++++++
 arch/arm/boot/dts/at91rm9200.dtsi           |  76 ++++++
 arch/arm/boot/dts/at91sam9260.dtsi          |  86 +++++++
 arch/arm/boot/dts/at91sam9263.dtsi          |  38 +++
 arch/arm/boot/dts/at91sam9263ek.dts         |   4 +
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi |   4 +
 arch/arm/boot/dts/at91sam9g45.dtsi          |  76 ++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts      |   4 +
 arch/arm/boot/dts/at91sam9n12.dtsi          |  82 ++++++
 arch/arm/boot/dts/at91sam9n12ek.dts         |   4 +
 arch/arm/boot/dts/at91sam9x5.dtsi           | 102 +++++++-
 arch/arm/boot/dts/at91sam9x5ek.dtsi         |   4 +
 arch/arm/boot/dts/usb_a9260.dts             |   9 +
 arch/arm/boot/dts/usb_a9263.dts             |  14 +
 arch/arm/boot/dts/usb_a9g20.dts             |  18 +-
 arch/arm/boot/dts/usb_a9g20_common.dtsi     |  27 ++
 arch/arm/boot/dts/usb_a9g20_lpw.dts         |  31 +++
 arch/arm/configs/at91_dt_defconfig          |   2 +
 arch/arm/configs/at91sam9260_9g20_defconfig |   1 -
 arch/arm/configs/at91sam9263_defconfig      |   1 -
 arch/arm/mach-at91/Kconfig.non_dt           |  19 --
 arch/arm/mach-at91/Makefile                 |   3 -
 arch/arm/mach-at91/board-usb-a926x.c        | 384 ----------------------------
 25 files changed, 737 insertions(+), 432 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91-foxg20.dts
 create mode 100644 arch/arm/boot/dts/usb_a9g20_common.dtsi
 create mode 100644 arch/arm/boot/dts/usb_a9g20_lpw.dts
 delete mode 100644 arch/arm/mach-at91/board-usb-a926x.c

-- 
Nicolas Ferre

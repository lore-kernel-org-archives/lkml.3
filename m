Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbaCLSCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:02:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:43535 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbaCLSCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:02:09 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [GIT PULL] at91: cleanup for 3.15 #1
Date: Wed, 12 Mar 2014 19:02:05 +0100
Message-ID: <1394647325-29757-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is the first AT91 pull-request for 3.15, and a cleanup one. The most of it
is the conversion of two more Atmel SoCs to Device Tree. These are older that
the ones already converted. Moreover, they already use the CCF so there is no
need to come back on this later (maybe to remove some code when the other
non-DT boards are converted as well).
The defconfig update was needed because they were pretty old and some
interesting options were missing.

Thanks, best regards,

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-cleanup

for you to fetch changes up to 050208dfd0d725c307e6ad3442d9f809501091cd:

  ARM: at91: add PWM clock (2014-03-12 18:23:45 +0100)

----------------------------------------------------------------
First batch of AT91 cleanup for 3.15
- some updates on the defconfig front
- two SoCs converted to Device Tree: sam9261 and sam9rl
  (with use of CCF!)
- a little PWM clock update that goes on top of this

----------------------------------------------------------------
Alexandre Belloni (11):
      ARM: at91/defconfig: refresh at91sam9rl_defconfig
      ARM: at91/defconfig: remove useless configuration in at91sam9260_9g20_defconfig
      ARM: at91/defconfig: refresh at91sam9260_9g20_defconfig
      ARM: at91: prepare at91sam9rl DT transition
      ARM: at91: Add at91sam9rl DT SoC support
      ARM: at91/defconfig: Add the sam9rl to the list of DT-enabled SOCs
      ARM: at91: dt: sam9rl: Device Tree for the at91sam9rlek
      ARM: at91: prepare common clk transition for sam9rl SoCs
      ARM: at91/dt: define at91sam9rl clocks
      ARM: at91/dt: define main clk frequency of at91sam9rlek
      ARM: at91: switch sam9rl to common clock framework

Bo Shen (1):
      ARM: at91: add PWM clock

Boris BREZILLON (1):
      ARM: at91: prepare sam9 dt boards transition to common clk

Jean-Jacques Hiblot (6):
      ARM: at91: dt: Add at91sam9261 dt SoC support
      ARM: at91: dt: defconfig: Added the sam9261 to the list of DT-enabled SOCs
      ARM: at91: dt: sam9261: Device Tree support for the at91sam9261ek
      ARM: at91: updated the at91_dt_defconfig with support for the ADS7846
      ARM: at91: prepare common clk transition for sam9261 SoC
      ARM: at91: move sam9261 SoC to common clk

 arch/arm/boot/dts/Makefile                  |   4 +
 arch/arm/boot/dts/at91sam9261.dtsi          | 735 +++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9261ek.dts         | 211 ++++++++
 arch/arm/boot/dts/at91sam9rl.dtsi           | 802 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9rlek.dts          | 157 ++++++
 arch/arm/configs/at91_dt_defconfig          |   3 +
 arch/arm/configs/at91sam9260_9g20_defconfig |   9 +-
 arch/arm/configs/at91sam9rl_defconfig       |  10 +-
 arch/arm/mach-at91/Kconfig                  |   2 -
 arch/arm/mach-at91/at91sam9261.c            |  25 +-
 arch/arm/mach-at91/at91sam9263.c            |   1 +
 arch/arm/mach-at91/at91sam9g45.c            |   1 +
 arch/arm/mach-at91/at91sam9n12.c            |   1 +
 arch/arm/mach-at91/at91sam9rl.c             |  24 +-
 arch/arm/mach-at91/at91sam9x5.c             |   1 +
 arch/arm/mach-at91/board-dt-sam9.c          |  11 +-
 16 files changed, 1981 insertions(+), 16 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9rl.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9rlek.dts

-- 
Nicolas Ferre

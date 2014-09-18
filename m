Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbaIRRTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:19:44 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:34224 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbaIRRTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:19:43 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Bo Shen <voice.shen@atmel.com>, <evanluijk@interact.nl>,
        <mark.roszko@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] at91: dt for 3.18 #3
Date: Thu, 18 Sep 2014 19:19:39 +0200
Message-ID: <1411060779-32090-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

A third DT update for AT91 during this 3.18 dev. phase. Interesting updates and
also new features used: the NFC clock and the changes in pinctrl new the driver
updates that are already queued in mtd and pinctrl trees. No build dependency
but the NFC clock need the modification in the driver to be able to actually
boot: a kind of "runtime" dependency. But I don't know if you want to pull the
mtd or l2-mtd trees... Tell me if I need to do something for this.

It is on top of what you already have in at91/dt2.

Thanks, best regards,

The following changes since commit 5f8157309624929e05ece846d3ca8a3a64988378:

  ARM: at91: remove phy fixup for sama5d3xek boards (2014-09-01 19:30:44 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt3

for you to fetch changes up to 4dd7933ad606af457bc85b1afdaaac68aa993abf:

  ARM: at91/dt: at91sam9m10g45ek add rtc node (2014-09-18 18:14:48 +0200)

----------------------------------------------------------------
More AT91 DT material for 3.18:
- specify DMA channels for USART on sama5d3 and choose peripherals
  that will use them on the EK boards
- SSC update for audio on at91sam9rl and at91sam9g20
- addition of the NFC clock and new pinctrl compatible string
  to use enhancements that will land in drivers during this release
- several new nodes and fixes

----------------------------------------------------------------
Alexandre Belloni (1):
      ARM: at91/dt: sama5d3: add the nfc clock

Bo Shen (3):
      ARM: at91: sama5d3xek: reserve dma channel for audio
      ARM: at91/dt: at91sam9rl: switch ssc compatible string
      ARM: at91/dt: at91sam9g20: switch ssc compatible string

Boris BREZILLON (1):
      ARM: at91/dt: declare sckc node on at91sam9g45

David Dueck (1):
      ARM: at91/dt: Fix typo regarding can0_clk

Erik van Luijk (1):
      ARM: at91/dt: at91sam9m10g45ek add rtc node

Ludovic Desroches (1):
      ARM: at91: sama5d3: add usart dma configurations

Marek Roszko (1):
      ARM: at91/dt: sama5d3: use new pinctrl compatible string

 arch/arm/boot/dts/at91sam9g20.dtsi     |  4 ++++
 arch/arm/boot/dts/at91sam9g45.dtsi     | 37 ++++++++++++++++++++++++++++++++--
 arch/arm/boot/dts/at91sam9m10g45ek.dts |  4 ++++
 arch/arm/boot/dts/at91sam9rl.dtsi      |  4 ++--
 arch/arm/boot/dts/sama5d3.dtsi         | 23 ++++++++++++++++++++-
 arch/arm/boot/dts/sama5d3_can.dtsi     |  2 +-
 arch/arm/boot/dts/sama5d3xmb.dtsi      |  4 ++++
 7 files changed, 72 insertions(+), 6 deletions(-)

-- 
Nicolas Ferre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbaGAONN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:13:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35533 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756962AbaGAONL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:13:11 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Gregory Hermant <gregory.hermant@calao-systems.com>,
        Joachim Eastwood <manabian@gmail.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Tim Schendekehl <tim.schendekehl@egnite.de>,
        Gael Portay <g.portay@overkiz.com>,
        Rodolfo Giometti <giometti@linux.it>
Subject: [PATCH 00/33] ARM: at91: Switch remaining SoCs and boards to CCF
Date: Tue,  1 Jul 2014 16:12:09 +0200
Message-Id: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the common clock framwork to the remaining atml
SoCs: at91rm9200, at91sam9260, at91sam9263, at91sam9g45.

It also defines the necessary main crystal and slow crystal frequencies.

I couldn't find datasheets for the following boards:
 - mpa1600
 - ge863-pro3
 - animeo_ip
 - tny_a9260

For those, I assumed the 32kHz crystal is present on the board as this is the
most common implementation (only one board doesn't have it). Please correct me
if this is wrong.

I could not test at91rm9200 as I don't own any board with that chip.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Gregory Hermant <gregory.hermant@calao-systems.com>
Cc: Joachim Eastwood <manabian@gmail.com>
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Jiri Prchal <jiri.prchal@aksignal.cz>
Cc: Tim Schendekehl <tim.schendekehl@egnite.de>
Cc: Gael Portay <g.portay@overkiz.com>
Cc: Rodolfo Giometti <giometti@linux.it>

Alexandre Belloni (33):
  Documentation: dt: document all the atmel pmc compatibles
  ARM: at91/dt: ariag25: define crystals frequencies
  clk: at91: main: warn when the main crystal frequency is not set
  ARM: at91: prepare common clk transition for rm9200
  ARM: at91/dt: rm9200: define clocks
  ARM: at91: move at91rm9200 SoC to the CCF
  ARM: at91/dt: at91rm9200ek: define crystals frequencies
  ARM: at91: prepare common clk transition for sam9260
  ARM: at91/dt: sam9260: define clocks
  ARM: at91/dt: sam9g20: define clocks
  ARM: at91: move at91sam9260 SoCs to the CCF
  ARM: at91/dt: at91sam9g20ek: define crystals frequencies
  ARM: at91/dt: foxg20: define crystals frequencies
  ARM: at91/dt: usb_a9260: define crystals frequencies
  ARM: at91/dt: tny_a9260: define crystals frequencies
  ARM: at91/dt: qil_a9260: define crystals frequencies
  ARM: at91/dt: mpa1600: define crytals frequencies
  ARM: at91/dt: ge863-pro3: define crystals frequencies
  ARM: at91/dt: ethernut5: define crystals frequencies
  ARM: at91/dt: animeo_ip: define crystals frequencies
  ARM: at91/dt: kizbox: define main crystal frequency
  ARM: at91: prepare common clk transition for sam9g45
  ARM: at91/dt: sam9g45: define clocks
  ARM: at91: move at91sam9g45 SoC to the CCF
  ARM: at91/dt: sam9m10g45ek: define crystals frequencies
  ARM: at91/dt: pm9g45: crystals frequencies
  ARM: at91/dt: cosino define crystals frequencies
  ARM: at91: prepare common clk transition for sam9263
  ARM: at91/dt: sam9263: define clocks
  ARM: at91: move at91sam9263 SoC to the CCF
  ARM: at91/dt: sam9263ek: define crystals frequencies
  ARM: at91/dt: tny_a9263: define crystals frequencies
  ARM: at91/dt: usb_a9263: define crystals frequencies

 .../devicetree/bindings/arm/atmel-pmc.txt          |   5 +-
 arch/arm/boot/dts/animeo_ip.dts                    |   8 +
 arch/arm/boot/dts/at91-ariag25.dts                 |   8 +
 arch/arm/boot/dts/at91-cosino.dtsi                 |   8 +
 arch/arm/boot/dts/at91-foxg20.dts                  |   8 +
 arch/arm/boot/dts/at91-qil_a9260.dts               |   8 +
 arch/arm/boot/dts/at91rm9200.dtsi                  | 304 ++++++++++++++++++
 arch/arm/boot/dts/at91rm9200ek.dts                 |   8 +
 arch/arm/boot/dts/at91sam9260.dtsi                 | 314 ++++++++++++++++++-
 arch/arm/boot/dts/at91sam9263.dtsi                 | 311 +++++++++++++++++++
 arch/arm/boot/dts/at91sam9263ek.dts                |   8 +
 arch/arm/boot/dts/at91sam9g20.dtsi                 |  24 ++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   8 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 | 340 ++++++++++++++++++++-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   8 +
 arch/arm/boot/dts/ethernut5.dts                    |  10 +
 arch/arm/boot/dts/ge863-pro3.dtsi                  |   8 +
 arch/arm/boot/dts/kizbox.dts                       |   4 +
 arch/arm/boot/dts/mpa1600.dts                      |   8 +
 arch/arm/boot/dts/pm9g45.dts                       |   8 +
 arch/arm/boot/dts/tny_a9260_common.dtsi            |   8 +
 arch/arm/boot/dts/tny_a9263.dts                    |   8 +
 arch/arm/boot/dts/usb_a9260_common.dtsi            |   8 +
 arch/arm/boot/dts/usb_a9263.dts                    |   8 +
 arch/arm/mach-at91/Kconfig                         |   4 -
 arch/arm/mach-at91/at91rm9200.c                    |   6 +-
 arch/arm/mach-at91/at91sam9260.c                   |   6 +-
 arch/arm/mach-at91/at91sam9263.c                   |   6 +-
 arch/arm/mach-at91/at91sam9g45.c                   |   6 +-
 drivers/clk/at91/clk-main.c                        |   1 +
 30 files changed, 1458 insertions(+), 11 deletions(-)

-- 
1.9.1


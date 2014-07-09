Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaGIQxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:53:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49721 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753748AbaGIQxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:53:02 -0400
Date: Wed, 9 Jul 2014 18:52:56 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: at91: Switch to CCF for 3.17
Message-ID: <20140709165256.GO3113@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

This is the switch to CCF for all the remaining at91 SoCs and boards. It
is based on my branch that already include fixes that you or Mike
Turquette have taken. Please tell me if you want me to rebase.

The following changes since commit 17229cb7259e6d4ab8d26f9c7c71e33ccaf072aa:

  clk: at91: main: warn when the main crystal frequency is not set (2014-07-07 22:12:55 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/CCF-for-3.17

for you to fetch changes up to f2558fcdc7ceaa31f265a85292db145ced2c4362:

  ARM: at91/dt: usb_a9263: define crystals frequencies (2014-07-09 18:29:45 +0200)

----------------------------------------------------------------
CCF migration for 3.17

----------------------------------------------------------------
Alexandre Belloni (34):
      Documentation: dt: document all the atmel pmc compatibles
      ARM: at91/dt: ariag25: define crystals frequencies
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
      ARM: at91/dt: ge863-pro3: define main crystal frequency
      ARM: at91/dt: aks-cdu: define slow crytal frequency
      ARM: at91/dt: evk-pro3: define slow crytal frequency
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
 arch/arm/boot/dts/aks-cdu.dts                      |   6 +
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
 arch/arm/boot/dts/at91sam9g45.dtsi                 | 342 ++++++++++++++++++++-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   8 +
 arch/arm/boot/dts/ethernut5.dts                    |  10 +
 arch/arm/boot/dts/evk-pro3.dts                     |   6 +
 arch/arm/boot/dts/ge863-pro3.dtsi                  |   4 +
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
 31 files changed, 1467 insertions(+), 11 deletions(-)

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3HDJ7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:59:08 -0400
Received: from up.free-electrons.com ([94.23.35.102]:37120 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751100Ab3HDJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:59:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 0/9] ARM: sunxi: Introduce Allwinner A20 support
Date: Sun,  4 Aug 2013 11:58:41 +0200
Message-Id: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patchset brings in support for the Allwinner A20 SoC.

This SoC is pretty much the heir of the Allwinner A10. They both have a lot of
IP in common, the A20 is pin-compatible with the A10, the only major difference
being that the A20 has 2 Cortex-A7 instead of the single Cortex-A8 found in the
A10.

Just like the A31, the SMP support isn't there yet, nor do we have clock
support or any storage device.

We also have the same SMP bit issue that makes Linux run without the caches
enabled for the time being when CONFIG_SMP isn't set.

This serie comes on top of the serie "ARM: sunxi: Add support for the Allwinner
A31 SoC" I sent previously.

Thanks,
Maxime

Changes from v2:
  - Fix the SoC base address in the DT
  - Fixed a typo in the olinuxino's LED label

Changes from v1:
  - Removed the patch that wrapped the compatibles in the clock driver

Maxime Ripard (9):
  ARM: sunxi: Introduce Allwinner A20 support
  ARM: sun7i: Add Allwinner A20 DTSI
  ARM: sun7i: Add Olimex A20-Olinuxino-Micro support
  pinctrl: sunxi: Add Allwinner A20 pins set
  pinctrl: sunxi: Fix inconsistent indentation
  ARM: sun7i: Add the PIO controller node to the DTSI
  ARM: sun7i: DT: Add UART muxing options to the DTSI
  ARM: sun7i: a20-olinuxino: Enable UARTs muxing
  ARM: sun7i: a20-olinuxino: Enable the user LED

 arch/arm/boot/dts/Makefile                      |    3 +-
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts |   61 ++
 arch/arm/boot/dts/sun7i-a20.dtsi                |  205 +++++
 arch/arm/mach-sunxi/sunxi.c                     |    1 +
 drivers/pinctrl/pinctrl-sunxi-pins.h            | 1028 ++++++++++++++++++++++-
 drivers/pinctrl/pinctrl-sunxi.c                 |    1 +
 6 files changed, 1293 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
 create mode 100644 arch/arm/boot/dts/sun7i-a20.dtsi

-- 
1.8.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaIUO6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 10:58:35 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:47412 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaIUO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 10:58:29 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Shuge <shuge@allwinnertech.com>,
        Meng Zhang <kevin@allwinnertech.com>, yhf@merrii.com, ctl@merrii.com
Subject: [PATCH 0/6] ARM: sunxi: Add basic support for Allwinner A80 SoC
Date: Sun, 21 Sep 2014 22:58:07 +0800
Message-Id: <1411311493-24344-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patch series adds very basic support for Allwinner's A80 SoC,
a big.LITTLE architecture with 4 Cortex-A7s and 4 Cortex-A15s.

Development is done on the A80 Optimus Board, the defacto development
board for the A80, with the accompanying SDK as a reference. 

So far I've been unable to get the board to boot from MMC, or
using Android fastboot. I'm using Allwinner's FEL mode to load
the bootloader and kernel+dtb image over USB. Notes on my attempts
can be found here: http://linux-sunxi.org/User:Wens#A80_Optimus


Patch 1 introduces the compatible string for the A80.

Patch 2 adds options to use UART0 on the A80 as the debug port for
earlyprintk.

Patch 3 adds a barebone dtsi with just the cpu, memory and uart nodes.

Patch 4 adds a barebone dts for the A80 Optimus Board.

Patch 5 documents the vendor prefix for Merrii Technology Co., Ltd,
the designer and vendor of the A80 Optimus Board.

Patch 6 documents all the Allwinner SoCs we currently support.


Cheers
ChenYu

Chen-Yu Tsai (6):
  ARM: sunxi: Introduce Allwinner A80 support
  ARM: sunxi: Add debug uart used by sun9i (Allwinner A80)
  ARM: dts: sunxi: Add Allwinner A80 dtsi
  ARM: dts: sun9i: Add A80 Optimus Board support
  devicetree: bindings: Add vendor prefix for Merrii Technology Co.,
    Ltd.
  devicetree: bindings: Document supported Allwinner sunxi SoCs

 Documentation/devicetree/bindings/arm/sunxi.txt    |  12 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/arm/Kconfig.debug                             |  10 +
 arch/arm/boot/dts/Makefile                         |   2 +
 arch/arm/boot/dts/sun9i-a80-optimus.dts            |  66 +++++
 arch/arm/boot/dts/sun9i-a80.dtsi                   | 280 +++++++++++++++++++++
 arch/arm/mach-sunxi/Kconfig                        |   5 +
 arch/arm/mach-sunxi/sunxi.c                        |   9 +
 8 files changed, 385 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sunxi.txt
 create mode 100644 arch/arm/boot/dts/sun9i-a80-optimus.dts
 create mode 100644 arch/arm/boot/dts/sun9i-a80.dtsi

-- 
2.1.0


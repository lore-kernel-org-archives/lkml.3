Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbaGXXBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:01:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715AbaGXXBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:01:06 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
Date: Fri, 25 Jul 2014 01:00:09 +0200
Message-Id: <1406242820-20140-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds an initial device tree for the Parallella board.
UART, SD card, Ethernet are enabled.
Not yet enabled are HDMI, QSPI flash and 2x USB.

v2 adds some SPI and FPGA pieces and tidies the device tree with a 
compatible string and matching documentation.

Not having all pieces for testing all of this (most notably I'm missing 
ADI ADV7513 and AXI-HDMI support for VDMA and axi-clkgen, as well as 
the 25Q128A flash chip for QSPI), I've kept new things in separate patches
so that we can make progress on the basic version and possibly squash
further cherry-picked pieces.

Punnaiah Choudary Kalluri had recently proposed to extend the Chipidea 
USB driver for Zynq; it kept complaining about the PHY though, and I 
haven't spotted a revised version based on the generic driver yet.
https://patchwork.kernel.org/patch/4434681/

My rebasing work branch is here:
https://github.com/afaerber/linux/commits/parallella-next

Regards,
Andreas

Cc: Punnaiah Choudary Kalluri <punnaia@xilinx.com> (USB)
Cc: Lars-Peter Clausen <lars@metafoo.de> (HDMI)

Andreas Färber (11):
  Documentation: devicetree: Adapteva vendor prefix
  Documentation: devicetree: Adapteva boards
  ARM: dts: zynq: Add Parallella device tree
  ARM: dts: zynq: Update deprecated xuartps clock names
  ARM: dts: zynq: Add QSPI for Parallella
  ARM: dts: zynq: Add DMAC for Parallella
  Documentation: devicetree: Fix Xilinx VDMA specification
  ARM: dts: zynq: Add VDMA to Parallella
  Documentation: devicetree: Fix ADI AXI SPDIF specification
  ARM: dts: zynq: Add SPDIF for Parallella
  ARM: dts: zynq: Add AXI clkgen for Parallella

 Documentation/devicetree/bindings/arm/adapteva.txt |   7 ++
 .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   2 +-
 .../devicetree/bindings/sound/adi,axi-spdif-tx.txt |   2 +-
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/arm/boot/dts/Makefile                         |   4 +-
 arch/arm/boot/dts/zynq-7000.dtsi                   |  58 +++++++++-
 arch/arm/boot/dts/zynq-parallella.dts              | 119 +++++++++++++++++++++
 7 files changed, 188 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/adapteva.txt
 create mode 100644 arch/arm/boot/dts/zynq-parallella.dts

-- 
1.9.3


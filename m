Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbaGPI0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:26:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60579 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756087AbaGPI0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:26:10 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/12] ARM: berlin: USB support
Date: Wed, 16 Jul 2014 10:25:54 +0200
Message-Id: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the support for ChipIdea USB2 (ci13xxx) controllers,
the USB PHYs of the Marvell Berlin SoCs and also adds a reset
controller for these SoCs.

The reset controller is used by the PHY driver and shares the
existing chip controller node with the clocks and one pin controller.

The Marvell Berlin USB controllers are host only on the BG2Q and are
compatible with USB ChipIdea. We here add a glue to use the available
common functions for this kind of controllers, and add a generic USB2
ChipIdea driver. A PHY driver is also added to control the USB PHY.

This series applies on top of the generic PHY support in the USB
framework[1].

Changes since v2:
	- moved the PHY driver to the generic PHY framework
	- changed the compatible to 'chipidea,usb2'
	- added a property to set the DMA mask in the USB2 CI driver
	- separated dt specific calls in the CI probing function
	- rebased on top of the generic PHY support for CI[1]

Changes since v1:
        - made the Berlin CI USB driver a generic one
        - added support to custom offset for the reset register
        - added fixed regulators to support supply the VBUS
        - modified the PHY driver to support the one one the BG2CD as
          well
        - documented the reset properties
        - added bindings for the BG2CD
        - cosmetic fixes

[1] https://lkml.org/lkml/2014/7/15/330

Antoine Ténart (10):
  reset: add the Berlin reset controller driver
  Documentation: bindings: add reset bindings docs for Marvell Berlin
    SoCs
  ARM: Berlin: select the reset controller
  ARM: dts: berlin: add a required reset property in the chip controller
    node
  phy: add the Berlin USB PHY driver
  Documentation: bindings: add doc for the Berlin USB PHY
  usb: chipidea: add a usb2 driver for ci13xxx
  Documentation: bindings: add doc for the USB2 ChipIdea USB driver
  ARM: dts: berlin: add BG2Q nodes for USB support
  ARM: dts: Berlin: enable USB on the BG2Q DMP

Sebastian Hesselbarth (2):
  ARM: dts: berlin: add BG2CD nodes for USB support
  ARM: dts: berlin: enable USB on the Google Chromecast

 .../devicetree/bindings/arm/marvell,berlin.txt     |  10 +
 .../devicetree/bindings/phy/berlin-usb-phy.txt     |  16 ++
 .../devicetree/bindings/usb/ci-hdrc-usb2.txt       |  23 +++
 arch/arm/boot/dts/berlin2.dtsi                     |   1 +
 arch/arm/boot/dts/berlin2cd-google-chromecast.dts  |   4 +
 arch/arm/boot/dts/berlin2cd.dtsi                   |  35 ++++
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |  53 +++++
 arch/arm/boot/dts/berlin2q.dtsi                    |  53 +++++
 arch/arm/mach-berlin/Kconfig                       |   2 +
 drivers/phy/Kconfig                                |   7 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-berlin-usb.c                       | 223 +++++++++++++++++++++
 drivers/reset/Makefile                             |   1 +
 drivers/reset/reset-berlin.c                       | 131 ++++++++++++
 drivers/usb/chipidea/Makefile                      |   1 +
 drivers/usb/chipidea/ci_hdrc_usb2.c                | 147 ++++++++++++++
 16 files changed, 708 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-usb-phy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
 create mode 100644 drivers/phy/phy-berlin-usb.c
 create mode 100644 drivers/reset/reset-berlin.c
 create mode 100644 drivers/usb/chipidea/ci_hdrc_usb2.c

-- 
1.9.1


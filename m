Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaFXKf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:35:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54278 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751407AbaFXKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:35:25 -0400
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
Subject: [PATCH v2 00/12] ARM: berlin: USB support
Date: Tue, 24 Jun 2014 12:35:09 +0200
Message-Id: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the support for generic ChipIdea USB controllers,
the USB PHYs of the Marvell Berlin SoCs and also adds a reset
controller for these SoCs.

The reset controller is used by the USB PHY driver and shares the
existing chip controller node with the clocks and one pin controller.

The Marvell Berlin USB controllers are host only on the BG2Q and are
compatible with USB ChipIdea. We here add a glue to use the available
common functions for this kind of controllers, and add a generic
driver. A USB PHY driver is also added to control the PHY.

Changes since v1:
        - made the Berlin CI USB driver a generic one
        - added support to custom offset for the reset register
        - added fixed regulators to support supply the VBUS
        - modified the PHY driver to support the one one the BG2CD as
          well
        - documented the reset properties
        - added bindings for the BG2CD
        - cosmetic fixes

Antoine Ténart (10):
  reset: add the Berlin reset controller driver
  Documentation: bindings: add reset bindings docs for Marvell Berlin
    SoCs
  ARM: Berlin: select the reset controller
  ARM: dts: berlin: add a required reset property in the chip controller
    node
  usb: phy: add the Berlin USB PHY driver
  Documentation: bindings: add doc for the Berlin USB PHY
  usb: chipidea: add a generic driver
  Documentation: bindings: add doc for the generic ChipIdea USB driver
  ARM: dts: berlin: add BG2Q nodes for USB support
  ARM: dts: Berlin: enable USB on the BG2Q DMP

Sebastian Hesselbarth (2):
  ARM: dts: berlin: add BG2CD nodes for USB support
  ARM: dts: berlin: enable USB on the Google Chromecast

 .../devicetree/bindings/arm/marvell,berlin.txt     |  10 +
 .../devicetree/bindings/usb/berlin-usb-phy.txt     |  16 ++
 .../devicetree/bindings/usb/ci-hdrc-generic.txt    |  22 +++
 arch/arm/boot/dts/berlin2.dtsi                     |   1 +
 arch/arm/boot/dts/berlin2cd-google-chromecast.dts  |   4 +
 arch/arm/boot/dts/berlin2cd.dtsi                   |  35 ++++
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |  53 ++++++
 arch/arm/boot/dts/berlin2q.dtsi                    |  53 ++++++
 arch/arm/mach-berlin/Kconfig                       |   2 +
 drivers/reset/Makefile                             |   1 +
 drivers/reset/reset-berlin.c                       | 131 +++++++++++++
 drivers/usb/chipidea/Makefile                      |   1 +
 drivers/usb/chipidea/ci_hdrc_generic.c             | 108 +++++++++++
 drivers/usb/phy/Kconfig                            |   9 +
 drivers/usb/phy/Makefile                           |   1 +
 drivers/usb/phy/phy-berlin-usb.c                   | 211 +++++++++++++++++++++
 16 files changed, 658 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/berlin-usb-phy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-generic.txt
 create mode 100644 drivers/reset/reset-berlin.c
 create mode 100644 drivers/usb/chipidea/ci_hdrc_generic.c
 create mode 100644 drivers/usb/phy/phy-berlin-usb.c

-- 
1.9.1


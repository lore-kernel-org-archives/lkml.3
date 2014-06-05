Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaFEPsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:48:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58863 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751667AbaFEPsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:48:50 -0400
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
Subject: [PATCH 0/9] ARM: Berlin: USB support
Date: Thu,  5 Jun 2014 17:48:37 +0200
Message-Id: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the support for the Marvell Berlin USB controllers,
the USB PHYs and also adds a reset controller.

The reset controller is used by the USB PHY driver and shares the
existing chip controller node with the clocks and one pin controller.

The Marvell Berlin USB controllers are host only on the BG2Q and are
compatible with USB ChipIdea. We here add a glue to use the available
common functions for this kind of controllers. A USB PHY driver is also
added to control the PHY.

Antoine Ténart (9):
  reset: add the Berlin reset controller driver
  ARM: Berlin: select the reset controller
  ARM: dts: berlin: add a required reset property in the chip controller
    node
  usb: phy: add the Berlin USB PHY driver
  Documentation: bindings: add doc for the Berlin USB PHY
  usb: chipidea: add Berlin USB support
  Documentation: bindings: add doc for the Berlin ChipIdea USB driver
  ARM: dts: berlin: add BG2Q nodes for USB support
  ARM: dts: Berlin: enable USB on the BG2Q DMP

 .../devicetree/bindings/usb/berlin-usbphy.txt      |  18 ++
 .../devicetree/bindings/usb/ci-hdrc-berlin.txt     |  18 ++
 arch/arm/boot/dts/berlin2.dtsi                     |   1 +
 arch/arm/boot/dts/berlin2cd.dtsi                   |   1 +
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |  20 ++
 arch/arm/boot/dts/berlin2q.dtsi                    |  52 +++++
 arch/arm/mach-berlin/Kconfig                       |   2 +
 drivers/reset/Makefile                             |   1 +
 drivers/reset/reset-berlin.c                       | 113 +++++++++++
 drivers/usb/chipidea/Makefile                      |   1 +
 drivers/usb/chipidea/ci_hdrc_berlin.c              | 108 ++++++++++
 drivers/usb/phy/Kconfig                            |   9 +
 drivers/usb/phy/Makefile                           |   1 +
 drivers/usb/phy/phy-berlin-usb.c                   | 223 +++++++++++++++++++++
 14 files changed, 568 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/berlin-usbphy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-berlin.txt
 create mode 100644 drivers/reset/reset-berlin.c
 create mode 100644 drivers/usb/chipidea/ci_hdrc_berlin.c
 create mode 100644 drivers/usb/phy/phy-berlin-usb.c

-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3KATqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:46:15 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:38535 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab3KATqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:46:12 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v2 0/9] USB Device Controller support for BCM281xx
Date: Fri,  1 Nov 2013 15:45:49 -0400
Message-Id: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
	- Convert USB phy driver to generic phy subsystem
	- Add phy bus width apis
	- Drop dwc2 phy bus width DT property in favor of querying the
	  phy provider for bus width
	- Add generic phy/clock properties to dwc2 DT binding
	- Add generic phy subsystem support to s3c-hsotg with the
	  existing usb phy and pdata phy methods as a fallback
	- Split bindings out to separate patches to match the latest
	  DT binding review guidelines

This series adds USB Device Controller support for the Broadcom
BCM281xx family of parts. BCM281xx contains a DWC2 OTG block and
s3c-hsotg is used to support UDC operation.

Part 1 adds phy bus width support to the generic phy subsystem

Parts 2-6 allows s3c-hsotg to build on non-Samsung platforms, supports
the dwc2 binding, and enables generic phy support to support fetching
of the phy bus width.

Part 7-8 add a generic phy binding and driver for the BCM Kona USB PHY.

Part 9 adds the DT nodes to enable UDC support on both BCM281xx boards
in the kernel.

This series depends on the "Update Kona drivers to use clocks" series
(https://lkml.org/lkml/2013/10/3/645). The dependencies noted for that
series are already queued for 3.13. It also depends on the generic PHY
subsystem which has also been queued for 3.13.

Matt Porter (9):
  phy: add phy_get_bus_width()/phy_set_bus_width() calls
  staging: dwc2: update DT binding to add generic clock/phy properties
  usb: gadget: s3c-hsotg: enable build for other platforms
  usb: gadget: s3c-hsotg: add snps,dwc2 compatible string
  usb: gadget: s3c-hsotg: enable generic phy support
  usb: gadget: s3c-hsotg: get phy bus width from phy subsystem
  phy: add Broadcom Kona USB2 PHY DT binding
  phy: add Broadcom Kona USB2 PHY driver
  ARM: dts: add usb udc support to bcm281xx

 .../devicetree/bindings/phy/bcm-kona-usb2-phy.txt  |  15 ++
 Documentation/devicetree/bindings/staging/dwc2.txt |  12 ++
 arch/arm/boot/dts/bcm11351-brt.dts                 |   6 +
 arch/arm/boot/dts/bcm11351.dtsi                    |  18 +++
 arch/arm/boot/dts/bcm28155-ap.dts                  |   8 +
 drivers/phy/Kconfig                                |   6 +
 drivers/phy/Makefile                               |   2 +
 drivers/phy/phy-bcm-kona-usb2.c                    | 161 +++++++++++++++++++++
 drivers/usb/gadget/Kconfig                         |   7 +-
 drivers/usb/gadget/s3c-hsotg.c                     |  71 ++++++---
 drivers/usb/gadget/s3c-hsotg.h                     |   1 +
 include/linux/phy/phy.h                            |  16 ++
 12 files changed, 298 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
 create mode 100644 drivers/phy/phy-bcm-kona-usb2.c

-- 
1.8.4


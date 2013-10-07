Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3JGKMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:12:42 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:53925 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab3JGKMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:12:39 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 0/5] USB Device Controller support for BCM281xx
Date: Mon,  7 Oct 2013 06:12:27 -0400
Message-Id: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds USB Device Controller support for the Broadcom
BCM281xx family of parts. BCM281xx contains a DWC2 OTG block and
s3c-hsotg is used to support UDC operation.

Parts 1-2 allows s3c-hsotg to build on non-Samsung platforms and
adds support for a configurable UTMI PHY width. s3c-hsotg is extended
to also support the dwc2 binding as that binding should describe the
hardware independently of there being two different drivers (dwc2 in
staging and s3c-hsotg) for the same device.

Parts 3-4 add a PHY control driver for the Broadcom USB control block
as well as a PHY driver that calls the exported API from the control
driver. This approach is borrowed directly from the phy-omap-control.c
driver.

Patch 5 adds the DT nodes to enable UDC support on both BCM281xx boards
in the kernel.

This series depends on the "Update Kona drivers to use clocks" series
(https://lkml.org/lkml/2013/10/3/645). The dependencies noted for that
series are already queued for 3.13.

Matt Porter (5):
  usb: gadget: s3c-hsotg: enable build for other platforms
  usb: gadget: s3c-hsotg: support configurable UTMI PHY width
  usb: phy: add Broadcom Kona USB control driver
  usb: phy: add Broadcom Kona USB PHY driver
  ARM: dts: add usb udc support to bcm281xx

 Documentation/devicetree/bindings/staging/dwc2.txt |   4 +
 .../devicetree/bindings/usb/bcm-kona-usb-ctrl.txt  |  12 ++
 .../devicetree/bindings/usb/bcm-kona-usb-phy.txt   |  10 ++
 arch/arm/boot/dts/bcm11351-brt.dts                 |  10 ++
 arch/arm/boot/dts/bcm11351.dtsi                    |  21 +++
 arch/arm/boot/dts/bcm28155-ap.dts                  |  12 ++
 drivers/usb/gadget/Kconfig                         |   7 +-
 drivers/usb/gadget/s3c-hsotg.c                     |  20 ++-
 drivers/usb/gadget/s3c-hsotg.h                     |   1 +
 drivers/usb/phy/Kconfig                            |  12 ++
 drivers/usb/phy/Makefile                           |   2 +
 drivers/usb/phy/bcm-kona-usb.h                     |  31 +++++
 drivers/usb/phy/phy-bcm-kona-ctrl.c                | 151 +++++++++++++++++++++
 drivers/usb/phy/phy-bcm-kona-usb2.c                |  99 ++++++++++++++
 14 files changed, 385 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/bcm-kona-usb-ctrl.txt
 create mode 100644 Documentation/devicetree/bindings/usb/bcm-kona-usb-phy.txt
 create mode 100644 drivers/usb/phy/bcm-kona-usb.h
 create mode 100644 drivers/usb/phy/phy-bcm-kona-ctrl.c
 create mode 100644 drivers/usb/phy/phy-bcm-kona-usb2.c

-- 
1.8.4


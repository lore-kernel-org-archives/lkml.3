Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3GRIxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:53:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39970 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733Ab3GRIxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:53:43 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <benoit.cousson@linaro.org>
CC: <p.zabel@pengutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/6] USB: phy: phy-nop: Use RESET controller for managing the reset line
Date: Thu, 18 Jul 2013 11:53:04 +0300
Message-ID: <1374137590-17865-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Till now we were modelling the RESET line as a voltage regulator and
using the regulator framework to manage it.

[1] introduces a GPIO based reset controller driver. We use that
to manage the PHY reset line, at least for DT boots. For legacy boots,
will still need to use the regulator framework for reset lines.

Felipe,

The first patch is for you. The Kconfig change might conflict if
you apply this on top of my PHY Kconfig cleanup series.

Benoit,

Patches 2 to 6 are for you.

NOTE: All patches depend on [1] which is yet to be merged in.

cheers,
-roger

[1] - http://thread.gmane.org/gmane.linux.drivers.devicetree/41348

Roger Quadros (6):
  usb: phy-nop: Use RESET Controller for managing the reset line
  ARM: dts: omap3-beagle: Use reset-gpio driver for hsusb2_reset
  ARM: dts: omap4-panda: Use reset-gpio driver for hsusb1_reset
  ARM: dts: omap5-uevm: Use reset-gpio driver for hsusb2_reset
  ARM: dts: omap3-beagle-xm: Add USB Host support
  ARM: dts: omap3-beagle: Make USB host pin naming consistent

 .../devicetree/bindings/usb/usb-nop-xceiv.txt      |   10 ++-
 arch/arm/boot/dts/omap3-beagle-xm.dts              |   75 +++++++++++++++++---
 arch/arm/boot/dts/omap3-beagle.dts                 |   41 +++++------
 arch/arm/boot/dts/omap4-panda-common.dtsi          |   22 ++----
 arch/arm/boot/dts/omap5-uevm.dts                   |   17 ++---
 drivers/usb/phy/Kconfig                            |    1 +
 drivers/usb/phy/phy-nop.c                          |   48 ++++++++++---
 7 files changed, 146 insertions(+), 68 deletions(-)

-- 
1.7.4.1


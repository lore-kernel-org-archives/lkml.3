Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab3CLL2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:28:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43668 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab3CLLZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:25:41 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <mark.rutland@arm.com>, <mkl@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH 0/8] USB: PHY: nop: Device tree support for 3.10
Date: Tue, 12 Mar 2013 13:24:18 +0200
Message-ID: <1363087466-32444-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

These patches add device tree support as well as PHY resource handling
(i.e. clock, reset, power) for the NOP transceiver driver.

Please add these patches before your patches that move/rename the
drivers/usb/otg/nop-usb-xceiv.c file.

NOTE: The first patch that changes platform header must be common between
you and Tony's OMAP tree. Maybe you guys can share an immutable branch?

cheers,
-roger

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:
  git://github.com/rogerq/linux.git usbhost-phy-next

Roger Quadros (8):
      usb: phy: nop: Add some parameters to platform data
      usb: phy: nop: use devm_kzalloc()
      usb: phy: nop: Manage PHY clock
      usb: phy: nop: Handle power supply regulator for the PHY
      usb: phy: nop: Handle RESET for the PHY
      usb: phy: nop: use new PHY API to register PHY
      usb: phy: nop: Add device tree support and binding information
      USB: phy: nop: Defer probe if device needs VCC/RESET

 .../devicetree/bindings/usb/usb-nop-xceiv.txt      |   34 +++++
 drivers/usb/otg/nop-usb-xceiv.c                    |  143 +++++++++++++++++--
 include/linux/usb/nop-usb-xceiv.h                  |    5 +
 3 files changed, 167 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt

-- 
1.7.4.1


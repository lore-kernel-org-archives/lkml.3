Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbaEFAO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:14:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41411 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756922AbaEFAO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:14:26 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 00/20] USB support for Armada 38x and Armada 375
Date: Tue,  6 May 2014 02:13:55 +0200
Message-Id: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds the USB support for the Armada 38x Armada
375. These SoCs use an xHCI but still need specific initialization,
mainly to setup the windows memory on the mbus. They also use the same
controller that the other mvebu SoC for EHCI.

Since the 2nd version I converted the usb cluster driver in a PHY
driver. While I was working on it I found a bug on ehci-orion which I
fixed in the 1st patch.

The other noticeable change was that in order to be able to use the
clocks I also added private platform data for xHCI.

In the meantime I also received the A0 version of the Armada 375 so I
removed all the workaround related to the very earlier version of the
SoC, indeed there were very few boards with this version of the SoC.


This series is also available in
the branch USB-375-38x-3.15-rc1-V3
https://github.com/MISL-EBU-System-SW/mainline-public.git

Thanks,

Gregory CLEMENT (20):
  usb: ehci-orion: Fix clock reference leaking
  usb: ehci-orion: Add the optional PHY support
  usb: host: xhci-plat: Sort the headers in alphabetic order
  usb: xhci: add a platform-private field
  usb: host: xhci-plat: Add clocks support
  usb: host: xhci-plat: Add support for the Armada 38x
  xhci-platform: Add a new controller using xhci: Armada 38x
  ARM: mvebu: Add Device Tree description of xHCI hosts on Armada 38x
  ARM: mvebu: Add Device Tree description of the EHCI host on Armada 38x
  ARM: mvebu: Add USB3 support for Armada 38x
  ARM: configs: Add usb_xhci_mvebu to mvebu_v7_defconfig
  ARM: configs: Add usb_xhci_mvebu to multi_v7_defconfig
  usb: host: xhci-plat: Add support for the Armada 375
  xhci-platform: Add a new controller using xHCI: Armada 375
  ARM: mvebu: Add Device Tree description of USB cluster controller on
    Armada 375
  dt: binding: Armada 375 USB cluster
  phy: Add support for USB cluster on the Armada 375 SoC
  ARM: mvebu: Add USB3 support for Armada 375
  ARM: mvebu: Add Device Tree description of the xHCI host on Armada 375
  ARM: mvebu: Add Device Tree description of the EHCI host on Armada 375

 .../bindings/phy/armada-375-usb-phy-cluster.txt    |  19 +++
 Documentation/devicetree/bindings/usb/usb-xhci.txt |   4 +-
 arch/arm/boot/dts/armada-375-db.dts                |   8 ++
 arch/arm/boot/dts/armada-375.dtsi                  |  34 +++++
 arch/arm/boot/dts/armada-385-db.dts                |  12 ++
 arch/arm/boot/dts/armada-385-rd.dts                |   4 +
 arch/arm/boot/dts/armada-38x.dtsi                  |  25 ++++
 arch/arm/configs/multi_v7_defconfig                |   1 +
 arch/arm/configs/mvebu_v7_defconfig                |   1 +
 arch/arm/mach-mvebu/Kconfig                        |   2 +
 drivers/phy/Kconfig                                |   5 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-armada375-usb2.c                   | 154 +++++++++++++++++++++
 drivers/usb/host/Kconfig                           |   7 +
 drivers/usb/host/Makefile                          |   1 +
 drivers/usb/host/ehci-orion.c                      |  68 ++++++---
 drivers/usb/host/xhci-mvebu.c                      |  71 ++++++++++
 drivers/usb/host/xhci-mvebu.h                      |  21 +++
 drivers/usb/host/xhci-plat.c                       |  74 +++++++++-
 drivers/usb/host/xhci.h                            |   3 +
 20 files changed, 491 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/armada-375-usb-phy-cluster.txt
 create mode 100644 drivers/phy/phy-armada375-usb2.c
 create mode 100644 drivers/usb/host/xhci-mvebu.c
 create mode 100644 drivers/usb/host/xhci-mvebu.h

-- 
1.8.1.2


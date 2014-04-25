Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaDYOHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:07:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47195 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750840AbaDYOHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:07:31 -0400
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
Subject: [PATCH v2 00/18] USB support for Armada 38x and Armada 375
Date: Fri, 25 Apr 2014 16:06:58 +0200
Message-Id: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch set adds the USB support for the Armada 38x Armada
375. These SoCs use an xHCI but still need specific initialization,
mainly to setup the windows memory on the mbus. They also use the same
controller that the other mvebu SoC for EHCI.

Since the 1st version this patch set add xHCI support for Armada 375
but also EHCI support for Armada 375 and Armada 38x. For EHCI it was
mainly a matter of updating the device tree.

The first patch is just a small clean-up

The second patch extend the xhci-plat driver to allow to use the
clocks if they are available.

The third patch add support the Armada 38x by introducing a quirk to
setup the memory windows on the mbus for Armada 38x.

Then the forth patch update the binding documentation.

The 10th patch add support for the Armada 375 using what have been
done for Armada 38x

The 11th  patch update the binding documentation with Armada 375 binding.

This patches 1 to 4 and 10 to 11 should go through the xhci subsystem.

The rest of the series is more platform specific and should go through
the mvebu tree, except the patch 9 that should be taken directly by
the arm-soc maintainer.

Thanks,

Gregory CLEMENT (18):
  usb: host: xhci-plat: Sort the headers in alphabetic order
  usb: host: xhci-plat: Add clocks support
  usb: host: xhci-plat: Add support for the Armada 38x
  xhci-platform: Add a new controller using xhci: Armada 38x
  ARM: mvebu: Add Device Tree description of xHCI hosts on Armada 38x
  ARM: mvebu: Add Device Tree description of EHCI hosts on Armada 38x
  ARM: mvebu: Add USB3 support for Armada 38x
  ARM: configs: Add usb_xhci_mvebu to mvebu_v7_defconfig
  ARM: configs: Add usb_xhci_mvebu to multi_v7_defconfig
  usb: host: xhci-plat: Add support for the Armada 375
  xhci-platform: Add a new controller using xhci: Armada 375
  ARM: mvebu: Add Device Tree description of USB cluster controller on
    Armada 375
  dt: binding: Armada 375 USB cluster
  ARM: mvebu: Add support for USB cluster on the Armada 375 SoC
  ARM: mvebu: Add USB3 support for Armada 375
  ARM: mvebu: add USB3 controller Device Tree details for Armada 375
  ARM: mvebu: dts: Enable USB3 in Armada 375 DB
  ARM: mvebu: Add Device Tree description of EHCI hosts on Armada 375

 .../bindings/arm/armada-375-usb-cluster.txt        | 17 ++++
 Documentation/devicetree/bindings/usb/usb-xhci.txt |  4 +-
 arch/arm/boot/dts/armada-375-db.dts                | 10 ++-
 arch/arm/boot/dts/armada-375.dtsi                  | 41 +++++++++
 arch/arm/boot/dts/armada-385-db.dts                | 12 +++
 arch/arm/boot/dts/armada-385-rd.dts                |  4 +
 arch/arm/boot/dts/armada-38x.dtsi                  | 25 ++++++
 arch/arm/configs/multi_v7_defconfig                |  1 +
 arch/arm/configs/mvebu_v7_defconfig                |  1 +
 arch/arm/mach-mvebu/Kconfig                        |  2 +
 arch/arm/mach-mvebu/Makefile                       |  2 +-
 arch/arm/mach-mvebu/usb-cluster.c                  | 96 ++++++++++++++++++++++
 drivers/usb/host/Kconfig                           |  7 ++
 drivers/usb/host/Makefile                          |  1 +
 drivers/usb/host/xhci-mvebu.c                      | 71 ++++++++++++++++
 drivers/usb/host/xhci-mvebu.h                      | 22 +++++
 drivers/usb/host/xhci-plat.c                       | 67 +++++++++++++--
 17 files changed, 374 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/armada-375-usb-cluster.txt
 create mode 100644 arch/arm/mach-mvebu/usb-cluster.c
 create mode 100644 drivers/usb/host/xhci-mvebu.c
 create mode 100644 drivers/usb/host/xhci-mvebu.h

-- 
1.8.1.2


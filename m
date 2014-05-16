Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbaEPQYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:24:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41855 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757965AbaEPQYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:24:41 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: "Kishon Vijay Abraham I" <kishon@ti.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH 0/5] Add support for USB cluster(PHY muxer) on the Armada 375 SoC
Date: Fri, 16 May 2014 18:24:25 +0200
Message-Id: <1400257465-13422-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series adds support for the USB cluster which is on the Armada
375 SoC. We can mainly see this device as a PHY muxer. After talking
with Antoine Ténart about it I found a better way than the previous
series to model it.

Only one controller can access to the PHY so instead trying to
enforcing this condition in the init or the power_on ops, I move it
the xlate function. Having the two USB controllers enable in the same
time trying to use the PHY in the same time shouldn't happen and would
only occur with a wrongly written dts. But if this case occurs then we
provide a phy to the first one and return an error for the next one.

While in the previous version I tried to enforce the use of the xHCI
for USB it both controller are used, now it will be the first one
which will get this usage. However in this case the dts is wrong, so
the better thing to do for the user is to fix his dts.

During the debug I also noticed that xhci don't handle the PHY so I
also add the support for an optional phy. This patch is for Mathias
Nyman.

Thanks,

Gregory

Gregory CLEMENT (5):
  phy: add support for USB cluster on the Armada 375 SoC
  Documentation: dt-bindings: document the Armada 375 USB cluster
    binding
  ARM: mvebu: add Device Tree description of USB cluster controller on
    Armada 375
  usb: host: xhci-plat: add optional PHY support
  ARM: mvebu: add PHY support to the dts for the USB controllers on
    Armada 375

 .../bindings/phy/armada-375-usb-phy-cluster.txt    |  20 +++
 arch/arm/boot/dts/armada-375.dtsi                  |  11 ++
 drivers/phy/Kconfig                                |   6 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-armada375-usb2.c                   | 140 +++++++++++++++++++++
 drivers/usb/host/xhci-plat.c                       |  29 ++++-
 drivers/usb/host/xhci.h                            |   2 +
 include/dt-bindings/phy/armada-375-usb-cluster.h   |  18 +++
 8 files changed, 226 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/phy/armada-375-usb-phy-cluster.txt
 create mode 100644 drivers/phy/phy-armada375-usb2.c
 create mode 100644 include/dt-bindings/phy/armada-375-usb-cluster.h

-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbaJXPYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:24:30 -0400
Received: from down.free-electrons.com ([37.187.137.238]:40635 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755416AbaJXPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:24:27 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: "Kishon Vijay Abraham I" <kishon@ti.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] Add support for USB cluster(PHY muxer) on the Armada 375
Date: Fri, 24 Oct 2014 17:24:08 +0200
Message-Id: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this is the second version of a series I initially submitted in May:
https://lkml.org/lkml/2014/5/16/743

This series adds support for the USB cluster which is on the Armada
375 SoC. We can mainly see this device as a PHY muxer.

I more or less forgotten this series until the talk of Kishon Vijay
Abraham I about the phy framework.

Since this time, things have changed in the USB framework and I no
longer have to add the generic phy support in the xhci driver since it
was done at the usb core level.

While I ran coccicheck on my code I also found some possible
improvement in the phy driver: it was done in the 1st patch.

The second patch was a patch initially submitted by Andrew. This patch
added the mvebu-phy.txt but fell through a crack when adding the
driver. I join this patch on my series in order to be able to add the
new binding for the USB cluster of the Armada 375.

This was done in the third patch.

The forth patch was the addition of the phys driver itself.

The fifth and sixth patches are updating the device tree files related
to the Armada 375 using the new biding.

Thanks,

Gregory

Changelog:

v1 -> v2:

- Add a patch fixing the use of PTR_ERR_OR_ZERO.

- Add the patch adding the DT binding documentation for Marvell MVEBU
SATA phy from Andrew Lunn

- Move the DT binding documentation of the Armada 375 USB cluster into
  the phy-mvebu.txt file.

- Made the armada375_usb_phy_xlate more robust" if there is a phy_put
  and then a phy_get".

Andrew Lunn (1):
  Phy: DT binding documentation for Marvell MVEBU SATA phy.

Gregory CLEMENT (5):
  phy: Use PTR_ERR_OR_ZERO to fix warning raised by coccinelle
  Phy: DT binding documentation for the Armada 375 USB cluster binding
  phy: add support for USB cluster on the Armada 375 SoC
  ARM: mvebu: add Device Tree description of USB cluster controller on
    Armada 375
  ARM: mvebu: add PHY support to the dts for the USB controllers on
    Armada 375

 Documentation/devicetree/bindings/ata/marvell.txt  |   6 +
 .../devicetree/bindings/phy/phy-mvebu.txt          |  43 ++++++
 arch/arm/boot/dts/armada-375.dtsi                  |  11 ++
 drivers/phy/Kconfig                                |   6 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-armada375-usb2.c                   | 145 +++++++++++++++++++++
 drivers/phy/phy-berlin-sata.c                      |   5 +-
 drivers/phy/phy-hix5hd2-sata.c                     |   5 +-
 drivers/phy/phy-miphy365x.c                        |   5 +-
 drivers/phy/phy-stih41x-usb.c                      |   5 +-
 include/dt-bindings/phy/armada-375-usb-cluster.h   |  19 +++
 11 files changed, 235 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-mvebu.txt
 create mode 100644 drivers/phy/phy-armada375-usb2.c
 create mode 100644 include/dt-bindings/phy/armada-375-usb-cluster.h

-- 
1.9.1


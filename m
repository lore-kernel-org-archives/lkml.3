Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaF3NLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:11:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54448 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbaF3NLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:11:11 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 0/7] ARM: berlin: add AHCI support
Date: Mon, 30 Jun 2014 15:09:25 +0200
Message-Id: <1404133772-11741-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the support for Berlin SoC AHCI controller. The
controller allows to use the SATA host interface and, for example, the
eSATA port on the BG2Q.

The series adds a PHY driver to control the two SATA ports available,
and adds a generic compatible to use the existing ahci_platform driver.

Also enable the eSATA interface on the BG2Q DMP.

Changes since v7:
        - got back to the each PHY as a sub-node representation
	- renamed the power bit in the PHY driver

Changes since v6:
        - added the 'clocks' property and support in the PHY driver
        - updated the PHY compatible

Changes since v5:
        - rebased on top of v3.16-rc1
        - added the 'clocks' property in the sata node

Changes since v4:
        - updated PHY driver as tristate
        - handled the case were no SATA port is enabled
        - updated the compatible to a generic one
        - cosmetic fixups

Changes since v3:
        - moved all PHY operations to the PHY driver
        - removed PHY sub-nodes
        - removed the custom Berlin AHCI driver and switched to
          ahci_platform
        - added multiple PHYs support to the libahci_platform

Changes since v2:
        - modeled each PHY as a sub-node
        - cosmetic fixups

Changes since v1:
        - added a PHY driver, allowing to enable each port
          individually and removed the 'force-port-map' property
        - made the drivers a bit less magic :)
        - wrote a function to select and configure registers in the
          AHCI driver
        - removed BG2 / BG2CD nodes

Antoine Ténart (7):
  phy: add a driver for the Berlin SATA PHY
  Documentation: bindings: add the Berlin SATA PHY
  ata: libahci: allow to use multiple PHYs
  ata: ahci_platform: add a generic AHCI compatible
  Documentation: bindings: document the sub-nodes AHCI bindings
  ARM: berlin: add the AHCI node for the BG2Q
  ARM: berlin: enable the eSATA interface on the BG2Q DMP

 .../devicetree/bindings/ata/ahci-platform.txt      |  37 +++
 .../devicetree/bindings/phy/berlin-sata-phy.txt    |  34 +++
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |   8 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  39 +++
 drivers/ata/ahci.h                                 |   3 +-
 drivers/ata/ahci_platform.c                        |   2 +
 drivers/ata/libahci.c                              |   7 +
 drivers/ata/libahci_platform.c                     | 170 ++++++++++---
 drivers/phy/Kconfig                                |   7 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-berlin-sata.c                      | 262 +++++++++++++++++++++
 11 files changed, 534 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
 create mode 100644 drivers/phy/phy-berlin-sata.c

-- 
1.9.1


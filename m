Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaETJEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:04:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58304 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699AbaETJEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:04:38 -0400
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
Subject: [PATCH v4 0/7] ARM: berlin: add AHCI support
Date: Tue, 20 May 2014 11:04:28 +0200
Message-Id: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com>
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
and uses the existing ahci_platform driver.

Also enable the eSATA interface on the BG2Q DMP.

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
  ata: ahci_platform: add the Marvell Berlin AHCI compatible
  Documentation: bindings: document the sub-nodes AHCI bindings
  ARM: berlin: add the AHCI node for the BG2Q
  ARM: berlin: enable the eSATA interface on the BG2Q DMP

 .../devicetree/bindings/ata/ahci-platform.txt      |  38 +++-
 .../devicetree/bindings/phy/berlin-sata-phy.txt    |  14 ++
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |   8 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  27 +++
 drivers/ata/Kconfig                                |   1 +
 drivers/ata/ahci.h                                 |   3 +-
 drivers/ata/ahci_platform.c                        |   1 +
 drivers/ata/libahci.c                              |   7 +
 drivers/ata/libahci_platform.c                     | 165 +++++++++++----
 drivers/phy/Kconfig                                |   5 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-berlin-sata.c                      | 230 +++++++++++++++++++++
 12 files changed, 463 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
 create mode 100644 drivers/phy/phy-berlin-sata.c

-- 
1.9.1


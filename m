Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaG3SOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:14:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57809 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755268AbaG3SOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:14:05 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v14 0/8] ARM: berlin: add AHCI support
Date: Wed, 30 Jul 2014 20:13:53 +0200
Message-Id: <1406744041-1269-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kishon already took patches 1-2.

Following the build failure, I tested with various configurations
including the one use when the failure occured.


Changes since v13:
	- fixed compilation error

Changes since v12:
        - rebased on top of libata/for-3.17 (with libata/for-3.16-fixes
          pulled in)
        - removed the host_flags argument
        - added a comment in ahci_host_priv for the inputs

Changes since v11:
        - fixed a small issue in libahci

Changes since v10:
        - made a 1:1 relation between PHYs and ports numbers
        - added a SoC specific compatible when using 'generic-ahci'

Changes since v9:
        - moved port_map parameters into the AHCI structure

Changes since v8:
        - stopped reset the controller from the PHY driver
        - removed fixed array sizes
        - got rid of the custom to_berlin_sata_phy_priv() macro
        - added dependency to HAS_IOMEM

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

Antoine Ténart (8):
  phy: add a driver for the Berlin SATA PHY
  Documentation: bindings: add the Berlin SATA PHY
  ata: libahci_platform: move port_map parameters into the AHCI
    structure
  ata: libahci: allow to use multiple PHYs
  ata: ahci_platform: add a generic AHCI compatible
  Documentation: bindings: document the sub-nodes AHCI bindings
  ARM: berlin: add the AHCI node for the BG2Q
  ARM: berlin: enable the eSATA interface on the BG2Q DMP

 .../devicetree/bindings/ata/ahci-platform.txt      |  41 +++
 .../devicetree/bindings/phy/berlin-sata-phy.txt    |  34 +++
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |   8 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  39 +++
 drivers/ata/acard-ahci.c                           |   2 +-
 drivers/ata/ahci.c                                 |   3 +-
 drivers/ata/ahci.h                                 |  17 +-
 drivers/ata/ahci_da850.c                           |   3 +-
 drivers/ata/ahci_imx.c                             |   3 +-
 drivers/ata/ahci_mvebu.c                           |   3 +-
 drivers/ata/ahci_platform.c                        |   8 +-
 drivers/ata/ahci_st.c                              |   2 +-
 drivers/ata/ahci_sunxi.c                           |   8 +-
 drivers/ata/ahci_tegra.c                           |   3 +-
 drivers/ata/ahci_xgene.c                           |   6 +-
 drivers/ata/libahci.c                              |  19 +-
 drivers/ata/libahci_platform.c                     | 202 +++++++++++----
 drivers/ata/sata_highbank.c                        |   2 +-
 drivers/phy/Kconfig                                |   7 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-berlin-sata.c                      | 284 +++++++++++++++++++++
 include/linux/ahci_platform.h                      |   5 +-
 22 files changed, 605 insertions(+), 95 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
 create mode 100644 drivers/phy/phy-berlin-sata.c

-- 
1.9.1


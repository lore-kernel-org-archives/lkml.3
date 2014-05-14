Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaENJtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:49:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45047 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751308AbaENJtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:49:08 -0400
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
Subject: [PATCH v3 0/6] ARM: berlin: add AHCI support
Date: Wed, 14 May 2014 11:48:56 +0200
Message-Id: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the support for Berlin SoCs AHCI controllers. The
controller allows to use the SATA host interface and, for example, the
eSATA port on the BG2Q.

The series adds a PHY driver to control the two SATA ports available.

Also enable the eSATA interface on the BG2Q DMP.

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

Antoine Ténart (6):
  phy: add a driver for the Berlin SATA PHY
  Documentation: bindings: add the Berlin SATA PHY
  ata: ahci: add AHCI support for the Berlin BG2Q
  Documentation: bindings: add the berlin-ahci compatible to the ahci
    platform
  ARM: berlin: add the AHCI node for the BG2Q
  ARM: berlin: enable the eSATA interface on the BG2Q DMP

 .../devicetree/bindings/ata/ahci-berlin.txt        |  18 ++
 .../devicetree/bindings/phy/berlin-sata-phy.txt    |  34 ++++
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |  10 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  25 +++
 drivers/ata/Kconfig                                |  10 +
 drivers/ata/Makefile                               |   1 +
 drivers/ata/ahci_berlin.c                          | 202 +++++++++++++++++++++
 drivers/phy/Kconfig                                |   5 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-berlin-sata.c                      | 180 ++++++++++++++++++
 10 files changed, 486 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ata/ahci-berlin.txt
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
 create mode 100644 drivers/ata/ahci_berlin.c
 create mode 100644 drivers/phy/phy-berlin-sata.c

-- 
1.9.1


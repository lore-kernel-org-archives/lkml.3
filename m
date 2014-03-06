Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaCFDy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 22:54:26 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:13911 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbaCFDyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 22:54:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvEDAKzwF1Ol5H4JgWdsb2JhbABahky+YoExDgEBFiYogyUYgSeIC88BF45RhD8EmD2VbCg
From: Alistair Popple <alistair@popple.id.au>
To: benh@kernel.crashing.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, chris@printf.net,
        linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
Cc: Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 0/5] V2 IBM Akebono/PPC46GTR Support
Date: Thu,  6 Mar 2014 14:52:23 +1100
Message-Id: <1394077948-8395-1-git-send-email-alistair@popple.id.au>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IBM Akebono board is a development board for the new PPC476GTR
system on chip (SoC).

This version of the series updates the device tree and drops the USB
patches as the equivalent functionality is already in linux-next. It
also addresses feedback from the previous submission.

Alistair Popple (5):
  SDHCI: Add a generic registration to the SDHCI platform driver
  IBM Akebono: Add support for a new PHY interface to the IBM emac
    driver
  IBM Currituck: Clean up board specific code before adding Akebono code
  IBM Akebono: Add the Akebono platform
  powerpc: Added PCI MSI support using the HSTA module

 .../devicetree/bindings/mmc/sdhci-pltfm.txt        |  16 +
 .../devicetree/bindings/powerpc/4xx/akebono.txt    |  54 +++
 .../devicetree/bindings/powerpc/4xx/emac.txt       |   9 +
 .../devicetree/bindings/powerpc/4xx/hsta.txt       |  19 +
 arch/powerpc/boot/Makefile                         |   3 +
 arch/powerpc/boot/dcr.h                            |   4 +
 arch/powerpc/boot/dts/akebono.dts                  | 415 +++++++++++++++++++++
 arch/powerpc/boot/treeboot-akebono.c               | 163 ++++++++
 arch/powerpc/boot/wrapper                          |   3 +
 arch/powerpc/configs/44x/akebono_defconfig         | 148 ++++++++
 arch/powerpc/platforms/44x/Kconfig                 |  28 ++
 arch/powerpc/platforms/44x/Makefile                |   3 +-
 arch/powerpc/platforms/44x/currituck.c             | 233 ------------
 arch/powerpc/platforms/44x/ppc476.c                | 299 +++++++++++++++
 arch/powerpc/sysdev/Kconfig                        |   6 +
 arch/powerpc/sysdev/Makefile                       |   1 +
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c              | 215 +++++++++++
 arch/powerpc/sysdev/ppc4xx_pci.c                   |  21 +-
 drivers/mmc/host/sdhci-pltfm.c                     |  28 ++
 drivers/net/ethernet/ibm/emac/Kconfig              |   4 +
 drivers/net/ethernet/ibm/emac/Makefile             |   1 +
 drivers/net/ethernet/ibm/emac/core.c               |  50 ++-
 drivers/net/ethernet/ibm/emac/core.h               |  12 +
 drivers/net/ethernet/ibm/emac/rgmii_wol.c          | 244 ++++++++++++
 drivers/net/ethernet/ibm/emac/rgmii_wol.h          |  62 +++
 25 files changed, 1796 insertions(+), 245 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-pltfm.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/akebono.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/hsta.txt
 create mode 100644 arch/powerpc/boot/dts/akebono.dts
 create mode 100644 arch/powerpc/boot/treeboot-akebono.c
 create mode 100644 arch/powerpc/configs/44x/akebono_defconfig
 delete mode 100644 arch/powerpc/platforms/44x/currituck.c
 create mode 100644 arch/powerpc/platforms/44x/ppc476.c
 create mode 100644 arch/powerpc/sysdev/ppc4xx_hsta_msi.c
 create mode 100644 drivers/net/ethernet/ibm/emac/rgmii_wol.c
 create mode 100644 drivers/net/ethernet/ibm/emac/rgmii_wol.h

-- 
1.8.3.2


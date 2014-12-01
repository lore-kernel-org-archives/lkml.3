Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaLAK1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:27:34 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50354 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752596AbaLAK1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:27:32 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 00/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Mon,  1 Dec 2014 11:27:16 +0100
Message-Id: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EBI (External Bus Interface) is used to access external peripherals
(NOR, SRAM, NAND, and other specific devices like ethernet controllers).
Each device is assigned a CS line and an address range and can have its
own configuration (timings, access mode, bus width, ...).
This driver provides a generic DT binding to configure a device according
to its requirements.
For specific device controllers (like the NAND one) the SMC timings
should be configured by the controller driver through the matrix and
smc syscon regmaps.

The first 4 patches introduce 2 syscon devices needed to configure the
EBI bus, patch 5 and 6 adds support for the EBI bus, and the remaining
patches declares the EBI related nodes in sama5d3 dts[i] files.

Changes since v2:
- minor fixes int DT bindings doc
- fix SMC macros
- make use of SMC macros defined in include/linux/mfd/syscon/atmel-smc.h

Changes since v1:
- almost everything :-)

Boris Brezillon (11):
  mfd: syscon: Add atmel-matrix registers definition
  mfd: syscon: Add Atmel Matrix bus DT binding documentation
  mfd: syscon: Add atmel-smc registers definition
  mfd: syscon: Add Atmel SMC binding doc
  memory: add Atmel EBI (External Bus Interface) driver
  memory: atmel-ebi: add DT bindings documentation
  ARM: at91: select ATMEL_EBI when compiling a kernel for at91sam9 or
    sama5d3
  ARM: at91/dt: add HSMC (Static Memory Controller) node in sama5d3 dtsi
  ARM: at91/dt: add matrix node in sama5d3 dtsi
  ARM: at91/dt: add EBI (External Bus Interface) node in sama5d3 dtsi
  ARM: at91/dt: add NOR definition in sama5d3xcm dtsi

 .../bindings/memory-controllers/atmel-ebi.txt      | 155 +++++
 .../devicetree/bindings/mfd/atmel-matrix.txt       |  24 +
 .../devicetree/bindings/mfd/atmel-smc.txt          |  19 +
 arch/arm/boot/dts/sama5d3.dtsi                     |  93 +++
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |  34 ++
 arch/arm/mach-at91/Kconfig                         |   2 +
 drivers/memory/Kconfig                             |  11 +
 drivers/memory/Makefile                            |   1 +
 drivers/memory/atmel-ebi.c                         | 627 +++++++++++++++++++++
 include/linux/mfd/syscon/atmel-matrix.h            | 114 ++++
 include/linux/mfd/syscon/atmel-smc.h               |  65 +++
 11 files changed, 1145 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-matrix.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-smc.txt
 create mode 100644 drivers/memory/atmel-ebi.c
 create mode 100644 include/linux/mfd/syscon/atmel-matrix.h
 create mode 100644 include/linux/mfd/syscon/atmel-smc.h

-- 
1.9.1


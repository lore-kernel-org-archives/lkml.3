Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaKEQBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:01:43 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42976 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755130AbaKEQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:01:32 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 00/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Wed,  5 Nov 2014 17:01:16 +0100
Message-Id: <1415203287-21517-1-git-send-email-boris.brezillon@free-electrons.com>
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

The converters approach I suggested to Jean-Jacques has been dropped
and only SMC specific timing properties are supported.

Arnd, you've commented the first version of this driver (IIRC, you
focused on the DT binding part), could you give your feedback on this
version (I based the new DT binding on TI's aemif driver).

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

 .../bindings/memory-controllers/atmel-ebi.txt      | 153 +++++
 .../devicetree/bindings/mfd/atmel-matrix.txt       |  24 +
 .../devicetree/bindings/mfd/atmel-smc.txt          |  19 +
 arch/arm/boot/dts/sama5d3.dtsi                     |  93 ++++
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |  34 ++
 arch/arm/mach-at91/Kconfig                         |   2 +
 drivers/memory/Kconfig                             |  11 +
 drivers/memory/Makefile                            |   1 +
 drivers/memory/atmel-ebi.c                         | 615 +++++++++++++++++++++
 include/linux/mfd/syscon/atmel-matrix.h            | 114 ++++
 include/linux/mfd/syscon/atmel-smc.h               |  60 ++
 11 files changed, 1126 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-matrix.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-smc.txt
 create mode 100644 drivers/memory/atmel-ebi.c
 create mode 100644 include/linux/mfd/syscon/atmel-matrix.h
 create mode 100644 include/linux/mfd/syscon/atmel-smc.h

-- 
1.9.1


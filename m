Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaCLOHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:07:43 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64286 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbaCLOHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:07:42 -0400
From: Matt Porter <mporter@linaro.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 0/5] BCM59056 PMU regulator support
Date: Wed, 12 Mar 2014 10:07:12 -0400
Message-Id: <1394633237-16837-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCM59056 is a multi-function power management unit used with the
BCM281xx family of SoCs. This series adds an MFD and voltage regulator
driver to support the BCM59056. The bcm28155-ap DT support is updated
to enable use of regulators on the otg and sdhci peripherals.

Changes since v4:
	- clarify binding wording: regulators is a child node rather than
	  a property and the list of ldos/dcdcs are node names
	- remove unused #address-cells and #size-cells properties from
	  the binding and dtsi

Changes since v3:
	- remove needless init of local ret variable in mfd driver probe

Changes since v2:
	- Move to mfd_add_devices() approach, eliminating representation
	  of the regulator block as a hardware subdevice. Regulators are
	  listed in the PMU binding and referenced via the parent device
	  of_node by the regulator driver.
	- Allow mfd driver to build as module
	- Remove regulator constraints from the .dtsi include only the
	  board-specific constraints in the board .dts.

Changes since v1:
        - renamed to bcm590xx to accomodate future family parts
        - remove use of subsys_initcall
        - fix BCM590XX_MAX_REGISTER value
        - remove unused chip id in mfd of/i2c matching
        - switch to of_platform_populate() in mfd
        - update binding to single document with regulators as optional
          properties in the regulator subdevice IP description
        - remove unused regulator get/set mode ops
        - remove unneeded regulator NULL constraint check
        - regulators property is optional, allow the driver to probe
          when it is missing
        - move of_node presence check into bcm590xx_parse_dt_reg_data()


Matt Porter (5):
  mfd: add bcm590xx pmu DT binding
  mfd: add bcm590xx pmu driver
  regulator: add bcm590xx regulator driver
  ARM: configs: bcm_defconfig: enable bcm590xx regulator support
  ARM: dts: add bcm590xx pmu support and enable for bcm28155-ap

 Documentation/devicetree/bindings/mfd/bcm590xx.txt |  37 ++
 arch/arm/boot/dts/bcm28155-ap.dts                  |  47 ++-
 arch/arm/boot/dts/bcm59056.dtsi                    |  74 ++++
 arch/arm/configs/bcm_defconfig                     |   7 +
 drivers/mfd/Kconfig                                |   8 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/bcm590xx.c                             |  93 +++++
 drivers/regulator/Kconfig                          |   8 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/bcm590xx-regulator.c             | 413 +++++++++++++++++++++
 include/linux/mfd/bcm590xx.h                       |  31 ++
 11 files changed, 719 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/bcm590xx.txt
 create mode 100644 arch/arm/boot/dts/bcm59056.dtsi
 create mode 100644 drivers/mfd/bcm590xx.c
 create mode 100644 drivers/regulator/bcm590xx-regulator.c
 create mode 100644 include/linux/mfd/bcm590xx.h

-- 
1.8.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaBRXRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:17:23 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37168 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaBRXRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:17:19 -0500
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
Subject: [PATCH v2 0/5] BCM59056 PMU regulator support
Date: Tue, 18 Feb 2014 18:17:07 -0500
Message-Id: <1392765432-9111-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCM59056 is a multi-function power management unit used with the
BCM281xx family of SoCs. This series adds an MFD and voltage regulator
driver to support the BCM59056. The bcm28155-ap DT support is updated
to enable use of regulators on the otg and sdhci peripherals.

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

 Documentation/devicetree/bindings/mfd/bcm590xx.txt |  49 +++
 arch/arm/boot/dts/bcm28155-ap.dts                  |  43 ++-
 arch/arm/boot/dts/bcm59056.dtsi                    | 162 ++++++++
 arch/arm/configs/bcm_defconfig                     |   7 +
 drivers/mfd/Kconfig                                |   8 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/bcm590xx.c                             |  86 +++++
 drivers/regulator/Kconfig                          |   8 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/bcm590xx-regulator.c             | 419 +++++++++++++++++++++
 include/linux/mfd/bcm590xx.h                       |  31 ++
 11 files changed, 814 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/bcm590xx.txt
 create mode 100644 arch/arm/boot/dts/bcm59056.dtsi
 create mode 100644 drivers/mfd/bcm590xx.c
 create mode 100644 drivers/regulator/bcm590xx-regulator.c
 create mode 100644 include/linux/mfd/bcm590xx.h

-- 
1.8.4


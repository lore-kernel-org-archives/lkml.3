Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaBDMTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:19:23 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:45176 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaBDMTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:19:18 -0500
From: Matt Porter <mporter@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] BCM59056 PMU regulator support
Date: Tue,  4 Feb 2014 07:19:06 -0500
Message-Id: <1391516352-32359-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCM59056 is a multi-function power management unit used with the
BCM281xx family of SoCs. This series adds an MFD and voltage regulator
driver to support the BCM59056. The bcm28155-ap DT support is updated
to enable use of regulators on the otg and sdhci peripherals.

Matt Porter (6):
  i2c: bcm-kona: register with subsys_initcall
  regulator: add bcm59056 pmu DT binding
  mfd: add bcm59056 pmu driver
  regulator: add bcm59056 regulator driver
  ARM: configs: bcm_defconfig: enable bcm59056 regulator support
  ARM: dts: add bcm59056 pmu support and enable for bcm28155-ap

 .../devicetree/bindings/regulator/bcm59056.txt     |  37 ++
 arch/arm/boot/dts/bcm28155-ap.dts                  |  41 ++
 arch/arm/boot/dts/bcm59056.dtsi                    | 158 ++++++++
 arch/arm/configs/bcm_defconfig                     |   7 +
 drivers/i2c/busses/i2c-bcm-kona.c                  |  14 +-
 drivers/mfd/Kconfig                                |   8 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/bcm59056.c                             | 119 ++++++
 drivers/regulator/Kconfig                          |   8 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/bcm59056-regulator.c             | 445 +++++++++++++++++++++
 include/linux/mfd/bcm59056.h                       |  35 ++
 12 files changed, 873 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/bcm59056.txt
 create mode 100644 arch/arm/boot/dts/bcm59056.dtsi
 create mode 100644 drivers/mfd/bcm59056.c
 create mode 100644 drivers/regulator/bcm59056-regulator.c
 create mode 100644 include/linux/mfd/bcm59056.h

-- 
1.8.4


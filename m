Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218AbaFSSVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:21:11 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:56743 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173AbaFSSVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:21:09 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 00/14] Add Maxim 77802 PMIC support
Date: Thu, 19 Jun 2014 20:20:26 +0200
Message-Id: <1403202040-12641-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77802 is a PMIC that contains 10 high efficiency Buck regulators,
32 Low-dropout (LDO) regulators, two 32kHz buffered clock outputs,
a Real-Time-Clock (RTC) and a I2C interface to program the individual
regulators, clocks and the RTC.

This third version of the patch-set addresses several issues pointed
out by Mark Brown, Lee Jones and Doug Anderson. The individual changes
are added on each patch change log.

This series are based on drivers added by Simon Glass to the Chrome OS
kernel and adds support for the Maxim 77802 Power Management IC, their
regulators, clocks, RTC and I2C interface.

The patch-set has been tested on both Daisy/Snow (max77686) and Peach
pit (max77802) Chromebooks and it's composed of the following patches:

Doug Anderson (1):
  mfd: max77686: Allow the max77686 rtc to wakeup the system

Javier Martinez Canillas (13):
  mfd: max77686: Convert to use regmap_irq
  clk: max77686: Add DT include for MAX77686 PMIC clock
  clk: max77686: Improve Maxim 77686 PMIC clocks binding
  clk: Add generic driver for Maxim PMIC clocks
  clk: max77686: Convert to the generic max clock driver
  mfd: Add driver for Maxim 77802 Power Management IC
  mfd: max77802: Add DT binding documentation
  regmap: Add regmap_reg_copy function
  regulator: Add driver for Maxim 77802 PMIC regulators
  clk: Add driver for Maxim 77802 PMIC clocks
  clk: max77802: Add DT binding documentation
  rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
  ARM: dts: Add max77802 device node for exynos5420-peach-pit

 .../devicetree/bindings/clock/maxim,max77686.txt   |  15 +-
 .../devicetree/bindings/clock/maxim,max77802.txt   |  42 ++
 Documentation/devicetree/bindings/mfd/max77802.txt |  97 +++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         | 320 ++++++++++
 drivers/base/regmap/regmap.c                       |  34 +
 drivers/clk/Kconfig                                |  11 +
 drivers/clk/Makefile                               |   2 +
 drivers/clk/clk-max-gen.c                          | 197 ++++++
 drivers/clk/clk-max-gen.h                          |  32 +
 drivers/clk/clk-max77686.c                         | 183 +-----
 drivers/clk/clk-max77802.c                         |  99 +++
 drivers/mfd/Kconfig                                |  15 +
 drivers/mfd/Makefile                               |   3 +-
 drivers/mfd/max77686-irq.c                         | 319 ----------
 drivers/mfd/max77686.c                             |  97 ++-
 drivers/mfd/max77802.c                             | 368 +++++++++++
 drivers/regulator/Kconfig                          |   9 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/max77802.c                       | 691 +++++++++++++++++++++
 drivers/rtc/Kconfig                                |  10 +
 drivers/rtc/Makefile                               |   1 +
 drivers/rtc/rtc-max77686.c                         |  55 +-
 drivers/rtc/rtc-max77802.c                         | 637 +++++++++++++++++++
 include/dt-bindings/clock/maxim,max77686.h         |  23 +
 include/dt-bindings/clock/maxim,max77802.h         |  22 +
 include/linux/mfd/max77686-private.h               |  28 +-
 include/linux/mfd/max77686.h                       |   2 -
 include/linux/mfd/max77802-private.h               | 307 +++++++++
 include/linux/mfd/max77802.h                       | 124 ++++
 include/linux/regmap.h                             |   9 +
 30 files changed, 3221 insertions(+), 532 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/maxim,max77802.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/max77802.txt
 create mode 100644 drivers/clk/clk-max-gen.c
 create mode 100644 drivers/clk/clk-max-gen.h
 create mode 100644 drivers/clk/clk-max77802.c
 delete mode 100644 drivers/mfd/max77686-irq.c
 create mode 100644 drivers/mfd/max77802.c
 create mode 100644 drivers/regulator/max77802.c
 create mode 100644 drivers/rtc/rtc-max77802.c
 create mode 100644 include/dt-bindings/clock/maxim,max77686.h
 create mode 100644 include/dt-bindings/clock/maxim,max77802.h
 create mode 100644 include/linux/mfd/max77802-private.h
 create mode 100644 include/linux/mfd/max77802.h

-- 
2.0.0.rc2


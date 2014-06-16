Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbaFPSDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:03:10 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:54590 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaFPSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:03:08 -0400
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
Subject: [PATCH v2 00/10] Add Maxim 77802 PMIC support
Date: Mon, 16 Jun 2014 20:02:28 +0200
Message-Id: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77802 is a PMIC that contains 10 high efficiency Buck regulators,
32 Low-dropout (LDO) regulators, two 32kHz buffered clock outputs,
a Real-Time-Clock (RTC) and a I2C interface to program the individual
regulators, clocks and the RTC.

This second version of the patch-set addresses several issues pointed
out by Krzysztof Kozlowski, Mark Brown and Lee Jones. The individual
changes are added on each patch change log.

The series are based on drivers added by Simon Glass to the Chrome OS
kernel and adds support for the Maxim 77802 Power Management IC, their
regulators, clocks, RTC and I2C interface. It's composed of patches:

[PATCH v2 1/10] mfd: max77686: Convert to use regmap_irq
[PATCH v2 2/10] clk: max77686: add DT include for MAX77686 PMIC clock
[PATCH v2 3/10] Documentation: dt: improve Maxim 77686 PMIC clocks binding
[PATCH v2 4/10] clk: Add generic driver for Maxim PMIC clocks
[PATCH v2 5/10] clk: max77686: convert to the generic max clock driver
[PATCH v2 6/10] mfd: Add driver for Maxim 77802 Power Management IC
[PATCH v2 7/10] regulator: Add driver for Maxim 77802 PMIC regulators
[PATCH v2 8/10] clk: Add driver for Maxim 77802 PMIC clocks
[PATCH v2 9/10] rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
[PATCH v2 10/10] ARM: dts: Add max77802 device node for exynos5420-peach-pit

Patches 1-3 are improvements to the max77686 driver, Patch 4 adds a generic
clock driver that can be shared by both max77686 and max77802 clock drivers
and Patch 5 converts the former.

Patches 6-9 add support for the different 77802 devices and Patch 10 enables
the MAX77802 PMIC on the Exynos5420 based Peach pit board.

The patch-set has been tested on both Daisy/Snow (max77686) and Peach pit
(max77802) Chromebooks.

NOTE: Since this series convert the max77686 driver to use regmap_irq API
(getting rid of drivers/mfd/max77686-irq.c) and refactor the clock driver,
the amount of duplicated code between 77686 and 77802 drivers were reduced
significantly since v1. Still there is room for more code consolidation if
the max77686 core mfd driver is extended to support max77802 instead.

drivers/mfd/max14577.c is an example of such a combined driver that support
two different Maxim PMIC (14577 and 77836) but I'm not convinced that having
a single driver to support both 77686 and 77802 lead to a cleaner and more
maintainable code than having two separate (and now smaller) mfd core drivers.

Thanks a lot and best regards,
Javier

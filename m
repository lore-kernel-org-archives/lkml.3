Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaFZNcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:32:48 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:58530 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaFZNcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:32:47 -0400
MIME-Version: 1.0
In-Reply-To: <1403723019-6212-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1403723019-6212-1-git-send-email-javier.martinez@collabora.co.uk>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 26 Jun 2014 19:02:25 +0530
Message-ID: <CAHfPSqB9620OiHxd_w3ReS6gg7PzYK1eN11rH6Z6boai0x=2og@mail.gmail.com>
Subject: Re: [PATCH v4 00/14] Add Maxim 77802 PMIC support
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Javier,

On 26 June 2014 00:33, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> MAX77802 is a PMIC that contains 10 high efficiency Buck regulators,
> 32 Low-dropout (LDO) regulators, two 32kHz buffered clock outputs,
> a Real-Time-Clock (RTC) and a I2C interface to program the individual
> regulators, clocks and the RTC.
>
> This fourth version of the patch-set addresses several issues pointed
> out by Mark Brown, Doug Anderson and Krzysztof Kozlowski The individual
> changes are added on each patch change log.
>
> This series are based on drivers added by Simon Glass to the Chrome OS
> kernel and adds support for the Maxim 77802 Power Management IC, their
> regulators, clocks, RTC and I2C interface.
>
> NOTE: This version of the series model the real power scheme for Maxim
> 77802 regulators instead of a simplistic model like in older versions.
> So these changes depend on patch:
>
> "[PATCH v3] ARM: dts: Add cros_ec to exynos5420-peach-pit and exynos5800-peach-pi"
> https://patchwork.kernel.org/patch/4411351/
>
> which adds tps65090 support to Peach boards since regulators from this
> PMIC supply power to a set of MAX77802 regulators.
>
> The patch-set has been tested on both Daisy/Snow (max77686) and Peach
> pit (max77802) Chromebooks and it's composed of the following patches:
>
> Doug Anderson (1):
>   mfd: max77686: Allow the max77686 rtc to wakeup the system
>
> Javier Martinez Canillas (13):
>   mfd: max77686: Convert to use regmap_irq
>   clk: max77686: Add DT include for MAX77686 PMIC clock
>   clk: max77686: Improve Maxim 77686 PMIC clocks binding
>   clk: Add generic driver for Maxim PMIC clocks
>   clk: max77686: Convert to the generic max clock driver
>   mfd: Add driver for Maxim 77802 Power Management IC
>   mfd: max77802: Add DT binding documentation
>   regmap: Add regmap_reg_copy function
>   regulator: Add driver for Maxim 77802 PMIC regulators
>   clk: Add driver for Maxim 77802 PMIC clocks
>   clk: max77802: Add DT binding documentation
>   rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
>   ARM: dts: Add max77802 to exynos5420-peach-pit and exynos5800-peach-pi
>
>  .../devicetree/bindings/clock/maxim,max77686.txt   |  15 +-
>  .../devicetree/bindings/clock/maxim,max77802.txt   |  42 ++
>  Documentation/devicetree/bindings/mfd/max77802.txt |  97 +++
>  arch/arm/boot/dts/exynos5420-peach-pit.dts         | 343 ++++++++++
>  arch/arm/boot/dts/exynos5800-peach-pi.dts          | 343 ++++++++++
>  drivers/base/regmap/regmap.c                       |  34 +
>  drivers/clk/Kconfig                                |  11 +
>  drivers/clk/Makefile                               |   2 +
>  drivers/clk/clk-max-gen.c                          | 195 ++++++
>  drivers/clk/clk-max-gen.h                          |  32 +
>  drivers/clk/clk-max77686.c                         | 183 +-----
>  drivers/clk/clk-max77802.c                         |  99 +++
>  drivers/mfd/Kconfig                                |  15 +
>  drivers/mfd/Makefile                               |   3 +-
>  drivers/mfd/max77686-irq.c                         | 319 ----------
>  drivers/mfd/max77686.c                             |  97 ++-
>  drivers/mfd/max77802.c                             | 366 +++++++++++
>  drivers/regulator/Kconfig                          |   9 +
>  drivers/regulator/Makefile                         |   1 +
>  drivers/regulator/max77802.c                       | 694 +++++++++++++++++++++
>  drivers/rtc/Kconfig                                |  10 +
>  drivers/rtc/Makefile                               |   1 +
>  drivers/rtc/rtc-max77686.c                         |  55 +-
>  drivers/rtc/rtc-max77802.c                         | 637 +++++++++++++++++++
>  include/dt-bindings/clock/maxim,max77686.h         |  23 +
>  include/dt-bindings/clock/maxim,max77802.h         |  22 +
>  include/linux/mfd/max77686-private.h               |  28 +-
>  include/linux/mfd/max77686.h                       |   2 -
>  include/linux/mfd/max77802-private.h               | 307 +++++++++
>  include/linux/mfd/max77802.h                       | 121 ++++
>  include/linux/regmap.h                             |   9 +
>  31 files changed, 3583 insertions(+), 532 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/maxim,max77802.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/max77802.txt
>  create mode 100644 drivers/clk/clk-max-gen.c
>  create mode 100644 drivers/clk/clk-max-gen.h
>  create mode 100644 drivers/clk/clk-max77802.c
>  delete mode 100644 drivers/mfd/max77686-irq.c
>  create mode 100644 drivers/mfd/max77802.c
>  create mode 100644 drivers/regulator/max77802.c
>  create mode 100644 drivers/rtc/rtc-max77802.c
>  create mode 100644 include/dt-bindings/clock/maxim,max77686.h
>  create mode 100644 include/dt-bindings/clock/maxim,max77802.h
>  create mode 100644 include/linux/mfd/max77802-private.h
>  create mode 100644 include/linux/mfd/max77802.h
>
> --
> 2.0.0.rc2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

With this patchset
+
[PATCH 0/4 v2] hwmon: ntc_thermistor: prepose vendor prefix change
http://www.spinics.net/lists/linux-samsung-soc/msg33034.html
+
spi: s3c64xx: fix broken "cs_gpios" usage in the driver
http://comments.gmane.org/gmane.linux.kernel.samsung-soc/33102
+
[PATCH v2] ARM: dts: Add cros_ec to exynos5420-peach-pit and exynos5800-peach-pi
http://www.gossamer-threads.com/lists/linux/kernel/1951591

Tested on Peach PIT and PI boards.

1. Max77802 seems to probe and configure the supplies properly.
    Verified via the sysfs entries exported by the regulators.

2. ADC probes fine and Thermistors report proper values,
    ADC requires vdd_supply = "ldo09_reg".

Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

-- 
Shine bright,
(: Nav :)

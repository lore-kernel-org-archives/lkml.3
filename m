Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaBFSDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:03:14 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.162]:61609 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaBFSDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:03:11 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-7.tower-39.messagelabs.com!1391709787!11864051!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 6 Feb 2014 18:03:04 +0000
Subject: [PATCH v2 0/8] da9055: Driver initialisation fixes, add DT support
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series provides the following updates for DA9055 drivers:

 - Fixes an issue with da9055 driver initialisation (conflicting device ids) of
   PMIC (MFD) and CODEC drivers which means they cannot be used together on
   the same I2C bus.
 - Add initial DT support for DA9055 related drivers, including binding
   documentation.
 - Remove use of regmap_irq_get_virq() in driver probes which was conflicting
   with use of platform_get_irq_byname(). platform_get_irq_byname() already
   returns the VIRQ number due to MFD core translation so using
   regmap_irq_get_virq() on that returned value results in an incorrect IRQ
   being requested. The driver probes then fail because of this.

[Changes since v1]:

 - Regulator:
    * fixed coding style issue (lack of braces for if,else statement)
    * removal of 'ifdef' around DT related headers
    * Use of 'of_regulator_match()' for retrieving regulator related info
      from DT nodes.

 - General:
    * Instead of removing platform_get_irq_byname() usage and device resources
      to fix IRQ conflict in driver probes, now removed 'regmap_irq_get_virq()'
      as advised. This has been tested on target for both DT and non-DT setups
      and works as expected.

Adam Thomson (8):
  ASoC: da9055: Fix device registration of PMIC and CODEC devices
  ASoC: da9055: Add DT support for CODEC
  mfd: da9055: Add DT support for PMIC
  regulator: da9055: Add DT support
  onkey: da9055: Remove use of regmap_irq_get_virq()
  hwmon: da9055: Remove use of regmap_irq_get_virq()
  rtc: da9055: Remove use of regmap_irq_get_virq()
  regulator: da9055: Remove use of regmap_irq_get_virq()

 Documentation/devicetree/bindings/mfd/da9055.txt   |   73 ++++++++++++++++++++
 Documentation/devicetree/bindings/sound/da9055.txt |   22 ++++++
 drivers/hwmon/da9055-hwmon.c                       |    4 -
 drivers/input/misc/da9055_onkey.c                  |    1 -
 drivers/mfd/da9055-i2c.c                           |   20 +++++-
 drivers/regulator/da9055-regulator.c               |   73 ++++++++++++++++++--
 drivers/rtc/rtc-da9055.c                           |    4 +-
 sound/soc/codecs/da9055.c                          |   19 +++++-
 8 files changed, 201 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9055.txt
 create mode 100644 Documentation/devicetree/bindings/sound/da9055.txt


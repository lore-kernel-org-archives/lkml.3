Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaBERzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:55:13 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.169]:30989 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450AbaBERzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:55:10 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2014 12:55:09 EST
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-2.tower-39.messagelabs.com!1391622513!11649373!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 5 Feb 2014 17:48:28 +0000
Subject: [PATCH 0/8] da9055: Driver initialisation fixes, add DT support
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
   PMIC (MFD) and CODEC drivers.
 - Add initial DT support for DA9055 related drivers, including binding
   documentation.
 - Remove conflicting use of platform_get_irq_byname() in driver probes.
 - Remove unnecessary resource structures for MFD cells as a result of removing
   use of platform_get_irq_byname().

Adam Thomson (8):
  ASoC: da9055: Fix device registration of PMIC and CODEC devices
  ASoC: da9055: Add DT support for CODEC
  mfd: da9055: Add DT support for PMIC
  regulator: da9055: Add DT support
  onkey: da9055: Remove use of platform_get_irq_byname()
  hwmon: da9055: Remove use of platform_get_irq_byname()
  rtc: da9055: Remove use of platform_get_irq_byname()
  mfd: da9055: Remove unused resource structures for mfd cells.

 Documentation/devicetree/bindings/mfd/da9055.txt   |   73 ++++++++++++++++++++
 Documentation/devicetree/bindings/sound/da9055.txt |   22 ++++++
 drivers/hwmon/da9055-hwmon.c                       |    7 +--
 drivers/input/misc/da9055_onkey.c                  |    9 +--
 drivers/mfd/da9055-core.c                          |   46 ------------
 drivers/mfd/da9055-i2c.c                           |   20 +++++-
 drivers/regulator/da9055-regulator.c               |   59 ++++++++++++++--
 drivers/rtc/rtc-da9055.c                           |    3 +-
 sound/soc/codecs/da9055.c                          |   19 +++++-
 9 files changed, 188 insertions(+), 70 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9055.txt
 create mode 100644 Documentation/devicetree/bindings/sound/da9055.txt


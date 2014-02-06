Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaBFAyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:54:14 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44404 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaBFAyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:54:12 -0500
Date: Wed, 5 Feb 2014 16:54:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 0/8] da9055: Driver initialisation fixes, add DT support
Message-ID: <20140206005406.GC1308@roeck-us.net>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 05:48:28PM +0000, Adam Thomson wrote:
> This patch series provides the following updates for DA9055 drivers:
> 
>  - Fixes an issue with da9055 driver initialisation (conflicting device ids) of
>    PMIC (MFD) and CODEC drivers.
>  - Add initial DT support for DA9055 related drivers, including binding
>    documentation.
>  - Remove conflicting use of platform_get_irq_byname() in driver probes.

Adam,

You don't really explain what the problem actually is. Can you elaborate ?

Also, I have been using platform_get_irq() to get the interrupt resource
in mfd client drivers and similar situations. Wouldn't this work here as well
if you don't want to use platform_get_irq_byname() ?

Thanks,
Guenter

>  - Remove unnecessary resource structures for MFD cells as a result of removing
>    use of platform_get_irq_byname().
> 
> Adam Thomson (8):
>   ASoC: da9055: Fix device registration of PMIC and CODEC devices
>   ASoC: da9055: Add DT support for CODEC
>   mfd: da9055: Add DT support for PMIC
>   regulator: da9055: Add DT support
>   onkey: da9055: Remove use of platform_get_irq_byname()
>   hwmon: da9055: Remove use of platform_get_irq_byname()
>   rtc: da9055: Remove use of platform_get_irq_byname()
>   mfd: da9055: Remove unused resource structures for mfd cells.
> 
>  Documentation/devicetree/bindings/mfd/da9055.txt   |   73 ++++++++++++++++++++
>  Documentation/devicetree/bindings/sound/da9055.txt |   22 ++++++
>  drivers/hwmon/da9055-hwmon.c                       |    7 +--
>  drivers/input/misc/da9055_onkey.c                  |    9 +--
>  drivers/mfd/da9055-core.c                          |   46 ------------
>  drivers/mfd/da9055-i2c.c                           |   20 +++++-
>  drivers/regulator/da9055-regulator.c               |   59 ++++++++++++++--
>  drivers/rtc/rtc-da9055.c                           |    3 +-
>  sound/soc/codecs/da9055.c                          |   19 +++++-
>  9 files changed, 188 insertions(+), 70 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/da9055.txt
>  create mode 100644 Documentation/devicetree/bindings/sound/da9055.txt
> 
> 

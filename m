Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3F0Kxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:53:37 -0400
Received: from www.xora.org.uk ([80.68.91.202]:35241 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3F0Kxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:53:34 -0400
Message-ID: <51CC19A1.90706@slimlogic.co.uk>
Date: Thu, 27 Jun 2013 11:53:21 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
CC: rob@landley.net, sameo@linux.intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, balajitk@ti.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v1 0/2] TWL6030, TWL6032 GPADC driver
References: <1372329818-12384-1-git-send-email-oleksandr.kozaruk@ti.com>
In-Reply-To: <1372329818-12384-1-git-send-email-oleksandr.kozaruk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suspect this will find a better home in drivers/iio that subsystem did
not exist when driver was originally written.

It would need converted to new API.

Graeme

On 27/06/13 11:43, Oleksandr Kozaruk wrote:
> Hello
>
> TWL603[02] GPADC is used to measure battery voltage,
> battery temperature, battery presence ID, and could
> be used to measure twl603[02] die temperature.
> This is used on TI blaze, blaze tablet platforms.
>
> The TWL6030 and TWL6032 have GPADC with 17 and 19
> channels respectively. Some channels have current
> source and are used for measuring voltage drop
> on resistive load for detecting battery ID resistance,
> or measuring voltage drop on NTC resistors for external
> temperature measurements. Some channels measure voltage,
> (i.e. battery voltage), and have inbuilt voltage dividers,
> thus, capable to scale voltage. Some channels are dedicated
> for measuring die temperature.
>
> Some channels could be calibrated in 2 points, having
> offsets from ideal values in trim registers.
>
> The difference between GPADC in TWL6030 and TWL6032:
> - 10 bit vs 12 bit ADC;
> - 17 vs 19 channels;
> - channels have different purpose(i. e. battery voltage
>   channel 8 vs channel 18);
> - trim values are interpreted differently.
>
> The driver exports function returning converted value for
> requested channels: raw code, corrected code, and converted
> to mV result.
>
> Sysfs entries are added to start and read conversion result
> in millivolts for channel if it has calibration data, or
> ADC code(for temperature and test network channels).
>
> The driver is derived from git://git.omapzoom.org/kernel/omap.git
> The original driver's authors and contributors are Balaji T K,
> Graeme Gregory, Ambresh K, Girish S Ghongdemath.
>
> The changes to the original driver:
> - device tree adaptation;
> - drop ioctl support - never been used;
> - unified measurement method for both devices;
> - get rid of "if (device == X)" code style to data driven;
> - drop polling end of conversion and use interrupt instead;
> - simplified (hopefully) exported external function interface to the driver.
>
> Tested with on blaze tablet 2 with OMAP4430(twl6030), and
> OMAP4470(twl6032) SOMs.
>
> The patches were tested against 3.10-rc7
>
> Oleksandr Kozaruk (2):
>   ARM: dts: twl: Add GPADC data to device tree
>   mfd: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
>
>  .../testing/sysfs-devices-platform-twl6030_gpadc   |    5 +
>  arch/arm/boot/dts/twl6030.dtsi                     |    5 +
>  drivers/mfd/Kconfig                                |    8 +
>  drivers/mfd/Makefile                               |    1 +
>  drivers/mfd/twl6030-gpadc.c                        | 1053 ++++++++++++++++++++
>  include/linux/i2c/twl6030-gpadc.h                  |   51 +
>  6 files changed, 1123 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-twl6030_gpadc
>  create mode 100644 drivers/mfd/twl6030-gpadc.c
>  create mode 100644 include/linux/i2c/twl6030-gpadc.h
>


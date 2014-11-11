Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaKKLhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:37:20 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:35245 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaKKLKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:45 -0500
Date: Tue, 11 Nov 2014 11:10:37 +0000
From: Lee Jones <lee.jones@linaro.org>
To: gyungoh@gmail.com
Cc: sameo@linux.intel.com, jg1.han@samsung.com, cooloney@gmail.com,
        broonie@kernel.org, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v6 0/8] Add Skyworks SKY81452 device drivers
Message-ID: <20141111111037.GW24004@x1>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gyungoh,

You are still missing Acks for this set.  Can you please send it again
with the Acks that you have collected thus far.

Please do not send it in reply-to these others.  I would suggest never
sending out the set again in reply-to a previous version, as things
get confusing real quick.

> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> 
> This patch set includes regulator and backlight driver for SKY81452.
> Also it includes documents for device tree and module.
> The initial version of sky81452-regulator was applied. Fo this, incremental
> patches are included.
> 
> v6:
> Added new line character at the end of line of dev_err()
> 
> v5:
> Changed DT for regulator : 'lout' node should be defined under 'regulator'
> Removed compatible string from sky81452-regulator driver
> Modified sky81452-regulator to return EINVAL when of_node is NULL
> Move sky81452-backlight.h to include/linux/platform_data
> 
> v4:
> Removed MODULE_VERSION()
> Modified license to GPLv2
> Removed calling to backlight_device_unregister() in sky81452-backlight
> 
> v3:
> Cleaned-up DBG messages
> Cleaned-up DT
> Fixed the backlight name from 'sky81452-bl' to 'sky81452-backlight'
> Assigned mfd_cell.of_compatible for binding device node
> Modified error messages
> Modified sky81452-regulator to return ENODATA when of_node is NULL
> 
> v2:
> Split the patches for each sub-system
> Added 'reg' attribute for I2C address in device tree documents
> Added 'compatible' attribute in child drivers
> Renamed CONFIG_SKY81452 to CONFIG_MFD_SKY81452
> Changed the dependency from I2C=y to I2C, for CONFIG_MFD_SKY81452
> Added message for exception or errors.
> Added vendor prefix for Skyworks Solutions, Inc.
> Add SKY81452 to the Trivial Devices list
> 
> Gyungoh Yoo (8):
>   mfd: Add support for Skyworks SKY81452 driver
>   backlight: Add support Skyworks SKY81452 backlight driver
>   devicetree: mfd: Add new SKY81452 mfd binding
>   devicetree: backlight: Add new SKY81452 backlight binding
>   devicetree: Add vendor prefix for Skyworks Solutions, Inc.
>   devicetree: i2c: Add SKY81452 to the Trivial Devices list
>   regulator: sky81452: Add compatible string for device binding
>   devicetree: regulator: sky81452: Add compatible string for device
>     binding
> 
>  .../devicetree/bindings/i2c/trivial-devices.txt    |   1 +
>  Documentation/devicetree/bindings/mfd/sky81452.txt |  33 ++
>  .../bindings/regulator/sky81452-regulator.txt      |  10 +-
>  .../devicetree/bindings/vendor-prefixes.txt        |   1 +
>  .../video/backlight/sky81452-backlight.txt         |  24 ++
>  drivers/mfd/Kconfig                                |  12 +
>  drivers/mfd/Makefile                               |   1 +
>  drivers/mfd/sky81452.c                             | 109 +++++++
>  drivers/regulator/Kconfig                          |   2 +-
>  drivers/regulator/sky81452-regulator.c             |  29 +-
>  drivers/video/backlight/Kconfig                    |  10 +
>  drivers/video/backlight/Makefile                   |   1 +
>  drivers/video/backlight/sky81452-backlight.c       | 345 +++++++++++++++++++++
>  include/linux/mfd/sky81452.h                       |  32 ++
>  include/linux/platform_data/sky81452-backlight.h   |  47 +++
>  15 files changed, 642 insertions(+), 15 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt
>  create mode 100644 Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
>  create mode 100644 drivers/mfd/sky81452.c
>  create mode 100644 drivers/video/backlight/sky81452-backlight.c
>  create mode 100644 include/linux/mfd/sky81452.h
>  create mode 100644 include/linux/platform_data/sky81452-backlight.h
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaJUMaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:30:12 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34979 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbaJUMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:30:10 -0400
Date: Tue, 21 Oct 2014 13:30:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: sameo@linux.intel.com, jg1.han@samsung.com, cooloney@gmail.com,
        broonie@kernel.org, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v4 1/8] mfd: Add support for Skyworks SKY81452
 driver
Message-ID: <20141021123001.GA4939@x1>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-2-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413179262-27636-2-git-send-email-jack.yoo@skyworksinc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2014, Gyungoh Yoo wrote:

> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> ---
> Changes v4:
> Removed MODULE_VERSION()
> Modified license to GPLv2
> 
> Changes v3:
> Fixed the backlight name from 'sky81452-bl' to 'sky81452-backlight'
> Assigned mfd_cell.of_compatible for binding device node
> Modified error messages
> 
> Changes v2:
> Renamed CONFIG_SKY81452 to CONFIG_MFD_SKY81452
> Changed the dependency from I2C=y to I2C, for CONFIG_MFD_SKY81452
> Added message for exception or errors
> 
>  drivers/mfd/Kconfig          |  12 +++++
>  drivers/mfd/Makefile         |   1 +
>  drivers/mfd/sky81452.c       | 110 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/sky81452.h |  32 +++++++++++++
>  4 files changed, 155 insertions(+)
>  create mode 100644 drivers/mfd/sky81452.c
>  create mode 100644 include/linux/mfd/sky81452.h

[...]

> +++ b/include/linux/mfd/sky81452.h
> @@ -0,0 +1,32 @@
> +/*
> + * sky81452.h	SKY81452 MFD driver
> + *
> + * Copyright 2014 Skyworks Solutions Inc.
> + * Author : Gyungoh Yoo <jack.yoo@skyworksinc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _SKY81452_H
> +#define _SKY81452_H
> +
> +#include <linux/sky81452-backlight.h>

Shouldn't this live in linux/platform_data?

> +#include <linux/regulator/machine.h>
> +
> +struct sky81452_platform_data {
> +	struct sky81452_bl_platform_data *bl_pdata;
> +	struct regulator_init_data *regulator_init_data;
> +};
> +
> +#endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaFPN2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:28:00 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:43723 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaFPN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:27:58 -0400
Date: Mon, 16 Jun 2014 14:27:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, support.opensource@diasemi.com
Subject: Re: [PATCH 6/8] power: Add support for DA9150 Charger
Message-ID: <20140616132749.GW14323@lee--X1>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
 <d4ef0d7ce2d6a2919d528ed75e82d2b99ec8d962.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4ef0d7ce2d6a2919d528ed75e82d2b99ec8d962.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Adam Thomson wrote:

> This patch adds support for DA9150 Charger & Fuel-Guage IC Charger.
> 
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> ---
>  drivers/power/Kconfig              |  23 ++
>  drivers/power/Makefile             |   1 +
>  drivers/power/da9150-charger.c     | 790 +++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/da9150/charger.h |  58 +++
>  4 files changed, 872 insertions(+)
>  create mode 100644 drivers/power/da9150-charger.c
>  create mode 100644 include/linux/mfd/da9150/charger.h

[...]

> diff --git a/include/linux/mfd/da9150/charger.h b/include/linux/mfd/da9150/charger.h
> new file mode 100644
> index 0000000..73c41b3
> --- /dev/null
> +++ b/include/linux/mfd/da9150/charger.h
> @@ -0,0 +1,58 @@
> +/*
> + * DA9150 MFD Driver - Charger Data
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef _DA9150_CHARGER_H
> +#define _DA9150_CHARGER_H

Two '_'s are normally preferred.

> +#include <linux/device.h>
> +#include <linux/i2c.h>

What are you using this for?

> +#include <linux/power_supply.h>
> +#include <linux/notifier.h>
> +#include <linux/usb/otg.h>
> +#include <linux/timer.h>
> +#include <linux/iio/consumer.h>
> +
> +#include <linux/mfd/da9150/core.h>
> +
> +

Extra '\n' here.

> +struct da9150_charger_attr_map {
> +	struct device_attribute attr;
> +	u16 reg;
> +	u8 shift;
> +	u8 mask;
> +};
> +
> +/* Private data */
> +struct da9150_charger {
> +	struct da9150 *da9150;
> +	struct device *dev;
> +
> +	struct power_supply ac;
> +	struct power_supply usb;
> +	struct power_supply battery;

Do you want these (or pointers to these) here?

How much space do they take up?

> +	struct power_supply *supply_online;
> +
> +	struct usb_phy *usb_phy;
> +	struct notifier_block otg_nb;
> +	struct work_struct otg_work;
> +	unsigned long usb_event;
> +
> +	struct iio_channel *ibus_chan;
> +	struct iio_channel *vbus_chan;
> +	struct iio_channel *tjunc_chan;
> +	struct iio_channel *vbat_chan;
> +
> +	bool invalid_tbat;
> +};
> +
> +#endif /* _DA9150_CHARGER_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

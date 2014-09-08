Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaIHQqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:46:42 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40723 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaIHQqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:46:40 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 8 Sep 2014 18:44:38 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 3/3] gpio: add support for the Diolan DLN-2 USB GPIO
 driver
Message-ID: <20140908164438.GG9560@localhost>
References: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
 <1409930279-1382-4-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409930279-1382-4-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 06:17:59PM +0300, Octavian Purdila wrote:

> --- /dev/null
> +++ b/drivers/gpio/gpio-dln2.c
> @@ -0,0 +1,537 @@
> +/*
> + * Driver for the Diolan DLN-2 USB-GPIO adapter
> + *
> + * Copyright (c) 2014 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/irqdomain.h>
> +#include <linux/irq.h>
> +#include <linux/irqchip/chained_irq.h>
> +#include <linux/usb.h>
> +#include <linux/gpio.h>
> +#include <linux/gpio/driver.h>
> +#include <linux/ptrace.h>
> +#include <linux/wait.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/dln2.h>

It seems you don't need all these includes (usb, ptrace, wait...). Only
include what you actually use.

Johan

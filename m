Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaLZPzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 10:55:09 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:65284 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaLZPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 10:55:07 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19GyuXFH7Yu1UKMtLL5yQZY
Date: Fri, 26 Dec 2014 07:54:57 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        ivo.g.dimitrov.75@gmail.com, jdelvare@suse.de, linux@roeck-us.net,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] add omap34xx temperature monitoring support
Message-ID: <20141226155456.GB12409@atomide.com>
References: <20141226102933.GA28778@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141226102933.GA28778@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [141226 02:32]:
> --- /dev/null
> +++ b/drivers/hwmon/omap34xx_temp.c
> @@ -0,0 +1,263 @@
> +/*
> + * omap34xx_temp.c - Linux kernel module for OMAP34xx hardware monitoring
> + *
> + * Copyright (C) 2008 Nokia Corporation
> + *
> + * Written by Peter De Schrijver <peter.de-schrijver@nokia.com>
> + *
> + * Inspired by k8temp.c
> + *
> + * This file is subject to the terms and conditions of the GNU General
> + * Public License. See the file "COPYING" in the main directory of this
> + * archive for more details.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/hrtimer.h>
> +#include <linux/module.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +
> +#include "../../arch/arm/mach-omap2/control.h"

No need to do this, you can use syscon here like pbias-regulator.c
is doing.

Regards,

Tony

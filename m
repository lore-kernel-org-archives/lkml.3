Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab3HOGUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:20:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:3650 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab3HOGUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:20:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,883,1367996400"; 
   d="scan'208";a="362939165"
Message-ID: <1376547666.2335.104.camel@rzhang-lenovo>
Subject: Re: [RFC PATCH 1/4] thermal: hwmon: move hwmon support to single
 file
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, durgadoss.r@intel.com, amit.daniel@samsung.com,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Aug 2013 14:21:06 +0800
In-Reply-To: <1373378414-28086-2-git-send-email-eduardo.valentin@ti.com>
References: <1373378414-28086-1-git-send-email-eduardo.valentin@ti.com>
	 <1373378414-28086-2-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eduardo,

thanks for the patch, just one minor comments.

On 二, 2013-07-09 at 10:00 -0400, Eduardo Valentin wrote:
> diff --git a/drivers/thermal/thermal_hwmon.h b/drivers/thermal/thermal_hwmon.h
> new file mode 100644
> index 0000000..c798fdb
> --- /dev/null
> +++ b/drivers/thermal/thermal_hwmon.h
> @@ -0,0 +1,49 @@
> +/*
> + *  thermal_hwmon.h - Generic Thermal Management hwmon support.
> + *
> + *  Code based on Intel thermal_core.c. Copyrights of the original code:
> + *  Copyright (C) 2008 Intel Corp
> + *  Copyright (C) 2008 Zhang Rui <rui.zhang@intel.com>
> + *  Copyright (C) 2008 Sujith Thomas <sujith.thomas@intel.com>
> + *
> + *  Copyright (C) 2013 Texas Instruments
> + *  Copyright (C) 2013 Eduardo Valentin <eduardo.valentin@ti.com>
> + *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +#ifndef __THERMAL_HWMON_H__
> +#define __THERMAL_HWMON_H__
> +
> +#include <linux/thermal.h>
> +
> +#ifdef CONFIG_THERMAL_HWMON
> +int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz);
> +void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz);
> +#else
> +static int
> +thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
> +{
> +	return 0;
> +}
> +
> +static void
> +thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
> +{
> +}
> +#endif
> +

I'd prefer use "inline" here.

thanks,
rui

> +#endif /* __THERMAL_HWMON_H__ */



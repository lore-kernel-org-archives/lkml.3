Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaKJKeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:34:36 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:57191 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbaKJKee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:34:34 -0500
Message-ID: <1415615671.4862.30.camel@x220>
Subject: Re: [PATCH v9 07/12] coresight-etm: add CoreSight ETM/PTM driver
From: Paul Bolle <pebolle@tiscali.nl>
To: mathieu.poirier@linaro.org
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, gregkh@linuxfoundation.org,
        linux@arm.linux.org.uk, pratikp@codeaurora.org, varshney@ti.com,
        Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, kaixu.xia@linaro.org, marcin.jabrzyk@gmail.com,
        r.sengupta@samsung.com, robbelibobban@gmail.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Nov 2014 11:34:31 +0100
In-Reply-To: <1415038066-22423-8-git-send-email-mathieu.poirier@linaro.org>
References: <1415038066-22423-1-git-send-email-mathieu.poirier@linaro.org>
	 <1415038066-22423-8-git-send-email-mathieu.poirier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2014 10:34:32.0219 (UTC) FILETIME=[EA0E16B0:01CFFCD1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 11:07 -0700, mathieu.poirier@linaro.org wrote:
> From: Pratik Patel <pratikp@codeaurora.org>
> 
> This driver manages CoreSight ETM (Embedded Trace Macrocell) that
> supports processor tracing. Currently supported version are ARM
> ETMv3.x and PTM1.x.
> 
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> coresight-etm3x: adding missing error checking

This landed in today's linx-next (ie, next-20141110) as commit
a939fc5a71ad ("coresight-etm: add CoreSight ETM/PTM driver").

>  arch/arm/Kconfig.debug                 |    9 +
>  arch/arm/include/asm/hardware/cp14.h   |  542 +++++++++
>  drivers/coresight/Makefile             |    1 +
>  drivers/coresight/coresight-etm-cp14.c |  591 ++++++++++
>  drivers/coresight/coresight-etm.h      |  251 +++++
>  drivers/coresight/coresight-etm3x.c    | 1928 ++++++++++++++++++++++++++++++++
>  6 files changed, 3322 insertions(+)
>  create mode 100644 arch/arm/include/asm/hardware/cp14.h
>  create mode 100644 drivers/coresight/coresight-etm-cp14.c
>  create mode 100644 drivers/coresight/coresight-etm.h
>  create mode 100644 drivers/coresight/coresight-etm3x.c
> 
>[...]
> diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/coresight/coresight-etm3x.c
> new file mode 100644
> index 0000000..d9e3ed6
> --- /dev/null
> +++ b/drivers/coresight/coresight-etm3x.c
> @@ -0,0 +1,1928 @@
> +/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/fs.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/smp.h>
> +#include <linux/sysfs.h>
> +#include <linux/stat.h>
> +#include <linux/clk.h>
> +#include <linux/cpu.h>
> +#include <linux/of.h>
> +#include <linux/coresight.h>
> +#include <linux/amba/bus.h>
> +#include <linux/seq_file.h>
> +#include <linux/uaccess.h>
> +#include <asm/sections.h>
> +
> +#include "coresight-etm.h"
> +
> +#ifdef CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE

There's no Kconfig symbol CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE. Neither
is there a preprocessor definition of this macro. So why was this
added? 

> +static int boot_enable = 1;
> +#else
> +static int boot_enable;
> +#endif
> +module_param_named(
> +	boot_enable, boot_enable, int, S_IRUGO
> +);


Paul Bolle


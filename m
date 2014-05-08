Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbaEHUFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:05:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40938 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755344AbaEHUE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:04:58 -0400
Message-ID: <536BE366.8080907@free-electrons.com>
Date: Thu, 08 May 2014 22:04:54 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v2 3/7] mfd: add support for sun6i PRCM (Power/Reset/Clock
 Management) unit
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com> <1399483554-8824-4-git-send-email-boris.brezillon@free-electrons.com> <20140508110205.GB5767@lee--X1>
In-Reply-To: <20140508110205.GB5767@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/05/2014 13:02, Lee Jones wrote:
>> The PRCM (Power/Reset/Clock Management) block exposes several subdevices
>> in different subsystems (clk, reset ...)
>>
>> Add basic support for the PRCM unit with clk (AR100, AHB0, and APB0 clks)
>> and reset controller subdevices.
>>
>> Other subdevices might be added later (if needed).
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  drivers/mfd/Kconfig      |   8 +++
>>  drivers/mfd/Makefile     |   1 +
>>  drivers/mfd/sun6i-prcm.c | 151 +++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 160 insertions(+)
>>  create mode 100644 drivers/mfd/sun6i-prcm.c
> [...]
>
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include <linux/errno.h>
>> +#include <linux/err.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/io.h>
>> +#include <linux/slab.h>
>> +#include <linux/mutex.h>
>> +#include <linux/completion.h>
>> +#include <linux/irq.h>
>> +#include <linux/jiffies.h>
>> +#include <linux/bitops.h>
>> +#include <linux/fs.h>
>> +#include <linux/of.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/mfd/core.h>
> I'm pretty sure you don't need half of these.  Please only add the
> ones you make use of.

Sure (this is what happens when you copy/paste from another driver :-))

>
> [...]
>
>> +	dev_info(&pdev->dev, "PRCM initialized\n");
> Please remove this from here.

Okay.

>
> [...]
>
>> +static struct platform_driver sun6i_prcm_driver = {
>> +	.driver = {
>> +		.name = "sun6i-prcm",
>> +		.owner = THIS_MODULE,
>> +		.of_match_table = sun6i_prcm_dt_ids,
>> +	},
>> +	.probe = sun6i_prcm_probe,
> You need a .remove() call-back.

This driver cannot be compiled as module (see the Kconfig definition)
and the devices are not hotpluggable, as a result a probed device will
never be removed.

Do you still want me to implement the remove function ?

>
>> +};
>> +module_platform_driver(sun6i_prcm_driver);
>> +
>> +MODULE_AUTHOR("Boris BREZILLON <boris.brezillon@free-electrons.com>");
>> +MODULE_DESCRIPTION("Allwinner sun6i PRCM driver");
>> +MODULE_LICENSE("GPL v2");

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com


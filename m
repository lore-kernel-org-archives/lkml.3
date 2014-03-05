Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbaCELxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:53:53 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:35305 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaCELxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:53:51 -0500
Message-ID: <5317102C.7000007@gmail.com>
Date: Wed, 05 Mar 2014 12:53:16 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 01/11] base: power: Add generic OF-based power domain
 look-up
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com> <1393862536-9842-2-git-send-email-tomasz.figa@gmail.com> <20140304182310.GA9985@codeaurora.org>
In-Reply-To: <20140304182310.GA9985@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.03.2014 19:23, Stephen Boyd wrote:
> On 03/03, Tomasz Figa wrote:
>> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
>> index dc127e5..006b455 100644
>> --- a/drivers/base/power/domain.c
>> +++ b/drivers/base/power/domain.c
>> @@ -3,12 +3,16 @@
>>    *
>>    * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
>>    *
>> + * Support for Device Tree based power domain providers:
>> + * Copyright (C) 2014 Tomasz Figa <tomasz.figa@gmail.com>
>> + *
>>    * This file is released under the GPLv2.
>>    */
>>
>>   #include <linux/init.h>
>>   #include <linux/kernel.h>
>>   #include <linux/io.h>
>> +#include <linux/platform_device.h>
>
> Is this still needed?
>

Probably not.

>>   #include <linux/pm_runtime.h>
>>   #include <linux/pm_domain.h>
>>   #include <linux/pm_qos.h>
> [...]
>> +
>> +/*
>> + * DEVICE<->DOMAIN BINDING USING DEVICE TREE LOOK-UP
>> + *
>> + * The code below registers a notifier for platform bus devices'
>> + * BUS_NOTIFY_BIND_DRIVER events and tries to attach devices to their power
>> + * domains by looking them up using Device Tree.
>> + *
>> + * Similarly in BUS_NOTIFY_UNBOUND_DRIVER the device is detached from its
>> + * domain, since it no longer supports runtime PM without any driver bound
>> + * to it.
>
> This looks outdated.
>

Oops, missed this one. Thanks for pointing out.

Best regards,
Tomasz

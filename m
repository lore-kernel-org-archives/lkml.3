Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbaF3QD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:03:28 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51927 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbaF3QDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <53B14386.1040706@de.bosch.com>
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
	<1403892261-25026-7-git-send-email-mathieu.poirier@linaro.org>
	<53B14386.1040706@de.bosch.com>
Date: Mon, 30 Jun 2014 10:03:24 -0600
Message-ID: <CANLsYky_D3J0=b-zGuwP0kgV4m2ZY5Gw0ft1M7=LbePczc0N0w@mail.gmail.com>
Subject: Re: [PATCH 6/9 v2] coresight-etm: add CoreSight ETM/PTM driver
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        Robert Marklund <robbelibobban@gmail.com>, Al Grant <Al.Grant@arm.com>,
        Patch Tracking <patches@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        r.sengupta@samsung.com,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Tony Armitstead <Tony.Armitstead@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James King <james.king@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2014 05:01, Dirk Behme <dirk.behme@de.bosch.com> wrote:
> On 27.06.2014 20:04, mathieu.poirier@linaro.org wrote:
>>
>> From: Pratik Patel <pratikp@codeaurora.org>
>>
>> This driver manages CoreSight ETM (Embedded Trace Macrocell) that
>> supports processor tracing. Currently supported version are ARM
>> ETMv3.3, v3.5 and PTM.
>>
>> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
>> Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> ---
>>   arch/arm/include/asm/hardware/cp14.h   |  540 ++++++++++++
>>   drivers/coresight/Kconfig              |   19 +
>>   drivers/coresight/Makefile             |    1 +
>>   drivers/coresight/coresight-etm-cp14.c |  506 +++++++++++
>>   drivers/coresight/coresight-etm.c      | 1507
>> ++++++++++++++++++++++++++++++++
>>   drivers/coresight/coresight-etm.h      |  192 ++++
>>   6 files changed, 2765 insertions(+)
>>   create mode 100644 arch/arm/include/asm/hardware/cp14.h
>>   create mode 100644 drivers/coresight/coresight-etm-cp14.c
>>   create mode 100644 drivers/coresight/coresight-etm.c
>>   create mode 100644 drivers/coresight/coresight-etm.h
>
> ....
>>
>> diff --git a/drivers/coresight/coresight-etm-cp14.c
>> b/drivers/coresight/coresight-etm-cp14.c
>> new file mode 100644
>> index 0000000..4173710
>> --- /dev/null
>> +++ b/drivers/coresight/coresight-etm-cp14.c
>> @@ -0,0 +1,506 @@
>> +/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/types.h>
>> +#include <linux/bug.h>
>> +#include <asm/hardware/cp14.h>
>> +
>> +#include <coresight-etm.h>
>
>
> As coresight-etm.h is in drivers/coresight I had to use
>
> -#include <coresight-etm.h>
> +#include "coresight-etm.h"
>
> Not sure if this somehow depends on the kernel version/tooling, though.

You mean that you got a compilation failure?

>
> Best regards
>
> Dirk
>

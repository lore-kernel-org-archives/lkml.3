Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab3A2NkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:40:01 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:44207 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab3A2Njv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:39:51 -0500
Message-ID: <5107D104.5050304@synopsys.com>
Date: Tue, 29 Jan 2013 19:09:16 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v3 32/71] ARC: [DeviceTree] Basic support
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-15-git-send-email-vgupta@synopsys.com> <5107CDD3.3050502@gmail.com>
In-Reply-To: <5107CDD3.3050502@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2013 06:55 PM, Rob Herring wrote:
> On 01/24/2013 04:50 AM, Vineet Gupta wrote:
>> This is minimal infrastructure needed for devicetree work.
>> It uses an a sample "skeleton" devicetree - embedded in kernel image -
>> to print the board, manufacturer by parsing the top-level "compatible"
>> string.
>>
>> As of now we don't need any additional "board" specific "machine_desc".
>>
>> TODO: support interpreting the command line as boot-loader passed dtb
>>
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: Rob Herring <rob.herring@calxeda.com>
> One minor thing below, otherwise:
>
> Reviewed-by: Rob Herring <rob.herring@calxeda.com>
>
>
>> diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
>> new file mode 100644
>> index 0000000..229f78e
>> --- /dev/null
>> +++ b/arch/arc/kernel/devtree.c
>> @@ -0,0 +1,69 @@
>> +/*
>> + * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
>> + *
>> + * Based on highly stipped down version of METAG
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +
>> +#include <linux/init.h>
>> +#include <linux/export.h>
>> +#include <linux/errno.h>
> Is this include needed?

Nope - removed.

>
>> +#include <linux/types.h>
>> +#include <linux/reboot.h>
> And this?

reboot.h is needed for the machine_halt() prototype.

>
>> +#include <linux/memblock.h>
>> +#include <linux/of.h>
>> +#include <linux/of_fdt.h>
>> +#include <linux/of_irq.h>
> And this?
>
>> +#include <linux/of_platform.h>
> And this?

Both of the above removed.

I'll send a revised patch which also addresses James' review comments as well -
(namely broken dtbs rule, adding dependency on scripts ...)
See https://lkml.org/lkml/2013/1/28/138 for reference.


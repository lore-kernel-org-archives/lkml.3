Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731Ab3E2LHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:07:38 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:34233 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965542Ab3E2LHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:07:37 -0400
Message-ID: <51A5E177.3090809@fold.natur.cuni.cz>
Date: Wed, 29 May 2013 13:07:35 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17.1
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] ACPI: Fix potential NULL pointer dereference in acpi_processor_add()
References: <519E0F2A.4070602@linaro.org> <1693841.iH9OWSxHyo@vostro.rjw.lan> <51A55C2B.7050805@linaro.org>
In-Reply-To: <51A55C2B.7050805@linaro.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hanjun Guo wrote:
> On 2013-5-29 7:30, Rafael J. Wysocki wrote:
>> On Thursday, May 23, 2013 08:44:26 PM Hanjun Guo wrote:
>>> In acpi_processor_add(), get_cpu_device() will return NULL sometimes,
>>> although the chances are small, I think it should be fixed.
>>>
>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>
>> This patch isn't necessary any more after the changes queued up for 3.11
>> in the acpi-hotplug branch of the linux-pm.git tree.
> 
> Ok, I noticed your patch set, just drop my patch.

But shouldn't this go to stable at least? I checked linux-3.9.4
and it applies fine. Whether this is relevant for other stable
series I will leave up to somebody else. ;)
Martin

> 
> Thanks
> Hanjun
> 
>>
>> Thanks,
>> Rafael
>>
>>
>>> ---
>>>  drivers/acpi/processor_driver.c |    4 ++++
>>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
>>> index bec717f..dd64f23 100644
>>> --- a/drivers/acpi/processor_driver.c
>>> +++ b/drivers/acpi/processor_driver.c
>>> @@ -579,6 +579,10 @@ static int __cpuinit acpi_processor_add(struct acpi_device
>>> *device)
>>>         per_cpu(processors, pr->id) = pr;
>>>
>>>         dev = get_cpu_device(pr->id);
>>> +       if (!dev) {
>>> +               result = -ENODEV;
>>> +               goto err_clear_processor;
>>> +       }
>>>         if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
>>>                 result = -EFAULT;
>>>                 goto err_clear_processor;
>>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

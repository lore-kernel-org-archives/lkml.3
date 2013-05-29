Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895Ab3E2BkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:40:11 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41314 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934257Ab3E2BkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:40:09 -0400
Message-ID: <51A55C2B.7050805@linaro.org>
Date: Wed, 29 May 2013 09:38:51 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] ACPI: Fix potential NULL pointer dereference in acpi_processor_add()
References: <519E0F2A.4070602@linaro.org> <1693841.iH9OWSxHyo@vostro.rjw.lan>
In-Reply-To: <1693841.iH9OWSxHyo@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-5-29 7:30, Rafael J. Wysocki wrote:
> On Thursday, May 23, 2013 08:44:26 PM Hanjun Guo wrote:
>> In acpi_processor_add(), get_cpu_device() will return NULL sometimes,
>> although the chances are small, I think it should be fixed.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> 
> This patch isn't necessary any more after the changes queued up for 3.11
> in the acpi-hotplug branch of the linux-pm.git tree.

Ok, I noticed your patch set, just drop my patch.

Thanks
Hanjun

> 
> Thanks,
> Rafael
> 
> 
>> ---
>>  drivers/acpi/processor_driver.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
>> index bec717f..dd64f23 100644
>> --- a/drivers/acpi/processor_driver.c
>> +++ b/drivers/acpi/processor_driver.c
>> @@ -579,6 +579,10 @@ static int __cpuinit acpi_processor_add(struct acpi_device
>> *device)
>>         per_cpu(processors, pr->id) = pr;
>>
>>         dev = get_cpu_device(pr->id);
>> +       if (!dev) {
>> +               result = -ENODEV;
>> +               goto err_clear_processor;
>> +       }
>>         if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
>>                 result = -EFAULT;
>>                 goto err_clear_processor;
>>


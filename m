Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaABW7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:59:32 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:25083 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaABW7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:59:31 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-e3-52c5ef5229af
Message-id: <52C5EF46.1010806@samsung.com>
Date: Thu, 02 Jan 2014 15:59:18 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: gregkh@linuxfoundation.org, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3/3] driver: Add Legacy PM OPS usage check and warning to
 driver_register()
References: <cover.1383868060.git.shuah.kh@samsung.com>
 <b33c1967bdaed9a36fa5a6d7855310c84cb9b910.1383868060.git.shuah.kh@samsung.com>
 <1868309.7dxduFC77U@vostro.rjw.lan>
In-reply-to: <1868309.7dxduFC77U@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9hX92g90eDDObN57JoXryezeLyrjls
	FmdOX2K1+PrTwYHFY+esu+we++euYffYcrWdxePzJrkAligum5TUnMyy1CJ9uwSujIPt99kK
	5vBVrHr2kbWBcRN3FyMnh4SAicSqcwdYIWwxiQv31rN1MXJxCAksY5Q4vX8LO4TTyyQxqekl
	I4SzkVHi3pyLYC28AloST/b8ZQOxWQRUJR7972ICsdkE1CU+v97BDmILCchJNC1ZzQxiiwpE
	SLw6O5EFoldQ4sfke2C2iIC2xNyeU2A1zAJlEgvuXwGaycEhLJAosWp+NsTedYwSR+ZNAdvL
	KWAgsfRHKztEvZnEo5Z1UL3yEpvXvGWG2Kss8efyKSaQORICihLbV1tNYBSZhWTzLCTds5B0
	L2BkXsUoVlqcXFCclJ5aYaRXnJhbXJqXrpecn7uJERIf1TsY7361OcQowMGoxMPr0Xg0SIg1
	say4MvcQowQHs5IIb+JjoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGpSs5fVKfdKqfn2P4Ffbu
	essx/rR7Wws8Ji4557pmVXcTd+3UbfL/JJQFiirral+4JD8Ta72iIib8gOV9zrGcFPbbUtun
	RNpteMGw+Xu+2eyC1F1bT0yIVZW7/s9TlL3IftcMh9mT/zErNOSaSTr/WvXn77ovWutfV503
	9o2bIn3WxNNDIPmAEktxRqKhFnNRcSIAMRDTHm0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 05:51 PM, Rafael J. Wysocki wrote:
> On Thursday, November 07, 2013 05:03:50 PM Shuah Khan wrote:
>> Add Legacy PM OPS usage checks to driver_register() function. If Legacy PM OPS
>> usage is found, print warning message to indicate the driver code needs
>> updating to use Dev PM OPS interfaces. This will help serve as a way to track
>> drivers that still use Legacy PM OPS and fix them.
>>
>> The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
>> resume(struct device *) struct device_driver interfaces.
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   drivers/base/driver.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/base/driver.c b/drivers/base/driver.c
>> index 9e29943..10ff280 100644
>> --- a/drivers/base/driver.c
>> +++ b/drivers/base/driver.c
>> @@ -157,6 +157,10 @@ int driver_register(struct device_driver *drv)
>>   		printk(KERN_WARNING "Driver '%s' needs updating - please use "
>>   			"bus_type methods\n", drv->name);
>>
>> +	if (drv->suspend || drv->resume)
>> +		pr_warn("Please update driver '%s' to use dev pm ops.\n",
>> +			drv->name);
>
> What about the following message instead:
>
> 		pr_warn("Driver '%s' needs updating - please use the pm pointer.\n",
> 			drv->name);

I thought pm ops would be more informative for driver developers. That 
said, I will change the message and re-send the patch.

>
> And analogously for bus types and classes?
>
>> +
>>   	other = driver_find(drv->name, drv->bus);
>>   	if (other) {
>>   		printk(KERN_ERR "Error: Driver '%s' is already registered, "
>>
>
> Thanks!
>


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

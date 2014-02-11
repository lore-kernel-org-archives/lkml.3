Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbaBKJuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:50:51 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:46080 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBKJuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:50:44 -0500
MIME-Version: 1.0
In-Reply-To: <52F9ED02.6000604@realtek.com>
References: <1391697307-23457-1-git-send-email-rogerable@realtek.com>
	<1391697307-23457-3-git-send-email-rogerable@realtek.com>
	<201402110748.s1B7miQ8010938@rtits1.realtek.com>
	<52F9ED02.6000604@realtek.com>
Date: Tue, 11 Feb 2014 10:50:43 +0100
Message-ID: <CAPDyKFqp-_KguRjby4gSnjjXKctHrhjh3uWqYHmJFcD=x3Dogg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mmc: Add realtek USB sdmmc host driver
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org,
        Wei WANG <wei_wang@realsil.com.cn>, micky_ching@realsil.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2014 10:27, Roger <rogerable@realtek.com> wrote:
> On 02/10/2014 10:58 PM, Ulf Hansson wrote:
>>
>> On 6 February 2014 15:35,  <rogerable@realtek.com> wrote:
>>>
>>> From: Roger Tseng <rogerable@realtek.com>
>>>
>>> Realtek USB SD/MMC host driver provides mmc host support based on the
>>> Realtek
>>> USB card reader MFD driver.
>>>
>>> Signed-off-by: Roger Tseng <rogerable@realtek.com>
>>> ---
>>>   drivers/mmc/host/Kconfig          |    7 +
>>>   drivers/mmc/host/Makefile         |    1 +
>>>   drivers/mmc/host/rtsx_usb_sdmmc.c | 1500
>>> +++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 1508 insertions(+)
>>>   create mode 100644 drivers/mmc/host/rtsx_usb_sdmmc.c
>
> [snip]
>
>>> +#ifdef CONFIG_PM_RUNTIME
>>
>>
>> There are stubs for pm_runtime* functions, thus the ifdefs can be removed.
>> Please go though the complete patch and remove all instances.
>>
>>> +               pm_runtime_put(sdmmc_dev(host));
>>
>>
>> I don't know so much about USB mmc hosts hardware, but I just wanted
>> to find out if I have understood this correct.
>>
>> You can't do fine grained power management of the USB parent device,
>> since it needs to be runtime resumed to be able keep the power the
>> card? Once it becomes runtime suspended, the power to the card will
>> thus also be dropped?
>>
> Yes, and to keep some internal state of the controller.

Okay.

But the internal state of the controller should be possible to restore
at runtime_resume, so that should not be the reason, right?

>
> [snip]
>
>>> +#ifdef CONFIG_PM
>>
>>
>> I suppose this should be CONFIG_PM_SLEEP?
>>
> ...
>
>>> +       err = mmc_suspend_host(mmc);
>>
>>
>> This won't compile. The mmc_suspend_host API has been removed.
>>
> ...
>
>>> +       return mmc_resume_host(mmc);
>>
>>
>> This won't compile. The mmc_resume_host API has been removed.
>>
> ...
>>>
>>> +static struct platform_driver rtsx_usb_sdmmc_driver = {
>>> +       .probe          = rtsx_usb_sdmmc_drv_probe,
>>> +       .remove         = rtsx_usb_sdmmc_drv_remove,
>>> +       .id_table       = rtsx_usb_sdmmc_ids,
>>> +       .suspend        = rtsx_usb_sdmmc_suspend,
>>> +       .resume         = rtsx_usb_sdmmc_resume,
>>
>>
>> Please use the modern pm_ops instead of the legacy suspend/resume
>> callbacks.
>> I suggest you then also switch to use the SIMPLE_DEV_PM_OPS macro.
>
>
> I just missed the removal of mmc_suspend|resume_host.
>
> I'll remove all these unnecessary mmc host pm things as done in commit
> ff71c4bcb0af2730d047989e485303ae4e1ce794 for drivers of our PCIe devices.
>
> Thanks for pointing this out.
>
>> Kind regards
>> Ulf Hansson

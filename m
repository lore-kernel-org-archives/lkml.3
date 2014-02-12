Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaBLDhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 22:37:33 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47786 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaBLDhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 22:37:31 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1C3aj1A020589, This message is accepted by code: ctloc85258
Message-ID: <52FAECEB.3060902@realtek.com>
Date: Wed, 12 Feb 2014 11:39:23 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>,
        Wei WANG <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v3 2/3] mmc: Add realtek USB sdmmc host driver
References: <1391697307-23457-1-git-send-email-rogerable@realtek.com>	<1391697307-23457-3-git-send-email-rogerable@realtek.com>	<201402110748.s1B7miQ8010938@rtits1.realtek.com>	<52F9ED02.6000604@realtek.com> <201402111621.s1BGLdOt002176@rtits1.realtek.com>
In-Reply-To: <201402111621.s1BGLdOt002176@rtits1.realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 05:50 PM, Ulf Hansson wrote:
> On 11 February 2014 10:27, Roger <rogerable@realtek.com> wrote:
>> On 02/10/2014 10:58 PM, Ulf Hansson wrote:
>>>
>>> On 6 February 2014 15:35,  <rogerable@realtek.com> wrote:
>>>>
>>>> From: Roger Tseng <rogerable@realtek.com>
>>>>
>>>> Realtek USB SD/MMC host driver provides mmc host support based on the
>>>> Realtek
>>>> USB card reader MFD driver.
>>>>
>>>> Signed-off-by: Roger Tseng <rogerable@realtek.com>
>>>> ---
>>>>    drivers/mmc/host/Kconfig          |    7 +
>>>>    drivers/mmc/host/Makefile         |    1 +
>>>>    drivers/mmc/host/rtsx_usb_sdmmc.c | 1500
>>>> +++++++++++++++++++++++++++++++++++++
>>>>    3 files changed, 1508 insertions(+)
>>>>    create mode 100644 drivers/mmc/host/rtsx_usb_sdmmc.c
>>
>> [snip]
>>
>>>> +#ifdef CONFIG_PM_RUNTIME
>>>
>>>
>>> There are stubs for pm_runtime* functions, thus the ifdefs can be removed.
>>> Please go though the complete patch and remove all instances.
>>>
>>>> +               pm_runtime_put(sdmmc_dev(host));
>>>
>>>
>>> I don't know so much about USB mmc hosts hardware, but I just wanted
>>> to find out if I have understood this correct.
>>>
>>> You can't do fine grained power management of the USB parent device,
>>> since it needs to be runtime resumed to be able keep the power the
>>> card? Once it becomes runtime suspended, the power to the card will
>>> thus also be dropped?
>>>
>> Yes, and to keep some internal state of the controller.
>
> Okay.
>
> But the internal state of the controller should be possible to restore
> at runtime_resume, so that should not be the reason, right?
>

I checked again. Internal registers will hold its state during suspend.
Card power is the exact reason.
>>> Kind regards
>>> Ulf Hansson
> .
>

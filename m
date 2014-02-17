Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaBQKXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:23:12 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51042 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBQKXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:23:09 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1HAML4f005119, This message is accepted by code: ctloc85258
Message-ID: <5301E376.8010000@realtek.com>
Date: Mon, 17 Feb 2014 18:24:54 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v4 1/3] mfd: Add realtek USB card reader driver
References: <1392199238-14500-1-git-send-email-rogerable@realtek.com> <1392199238-14500-2-git-send-email-rogerable@realtek.com> <20140214094427.GA7380@lee--X1> <5301A786.8040607@realtek.com> <20140217082222.GA17875@lee--X1> <5301D369.5010100@realtek.com> <20140217100211.GE17875@lee--X1>
In-Reply-To: <20140217100211.GE17875@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 06:02 PM, Lee Jones wrote:
>>>>>> From: Roger Tseng <rogerable@realtek.com>
>>>>>>
>>>>>> Realtek USB card reader provides a channel to transfer command or data to flash
>>>>>> memory cards. This driver exports host instances for mmc and memstick subsystems
>>>>>> and handles basic works.
>>>>>>
>>>>>> Signed-off-by: Roger Tseng <rogerable@realtek.com>
>>>>>> ---
>>>>>>   drivers/mfd/Kconfig          |  10 +
>>>>>>   drivers/mfd/Makefile         |   1 +
>>>>>>   drivers/mfd/rtsx_usb.c       | 760 +++++++++++++++++++++++++++++++++++++++++++
>>>>>>   include/linux/mfd/rtsx_usb.h | 628 +++++++++++++++++++++++++++++++++++
>>>>>>   4 files changed, 1399 insertions(+)
>>>>>>   create mode 100644 drivers/mfd/rtsx_usb.c
>>>>>>   create mode 100644 include/linux/mfd/rtsx_usb.h
>>>>>
>>>>> Applied again, thanks.
>>>>>
>>>> Would you also apply patch 2/3 and 3/3 that to make the device fully
>>>> operational for users? Or should they be applied by maintainers of
>>>> mmc/memstick subsystems?
>>>>
>>>> Chris, would you give some comment?
>>>
>>> I can apply them, but I need the other Maintainer Acks.
>>>
>>> If they are build orthogonal i.e. there are no build dependencies
>>> between them, it's probably better that they go into their associated
>>> trees separately.
>>>
>> I think it would be better to apply them together since the later
>> patches really depend on the 1st one,so now we are waiting for Acks
>> from mmc/memstick subsystems.
>
> When you say "depend on", do you mean as a build depenency, or won't
> run without the first patch applied?

The later 2 patches actually invoke symbols defined in the first patch 
and won't compile if it is not applied first. The Kconfig changes for 
the later oness also specified this by "depends on".

I'm not sure if this means "build dependency". Sorry for my unclear words.

>> But there is no one specified for "memstick/host/" in MAINTAINERS.
>> Could anyone else Ack this?
>

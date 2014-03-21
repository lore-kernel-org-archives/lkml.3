Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbaCUIXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:23:14 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36149 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaCUIXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:23:09 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-55-532bf6ea5291
Message-id: <532BF6E3.10003@samsung.com>
Date: Fri, 21 Mar 2014 09:22:59 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC 6/8] leds: Add support for max77693 mfd flash cell
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-7-git-send-email-j.anaszewski@samsung.com>
 <20140320153443.GD8207@lee--X1>
In-reply-to: <20140320153443.GD8207@lee--X1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/xa7qvvmkHG8yezmlxa905VoujOycy
	Wcw/AmR9vPeP1eJs0xt2i/tfjzJaXN41h81i65t1jBY9G7ayWuze9ZTV4vCbdlaL092sDjwe
	O2fdZfe4c20Pm8e8k4Eee+b/YPXo27KK0ePZx3fMHp83yQWwR3HZpKTmZJalFunbJXBl3L35
	gLXgmkjFv2tXWRsYDwh0MXJySAiYSHTfPM0CYYtJXLi3nq2LkYtDSGApo8TXeeeZIJzPjBIH
	/t9hAqniFdCQOPKjhRHEZhFQlfj/czpYnE3AUOLni9dgtqhAhMSf0/tYIeoFJX5Mvge0gYND
	REBF4twbc5CZzAJXmSTObX/KDFIjLOAl8fTtfajNKxklvu9vB2vmFNCReL+lGWwos4CZxKOW
	dcwQtrzE5jVvmScwCsxCsmMWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJ
	la87GJceszrEKMDBqMTDW8GpHSzEmlhWXJl7iFGCg1lJhHf6Z6AQb0piZVVqUX58UWlOavEh
	RiYOTqkGRvlQnZWphg93OTfsahGR+e5kE/RB+ksPO99zD5Nr6k+O3M9/vVhn8r697+0nT6my
	9b145caH5zml/za9KWWs3LnrhmOrbva0CXNY7T+v/tZlrbR0isKtC+cFO9Knur7kShKKalwv
	aZ8luvi05w8DyUcLqzkvrJ9wRM/z6pmqTzGbVm5pys9InaLEUpyRaKjFXFScCABgk8sjcwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 04:34 PM, Lee Jones wrote:
> On Thu, 20 Mar 2014, Jacek Anaszewski wrote:
>
>> This patch adds led-flash support to Maxim max77693 chipset.
>> Device can be exposed to user space through LED subsystem
>> sysfs interface or through V4L2 subdevice when the support
>> for Multimedia Framework is enabled. Device supports up to
>> two leds which can work in flash and torch mode. Leds can
>> be triggered externally or by software.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Cc: SangYoung Son <hello.son@smasung.com>
>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> ---
>>   drivers/leds/Kconfig         |    9 +
>>   drivers/leds/Makefile        |    1 +
>>   drivers/leds/leds-max77693.c |  768 ++++++++++++++++++++++++++++++++++++++++++
>>   drivers/mfd/max77693.c       |   21 +-
>>   include/linux/mfd/max77693.h |   32 ++
>>   5 files changed, 825 insertions(+), 6 deletions(-)
>>   create mode 100644 drivers/leds/leds-max77693.c
>
> [...]
>
>> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
>> index c5535f0..6fa92d3 100644
>> --- a/drivers/mfd/max77693.c
>> +++ b/drivers/mfd/max77693.c
>> @@ -41,12 +41,21 @@
>>   #define I2C_ADDR_MUIC	(0x4A >> 1)
>>   #define I2C_ADDR_HAPTIC	(0x90 >> 1)
>>
>> -static const struct mfd_cell max77693_devs[] = {
>> -	{ .name = "max77693-pmic", },
>> -	{ .name = "max77693-charger", },
>> -	{ .name = "max77693-flash", },
>> -	{ .name = "max77693-muic", },
>> -	{ .name = "max77693-haptic", },
>> +enum mfd_devs_idx {
>> +	IDX_PMIC,
>> +	IDX_CHARGER,
>> +	IDX_LED,
>> +	IDX_MUIC,
>> +	IDX_HAPTIC,
>> +};
>> +
>> +static struct mfd_cell max77693_devs[] = {
>> +	[IDX_PMIC]      = { .name = "max77693-pmic", },
>> +	[IDX_CHARGER]   = { .name = "max77693-charger", },
>> +	[IDX_LED]       = { .name = "max77693-led",
>> +			    .of_compatible = "maxim,max77693-led"},
>> +	[IDX_MUIC]      = { .name = "max77693-muic", },
>> +	[IDX_HAPTIC]    = { .name = "max77693-haptic", },
>>   };
>
> What is the purpose of this change?
>

Introducing mfd_devs_idx itself is a cosmetic change, which
actually could be avoided. Initialization of the of_compatible field
is required for the led driver to get matched properly. And as I've
just realized also max77693-flash name should be preserved.
I will fix this in the next version of the patch.

Thanks,
Jacek Anaszewski

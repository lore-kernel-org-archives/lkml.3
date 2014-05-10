Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbaEJKlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:41:17 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45077 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbaEJKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:41:15 -0400
Message-ID: <536E02AD.9000201@kernel.org>
Date: Sat, 10 May 2014 11:42:53 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org
CC: Josh Wu <josh.wu@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] iio:adc: at91 requires the input subsystem
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-13-git-send-email-arnd@arndb.de> <536CA78C.5070603@atmel.com> <4163305.otOGv8yVK1@wuerfel> <536CD0C9.4040603@atmel.com>
In-Reply-To: <536CD0C9.4040603@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 13:57, Nicolas Ferre wrote:
> On 09/05/2014 13:43, Arnd Bergmann :
>> On Friday 09 May 2014 12:01:48 Nicolas Ferre wrote:
>>> On 08/05/2014 16:56, Arnd Bergmann :
>>>> Building the at91 adc driver with CONFIG_INPUT disabled results in this
>>>> build error:
>>>>
>>>> ERROR: "input_event" [drivers/iio/adc/at91_adc.ko] undefined!
>>>> ERROR: "input_unregister_device" [drivers/iio/adc/at91_adc.ko] undefined!
>>>> ERROR: "input_free_device" [drivers/iio/adc/at91_adc.ko] undefined!
>>>> ERROR: "input_register_device" [drivers/iio/adc/at91_adc.ko] undefined!
>>>> ERROR: "input_set_abs_params" [drivers/iio/adc/at91_adc.ko] undefined!
>>>> ERROR: "input_allocate_device" [drivers/iio/adc/at91_adc.ko] undefined!
>>>>
>>>> To make sure we can build random configurations, this turns on CONFIG_INPUT
>>>> whenever CONFIG_AT91_ADC is enabled.
>>>
>>> Isn't it a "select" instead of "depends" that is required then?
>>
>> It seems I fixed the patch at some point but didn't update the message.
>>
>> In general, we should not mix 'depends on' and 'select' for the same symbol,
>> since that causes extra confusion.
>>
>> In case of CONFIG_INPUT, almost all the users do 'depends on INPUT', with
>> a few exceptions that seem to be done in error.
>
> Ok, that makes sense.
>
>
>> Updated patch below.
>
> Thanks Arnd.
>
>> 	Arnd
>>
>> 8<----
>>
>> >From 4679d63b24a681d9c6afcfdde266bae0f940e90b Mon Sep 17 00:00:00 2001
>> From: Arnd Bergmann <arnd@arndb.de>
>> Date: Wed, 9 Apr 2014 17:18:10 +0200
>> Subject: [PATCH] [SUBMITTED] iio:adc: at91 requires the input subsystem
>>
>> Building the at91 adc driver with CONFIG_INPUT disabled results in this
>> build error:
>>
>> ERROR: "input_event" [drivers/iio/adc/at91_adc.ko] undefined!
>> ERROR: "input_unregister_device" [drivers/iio/adc/at91_adc.ko] undefined!
>> ERROR: "input_free_device" [drivers/iio/adc/at91_adc.ko] undefined!
>> ERROR: "input_register_device" [drivers/iio/adc/at91_adc.ko] undefined!
>> ERROR: "input_set_abs_params" [drivers/iio/adc/at91_adc.ko] undefined!
>> ERROR: "input_allocate_device" [drivers/iio/adc/at91_adc.ko] undefined!
>>
>> To make sure we can build random configurations, this adds a Kconfig
>> dependency on CONFIG_INPUT, as we do for other similar drivers.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: linux-iio@vger.kernel.org
>> Cc: Josh Wu <josh.wu@atmel.com>
>> Cc: Jonathan Cameron <jic23@kernel.org>
>> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
>
>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>
Applied to the togreg branch of iio.git.  Thanks,

Jonathan
> Bye,
>
>>
>> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
>> index 90f596d..a80d236 100644
>> --- a/drivers/iio/adc/Kconfig
>> +++ b/drivers/iio/adc/Kconfig
>> @@ -110,6 +110,7 @@ config AD799X
>>   config AT91_ADC
>>   	tristate "Atmel AT91 ADC"
>>   	depends on ARCH_AT91
>> +	depends on INPUT
>>   	select IIO_BUFFER
>>   	select IIO_TRIGGERED_BUFFER
>>   	select SYSFS
>>
>>
>>
>
>


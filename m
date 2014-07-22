Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaGVFDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:03:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54847 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaGVFDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:03:04 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53CDF086.6010705@roeck-us.net>
Date: Mon, 21 Jul 2014 22:03:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] gpiolib: Export gpiochip_request_own_desc and gpiochip_free_own_desc
References: <1406003194-20351-1-git-send-email-linux@roeck-us.net> <CAAVeFu+9NTH8pbx-dvYD3xVpZ9Y5F0P9KNDQP1DMB6Qn0Sv8KQ@mail.gmail.com>
In-Reply-To: <CAAVeFu+9NTH8pbx-dvYD3xVpZ9Y5F0P9KNDQP1DMB6Qn0Sv8KQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 09:42 PM, Alexandre Courbot wrote:
> On Tue, Jul 22, 2014 at 1:26 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> Both functions were introduced to let gpio drivers request their own
>> gpio pins. Without exporting the functions, this can however only be
>> used by gpio drivers built into the kernel.
>>
>> Secondary impact is that the functions can not currently be used by
>> platform initialization code associated with the gpio-pca953x driver.
>> This code permits auto-export of gpio pins through platform data, but
>> if this functionality is used, the module can no longer be unloaded due
>> to the problem solved with the introduction of gpiochip_request_own_desc
>> and gpiochip_free_own_desc.
>>
>> Export both function so they can be used from modules and from
>> platform initialization code.
>>
>> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/gpio/gpiolib.c        | 2 ++
>>   drivers/gpio/gpiolib.h        | 3 ---
>>   include/linux/gpio/consumer.h | 3 +++
>>   3 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index 43d9e34..04c647e 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -1953,6 +1953,7 @@ int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label)
>>
>>          return __gpiod_request(desc, label);
>>   }
>> +EXPORT_SYMBOL(gpiochip_request_own_desc);
>>
>>   /**
>>    * gpiochip_free_own_desc - Free GPIO requested by the chip driver
>> @@ -1966,6 +1967,7 @@ void gpiochip_free_own_desc(struct gpio_desc *desc)
>>          if (desc)
>>                  __gpiod_free(desc);
>>   }
>> +EXPORT_SYMBOL(gpiochip_free_own_desc);
>>
>>   /* Drivers MUST set GPIO direction before making get/set calls.  In
>>    * some cases this is done in early boot, before IRQs are enabled.
>> diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
>> index 1a4103d..2bdb69d 100644
>> --- a/drivers/gpio/gpiolib.h
>> +++ b/drivers/gpio/gpiolib.h
>> @@ -45,9 +45,6 @@ acpi_get_gpiod_by_index(struct device *dev, int index,
>>   }
>>   #endif
>>
>> -int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label);
>> -void gpiochip_free_own_desc(struct gpio_desc *desc);
>> -
>>   struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
>>                     const char *list_name, int index, enum of_gpio_flags *flags);
>>
>> diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
>> index 05e53cc..e85f7e6 100644
>> --- a/include/linux/gpio/consumer.h
>> +++ b/include/linux/gpio/consumer.h
>> @@ -32,6 +32,9 @@ struct gpio_desc *__must_check gpiod_get_index_optional(struct device *dev,
>>
>>   void gpiod_put(struct gpio_desc *desc);
>>
>> +int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label);
>> +void gpiochip_free_own_desc(struct gpio_desc *desc);
>
> I guess these functions should be made public in driver.h, not
> consumer.h. Users will be GPIO drivers and platform code, not device
> drivers which are the typical consumers of GPIOs.
>

No problem; I was not sure which include file would be appropriate,
and just picked one. I'll update the patch and resubmit.

Thanks,
Guenter


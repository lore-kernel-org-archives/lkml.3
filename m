Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaGVGxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:53:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50103 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaGVGx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:53:29 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53CE0A67.7060005@roeck-us.net>
Date: Mon, 21 Jul 2014 23:53:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH v2] gpiolib: Export gpiochip_request_own_desc and gpiochip_free_own_desc
References: <1406006305-22694-1-git-send-email-linux@roeck-us.net> <20140722064348.GG1655@lahna.fi.intel.com>
In-Reply-To: <20140722064348.GG1655@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 11:43 PM, Mika Westerberg wrote:
> On Mon, Jul 21, 2014 at 10:18:25PM -0700, Guenter Roeck wrote:
>> Both functions were introduced to let gpio drivers request their own
>> gpio pins. Without exporting the functions, this can however only be
>> used by gpio drivers built into the kernel.
>
> The reason why these are private to drivers is that those are dangerous
> if used blindly.
>
>> Secondary impact is that the functions can not currently be used by
>> platform initialization code associated with the gpio-pca953x driver.
>> This code permits auto-export of gpio pins through platform data, but
>> if this functionality is used, the module can no longer be unloaded due
>> to the problem solved with the introduction of gpiochip_request_own_desc
>> and gpiochip_free_own_desc.
>>
>> Export both function so they can be used from modules and from
>> platform initialization code.
>
> However, you have valid reason above. I wonder if this requires
> some documentation in Documentation/gpio/driver.txt?
>
Sure. Any idea what I should write, or do you want me to come up with something ?

>> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v2: Move function declarations from consumer.h to driver.h.
>>
>>   drivers/gpio/gpiolib.c      | 2 ++
>>   drivers/gpio/gpiolib.h      | 3 ---
>>   include/linux/gpio/driver.h | 3 +++
>>   3 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index 43d9e34..04c647e 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -1953,6 +1953,7 @@ int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label)
>>
>>   	return __gpiod_request(desc, label);
>>   }
>> +EXPORT_SYMBOL(gpiochip_request_own_desc);
>
> EXPORT_SYMBOL_GPL?
>
Ok.

Thanks,
Guenter


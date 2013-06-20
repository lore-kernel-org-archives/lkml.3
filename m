Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161281Ab3FTSvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:51:25 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61558 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161250Ab3FTSvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:51:23 -0400
Message-ID: <51C34F28.403@gmail.com>
Date: Thu, 20 Jun 2013 11:51:20 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] gpio MIPS/OCTEON: Add a driver for OCTEON's on-chip GPIO
 pins.
References: <1371251915-18271-1-git-send-email-ddaney.cavm@gmail.com>  <CACRpkdYHzBBbPNujYRGkMFGuQRzeYKs9jgfc3e3HWyxQFahvRQ@mail.gmail.com>  <51C34584.8070301@gmail.com> <1371752324.2146.25.camel@joe-AO722>  <51C3497D.2050107@gmail.com> <1371753812.2146.37.camel@joe-AO722>
In-Reply-To: <1371753812.2146.37.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 11:43 AM, Joe Perches wrote:
> On Thu, 2013-06-20 at 11:27 -0700, David Daney wrote:
>> On 06/20/2013 11:18 AM, Joe Perches wrote:
>>> On Thu, 2013-06-20 at 11:10 -0700, David Daney wrote:
>>>> Sorry for not responding earlier, but my e-mail system seems to have
>>>> malfunctioned with respect to this message...
>>> []
>>>> On 06/17/2013 01:51 AM, Linus Walleij wrote:
>>>>>> +static int octeon_gpio_get(struct gpio_chip *chip, unsigned offset)
>>>>>> +{
>>>>>> +       struct octeon_gpio *gpio = container_of(chip, struct octeon_gpio, chip);
>>>>>> +       u64 read_bits = cvmx_read_csr(gpio->register_base + RX_DAT);
>>>>>> +
>>>>>> +       return ((1ull << offset) & read_bits) != 0;
>>>>>
>>>>> A common idiom we use for this is:
>>>>>
>>>>> return !!(read_bits & (1ull << offset));
>>>>
>>>> I hate that idiom, but if its use is a condition of accepting the patch,
>>>> I will change it.
>>>
>>> Or use an even more common idiom and change the
>>> function to return bool and let the compiler do it.
>>>
>>
>> ... but it is part of the gpiochip system interface, so it would have to
>> be done kernel wide.
>
> Not really.  It's a local static function.

... which we generate a pointer to, and then assign that pointer to a 
variable with a type defined in the gpiochip system interface.  So If we 
do what you suggest, the result is:

   CC      drivers/gpio/gpio-octeon.o
drivers/gpio/gpio-octeon.c: In function 'octeon_gpio_probe':
drivers/gpio/gpio-octeon.c:113:12: warning: assignment from incompatible 
pointer type [enabled by default]



>
>> Really I don't like the idea of GPIO lines having Boolean truth values
>> associated with them.  Some represent things that are active-high and
>> others active-low.  Converting the pin voltage being above or below a
>> given threshold to something other than zero or one would in my opinion
>> be confusing.
>
> No worries, just offering options.  Your code, your choice.
>
>
>

